using DBFunction;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AIE
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Ado.UserDetails == null)
            {
                Response.Redirect("~/");
                return;
            }

            if (!IsPostBack)
            {
                DataView dv = new DataView();
                dv = Ado.UsersGetByID(Ado.UserDetails.UserID.ToString());
                if (dv != null && dv.Count > 0)
                {
                    LblId.Text = dv[0]["UserID"].ToString();
                    LblName.Text = dv[0]["FullName"].ToString();
                    TxtEmail.Text = dv[0]["Username"].ToString();
                    TxtMobile.Text = dv[0]["MobileNo"].ToString();

                    TxtEditMobile.Text = dv[0]["MobileNo"].ToString();
                    TxtGender.Value = dv[0]["Gender"].ToString();
                    Nationality.Value = dv[0]["Nationality"].ToString();
                    TxtLinkedin.Text = dv[0]["Linkedn"].ToString();
                }
            }

            divError.Visible = false;
            divError.Attributes["class"] = "error_input text-dark";

            divErrorProfile.Visible = false;
            divErrorProfile.Attributes["class"] = "error_input text-dark";
        }

        protected void BtnShowChangePass_Click(object sender, EventArgs e)
        {
            if (div_changepasss.Visible == false)
            {
                div_changepasss.Visible = true;
                div_editprofile.Visible = false;
            }
            else
            {
                div_changepasss.Visible = false;
                div_editprofile.Visible = false;
            }
        }

        protected void BtnShowSurvey_Click(object sender, EventArgs e)
        {

        }

        protected void BtnShowProfile_Click(object sender, EventArgs e)
        {
            div_changepasss.Visible = false;
            div_editprofile.Visible = true;
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
        ة
            if (Ado.UserDetails == null)
            {
                Response.Redirect("~/");
                return;
            }


            if (string.IsNullOrWhiteSpace(TxtCurrentPass.Text))
            {
                divError.Visible = true;
                divError.InnerHtml = "Current Password is required";
                return;
            }

            if (string.IsNullOrWhiteSpace(TxtPass.Text))
            {
                divError.Visible = true;
                divError.InnerHtml = "New Password is required";
                return;
            }

            if (TxtPass.Text != TxtPassRe.Text)
            {
                divError.Visible = true;
                divError.InnerHtml = "Password does not match";
                return;
            }


            DataView dvCheck = Ado.UsersGetByUserName(Ado.UserDetails.UserName, TxtCurrentPass.Text);
            if (dvCheck == null || dvCheck.Count == 0)
            {
                divError.Visible = true;
                divError.InnerHtml = "Current password is incorrect";
                return;
            }

        
            string currentUserId = Ado.UserDetails.UserID.ToString();
            Ado.UsersUpdatePass(currentUserId, TxtPass.Text);

            divError.Visible = true;
            divError.Attributes["class"] = "alert alert-success";
            divError.InnerHtml = "Successfully Updated";

            TxtCurrentPass.Text = "";
            TxtPass.Text = "";
            TxtPassRe.Text = "";
        }

        protected void BtnPudateProfile_Click(object sender, EventArgs e)
        {
            
            if (Ado.UserDetails == null)
            {
                Response.Redirect("~/");
                return;
            }

        
            string currentUserId = Ado.UserDetails.UserID.ToString();
            Ado.UsersUpdateInfo(currentUserId, TxtEditMobile.Text, TxtGender.SelectedItem.Value.ToString(), Nationality.Value.ToString(), TxtLinkedin.Text);

            divErrorProfile.Visible = true;
            divErrorProfile.Attributes["class"] = "alert alert-success";
            divErrorProfile.InnerHtml = "Successfully Updated";
        }
    }
}﻿


      
