using SmartLocker.Models;

namespace SmartLockerAPI.Models
{
    public class AuthenticateResponse
    {
        public String Id { get; set; }
        public string name { get; set; }
        public string mail { get; set; }
        public string phone { get; set; }
        public String role { get; set; }
        public string Token { get; set; }


        public AuthenticateResponse(User user, string token)
        {
            Id = user.UserId;
            name = user.Name;
            mail = user.Mail;
            phone = user.Phone;
            role = user.RoleId;
            Token = token;
        }
    }
}