using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AIE
{
    public partial class Publication : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string track = Request.QueryString["track"];
            if (!string.IsNullOrEmpty(track))
            {
                Response.Redirect("~/Ceremony?track=" + Server.UrlEncode(track), false);
            }
            else
            {
                Response.Redirect("~/Ceremony", false);
            }
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}