using DBFunction;
using System;
using System.ComponentModel.DataAnnotations;
using System.Data;

namespace AIE.Ar_Sa
{
    public partial class ContactUs : System.Web.UI.Page
    {
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            divError.Visible = false;
            divError.Attributes["class"] = "error_input droidkufiregular";
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            ds = Ado.LanguagesGet();
            if (Ado.BlnError)
            {
                string sError = Ado.StrError;
                return;
            }
            if (ds.Tables[0].Rows.Count > 0)
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
                    divError.InnerHtml = "يرجى إدخال الاسم الكامل (3 أحرف على الأقل).";
                    return;
                }
                if (!IsValidEmailAddress(email))
                {
                    divError.Visible = true;
                    divError.Attributes["class"] = "alert alert-danger";
                    divError.InnerHtml = ds.Tables[0].Select("Title='Email'")[0].ItemArray[3].ToString(); // "Email format not valid";
                    return;
                }
                if (!string.IsNullOrEmpty(mobile))
                {
                    string mobErr = AuthService.ValidateMobile(mobile);
                    if (mobErr != null)
                    {
                        divError.Visible = true;
                        divError.Attributes["class"] = "alert alert-danger";
                        divError.InnerHtml = "يرجى إدخال رقم جوال صحيح.";
                        return;
                    }
                }
                if (string.IsNullOrWhiteSpace(message) || message.Length < 10)
                {
                    divError.Visible = true;
                    divError.Attributes["class"] = "alert alert-danger";
                    divError.InnerHtml = "يرجى إدخال نص الرسالة (10 أحرف على الأقل).";
                    return;
                }

                Ado.ContactUsInsert(HttpUtility.HtmlEncode(name), email, mobile, HttpUtility.HtmlEncode(message));
                divError.Visible = true;
                divError.Attributes["class"] = "alert alert-success";
                divError.InnerHtml = ds.Tables[0].Select("Title='Submitsuccess'")[0].ItemArray[3].ToString(); // "Successfully Submitted";

                TxtName.Text = "";
                TxtMobile.Text = "";
                TxtEmail.Text = "";
                TxtMessage.Text = "";
            }

            }



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