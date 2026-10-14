using AIE.Content.Models;
using System;
using System.Linq;

namespace AIEService
{
    public class LoginSecurity
    {
        public static bool Login(string username, string password)
        {
            // 1. Validate that input credentials are not null or whitespace
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                return false;
            }

            try
            {
                using (EntitiesAPI entities = new EntitiesAPI())
                {
                    string cleanUser = username.Trim().ToLower();

                    // 2. Query user without StringComparison.OrdinalIgnoreCase to prevent Entity Framework NotSupportedException
                    var apiUser = entities.qryApiUsers
                        .FirstOrDefault(user => user.UserName.ToLower() == cleanUser && user.UserPass == password);

                    if (apiUser == null)
                    {
                        return false;
                    }

                    // 3. Verify that the password has not expired
                    if (apiUser.PasswordExpired.HasValue && apiUser.PasswordExpired.Value < DateTime.Now)
                    {
                        return false;
                    }

                    return true;
                }
            }
            catch (Exception)
            {
                // 4. Return false safely on any database connection or query failure
                return false;
            }
        }
    }
}
