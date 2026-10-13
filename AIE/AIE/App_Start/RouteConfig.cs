using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace AIE
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            routes.EnableFriendlyUrls(settings);

            // Legacy backward-compatibility routes
            routes.MapPageRoute("LegacyJudgesRoute", "Judges", "~/Speakers.aspx");
            routes.MapPageRoute("LegacyJudgesArRoute", "Ar_Sa/Judges", "~/Ar_Sa/Speakers.aspx");
        }
    }
}
