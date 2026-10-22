using DBFunction;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AIE
{
    public partial class ContactUs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            divError.Visible = false;
            divError.Attributes["class"] = "error_input";
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            string name = (TxtName.Text ?? string.Empty).Trim();
            string email = (TxtEmail.Text ?? string.Empty).Trim();
            string message = (TxtMessage.Text ?? string.Empty).Trim();
            string countryCode = Request.Form["DdlContactCountryCode"] ?? "+966";
            string mobile = AuthService.NormalizeMobile(countryCode, TxtMobile.Text);

            if (string.IsNullOrWhiteSpace(name) || name.Length < 3)
            {
                divError.Visible = true;
                divError.Attributes["class"] = "alert alert-danger";
                divError.InnerHtml = "Please enter your full name (at least 3 characters).";
                return;
            }
            if (!IsValidEmailAddress(email))
            {
                divError.Visible = true;
                divError.Attributes["class"] = "alert alert-danger";
                divError.InnerHtml = "Please enter a valid email address.";
                return;
            }
            if (!string.IsNullOrEmpty(mobile))
            {
                string mobErr = AuthService.ValidateMobile(mobile);
                if (mobErr != null)
                {
                    divError.Visible = true;
                    divError.Attributes["class"] = "alert alert-danger";
                    divError.InnerHtml = "Please enter a valid mobile number.";
                    return;
                }
            }
            if (string.IsNullOrWhiteSpace(message) || message.Length < 10)
            {
                divError.Visible = true;
                divError.Attributes["class"] = "alert alert-danger";
                divError.InnerHtml = "Please enter a message (at least 10 characters).";
                return;
            }

            Ado.ContactUsInsert(HttpUtility.HtmlEncode(name), email, mobile, HttpUtility.HtmlEncode(message));
            divError.Visible = true;
            divError.Attributes["class"] = "alert alert-success";
            divError.InnerHtml = "Your message has been submitted successfully! Thank you for contacting SAIRH 2026.";

            TxtName.Text = "";
            TxtMobile.Text = "";
            TxtEmail.Text = "";
            TxtMessage.Text = "";
        }

        public bool IsValidEmailAddress(string email)
        {
            if (!string.IsNullOrEmpty(email) && new EmailAddressAttribute().IsValid(email))
                return true;
            else
                return false;
        }

    }
}