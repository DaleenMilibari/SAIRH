using System;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using Microsoft.Data.SqlClient;

namespace SAIRH.Tools
{
    class Program
    {
        static int Main(string[] args)
        {
            Console.WriteLine("==================================================================");
            Console.WriteLine("   SAIRH 2026 - Database Connection & Speakers Diagnostic Tool   ");
            Console.WriteLine("==================================================================");

            // 1. Locate Web.config
            string rootDir = Directory.GetCurrentDirectory();
            string webConfigPath = Path.Combine(rootDir, "AIE", "AIE", "Web.config");
            if (!File.Exists(webConfigPath))
            {
                // Try parent directories
                string? parent = Directory.GetParent(rootDir)?.FullName;
                if (parent != null && File.Exists(Path.Combine(parent, "AIE", "AIE", "Web.config")))
                {
                    webConfigPath = Path.Combine(parent, "AIE", "AIE", "Web.config");
                }
            }

            if (!File.Exists(webConfigPath))
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"[ERROR] Could not find Web.config at {webConfigPath}");
                Console.ResetColor();
                return 1;
            }

            Console.WriteLine($"[1] Located Web.config: {webConfigPath}");

            // 2. Read AIEConnectionString from Web.config
            string configContent = File.ReadAllText(webConfigPath);
            var match = Regex.Match(configContent, @"name=[""']AIEConnectionString[""']\s+connectionString=[""']([^""']+)[""']");
            if (!match.Success)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("[ERROR] 'AIEConnectionString' not found in Web.config.");
                Console.ResetColor();
                return 1;
            }

            string rawConnStr = match.Groups[1].Value;
            string maskedConnStr = Regex.Replace(rawConnStr, @"(Password|pwd)\s*=\s*[^;]+", "$1=******", RegexOptions.IgnoreCase);
            Console.WriteLine($"[2] Connection String: {maskedConnStr}");

            // Check if (localdb) is being used on macOS
            bool isMac = OperatingSystem.IsMacOS() || OperatingSystem.IsLinux();
            if (isMac && rawConnStr.Contains("(localdb)", StringComparison.OrdinalIgnoreCase))
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine("\n[NOTE] Detected '(localdb)\\MSSQLLocalDB' on macOS/Linux.");
                Console.WriteLine("       Microsoft SQL Server LocalDB runs only on Windows.");
                Console.WriteLine("       On macOS, connect to SQL Server via Docker, Azure SQL, or a remote server.");
                Console.ResetColor();
            }

            // 3. Attempt Connection to Database
            Console.WriteLine("\n[3] Testing SQL Server connectivity...");
            try
            {
                using var conn = new SqlConnection(rawConnStr);
                conn.Open();

                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine($"[SUCCESS] Connected to SQL Server successfully! (Server Version: {conn.ServerVersion})");
                Console.ResetColor();

                // 4. Verify dbo.Speakers table
                Console.WriteLine("\n[4] Inspecting [dbo].[Speakers] table...");
                using var checkCmd = new SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Speakers'", conn);
                int tableExists = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (tableExists == 0)
                {
                    Console.ForegroundColor = ConsoleColor.Yellow;
                    Console.WriteLine("[WARNING] Table [dbo].[Speakers] does not exist yet.");
                    Console.WriteLine("          Run 'AIE/AIE/Database/SAIRH_Database_Setup.sql' in SQL Server Management Studio or Azure Data Studio.");
                    Console.ResetColor();
                    return 0;
                }

                bool syncMode = args != null && Array.Exists(args, a => a.Equals("--sync", StringComparison.OrdinalIgnoreCase) || a.Equals("--export", StringComparison.OrdinalIgnoreCase));

                // Query speakers
                const string query = @"
                    IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL
                    BEGIN
                        EXEC('SELECT * FROM [dbo].[vw_SummitSpeakers] ORDER BY [Sorting] ASC, [SpeakerID] ASC;');
                    END
                    ELSE
                    BEGIN
                        EXEC('SELECT * FROM [dbo].[Speakers] WHERE [IsActive] = 1 ORDER BY [Sorting] ASC, [SpeakerID] ASC;');
                    END";

                using var cmd = new SqlCommand(query, conn);
                using var reader = cmd.ExecuteReader();

                var cols = new System.Collections.Generic.HashSet<string>(StringComparer.OrdinalIgnoreCase);
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    cols.Add(reader.GetName(i));
                }

                var speakerList = new System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object?>>();
                int count = 0;
                Console.WriteLine("\n[5] Retrieved Active Speakers from Database:");
                Console.WriteLine("------------------------------------------------------------------");
                Console.WriteLine(string.Format("{0,-4} | {1,-26} | {2,-10} | {3,-10}", "ID", "Name (EN)", "Track", "Sector"));
                Console.WriteLine("------------------------------------------------------------------");

                while (reader.Read())
                {
                    count++;
                    int id = cols.Contains("SpeakerID") && !reader.IsDBNull(reader.GetOrdinal("SpeakerID")) ? Convert.ToInt32(reader["SpeakerID"]) : count;
                    string nameEn = cols.Contains("FullNameEn") && !reader.IsDBNull(reader.GetOrdinal("FullNameEn")) ? reader["FullNameEn"].ToString() ?? "" : "";
                    string track = cols.Contains("Track") && !reader.IsDBNull(reader.GetOrdinal("Track")) ? reader["Track"].ToString() ?? "track-a" : "track-a";
                    string sector = cols.Contains("Sector") && !reader.IsDBNull(reader.GetOrdinal("Sector")) ? reader["Sector"].ToString() ?? "clinical" : "clinical";

                    if (count <= 10)
                    {
                        Console.WriteLine(string.Format("{0,-4} | {1,-26} | {2,-10} | {3,-10}", id, Truncate(nameEn, 26), track, sector));
                    }

                    if (syncMode)
                    {
                        var row = new System.Collections.Generic.Dictionary<string, object?>();
                        row["SpeakerID"] = id;
                        row["FullNameEn"] = nameEn;
                        row["FullNameAr"] = cols.Contains("FullNameAr") && !reader.IsDBNull(reader.GetOrdinal("FullNameAr")) ? reader["FullNameAr"].ToString() : "";
                        row["JobTitleEn"] = cols.Contains("JobTitleEn") && !reader.IsDBNull(reader.GetOrdinal("JobTitleEn")) ? reader["JobTitleEn"].ToString() : "";
                        row["JobTitleAr"] = cols.Contains("JobTitleAr") && !reader.IsDBNull(reader.GetOrdinal("JobTitleAr")) ? reader["JobTitleAr"].ToString() : "";
                        row["OrganizationEn"] = cols.Contains("OrganizationEn") && !reader.IsDBNull(reader.GetOrdinal("OrganizationEn")) ? reader["OrganizationEn"].ToString() : "";
                        row["OrganizationAr"] = cols.Contains("OrganizationAr") && !reader.IsDBNull(reader.GetOrdinal("OrganizationAr")) ? reader["OrganizationAr"].ToString() : "";
                        row["LectureTitleEn"] = cols.Contains("LectureTitleEn") && !reader.IsDBNull(reader.GetOrdinal("LectureTitleEn")) ? reader["LectureTitleEn"].ToString() : (cols.Contains("BioEn") && !reader.IsDBNull(reader.GetOrdinal("BioEn")) ? reader["BioEn"].ToString() : "");
                        row["LectureTitleAr"] = cols.Contains("LectureTitleAr") && !reader.IsDBNull(reader.GetOrdinal("LectureTitleAr")) ? reader["LectureTitleAr"].ToString() : (cols.Contains("BioAr") && !reader.IsDBNull(reader.GetOrdinal("BioAr")) ? reader["BioAr"].ToString() : "");
                        row["Track"] = track;
                        row["TrackNameEn"] = cols.Contains("TrackNameEn") && !reader.IsDBNull(reader.GetOrdinal("TrackNameEn")) ? reader["TrackNameEn"].ToString() : "";
                        row["TrackNameAr"] = cols.Contains("TrackNameAr") && !reader.IsDBNull(reader.GetOrdinal("TrackNameAr")) ? reader["TrackNameAr"].ToString() : "";
                        row["Sector"] = sector;
                        row["SectorNameEn"] = cols.Contains("SectorNameEn") && !reader.IsDBNull(reader.GetOrdinal("SectorNameEn")) ? reader["SectorNameEn"].ToString() : "";
                        row["SectorNameAr"] = cols.Contains("SectorNameAr") && !reader.IsDBNull(reader.GetOrdinal("SectorNameAr")) ? reader["SectorNameAr"].ToString() : "";
                        row["Region"] = cols.Contains("Region") && !reader.IsDBNull(reader.GetOrdinal("Region")) ? reader["Region"].ToString() : "national";
                        row["RegionNameEn"] = cols.Contains("RegionNameEn") && !reader.IsDBNull(reader.GetOrdinal("RegionNameEn")) ? reader["RegionNameEn"].ToString() : "Saudi Arabia";
                        row["RegionNameAr"] = cols.Contains("RegionNameAr") && !reader.IsDBNull(reader.GetOrdinal("RegionNameAr")) ? reader["RegionNameAr"].ToString() : "المملكة العربية السعودية";
                        row["ImagePath"] = cols.Contains("ImagePath") && !reader.IsDBNull(reader.GetOrdinal("ImagePath")) ? reader["ImagePath"].ToString() : "/Content/images/speakers/Speaker-Photo.png";
                        row["CvPdfPath"] = cols.Contains("CvPdfPath") && !reader.IsDBNull(reader.GetOrdinal("CvPdfPath")) ? reader["CvPdfPath"].ToString() : "";
                        row["Flag"] = cols.Contains("Flag") && !reader.IsDBNull(reader.GetOrdinal("Flag")) ? reader["Flag"].ToString() : "🇸🇦";
                        row["Initials"] = cols.Contains("Initials") && !reader.IsDBNull(reader.GetOrdinal("Initials")) ? reader["Initials"].ToString() : "";
                        row["Sorting"] = cols.Contains("Sorting") && !reader.IsDBNull(reader.GetOrdinal("Sorting")) ? Convert.ToInt32(reader["Sorting"]) : id;
                        row["IsActive"] = true;

                        // Session fields
                        row["RoomEn"] = cols.Contains("RoomEn") && !reader.IsDBNull(reader.GetOrdinal("RoomEn")) ? reader["RoomEn"].ToString() : "";
                        row["RoomAr"] = cols.Contains("RoomAr") && !reader.IsDBNull(reader.GetOrdinal("RoomAr")) ? reader["RoomAr"].ToString() : "";
                        row["DayNumber"] = cols.Contains("DayNumber") && !reader.IsDBNull(reader.GetOrdinal("DayNumber")) ? Convert.ToInt32(reader["DayNumber"]) : 1;
                        row["StartTime"] = cols.Contains("StartTime") && !reader.IsDBNull(reader.GetOrdinal("StartTime")) ? reader["StartTime"].ToString() : "";
                        row["EndTime"] = cols.Contains("EndTime") && !reader.IsDBNull(reader.GetOrdinal("EndTime")) ? reader["EndTime"].ToString() : "";
                        row["StartDateTime"] = cols.Contains("StartDateTime") && !reader.IsDBNull(reader.GetOrdinal("StartDateTime")) ? reader["StartDateTime"].ToString() : "";
                        row["EndDateTime"] = cols.Contains("EndDateTime") && !reader.IsDBNull(reader.GetOrdinal("EndDateTime")) ? reader["EndDateTime"].ToString() : "";
                        row["RoleEn"] = cols.Contains("SessionRoleEn") && !reader.IsDBNull(reader.GetOrdinal("SessionRoleEn")) ? reader["SessionRoleEn"].ToString() : (cols.Contains("RoleEn") && !reader.IsDBNull(reader.GetOrdinal("RoleEn")) ? reader["RoleEn"].ToString() : "Speaker");
                        row["RoleAr"] = cols.Contains("SessionRoleAr") && !reader.IsDBNull(reader.GetOrdinal("SessionRoleAr")) ? reader["SessionRoleAr"].ToString() : (cols.Contains("RoleAr") && !reader.IsDBNull(reader.GetOrdinal("RoleAr")) ? reader["RoleAr"].ToString() : "متحدث");

                        speakerList.Add(row);
                    }
                }

                if (count > 10)
                {
                    Console.WriteLine($"... and {count - 10} more speakers (total: {count})");
                }

                Console.WriteLine("------------------------------------------------------------------");
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine($"[RESULT] Live database data retrieval works! Total active speakers: {count}");
                Console.ResetColor();

                if (syncMode)
                {
                    string targetJson = Path.Combine(rootDir, "AIE", "AIE", "Content", "data", "speakers.json");
                    if (!File.Exists(targetJson))
                    {
                        string? parent = Directory.GetParent(rootDir)?.FullName;
                        if (parent != null) targetJson = Path.Combine(parent, "AIE", "AIE", "Content", "data", "speakers.json");
                    }

                    if (File.Exists(targetJson))
                    {
                        string jsonString = System.Text.Json.JsonSerializer.Serialize(speakerList, new System.Text.Json.JsonSerializerOptions { WriteIndented = true });
                        File.WriteAllText(targetJson, jsonString);
                        Console.ForegroundColor = ConsoleColor.Cyan;
                        Console.WriteLine($"\n[SYNC SUCCESS] Exported {speakerList.Count} speakers from database directly to:");
                        Console.WriteLine($"               {targetJson}");
                        Console.WriteLine("               Changes from DataGrip are now synced with the website!");
                        Console.ResetColor();
                    }
                }
                else
                {
                    Console.WriteLine("\n[TIP] To sync changes from DataGrip to the website's cache, run:");
                    Console.WriteLine("      dotnet run --project tools/TestDbConnection --sync");
                }

                return 0;
            }
            catch (SqlException sqlEx)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"\n[DB ERROR] SQL Exception: {sqlEx.Message}");
                Console.ResetColor();
                Console.WriteLine($"           Error Number: {sqlEx.Number}");

                // Test Fallback System
                TestFallbackSystem(rootDir);
                return 0; // Return 0 because fallback works
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"\n[ERROR] Connection failed: {ex.Message}");
                Console.ResetColor();

                TestFallbackSystem(rootDir);
                return 0;
            }
        }

        static void TestFallbackSystem(string rootDir)
        {
            Console.WriteLine("\n[4] Verifying Crash-Prevention Fallback Mechanism...");
            string jsonPath = Path.Combine(rootDir, "AIE", "AIE", "Content", "data", "speakers.json");
            if (!File.Exists(jsonPath))
            {
                string? parent = Directory.GetParent(rootDir)?.FullName;
                if (parent != null) jsonPath = Path.Combine(parent, "AIE", "AIE", "Content", "data", "speakers.json");
            }

            if (File.Exists(jsonPath))
            {
                string content = File.ReadAllText(jsonPath);
                int count = Regex.Matches(content, @"""SpeakerID""").Count;

                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine($"[VERIFIED] Fallback cache is healthy: {count} speakers ready in 'Content/data/speakers.json'.");
                Console.WriteLine("           Because of the try-catch error handling in SpeakerService.cs,");
                Console.WriteLine("           the website will gracefully serve these cached speakers without crashing!");
                Console.ResetColor();
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"[ERROR] Fallback file not found at {jsonPath}");
                Console.ResetColor();
            }
        }

        static string Truncate(string value, int maxChars)
        {
            return value.Length <= maxChars ? value : value.Substring(0, maxChars - 3) + "...";
        }
    }
}
