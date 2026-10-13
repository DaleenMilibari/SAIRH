using DBFunction;
using System;
using System.Web.UI;
using System.Web.Services;

namespace AIE.Ar_Sa
{
    public partial class BoothVisit : Page
    {
        public string BoothCode { get; set; } = "S1";
        public string BoothType { get; set; } = "SponsorBooth";
        public string BoothNameAr { get; set; } = "راعي الذكاء الاصطناعي في التصوير الطبي S1";
        public string OrganizationAr { get; set; } = "حلول التصوير الطبي الذكي";
        public string HallAr { get; set; } = "قاعة الرعاة";
        public int ProjectedAvgMinutes { get; set; } = 5;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string code = Request.QueryString["code"];
                if (!string.IsNullOrWhiteSpace(code))
                {
                    BoothCode = code.Trim().ToUpperInvariant();
                }
            }
        }

        [WebMethod]
        public static object RecordVisit(string boothCode, string status)
        {
            string email = (Ado.UserDetails != null) ? Ado.UserDetails.UserEmail : "guest@sairh.com";
            int? attendeeId = (Ado.UserDetails != null) ? (int?)Ado.UserDetails.UserID : null;
            return new { success = true, boothCode, status, email, attendeeId };
        }
    }
}
