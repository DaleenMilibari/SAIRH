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
    // Apply basic authentication to protect all endpoints from unauthorized access
    [BasicAuthentication]
    public class ContactUsController : ApiController
    {
        // GET: api/ContactUs/{id} - Retrieve a specific contact message by ID
        public HttpResponseMessage Get(int id)
        {
            string username = Thread.CurrentPrincipal.Identity.Name;
            if (!string.Equals(username, "aie-user", StringComparison.OrdinalIgnoreCase))
            {
                return Request.CreateResponse(HttpStatusCode.Forbidden, new { message = "Access denied." });
            }

            using (EntitiesAPI entities = new EntitiesAPI())
            {
                var contact = entities.qryApiContactUs.FirstOrDefault(e => e.ContactUsId == id);
                if (contact == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, new { statusCode = HttpStatusCode.NotFound });
                }

                return Request.CreateResponse(HttpStatusCode.OK, new { statusCode = HttpStatusCode.OK, data = contact });
            }
        }

        // GET: api/ContactUs - Retrieve all contact messages (protected against PII leaks)
        public HttpResponseMessage Get()
        {
            string username = Thread.CurrentPrincipal.Identity.Name;
            if (!string.Equals(username, "aie-user", StringComparison.OrdinalIgnoreCase))
            {
                return Request.CreateResponse(HttpStatusCode.Forbidden, new { message = "Access denied." });
            }

            using (EntitiesAPI entities = new EntitiesAPI())
            {
                var list = entities.qryApiContactUs.ToList();
                return Request.CreateResponse(HttpStatusCode.OK, list);
            }
        }
    }
}
