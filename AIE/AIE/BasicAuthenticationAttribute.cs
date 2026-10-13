using System;
using System.Net;
using System.Net.Http;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace AIEService
{
    public class BasicAuthenticationAttribute : AuthorizationFilterAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            var authHeader = actionContext.Request.Headers.Authorization;

            // 1. Validate that the Authorization header exists, uses Basic scheme, and is not empty
            if (authHeader == null || !string.Equals(authHeader.Scheme, "Basic", StringComparison.OrdinalIgnoreCase) || string.IsNullOrWhiteSpace(authHeader.Parameter))
            {
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
                return;
            }

            try
            {
                // 2. Safely decode the Base64 authentication parameter
                string authenticationToken = authHeader.Parameter;
                string decodedAuthenticationToken = Encoding.UTF8.GetString(Convert.FromBase64String(authenticationToken));

                // 3. Split by colon into at most 2 parts (handles passwords that contain colons)
                string[] usernamePasswordArray = decodedAuthenticationToken.Split(new[] { ':' }, 2);

                if (usernamePasswordArray.Length != 2)
                {
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
                    return;
                }

                string username = usernamePasswordArray[0];
                string password = usernamePasswordArray[1];

                // 4. Validate credentials against security provider
                if (LoginSecurity.Login(username, password))
                {
                    var principal = new GenericPrincipal(new GenericIdentity(username), null);
                    Thread.CurrentPrincipal = principal;

                    if (HttpContext.Current != null)
                    {
                        HttpContext.Current.User = principal;
                    }
                }
                else
                {
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
                }
            }
            catch (Exception)
            {
                // 5. Catch any format/decoding exceptions and return 401 Unauthorized instead of throwing 500 error
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            }
        }
    }
}
