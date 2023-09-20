using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Humanizer;
using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using MimeKit;
using OtpSharp;
using SmartLocker.Data;
using SmartLocker.Models;
using SmartLockerAPI.Helpers;
using SmartLockerAPI.Models;
using SmartLockerAPI.Services;
using Otp = SmartLocker.Models.Otp;

namespace SmartLockerAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OtpsController : ControllerBase
    {
        private readonly SmartLockerContext _context;
        private readonly AppSettings _appSettings;
        private TokenService _tokenService;
        private static List<OtpSecretKey> _secretKeys = new List<OtpSecretKey>();

        public OtpsController(SmartLockerContext context, IOptions<AppSettings> appSettings, TokenService tokenService)
        {
            _context = context;
            _appSettings = appSettings.Value;
            _tokenService = tokenService;
        }

        [Authorize]
        // GET: api/Otps
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Otp>>> GetOtps()
        {
            if (_context.Otps == null)
            {
                return NotFound();
            }
            return await _context.Otps.ToListAsync();
        }

        [Authorize]
        // GET: api/Otps/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Otp>> GetOtp(string id)
        {
            if (_context.Otps == null)
            {
                return NotFound();
            }
            var otp = await _context.Otps.FindAsync(id);

            if (otp == null)
            {
                return NotFound();
            }

            return otp;
        }

        [Authorize]
        // PUT: api/Otps/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutOtp(string id, Otp otp)
        {
            if (id != otp.OtpId)
            {
                return BadRequest();
            }

            _context.Entry(otp).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!OtpExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [Authorize]
        // POST: api/Otps
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Otp>> PostOtp(Otp otp)
        {
            if (_context.Otps == null)
            {
                return Problem("Entity set 'SmartLockerContext.Otps'  is null.");
            }
            _context.Otps.Add(otp);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (OtpExists(otp.OtpId))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetOtp", new { id = otp.OtpId }, otp);
        }

        [Authorize]
        // DELETE: api/Otps/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOtp(string id)
        {
            if (_context.Otps == null)
            {
                return NotFound();
            }
            var otp = await _context.Otps.FindAsync(id);
            if (otp == null)
            {
                return NotFound();
            }

            _context.Otps.Remove(otp);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool OtpExists(string id)
        {
            return (_context.Otps?.Any(e => e.OtpId == id)).GetValueOrDefault();
        }

        [Authorize]
        [HttpPost("generatedotp")]
        public Task<IActionResult> GenerateOtpAsync()
        {
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            byte[] secretKey = Encoding.ASCII.GetBytes(_appSettings.Secret);
            var response = _tokenService.GetUserIdFromToken(token, secretKey);
            if (response == null)
            {
                return Task.FromResult<IActionResult>(BadRequest("Invalid token"));
            }
            var userId = response;
            Random random = new Random();
            var listLockers = _context.Lockers.Where(x => x.Status == "on");
            List<Locker> lockers;
            int randomIndex;
            Locker randomLocker;
            if (listLockers.Any())
            {
                lockers = listLockers.ToList();
                randomIndex = random.Next(lockers.Count);
                randomLocker = lockers[randomIndex];
            }
            else
            {
                lockers = new List<Locker>();
                randomLocker = new Locker();
            }
            if(lockers.Count() <= 0 && randomLocker.LockerId == null)
            {
                return Task.FromResult<IActionResult>(BadRequest(new { title = "No locker" }));
            }
            if(userId == null)
            {
                return Task.FromResult<IActionResult>(Unauthorized(new { title = "No user login" }));
            }   
            byte[] newSecretKey = Encoding.UTF8.GetBytes(GenerateRandomString(50));
            // Tạo mới OTP
            var totp = new Totp(newSecretKey, step: 10800);
            var otpCode = totp.ComputeTotp(DateTime.UtcNow);

            Guid guid = Guid.NewGuid();
            OtpSecretKey otpSecret = new OtpSecretKey(newSecretKey, otpCode);
            _secretKeys.Add(otpSecret);
            Otp otp = new Otp
            {
                OtpId = guid.ToString(),
                OtpCode = otpCode,
                ExpirationTime = DateTime.Now.AddHours(3),
                UserId = userId,
                LockerId = randomLocker.LockerId
            };
            randomLocker.Status = "off";
            _context.Otps.Add(otp);
            _context.SaveChanges();

            return Task.FromResult<IActionResult>(Ok(new { otp = otpCode }));
        }

        //[Authorize]
        [HttpPost("sendmail")]
        public async Task<IActionResult> SendMail([FromBody] MailData mailData)
        {
            if (mailData.UserId == null) return BadRequest();
            var user = _context.Users.Find(mailData.UserId);
            if (user == null) return BadRequest();
            try
            {
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("SmartLocker", "smartlocker894@gmail.com"));
                message.To.Add(new MailboxAddress(user.Name, user.Mail));
                message.Subject = "You have request on SmartLocker";

                string messageText = $"Hi {user.Name},\n\nThis is your OTP code: {mailData.OTP} to use SmartLocker\n\n-- SmartLocker";

                message.Body = new TextPart("plain")
                {
                    Text = messageText
                };


                using (var client = new SmtpClient())
                {
                    await client.ConnectAsync("smtp.gmail.com", 587, false); // SMTP server và cổng
                    await client.AuthenticateAsync("smartlocker894@gmail.com", "mmlc clpt nhal xnwn"); // Tên đăng nhập và mật khẩu email của bạn
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }

                return Ok("Email sent successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Email sending failed: {ex.Message}");
            }
        }

        static string GenerateRandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            Random random = new Random();
            StringBuilder stringBuilder = new StringBuilder(length);

            for (int i = 0; i < length; i++)
            {
                int index = random.Next(chars.Length);
                char randomChar = chars[index];
                stringBuilder.Append(randomChar);
            }

            return stringBuilder.ToString();
        }
    }
    public class MailData
    {
        public string? UserId { get; set; }
        public string? OTP { get; set; }
    }
}
