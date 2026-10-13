using DBFunction;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AIE
{
    public partial class PublicAr : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UpdateAuthVisibility();

            if (!IsPostBack)
            {

                string currentPage = Request.Url.AbsolutePath.ToLower();

                if (currentPage.Contains("publication") || currentPage.Contains("ceremony"))
                    linkCeremonyAr.Attributes["class"] += " active";
                else if (currentPage.Contains("schedules"))
                    linkSchedulesAr.Attributes["class"] += " active";
                else if (currentPage.Contains("speakers") || currentPage.Contains("judges"))
                    linkSpeakersAr.Attributes["class"] += " active";
                else if (currentPage.Contains("sponsors"))
                    linkSponsorsAr.Attributes["class"] += " active";
                else if (currentPage.Contains("contactus"))
                    linkContactUsAr.Attributes["class"] += " active";
                else
                    linkHomeAr.Attributes["class"] += " active"; 
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            UpdateAuthVisibility();
        }

        private void UpdateAuthVisibility()
        {
            bool isSignedIn = (Ado.UserDetails != null) ||
                              (Context.User != null && Context.User.Identity != null && Context.User.Identity.IsAuthenticated);

            if (isSignedIn)
            {
                liLogin.Visible = false;
                liProfile.Visible = true;
                liLogOut.Visible = true;
                if (Ado.UserDetails != null && Ado.UserDetails.UserLevel == "Admin")
                {
                    liDashboard.Visible = true;
                }
                else
                {
                    liDashboard.Visible = false;
                }
            }
            else
            {
                liLogin.Visible = true;
                liProfile.Visible = false;
                liLogOut.Visible = false;
                liDashboard.Visible = false;
            }
        }

        private void GetAbsolutePath()
        {
            string absolutepath = HttpContext.Current.Request.Url.AbsolutePath;
            Page.Header.Title = "";

            if (absolutepath.Contains("default"))
            {

                Response.Redirect("~/");
            }
            else if (absolutepath.Contains("Sponsors"))
            {
                Response.Redirect("~/Sponsors");
            }

            else if (absolutepath.Contains("Speakers") || absolutepath.Contains("Judges"))
            {
                Response.Redirect("~/Speakers");
            }

            else if (absolutepath.Contains("Winners"))
            {
                Response.Redirect("~/Winners");
            }
            else if (absolutepath.Contains("Schedules"))
            {
                Response.Redirect("~/Schedules");
            }
            else if (absolutepath.Contains("ContactUs"))
            {
                Response.Redirect("~/ContactUs");
            }
            else if (absolutepath.Contains("Login"))
            {
                Response.Redirect("~/Login");
            }
            else if (absolutepath.Contains("Register"))
            {
                Response.Redirect("~/Register");
            }
            else if (absolutepath.Contains("Ceremony"))
            {
                Response.Redirect("~/Ceremony");
            }
            else if (absolutepath.Contains("Publication"))
            {
                Response.Redirect("~/Publication");
            }
            else if (absolutepath.Contains("Profile"))
            {
                Response.Redirect("~/Profile");
            }
            else if (absolutepath.Contains("Dashboard"))
            {
                Response.Redirect("~/Dashboard");
            }


        }
        protected void BtnToEn_Click(object sender, EventArgs e)
        {
            GetAbsolutePath();
        }

        protected void BtnSignOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("~/Ar_Sa");
        }
        protected void BtnProfile_Click(object sender, EventArgs e)
        {

        }
    }
}