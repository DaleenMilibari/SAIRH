using DBFunction;
using System;
using System.Web.UI;

namespace AIE.Ar_Sa.Admin
{
    public partial class ManageSummit : Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            EnforceAdminAuthorization();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            EnforceAdminAuthorization();
        }

        /// <summary>
        /// OWASP Top 10 Broken Access Control (BAC) & Forced Browsing Prevention.
        /// Strictly verifies the current authenticated identity has the Administrator role.
        /// Direct URL access without administrative privileges returns HTTP 403 Forbidden.
        /// </summary>
        private void EnforceAdminAuthorization()
        {
            bool isAuthorizedAdmin = false;

            if (Ado.UserDetails != null && Ado.UserDetails.IsAdmin)
            {
                isAuthorizedAdmin = true;
            }

            if (!isAuthorizedAdmin)
            {
                Response.Clear();
                Response.StatusCode = 403;
                Response.StatusDescription = "Forbidden - Administrator Privileges Required";
                Response.Write("<!DOCTYPE html><html dir='rtl'><head><title>403 - محظور</title><style>body{background:#0a0f1d;color:#fff;font-family:sans-serif;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;}div{text-align:center;max-width:500px;padding:30px;background:rgba(255,255,255,0.05);border-radius:16px;border:1px solid rgba(239,68,68,0.4);}</style></head><body><div><h1 style='color:#ef4444;'>403 - الوصول محظور</h1><p>لا تمتلك صلاحيات المشرف للوصول إلى هذه اللوحة الإدارية.</p><p style='color:#94a3b8;font-size:0.9rem;'>التصفح القسري المباشر للصفحات الإدارية مقيد ومحمي وفق السياسات الأمنية.</p><a href='../Login' style='color:#38bdf8;'>تسجيل الدخول كمشرف</a> | <a href='../Default' style='color:#38bdf8;'>العودة للرئيسية</a></div></body></html>");
                Response.End();
            }
        }
    }
}
