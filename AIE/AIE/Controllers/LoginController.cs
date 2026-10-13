using AIE.Content.Models;
using AIEService;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Web.Http;

namespace AIE.Controllers
{
   
    public class LoginRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }

    public class LoginController : ApiController
    {
        [HttpPost]
        [BasicAuthentication]
        public HttpResponseMessage Post([FromBody] LoginRequest request)
        {
        
            if (request == null || string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.Password))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { message = "Email and password are required." });
            }

            
            string username = Thread.CurrentPrincipal.Identity.Name;
            if (!string.Equals(username, "aie-user", StringComparison.OrdinalIgnoreCase))
            {
                return Request.CreateResponse(HttpStatusCode.Forbidden, new { message = "Access denied." });
            }

            using (EntitiesAPI entities = new EntitiesAPI())
            {
           
                var user = entities.qryApiUserLogins
                    .Where(x => x.Email == request.Email && x.Password == request.Password)
                    .Select(x => new
                    {
                        x.ID,
                        x.Email,
                        x.Username,
                        x.FullName
                    })
                    .FirstOrDefault();

                if (user == null)
                {
                    return Request.CreateResponse(HttpStatusCode.Unauthorized, new { message = "Invalid credentials." });
                }

                return Request.CreateResponse(HttpStatusCode.OK, user);
            }
        }
    }
}
