using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Humanizer;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
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
        public async Task<IActionResult> GenerateOtpAsync()
        {
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            byte[] secretKey = Encoding.ASCII.GetBytes(_appSettings.Secret);
            var response = _tokenService.GetUserIdFromToken(token, secretKey);
            if (response == null)
            {
                return BadRequest("Invalid token");
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
            if(lockers.Count() > 0 && randomLocker.LockerId != null)
            {
                return BadRequest(new { title = "No locker" });
            }
            if(userId != null)
            {
                return Unauthorized(new { title = "No user login" });
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

            return Ok(new { otp = otpCode });
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
}
