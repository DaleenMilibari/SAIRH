using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;

namespace AIE
{
    /// <summary>
    /// Core Service uniting Survey recommendations, Exhibition Floor SiteMap state,
    /// NFC scans, and database persistence for SAIRH 2026.
    /// Supports live SQL Server operations with graceful memory/JSON fallback.
    /// </summary>
    public static class SurveyService
    {
        private static readonly ConcurrentDictionary<string, DateTime> BoothCooldowns = new ConcurrentDictionary<string, DateTime>(StringComparer.OrdinalIgnoreCase);
        private static readonly ConcurrentDictionary<string, HashSet<string>> UserVisited = new ConcurrentDictionary<string, HashSet<string>>(StringComparer.OrdinalIgnoreCase);
        private static readonly ConcurrentDictionary<string, List<string>> UserRoadmaps = new ConcurrentDictionary<string, List<string>>(StringComparer.OrdinalIgnoreCase);

        private static string ConnectionString
        {
            get
            {
                var cs = ConfigurationManager.ConnectionStrings["AIEConnectionString"];
                return cs != null ? cs.ConnectionString : string.Empty;
            }
        }

        public class BoothModel
        {
            public int Id { get; set; }
            public string BoothCode { get; set; }
            public string NameEn { get; set; }
            public string NameAr { get; set; }
            public string OrganizationEn { get; set; }
            public string OrganizationAr { get; set; }
            public string Type { get; set; } // "SponsorBooth" or "ResearchScreen"
            public string HallEn { get; set; }
            public string HallAr { get; set; }
            public List<string> CategoriesEn { get; set; } = new List<string>();
            public List<string> CategoriesAr { get; set; } = new List<string>();
            public int X { get; set; }
            public int Y { get; set; }
            public int MatchScore { get; set; }

            public string GetDisplayName(bool isArabic) => isArabic ? NameAr : NameEn;
            public string GetDisplayOrg(bool isArabic) => isArabic ? OrganizationAr : OrganizationEn;
            public string GetDisplayHall(bool isArabic) => isArabic ? HallAr : HallEn;
            public List<string> GetDisplayCategories(bool isArabic) => isArabic ? CategoriesAr : CategoriesEn;
        }

        public class BoothMapStateDto
        {
            public string BoothCode { get; set; }
            public string Name { get; set; }
            public string Organization { get; set; }
            public string Type { get; set; }
            public string Hall { get; set; }
            public List<string> Categories { get; set; } = new List<string>();
            public int Status { get; set; } // 0 = Available, 1 = Busy
            public bool IsVisitedByCurrentUser { get; set; }
            public bool IsRecommended { get; set; }
            public int RemainingBusySeconds { get; set; }
        }

        // Master definitions of all 45 booths
        private static readonly List<BoothModel> AllBooths = InitializeBooths();

        private static List<BoothModel> InitializeBooths()
        {
            var list = new List<BoothModel>();

            // 15 Sponsor Booths (S1 to S15)
            var sponsorData = new[]
            {
                new { Code = "S1", NameEn = "Sponsor Booth S1", NameAr = "جناح الراعي S1", OrgEn = "AI Imaging Sponsor", OrgAr = "راعي الذكاء الاصطناعي والتصوير", CatEn = new[] { "AI & Digital Technology", "Medical Imaging & Radiology", "AI Companies", "New Technology" }, CatAr = new[] { "الذكاء الاصطناعي والتقنية الرقمية", "التصوير الطبي والأشعة", "شركات الذكاء الاصطناعي", "تقنيات جديدة" }, X = 755, Y = 195 },
                new { Code = "S2", NameEn = "Sponsor Booth S2", NameAr = "جناح الراعي S2", OrgEn = "Radiology Technology Sponsor", OrgAr = "راعي تقنيات الأشعة", CatEn = new[] { "Medical Imaging & Radiology", "Healthcare Technology", "Medical Imaging Companies", "Products" }, CatAr = new[] { "التصوير الطبي والأشعة", "تقنية الرعاية الصحية", "شركات التصوير الطبي", "منتجات وخدمات" }, X = 755, Y = 235 },
                new { Code = "S3", NameEn = "Sponsor Booth S3", NameAr = "جناح الراعي S3", OrgEn = "Healthcare Innovation Sponsor", OrgAr = "راعي الابتكار الصحي", CatEn = new[] { "Health Innovation", "Healthcare Technology", "Healthcare Organizations", "Healthcare Solutions" }, CatAr = new[] { "الابتكار الصحي", "تقنية الرعاية الصحية", "المنظمات الصحية", "حلول الرعاية الصحية" }, X = 755, Y = 275 },
                new { Code = "S4", NameEn = "Sponsor Booth S4", NameAr = "جناح الراعي S4", OrgEn = "AI Solutions Sponsor", OrgAr = "راعي حلول الذكاء الاصطناعي", CatEn = new[] { "AI & Digital Technology", "AI Companies", "Healthcare Technology", "New Technology" }, CatAr = new[] { "الذكاء الاصطناعي والتقنية الرقمية", "شركات الذكاء الاصطناعي", "تقنية الرعاية الصحية", "تقنيات جديدة" }, X = 755, Y = 315 },
                new { Code = "S5", NameEn = "Sponsor Booth S5", NameAr = "جناح الراعي S5", OrgEn = "Medical Imaging Sponsor", OrgAr = "راعي التصوير الطبي", CatEn = new[] { "Medical Imaging & Radiology", "Medical Imaging Companies", "Products", "New Technology" }, CatAr = new[] { "التصوير الطبي والأشعة", "شركات التصوير الطبي", "منتجات وخدمات", "تقنيات جديدة" }, X = 755, Y = 355 },
                new { Code = "S6", NameEn = "Sponsor Booth S6", NameAr = "جناح الراعي S6", OrgEn = "University Partner", OrgAr = "الشريك الأكاديمي والجامعي", CatEn = new[] { "Research & Education", "Universities & Colleges", "Research", "Networking" }, CatAr = new[] { "البحث والتعليم", "الجامعات والكليات", "أبحاث سريرية", "تواصل مهني" }, X = 755, Y = 395 },
                new { Code = "S7", NameEn = "Sponsor Booth S7", NameAr = "جناح الراعي S7", OrgEn = "Health Organization Partner", OrgAr = "شريك المنظمات الصحية", CatEn = new[] { "Health Innovation", "Healthcare Organizations", "Healthcare Solutions", "Networking" }, CatAr = new[] { "الابتكار الصحي", "المنظمات الصحية", "حلول الرعاية الصحية", "تواصل مهني" }, X = 755, Y = 435 },
                new { Code = "S8", NameEn = "Sponsor Booth S8", NameAr = "جناح الراعي S8", OrgEn = "Medical Technology Sponsor", OrgAr = "راعي التقنيات الطبية المتقدمة", CatEn = new[] { "Healthcare Technology", "Medical Imaging & Radiology", "Medical Imaging Companies", "Products" }, CatAr = new[] { "تقنية الرعاية الصحية", "التصوير الطبي والأشعة", "شركات التصوير الطبي", "منتجات وخدمات" }, X = 920, Y = 115 },
                new { Code = "S9", NameEn = "Sponsor Booth S9", NameAr = "جناح الراعي S9", OrgEn = "AI Healthcare Sponsor", OrgAr = "راعي الذكاء الاصطناعي الصحي", CatEn = new[] { "AI & Digital Technology", "Health Innovation", "AI Companies", "Healthcare Solutions" }, CatAr = new[] { "الذكاء الاصطناعي والتقنية الرقمية", "الابتكار الصحي", "شركات الذكاء الاصطناعي", "حلول الرعاية الصحية" }, X = 920, Y = 155 },
                new { Code = "S10", NameEn = "Sponsor Booth S10", NameAr = "جناح الراعي S10", OrgEn = "Startup Sponsor", OrgAr = "راعي الشركات الناشئة والريادة", CatEn = new[] { "Startups & Innovation", "Startups", "Innovation", "Networking" }, CatAr = new[] { "الشركات الناشئة والابتكار", "الشركات الناشئة", "ابتكار وتقنيات واعدة", "تواصل مهني" }, X = 920, Y = 195 },
                new { Code = "S11", NameEn = "Sponsor Booth S11", NameAr = "جناح الراعي S11", OrgEn = "Digital Health Sponsor", OrgAr = "راعي الصحة الرقمية", CatEn = new[] { "AI & Digital Technology", "Health Innovation", "Healthcare Technology", "New Technology" }, CatAr = new[] { "الذكاء الاصطناعي والتقنية الرقمية", "الابتكار الصحي", "تقنية الرعاية الصحية", "تقنيات جديدة" }, X = 920, Y = 235 },
                new { Code = "S12", NameEn = "Sponsor Booth S12", NameAr = "جناح الراعي S12", OrgEn = "Research Partner", OrgAr = "الشريك البحثي الوطني", CatEn = new[] { "Research & Education", "Universities & Colleges", "Research", "Networking" }, CatAr = new[] { "البحث والتعليم", "الجامعات والكليات", "أبحاث سريرية", "تواصل مهني" }, X = 920, Y = 275 },
                new { Code = "S13", NameEn = "Sponsor Booth S13", NameAr = "جناح الراعي S13", OrgEn = "Clinical Technology Sponsor", OrgAr = "راعي التقنيات السريرية", CatEn = new[] { "Medical Imaging & Radiology", "Healthcare Organizations", "Healthcare Solutions", "Products" }, CatAr = new[] { "التصوير الطبي والأشعة", "المنظمات الصحية", "حلول الرعاية الصحية", "منتجات وخدمات" }, X = 920, Y = 315 },
                new { Code = "S14", NameEn = "Sponsor Booth S14", NameAr = "جناح الراعي S14", OrgEn = "Innovation Sponsor", OrgAr = "راعي الابتكار المستقبلي", CatEn = new[] { "Startups & Innovation", "Health Innovation", "Innovation", "New Technology" }, CatAr = new[] { "الشركات الناشئة والابتكار", "الابتكار الصحي", "ابتكار وتقنيات واعدة", "تقنيات جديدة" }, X = 920, Y = 355 },
                new { Code = "S15", NameEn = "Sponsor Booth S15", NameAr = "جناح الراعي S15", OrgEn = "AI Research Sponsor", OrgAr = "راعي أبحاث الذكاء الاصطناعي", CatEn = new[] { "AI & Digital Technology", "Research & Education", "AI Companies", "Research" }, CatAr = new[] { "الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "شركات الذكاء الاصطناعي", "أبحاث سريرية" }, X = 920, Y = 395 },
            };

            for (int i = 0; i < sponsorData.Length; i++)
            {
                var s = sponsorData[i];
                list.Add(new BoothModel
                {
                    Id = i + 1,
                    BoothCode = s.Code,
                    NameEn = s.NameEn,
                    NameAr = s.NameAr,
                    OrganizationEn = s.OrgEn,
                    OrganizationAr = s.OrgAr,
                    Type = "SponsorBooth",
                    HallEn = "Sponsor Hall",
                    HallAr = "قاعة الرعاة",
                    CategoriesEn = s.CatEn.ToList(),
                    CategoriesAr = s.CatAr.ToList(),
                    X = s.X,
                    Y = s.Y
                });
            }

            // 30 Research Screens (R1 to R30)
            var researchCatEn = new[]
            {
                new[] { "AI & Digital Technology", "Research & Education", "Research Displays", "Research" },
                new[] { "Medical Imaging & Radiology", "Research & Education", "Research Displays", "Research" },
                new[] { "Health Innovation", "Research & Education", "Research Displays", "Research" },
                new[] { "AI & Digital Technology", "Medical Imaging & Radiology", "Research Displays", "New Technology" },
                new[] { "Healthcare Technology", "Health Innovation", "Research Displays", "Healthcare Solutions" },
                new[] { "AI & Digital Technology", "Research & Education", "Research Displays", "New Technology" }
            };

            var researchCatAr = new[]
            {
                new[] { "الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية" },
                new[] { "التصوير الطبي والأشعة", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية" },
                new[] { "الابتكار الصحي", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية" },
                new[] { "الذكاء الاصطناعي والتقنية الرقمية", "التصوير الطبي والأشعة", "منصات عرض الأبحاث", "تقنيات جديدة" },
                new[] { "تقنية الرعاية الصحية", "الابتكار الصحي", "منصات عرض الأبحاث", "حلول الرعاية الصحية" },
                new[] { "الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "منصات عرض الأبحاث", "تقنيات جديدة" }
            };

            for (int i = 1; i <= 30; i++)
            {
                int x, y;
                if (i <= 12) { x = 90 + (i - 1) * 50; y = 35; }
                else if (i <= 18) { x = 35; y = 70 + (i - 13) * 28; }
                else { x = 90 + (i - 19) * 50; y = 220; }

                int catIdx = (i - 1) % 6;
                list.Add(new BoothModel
                {
                    Id = 15 + i,
                    BoothCode = $"R{i}",
                    NameEn = $"Research Screen R{i}",
                    NameAr = $"شاشة البحث R{i}",
                    OrganizationEn = $"Research Project {i}",
                    OrganizationAr = $"مشروع بحثي {i}",
                    Type = "ResearchScreen",
                    HallEn = "Research Screen Hall",
                    HallAr = "قاعة العروض البحثية",
                    CategoriesEn = researchCatEn[catIdx].ToList(),
                    CategoriesAr = researchCatAr[catIdx].ToList(),
                    X = x,
                    Y = y
                });
            }

            return list;
        }

        public static List<BoothModel> GetAllBooths()
        {
            return AllBooths.Select(b => new BoothModel
            {
                Id = b.Id,
                BoothCode = b.BoothCode,
                NameEn = b.NameEn,
                NameAr = b.NameAr,
                OrganizationEn = b.OrganizationEn,
                OrganizationAr = b.OrganizationAr,
                Type = b.Type,
                HallEn = b.HallEn,
                HallAr = b.HallAr,
                CategoriesEn = new List<string>(b.CategoriesEn),
                CategoriesAr = new List<string>(b.CategoriesAr),
                X = b.X,
                Y = b.Y
            }).ToList();
        }

        /// <summary>
        /// Exact balanced recommendation algorithm matching the Survey project.
        /// Scores all 45 booths and returns the top ordered booth codes (e.g. S1, R6, R12...).
        /// </summary>
        public static List<BoothModel> CalculateRecommendations(
            List<string> interests,
            List<string> boothTypes,
            List<string> goals,
            int boothCount)
        {
            interests = interests ?? new List<string>();
            boothTypes = boothTypes ?? new List<string>();
            goals = goals ?? new List<string>();
            if (boothCount <= 0) boothCount = 5;

            var booths = GetAllBooths();

            foreach (var booth in booths)
            {
                int score = 0;
                // 1. Interests (* 3)
                score += booth.CategoriesEn.Count(c => interests.Contains(c, StringComparer.OrdinalIgnoreCase)) * 3;
                // 2. Exhibition Area Type (* 2)
                score += booth.CategoriesEn.Count(c => boothTypes.Contains(c, StringComparer.OrdinalIgnoreCase)) * 2;
                // 3. Visitor Goals (* 1)
                score += booth.CategoriesEn.Count(c => goals.Contains(c, StringComparer.OrdinalIgnoreCase));

                // Bonuses for Research Screens
                if (booth.Type == "ResearchScreen")
                {
                    if (boothTypes.Any(b => b.IndexOf("Research", StringComparison.OrdinalIgnoreCase) >= 0))
                        score += 5;
                    if (interests.Any(i => i.IndexOf("Research", StringComparison.OrdinalIgnoreCase) >= 0))
                        score += 3;
                    if (goals.Any(g => g.IndexOf("Research", StringComparison.OrdinalIgnoreCase) >= 0))
                        score += 3;
                }

                booth.MatchScore = score;
            }

            var matchingSponsors = booths.Where(b => b.Type == "SponsorBooth" && b.MatchScore > 0)
                                         .OrderByDescending(b => b.MatchScore).ThenBy(b => b.Id).ToList();
            var matchingResearch = booths.Where(b => b.Type == "ResearchScreen" && b.MatchScore > 0)
                                         .OrderByDescending(b => b.MatchScore).ThenBy(b => b.Id).ToList();

            var recommended = new List<BoothModel>();

            // Guarantee representation from both halls if count >= 2
            if (boothCount >= 2 && matchingSponsors.Any() && matchingResearch.Any())
            {
                recommended.Add(matchingSponsors.First());
                recommended.Add(matchingResearch.First());
            }
            else if (boothCount == 1)
            {
                var best = booths.Where(b => b.MatchScore > 0).OrderByDescending(b => b.MatchScore).FirstOrDefault();
                if (best != null) recommended.Add(best);
            }

            // Fill remaining by score
            var remaining = booths.Where(b => b.MatchScore > 0 && !recommended.Any(r => r.BoothCode == b.BoothCode))
                                  .OrderByDescending(b => b.MatchScore)
                                  .ThenByDescending(b => b.Type == "ResearchScreen")
                                  .ThenBy(b => b.Id).ToList();

            foreach (var b in remaining)
            {
                if (recommended.Count >= boothCount) break;
                recommended.Add(b);
            }

            // Fallback if needed
            if (recommended.Count < boothCount)
            {
                var fallbacks = booths.Where(b => !recommended.Any(r => r.BoothCode == b.BoothCode))
                                      .OrderByDescending(b => b.MatchScore)
                                      .ThenByDescending(b => b.Type == "ResearchScreen")
                                      .ThenBy(b => b.Id).ToList();
                foreach (var b in fallbacks)
                {
                    if (recommended.Count >= boothCount) break;
                    recommended.Add(b);
                }
            }

            return recommended.OrderByDescending(b => b.MatchScore).ToList();
        }

        /// <summary>
        /// Saves user survey response & calculated roadmap to DB & memory cache.
        /// </summary>
        public static void SaveSurveyResponse(
            string email,
            int? attendeeId,
            List<string> interests,
            List<string> boothTypes,
            List<string> goals,
            int boothCount,
            List<string> recommendedCodes,
            string language)
        {
            email = (email ?? string.Empty).Trim().ToLowerInvariant();
            if (string.IsNullOrEmpty(email)) return;

            UserRoadmaps[email] = recommendedCodes;

            // Attempt live DB persistence
            try
            {
                string connStr = ConnectionString;
                if (!string.IsNullOrEmpty(connStr))
                {
                    using (var conn = new SqlConnection(connStr))
                    {
                        conn.Open();

                        // 1. Insert into SurveyResponses
                        string sql = @"INSERT INTO dbo.SurveyResponses (AttendeeID, UserEmail, Interests, BoothTypes, Goals, BoothCount, RecommendedBooths, Language)
                                       VALUES (@AttendeeID, @Email, @Interests, @BoothTypes, @Goals, @BoothCount, @Roadmap, @Lang);";
                        using (var cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.Add("@AttendeeID", SqlDbType.Int).Value = attendeeId.HasValue ? (object)attendeeId.Value : DBNull.Value;
                            cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = email;
                            cmd.Parameters.Add("@Interests", SqlDbType.NVarChar).Value = string.Join(",", interests ?? new List<string>());
                            cmd.Parameters.Add("@BoothTypes", SqlDbType.NVarChar).Value = string.Join(",", boothTypes ?? new List<string>());
                            cmd.Parameters.Add("@Goals", SqlDbType.NVarChar).Value = string.Join(",", goals ?? new List<string>());
                            cmd.Parameters.Add("@BoothCount", SqlDbType.Int).Value = boothCount;
                            cmd.Parameters.Add("@Roadmap", SqlDbType.NVarChar).Value = JsonConvert.SerializeObject(recommendedCodes);
                            cmd.Parameters.Add("@Lang", SqlDbType.VarChar, 10).Value = language ?? "en";
                            cmd.ExecuteNonQuery();
                        }

                        // 2. Mark HasCompletedSurvey = 1 on Attendee if AttendeeID or Email matches
                        string updateSql = @"UPDATE dbo.Attendees SET HasCompletedSurvey = 1 WHERE Email = @Email" + (attendeeId.HasValue ? " OR AttendeeID = @AttendeeID;" : ";");
                        using (var updateCmd = new SqlCommand(updateSql, conn))
                        {
                            updateCmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = email;
                            if (attendeeId.HasValue) updateCmd.Parameters.Add("@AttendeeID", SqlDbType.Int).Value = attendeeId.Value;
                            updateCmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceWarning("[SurveyService] DB save warning: " + ex.Message);
            }
        }

        /// <summary>
        /// Retrieves the user's recommended booth codes (from memory cache or DB).
        /// </summary>
        public static List<string> GetUserRoadmap(string email)
        {
            email = (email ?? string.Empty).Trim().ToLowerInvariant();
            if (string.IsNullOrEmpty(email)) return new List<string>();

            if (UserRoadmaps.TryGetValue(email, out var list) && list != null && list.Count > 0)
            {
                return list;
            }

            // Try DB query
            try
            {
                string connStr = ConnectionString;
                if (!string.IsNullOrEmpty(connStr))
                {
                    using (var conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        string sql = "SELECT TOP 1 RecommendedBooths FROM dbo.SurveyResponses WHERE UserEmail = @Email ORDER BY SubmittedAtUtc DESC;";
                        using (var cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = email;
                            var json = cmd.ExecuteScalar() as string;
                            if (!string.IsNullOrEmpty(json))
                            {
                                var loaded = JsonConvert.DeserializeObject<List<string>>(json);
                                if (loaded != null && loaded.Count > 0)
                                {
                                    UserRoadmaps[email] = loaded;
                                    return loaded;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceWarning("[SurveyService] GetUserRoadmap error: " + ex.Message);
            }

            return new List<string>();
        }

        /// <summary>
        /// Checks whether user has completed the survey.
        /// </summary>
        public static bool HasUserCompletedSurvey(string email)
        {
            email = (email ?? string.Empty).Trim().ToLowerInvariant();
            if (string.IsNullOrEmpty(email)) return false;

            if (UserRoadmaps.ContainsKey(email) && UserRoadmaps[email].Count > 0)
                return true;

            try
            {
                string connStr = ConnectionString;
                if (!string.IsNullOrEmpty(connStr))
                {
                    using (var conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        using (var cmd = new SqlCommand("SELECT HasCompletedSurvey FROM dbo.Attendees WHERE Email = @Email;", conn))
                        {
                            cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = email;
                            var res = cmd.ExecuteScalar();
                            if (res != null && res != DBNull.Value && Convert.ToBoolean(res))
                                return true;
                        }
                    }
                }
            }
            catch (Exception) { }

            return false;
        }

        /// <summary>
        /// Registers an NFC / QR scan on a booth for cooldown and marking as visited.
        /// </summary>
        public static void RegisterScan(string boothCode, string email, int? attendeeId = null)
        {
            boothCode = (boothCode ?? string.Empty).Trim().ToUpperInvariant();
            email = (email ?? string.Empty).Trim().ToLowerInvariant();
            if (string.IsNullOrEmpty(boothCode)) return;

            // Set 5-min cooldown
            BoothCooldowns[boothCode] = DateTime.UtcNow;

            // Record visited
            if (!string.IsNullOrEmpty(email))
            {
                var set = UserVisited.GetOrAdd(email, _ => new HashSet<string>(StringComparer.OrdinalIgnoreCase));
                lock (set) { set.Add(boothCode); }

                try
                {
                    string connStr = ConnectionString;
                    if (!string.IsNullOrEmpty(connStr))
                    {
                        using (var conn = new SqlConnection(connStr))
                        {
                            conn.Open();
                            string sql = @"INSERT INTO dbo.BoothVisits (AttendeeID, UserEmail, BoothCode) VALUES (@AttendeeID, @Email, @Code);
                                           UPDATE dbo.Booths SET LastScannedAtUtc = SYSUTCDATETIME() WHERE BoothCode = @Code;";
                            using (var cmd = new SqlCommand(sql, conn))
                            {
                                cmd.Parameters.Add("@AttendeeID", SqlDbType.Int).Value = attendeeId.HasValue ? (object)attendeeId.Value : DBNull.Value;
                                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = email;
                                cmd.Parameters.Add("@Code", SqlDbType.VarChar, 10).Value = boothCode;
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceWarning("[SurveyService] RegisterScan DB warning: " + ex.Message);
                }
            }
        }

        /// <summary>
        /// Generates full interactive state DTOs for all 45 booths on the SiteMap.
        /// </summary>
        public static List<BoothMapStateDto> GetMapStatus(string email, bool isArabic = false)
        {
            email = (email ?? string.Empty).Trim().ToLowerInvariant();
            var roadmap = GetUserRoadmap(email);
            var roadmapSet = new HashSet<string>(roadmap, StringComparer.OrdinalIgnoreCase);

            HashSet<string> visitedSet = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            if (!string.IsNullOrEmpty(email) && UserVisited.TryGetValue(email, out var set))
            {
                lock (set) { visitedSet = new HashSet<string>(set, StringComparer.OrdinalIgnoreCase); }
            }

            var now = DateTime.UtcNow;
            var list = new List<BoothMapStateDto>();

            foreach (var b in AllBooths)
            {
                DateTime lastScanned = DateTime.MinValue;
                BoothCooldowns.TryGetValue(b.BoothCode, out lastScanned);

                TimeSpan elapsed = (lastScanned > DateTime.MinValue) ? (now - lastScanned) : TimeSpan.FromMinutes(999);
                bool isBusy = elapsed < TimeSpan.FromMinutes(5);
                int remainingSeconds = isBusy ? (int)(TimeSpan.FromMinutes(5) - elapsed).TotalSeconds : 0;

                list.Add(new BoothMapStateDto
                {
                    BoothCode = b.BoothCode,
                    Name = b.GetDisplayName(isArabic),
                    Organization = b.GetDisplayOrg(isArabic),
                    Type = b.Type,
                    Hall = b.GetDisplayHall(isArabic),
                    Categories = b.GetDisplayCategories(isArabic),
                    Status = isBusy ? 1 : 0,
                    IsVisitedByCurrentUser = visitedSet.Contains(b.BoothCode),
                    IsRecommended = roadmapSet.Contains(b.BoothCode),
                    RemainingBusySeconds = remainingSeconds
                });
            }

            return list;
        }
    }
}
