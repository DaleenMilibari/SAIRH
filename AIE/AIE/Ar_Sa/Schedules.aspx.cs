using System;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

namespace AIE.Ar_Sa
{
    public partial class Schedules : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoadmap();
            }
        }

        private void LoadRoadmap()
        {
            try
            {
                string email = null;
                if (DBFunction.Ado.UserDetails != null)
                {
                    email = DBFunction.Ado.UserDetails.UserName;
                }

                if (string.IsNullOrEmpty(email) && Session["AIE_AttendeeEmail"] != null)
                {
                    email = Session["AIE_AttendeeEmail"].ToString();
                }

                if (string.IsNullOrEmpty(email) && Request.Cookies["sairh_user"] != null)
                {
                    email = Request.Cookies["sairh_user"].Value;
                }

                if (!string.IsNullOrEmpty(email))
                {
                    var roadmapCodes = SurveyService.GetUserRoadmap(email);
                    if (roadmapCodes != null && roadmapCodes.Count > 0)
                    {
                        pnlRoadmap.Visible = true;
                        pnlSurveyCTA.Visible = false;

                        var mapStatus = SurveyService.GetMapStatus(email, true);
                        var recommendedBooths = mapStatus.Where(b => b.IsRecommended).ToList();

                        var sb = new StringBuilder();
                        foreach (var b in recommendedBooths)
                        {
                            sb.AppendFormat(
                                "<div class=\"recommended-stop-card\" onclick=\"openBoothModal('{1}')\" style=\"cursor:pointer;\">" +
                                "<div class=\"d-flex justify-content-between align-items-center mb-1\">" +
                                "<span class=\"badge badge-info\">{0}</span>" +
                                "<strong class=\"text-white\">{1}</strong>" +
                                "</div>" +
                                "<div class=\"text-white font-weight-bold\">{2}</div>" +
                                "<div class=\"text-secondary small\">{3}</div>" +
                                "</div>",
                                HttpUtility.HtmlEncode(b.Hall),
                                HttpUtility.HtmlEncode(b.BoothCode),
                                HttpUtility.HtmlEncode(b.Name),
                                HttpUtility.HtmlEncode(b.Organization)
                            );
                        }
                        recCardsContainer.InnerHtml = sb.ToString();
                        return;
                    }
                }

                pnlRoadmap.Visible = false;
                pnlSurveyCTA.Visible = true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceWarning("[Ar_Sa/Schedules] LoadRoadmap error: " + ex.Message);
                pnlRoadmap.Visible = false;
                pnlSurveyCTA.Visible = true;
            }
        }
    }
}