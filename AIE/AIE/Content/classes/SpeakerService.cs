using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;

namespace AIE
{
    /// <summary>
    /// Service for querying and binding Summit Speakers dynamically from the database
    /// with resilient error handling and automatic fallback.
    /// </summary>
    public static class SpeakerService
    {
        private static string ConnectionString
        {
            get
            {
                var cs = ConfigurationManager.ConnectionStrings["AIEConnectionString"];
                return cs != null ? cs.ConnectionString : string.Empty;
            }
        }

        public class SpeakerViewModel
        {
            public int SpeakerId { get; set; }
            public string Name { get; set; }
            public string JobTitle { get; set; }
            public string Organization { get; set; }
            public string LectureTitle { get; set; }
            public string Track { get; set; }
            public string TrackName { get; set; }
            public string TrackBadge { get; set; }
            public string TrackIcon { get; set; }
            public string TrackCssClass { get; set; }
            public string Sector { get; set; }
            public string SectorName { get; set; }
            public string SectorBadge { get; set; }
            public string SectorIcon { get; set; }
            public string Region { get; set; }
            public string RegionName { get; set; }
            public string ImagePath { get; set; }
            public string CvPdfPath { get; set; }
            public string Flag { get; set; }
            public string Initials { get; set; }
            public string LectureLabel { get; set; }
            public string QuickOverviewText { get; set; }
            public int Sorting { get; set; }
            public bool IsActive { get; set; }

            // Session Information (from dbo.Sessions via dbo.vw_SummitSpeakers)
            public int? SessionId { get; set; }
            public string Room { get; set; }
            public string RoomEn { get; set; }
            public string RoomAr { get; set; }
            public int DayNumber { get; set; }
            public string StartTime { get; set; }
            public string EndTime { get; set; }
            public string SessionTime { get; set; }
            public string Role { get; set; }
            public string RoleEn { get; set; }
            public string RoleAr { get; set; }
        }

        /// <summary>
        /// Retrieves summit speakers dynamically. First attempts live database query;
        /// if database fails or is unreachable, catches the exception and gracefully
        /// falls back to cached data to prevent page crashes.
        /// </summary>
        public static List<SpeakerViewModel> GetSpeakers(bool isArabic, out bool loadedFromDb, out string errorMessage)
        {
            loadedFromDb = false;
            errorMessage = null;

            // 1. Attempt live database query inside a clean try-catch block
            try
            {
                if (!string.IsNullOrWhiteSpace(ConnectionString))
                {
                    List<SpeakerViewModel> dbSpeakers = GetSpeakersFromDatabase(isArabic);
                    if (dbSpeakers != null && dbSpeakers.Count > 0)
                    {
                        loadedFromDb = true;
                        return dbSpeakers;
                    }
                    else
                    {
                        errorMessage = "Database query executed successfully, but returned 0 active speakers ([IsActive] = 1). In DataGrip, ensure changes are committed and [IsActive] is set to 1.";
                    }
                }
                else
                {
                    errorMessage = "Database connection string 'AIEConnectionString' is not configured.";
                }
            }
            catch (SqlException sqlEx)
            {
                errorMessage = "Database connection error: " + sqlEx.Message;
                System.Diagnostics.Trace.TraceError("[SpeakerService] SQL Exception: " + sqlEx);
            }
            catch (Exception ex)
            {
                errorMessage = "Unexpected error loading speakers from database: " + ex.Message;
                System.Diagnostics.Trace.TraceError("[SpeakerService] Exception: " + ex);
            }

            // 2. Resilient fallback: load from cached JSON to guarantee page does not crash
            try
            {
                return GetFallbackSpeakers(isArabic);
            }
            catch (Exception fbEx)
            {
                System.Diagnostics.Trace.TraceError("[SpeakerService] Fallback loading error: " + fbEx);
                return new List<SpeakerViewModel>();
            }
        }

        /// <summary>
        /// Convenience overload without out parameters.
        /// </summary>
        public static List<SpeakerViewModel> GetSpeakers(bool isArabic)
        {
            bool loadedFromDb;
            string errorMessage;
            return GetSpeakers(isArabic, out loadedFromDb, out errorMessage);
        }

        /// <summary>
        /// Queries the dbo.Speakers table directly via ADO.NET with parameterized queries.
        /// Safely inspects available columns so it works with any schema version.
        /// </summary>
        private static List<SpeakerViewModel> GetSpeakersFromDatabase(bool isArabic)
        {
            var list = new List<SpeakerViewModel>();
            const string sql = @"
                IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL
                BEGIN
                    EXEC('SELECT * FROM [dbo].[vw_SummitSpeakers] ORDER BY [Sorting] ASC, [SpeakerID] ASC;');
                END
                ELSE IF OBJECT_ID(N'[dbo].[Sessions]', N'U') IS NOT NULL
                BEGIN
                    EXEC('
                        SELECT s.*, 
                               sess.[SessionID],
                               sess.[TitleEn] AS [LectureTitleEn],
                               sess.[TitleAr] AS [LectureTitleAr],
                               sess.[Track] AS [SessionTrack],
                               sess.[TrackNameEn] AS [SessionTrackNameEn],
                               sess.[TrackNameAr] AS [SessionTrackNameAr],
                               sess.[RoomEn], sess.[RoomAr],
                               sess.[DayNumber], sess.[StartTime], sess.[EndTime],
                               sess.[RoleEn] AS [SessionRoleEn], sess.[RoleAr] AS [SessionRoleAr]
                        FROM [dbo].[Speakers] s
                        LEFT JOIN [dbo].[Sessions] sess ON s.[SpeakerID] = sess.[SpeakerID]
                        WHERE s.[IsActive] = 1
                        ORDER BY s.[Sorting] ASC, s.[SpeakerID] ASC;
                    ');
                END
                ELSE
                BEGIN
                    EXEC('SELECT * FROM [dbo].[Speakers] WHERE [IsActive] = 1 ORDER BY [Sorting] ASC, [SpeakerID] ASC;');
                END";

            using (var conn = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.CommandTimeout = 15; // 15s timeout prevents page freeze
                conn.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    var cols = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        cols.Add(reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        SpeakerViewModel vm = MapRowToViewModel(reader, cols, isArabic);
                        if (vm != null)
                        {
                            list.Add(vm);
                        }
                    }
                }
            }

            return list;
        }

        private static SpeakerViewModel MapRowToViewModel(IDataRecord r, HashSet<string> cols, bool isArabic)
        {
            int speakerId = cols.Contains("SpeakerID") && r["SpeakerID"] != DBNull.Value ? Convert.ToInt32(r["SpeakerID"]) : 0;
            int sorting = cols.Contains("Sorting") && r["Sorting"] != DBNull.Value ? Convert.ToInt32(r["Sorting"]) : speakerId;

            string nameEn = GetColString(r, cols, "FullNameEn");
            string nameAr = GetColString(r, cols, "FullNameAr");
            string name = isArabic ? (!string.IsNullOrEmpty(nameAr) ? nameAr : nameEn) : (!string.IsNullOrEmpty(nameEn) ? nameEn : nameAr);

            string jobTitleEn = GetColString(r, cols, "JobTitleEn");
            string jobTitleAr = GetColString(r, cols, "JobTitleAr");
            string jobTitle = isArabic ? (!string.IsNullOrEmpty(jobTitleAr) ? jobTitleAr : jobTitleEn) : (!string.IsNullOrEmpty(jobTitleEn) ? jobTitleEn : jobTitleAr);

            string orgEn = GetColString(r, cols, "OrganizationEn");
            string orgAr = GetColString(r, cols, "OrganizationAr");
            string org = isArabic ? (!string.IsNullOrEmpty(orgAr) ? orgAr : orgEn) : (!string.IsNullOrEmpty(orgEn) ? orgEn : orgAr);

            string lectureEn = GetColString(r, cols, "LectureTitleEn", "TitleEn", "SessionTitleEn", "BioEn");
            string lectureAr = GetColString(r, cols, "LectureTitleAr", "TitleAr", "SessionTitleAr", "BioAr");
            string lecture = isArabic ? (!string.IsNullOrEmpty(lectureAr) ? lectureAr : lectureEn) : (!string.IsNullOrEmpty(lectureEn) ? lectureEn : lectureAr);

            // Session Details (Room, Time, Day, Role)
            int? sessionId = null;
            if (cols.Contains("SessionID") && r["SessionID"] != DBNull.Value)
            {
                int sid;
                if (int.TryParse(r["SessionID"].ToString(), out sid)) sessionId = sid;
            }

            string roomEn = GetColString(r, cols, "RoomEn");
            string roomAr = GetColString(r, cols, "RoomAr");
            string room = isArabic ? (!string.IsNullOrEmpty(roomAr) ? roomAr : roomEn) : (!string.IsNullOrEmpty(roomEn) ? roomEn : roomAr);

            int dayNumber = 1;
            if (cols.Contains("DayNumber") && r["DayNumber"] != DBNull.Value)
            {
                int.TryParse(r["DayNumber"].ToString(), out dayNumber);
            }

            string startTime = GetColString(r, cols, "StartTime");
            string endTime = GetColString(r, cols, "EndTime");
            string sessionTime = "";
            if (!string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(endTime))
            {
                sessionTime = startTime + " - " + endTime;
            }
            else if (!string.IsNullOrEmpty(startTime))
            {
                sessionTime = startTime;
            }

            string roleEn = GetColString(r, cols, "SessionRoleEn", "RoleEn");
            string roleAr = GetColString(r, cols, "SessionRoleAr", "RoleAr");
            string role = isArabic ? (!string.IsNullOrEmpty(roleAr) ? roleAr : roleEn) : (!string.IsNullOrEmpty(roleEn) ? roleEn : roleAr);
            if (string.IsNullOrEmpty(role))
            {
                role = isArabic ? "متحدث" : "Speaker";
            }

            // Track determination
            string track = GetColString(r, cols, "Track", "SessionTrack");
            if (string.IsNullOrEmpty(track))
            {
                if (sorting <= 10) track = "track-a";
                else if (sorting <= 23) track = "track-b";
                else track = "track-c";
            }
            track = track.ToLowerInvariant().Trim();

            string trackName = isArabic ? GetColString(r, cols, "TrackNameAr", "SessionTrackNameAr") : GetColString(r, cols, "TrackNameEn", "SessionTrackNameEn");
            if (string.IsNullOrEmpty(trackName))
            {
                trackName = GetDefaultTrackName(track, isArabic);
            }

            // Sector determination
            string sector = GetColString(r, cols, "Sector");
            if (string.IsNullOrEmpty(sector)) sector = "clinical";
            sector = sector.ToLowerInvariant().Trim();

            string sectorName = isArabic ? GetColString(r, cols, "SectorNameAr") : GetColString(r, cols, "SectorNameEn");
            if (string.IsNullOrEmpty(sectorName))
            {
                sectorName = GetDefaultSectorName(sector, isArabic);
            }

            // Region & Flag
            string region = GetColString(r, cols, "Region");
            if (string.IsNullOrEmpty(region)) region = "national";
            region = region.ToLowerInvariant().Trim();

            string regionName = isArabic ? GetColString(r, cols, "RegionNameAr") : GetColString(r, cols, "RegionNameEn");
            if (string.IsNullOrEmpty(regionName))
            {
                regionName = isArabic ? "المملكة العربية السعودية" : "Saudi Arabia";
            }

            string flag = GetColString(r, cols, "Flag");
            if (string.IsNullOrEmpty(flag)) flag = "🇸🇦";

            string initials = GetColString(r, cols, "Initials");
            if (string.IsNullOrEmpty(initials)) initials = ComputeInitials(name);

            string imagePath = GetColString(r, cols, "ImagePath");
            if (string.IsNullOrEmpty(imagePath)) imagePath = "/Content/images/speakers/Speaker-Photo.png";

            string cvPdfPath = GetColString(r, cols, "CvPdfPath");

            return new SpeakerViewModel
            {
                SpeakerId = speakerId,
                Name = name,
                JobTitle = jobTitle,
                Organization = org,
                LectureTitle = lecture,
                Track = track,
                TrackName = trackName,
                TrackBadge = GetTrackBadge(track, isArabic),
                TrackIcon = GetTrackIcon(track),
                TrackCssClass = track,
                Sector = sector,
                SectorName = sectorName,
                SectorBadge = GetSectorBadge(sector, isArabic, sectorName),
                SectorIcon = GetSectorIcon(sector),
                Region = region,
                RegionName = regionName,
                ImagePath = imagePath,
                CvPdfPath = cvPdfPath,
                Flag = flag,
                Initials = initials,
                LectureLabel = isArabic ? "عنوان المحاضرة" : "Lecture Presentation",
                QuickOverviewText = isArabic ? "نظرة سريعة" : "Quick Overview",
                Sorting = sorting,
                IsActive = true,

                // Session mapping
                SessionId = sessionId,
                Room = room,
                RoomEn = roomEn,
                RoomAr = roomAr,
                DayNumber = dayNumber,
                StartTime = startTime,
                EndTime = endTime,
                SessionTime = sessionTime,
                Role = role,
                RoleEn = roleEn,
                RoleAr = roleAr
            };
        }

        /// <summary>
        /// Reads fallback speakers from Content/data/speakers.json.
        /// </summary>
        public static List<SpeakerViewModel> GetFallbackSpeakers(bool isArabic)
        {
            var list = new List<SpeakerViewModel>();
            string filePath = string.Empty;

            if (HttpContext.Current != null && HttpContext.Current.Server != null)
            {
                filePath = HttpContext.Current.Server.MapPath("~/Content/data/speakers.json");
            }
            else
            {
                filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Content", "data", "speakers.json");
            }

            if (!File.Exists(filePath))
            {
                return list;
            }

            string json = File.ReadAllText(filePath);
            var rawList = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json);
            if (rawList == null) return list;

            foreach (var item in rawList)
            {
                int id = item.ContainsKey("SpeakerID") ? Convert.ToInt32(item["SpeakerID"]) : 0;
                int sorting = item.ContainsKey("Sorting") ? Convert.ToInt32(item["Sorting"]) : id;

                string nameEn = item.ContainsKey("FullNameEn") ? Convert.ToString(item["FullNameEn"]) : "";
                string nameAr = item.ContainsKey("FullNameAr") ? Convert.ToString(item["FullNameAr"]) : "";
                string name = isArabic ? (!string.IsNullOrEmpty(nameAr) ? nameAr : nameEn) : (!string.IsNullOrEmpty(nameEn) ? nameEn : nameAr);

                string jobTitleEn = item.ContainsKey("JobTitleEn") ? Convert.ToString(item["JobTitleEn"]) : "";
                string jobTitleAr = item.ContainsKey("JobTitleAr") ? Convert.ToString(item["JobTitleAr"]) : "";
                string jobTitle = isArabic ? (!string.IsNullOrEmpty(jobTitleAr) ? jobTitleAr : jobTitleEn) : (!string.IsNullOrEmpty(jobTitleEn) ? jobTitleEn : jobTitleAr);

                string orgEn = item.ContainsKey("OrganizationEn") ? Convert.ToString(item["OrganizationEn"]) : "";
                string orgAr = item.ContainsKey("OrganizationAr") ? Convert.ToString(item["OrganizationAr"]) : "";
                string org = isArabic ? (!string.IsNullOrEmpty(orgAr) ? orgAr : orgEn) : (!string.IsNullOrEmpty(orgEn) ? orgEn : orgAr);

                string lectureEn = item.ContainsKey("LectureTitleEn") ? Convert.ToString(item["LectureTitleEn"]) : "";
                string lectureAr = item.ContainsKey("LectureTitleAr") ? Convert.ToString(item["LectureTitleAr"]) : "";
                string lecture = isArabic ? (!string.IsNullOrEmpty(lectureAr) ? lectureAr : lectureEn) : (!string.IsNullOrEmpty(lectureEn) ? lectureEn : lectureAr);

                string track = item.ContainsKey("Track") ? Convert.ToString(item["Track"]).ToLowerInvariant().Trim() : "track-a";
                string trackNameEn = item.ContainsKey("TrackNameEn") ? Convert.ToString(item["TrackNameEn"]) : "";
                string trackNameAr = item.ContainsKey("TrackNameAr") ? Convert.ToString(item["TrackNameAr"]) : "";
                string trackName = isArabic ? (!string.IsNullOrEmpty(trackNameAr) ? trackNameAr : trackNameEn) : (!string.IsNullOrEmpty(trackNameEn) ? trackNameEn : trackNameAr);

                string sector = item.ContainsKey("Sector") ? Convert.ToString(item["Sector"]).ToLowerInvariant().Trim() : "clinical";
                string sectorNameEn = item.ContainsKey("SectorNameEn") ? Convert.ToString(item["SectorNameEn"]) : "";
                string sectorNameAr = item.ContainsKey("SectorNameAr") ? Convert.ToString(item["SectorNameAr"]) : "";
                string sectorName = isArabic ? (!string.IsNullOrEmpty(sectorNameAr) ? sectorNameAr : sectorNameEn) : (!string.IsNullOrEmpty(sectorNameEn) ? sectorNameEn : sectorNameAr);

                string region = item.ContainsKey("Region") ? Convert.ToString(item["Region"]).ToLowerInvariant().Trim() : "national";
                string regionNameEn = item.ContainsKey("RegionNameEn") ? Convert.ToString(item["RegionNameEn"]) : "";
                string regionNameAr = item.ContainsKey("RegionNameAr") ? Convert.ToString(item["RegionNameAr"]) : "";
                string regionName = isArabic ? (!string.IsNullOrEmpty(regionNameAr) ? regionNameAr : regionNameEn) : (!string.IsNullOrEmpty(regionNameEn) ? regionNameEn : regionNameAr);

                string imagePath = item.ContainsKey("ImagePath") ? Convert.ToString(item["ImagePath"]) : "";
                string cvPdfPath = item.ContainsKey("CvPdfPath") ? Convert.ToString(item["CvPdfPath"]) : "";
                string flag = item.ContainsKey("Flag") ? Convert.ToString(item["Flag"]) : "🇸🇦";
                string initials = item.ContainsKey("Initials") ? Convert.ToString(item["Initials"]) : ComputeInitials(name);

                string roomEn = item.ContainsKey("RoomEn") ? Convert.ToString(item["RoomEn"]) : "";
                string roomAr = item.ContainsKey("RoomAr") ? Convert.ToString(item["RoomAr"]) : "";
                string room = isArabic ? (!string.IsNullOrEmpty(roomAr) ? roomAr : roomEn) : (!string.IsNullOrEmpty(roomEn) ? roomEn : roomAr);

                int dayNumber = 1;
                if (item.ContainsKey("DayNumber") && item["DayNumber"] != null)
                {
                    int.TryParse(item["DayNumber"].ToString(), out dayNumber);
                }

                string startTime = item.ContainsKey("StartTime") ? Convert.ToString(item["StartTime"]) : "";
                string endTime = item.ContainsKey("EndTime") ? Convert.ToString(item["EndTime"]) : "";
                string sessionTime = "";
                if (!string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(endTime))
                {
                    sessionTime = startTime + " - " + endTime;
                }
                else if (!string.IsNullOrEmpty(startTime))
                {
                    sessionTime = startTime;
                }

                string roleEn = item.ContainsKey("RoleEn") ? Convert.ToString(item["RoleEn"]) : "Speaker";
                string roleAr = item.ContainsKey("RoleAr") ? Convert.ToString(item["RoleAr"]) : "متحدث";
                string role = isArabic ? (!string.IsNullOrEmpty(roleAr) ? roleAr : roleEn) : (!string.IsNullOrEmpty(roleEn) ? roleEn : roleAr);

                list.Add(new SpeakerViewModel
                {
                    SpeakerId = id,
                    Name = name,
                    JobTitle = jobTitle,
                    Organization = org,
                    LectureTitle = lecture,
                    Track = track,
                    TrackName = trackName,
                    TrackBadge = GetTrackBadge(track, isArabic),
                    TrackIcon = GetTrackIcon(track),
                    TrackCssClass = track,
                    Sector = sector,
                    SectorName = sectorName,
                    SectorBadge = GetSectorBadge(sector, isArabic, sectorName),
                    SectorIcon = GetSectorIcon(sector),
                    Region = region,
                    RegionName = regionName,
                    ImagePath = imagePath,
                    CvPdfPath = cvPdfPath,
                    Flag = flag,
                    Initials = initials,
                    LectureLabel = isArabic ? "عنوان المحاضرة" : "Lecture Presentation",
                    QuickOverviewText = isArabic ? "نظرة سريعة" : "Quick Overview",
                    Sorting = sorting,
                    IsActive = true,

                    // Session mapping
                    SessionId = id,
                    Room = room,
                    RoomEn = roomEn,
                    RoomAr = roomAr,
                    DayNumber = dayNumber,
                    StartTime = startTime,
                    EndTime = endTime,
                    SessionTime = sessionTime,
                    Role = role,
                    RoleEn = roleEn,
                    RoleAr = roleAr
                });
            }

            return list;
        }

        // ------------------------------------------------------------------
        // Helper formatting functions
        // ------------------------------------------------------------------

        public static string GetTrackIcon(string track)
        {
            switch (track)
            {
                case "track-a": return "bi bi-cpu";
                case "track-b": return "bi bi-activity";
                case "track-c": return "bi bi-lightbulb";
                default: return "bi bi-cpu";
            }
        }

        public static string GetTrackBadge(string track, bool isArabic)
        {
            switch (track)
            {
                case "track-a": return isArabic ? "المسار أ" : "Track A";
                case "track-b": return isArabic ? "المسار ب" : "Track B";
                case "track-c": return isArabic ? "المسار ج" : "Track C";
                default: return isArabic ? "مسار القمة" : "Summit Track";
            }
        }

        public static string GetDefaultTrackName(string track, bool isArabic)
        {
            switch (track)
            {
                case "track-a": return isArabic ? "المسار أ – الذكاء الاصطناعي والتحول التقني الرقمي" : "Track A – AI & Digital Technology Transformation";
                case "track-b": return isArabic ? "المسار ب – تقنيات الأشعة المتقدمة" : "Track B – Advanced Radiology";
                case "track-c": return isArabic ? "المسار ج – الابتكار الصحي ونماذج الأعمال" : "Track C – Health Innovation";
                default: return isArabic ? "مسارات القمة" : "Summit Tracks";
            }
        }

        public static string GetSectorIcon(string sector)
        {
            switch (sector)
            {
                case "clinical": return "bi bi-hospital";
                case "academic": return "bi bi-mortarboard";
                case "industry": return "bi bi-building";
                case "international": return "bi bi-globe";
                case "governmental": return "bi bi-shield-check";
                default: return "bi bi-award";
            }
        }

        public static string GetSectorBadge(string sector, bool isArabic, string sectorName)
        {
            if (isArabic)
            {
                switch (sector)
                {
                    case "clinical": return "قطاع سريري";
                    case "academic": return "قطاع أكاديمي";
                    case "industry": return "قطاع صناعي";
                    case "international": return "دولي";
                    default: return !string.IsNullOrEmpty(sectorName) ? sectorName : "قطاع متخصص";
                }
            }
            else
            {
                switch (sector)
                {
                    case "clinical": return "Clinical";
                    case "academic": return "Academic";
                    case "industry": return "Industry";
                    case "international": return "International";
                    default: return !string.IsNullOrEmpty(sectorName) ? sectorName : "Specialized";
                }
            }
        }

        public static string GetDefaultSectorName(string sector, bool isArabic)
        {
            if (isArabic)
            {
                switch (sector)
                {
                    case "clinical": return "رعاية صحية ومستشفيات";
                    case "academic": return "أكاديمي وجامعي";
                    case "industry": return "صناعة وتقنية";
                    case "international": return "دولي وإقليمي";
                    default: return "قطاع الرعاية الصحية";
                }
            }
            else
            {
                switch (sector)
                {
                    case "clinical": return "Hospitals & Healthcare";
                    case "academic": return "Academic & Universities";
                    case "industry": return "Industry & Technology";
                    case "international": return "International";
                    default: return "Healthcare Sector";
                }
            }
        }

        private static string GetColString(IDataRecord r, HashSet<string> cols, params string[] candidateNames)
        {
            foreach (var col in candidateNames)
            {
                if (cols.Contains(col) && r[col] != DBNull.Value)
                {
                    string val = r[col].ToString().Trim();
                    if (!string.IsNullOrEmpty(val)) return val;
                }
            }
            return string.Empty;
        }

        private static string ComputeInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "SP";
            string clean = Regex.Replace(name, @"^(Dr\.|Prof\.|Mr\.|Ms\.|Eng\.|د\.|أ\.|م\.|بروفيسور\.)\s*", "", RegexOptions.IgnoreCase).Trim();
            string[] parts = clean.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length >= 2)
            {
                return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpperInvariant();
            }
            if (parts.Length == 1 && parts[0].Length >= 2)
            {
                return parts[0].Substring(0, 2).ToUpperInvariant();
            }
            return "SP";
        }
    }
}
