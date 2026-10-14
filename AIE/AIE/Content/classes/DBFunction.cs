using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace DBFunction
{
    public class Ado
    {
        // 1. Safely retrieve the connection string with null fallback
        private static string _connString
        {
            get
            {
                var conn = ConfigurationManager.ConnectionStrings["AIEConnectionString"];
                return conn != null ? conn.ConnectionString : string.Empty;
            }
        }

        // 2. Per-request error state storage in HttpContext to prevent concurrency race conditions across users
        private const string BlnErrorKey = "__Ado_BlnError";
        private const string StrErrorKey = "__Ado_StrError";

        [ThreadStatic]
        private static bool _fallbackBlnError;
        [ThreadStatic]
        private static string _fallbackStrError;

        // Safely record errors scoped exclusively to the current HTTP request or thread
        private static void SetError(bool hasError, string errorMsg)
        {
            if (HttpContext.Current != null)
            {
                HttpContext.Current.Items[BlnErrorKey] = hasError;
                HttpContext.Current.Items[StrErrorKey] = errorMsg ?? string.Empty;
            }
            else
            {
                _fallbackBlnError = hasError;
                _fallbackStrError = errorMsg ?? string.Empty;
            }
        }

        public static bool BlnError
        {
            get
            {
                if (HttpContext.Current != null)
                {
                    if (HttpContext.Current.Items[BlnErrorKey] is bool b && b)
                    {
                        HttpContext.Current.Items[BlnErrorKey] = false;
                        return true;
                    }
                    return false;
                }
                else
                {
                    if (_fallbackBlnError)
                    {
                        _fallbackBlnError = false;
                        return true;
                    }
                    return false;
                }
            }
            set
            {
                SetError(value, StrError);
            }
        }

        public static string StrError
        {
            get
            {
                if (HttpContext.Current != null)
                {
                    string str = HttpContext.Current.Items[StrErrorKey] as string;
                    if (!string.IsNullOrEmpty(str))
                    {
                        HttpContext.Current.Items[StrErrorKey] = string.Empty;
                        return str;
                    }
                    return string.Empty;
                }
                else
                {
                    if (!string.IsNullOrEmpty(_fallbackStrError))
                    {
                        string str = _fallbackStrError;
                        _fallbackStrError = string.Empty;
                        return str;
                    }
                    return string.Empty;
                }
            }
            set
            {
                SetError(BlnError, value);
            }
        }

        // 3. Configurable encryption key with fallback
        private static string EncryptionKey => ConfigurationManager.AppSettings["EncryptionKey"] ?? "@iau#amc@year2022";

        public static string encrypt(string encryptString)
        {
            if (string.IsNullOrEmpty(encryptString)) return string.Empty;

            try
            {
                byte[] clearBytes = Encoding.Unicode.GetBytes(encryptString);
                using (Aes encryptor = Aes.Create())
                {
                    Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x02, 0x18, 0x78, 0x18, 0x18, 0x18, 0x18, 0x18 });
                    encryptor.Key = pdb.GetBytes(32);
                    encryptor.IV = pdb.GetBytes(16);
                    using (MemoryStream ms = new MemoryStream())
                    {
                        using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                        {
                            cs.Write(clearBytes, 0, clearBytes.Length);
                            cs.Close();
                        }
                        return Convert.ToBase64String(ms.ToArray());
                    }
                }
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }

        public static string Decrypt(string cipherText)
        {
            if (string.IsNullOrEmpty(cipherText)) return string.Empty;

            try
            {
                cipherText = cipherText.Replace(" ", "+");
                byte[] cipherBytes = Convert.FromBase64String(cipherText);
                using (Aes encryptor = Aes.Create())
                {
                    Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x02, 0x18, 0x78, 0x18, 0x18, 0x18, 0x18, 0x18 });
                    encryptor.Key = pdb.GetBytes(32);
                    encryptor.IV = pdb.GetBytes(16);
                    using (MemoryStream ms = new MemoryStream())
                    {
                        using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                        {
                            cs.Write(cipherBytes, 0, cipherBytes.Length);
                            cs.Close();
                        }
                        return Encoding.Unicode.GetString(ms.ToArray());
                    }
                }
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }

        // 4. Cryptographically secure, thread-safe random string generator
        public static string RandomString(int length)
        {
            if (length <= 0) return string.Empty;
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            char[] result = new char[length];
            byte[] randomBytes = new byte[length];

            using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(randomBytes);
            }

            for (int i = 0; i < length; i++)
            {
                result[i] = chars[randomBytes[i] % chars.Length];
            }
            return new string(result);
        }

        // 5. Sanitize parameters to eliminate Delimiter Injection attacks (#~~#)
        private static string CleanParam(string param)
        {
            if (string.IsNullOrEmpty(param)) return string.Empty;
            return param.Replace("#~~#", string.Empty);
        }

        public class Users
        {
            public Int32 UserID { get; set; }
            public string UserName { get; set; }
            public string FullName { get; set; }
            public string UserLevel { get; set; }
        }

        public static Users UserDetails
        {
            get
            {
                if (HttpContext.Current?.Session == null) return null;
                return HttpContext.Current.Session["UserDetails"] as Users;
            }
            set
            {
                if (HttpContext.Current?.Session != null)
                {
                    HttpContext.Current.Session["UserDetails"] = value;
                }
            }
        }

        public class UsersRoles
        {
            public Int32 UserID { get; set; }
            public Int32 RoleID { get; set; }
            public string RoleShortname { get; set; }
        }

        public static IList<UsersRoles> UsersRolesDetails
        {
            get
            {
                if (HttpContext.Current?.Session == null) return null;
                return HttpContext.Current.Session["UsersRolesDetails"] as IList<UsersRoles>;
            }
            set
            {
                if (HttpContext.Current?.Session != null)
                {
                    HttpContext.Current.Session["UsersRolesDetails"] = value;
                }
            }
        }

        public class SaudiIqamaIdValidator
        {
            public static bool IsNumeric(object Expression)
            {
                double retNum;
                bool isNum = Double.TryParse(Convert.ToString(Expression), System.Globalization.NumberStyles.Any, System.Globalization.NumberFormatInfo.InvariantInfo, out retNum);
                return isNum;
            }

            public static Tuple<String> SaudiIqamaIdIsValid(string SaudiIqamaId)
            {
                if (string.IsNullOrWhiteSpace(SaudiIqamaId))
                {
                    return Tuple.Create("Invalid");
                }

                string SaudiID = SaudiIqamaId.Trim();
                int i = 0; int TOT = 0; int ten = 0;
                string TEMP = ""; string FIN;

                if (SaudiID.Length == 10 && IsNumeric(SaudiID))
                {
                    for (i = 0; i < 9; i++)
                    {
                        if ((i + 1) % 2 != 0)
                        {
                            TEMP = (Convert.ToInt32(SaudiID.Substring(i, 1)) * 2).ToString();
                            if (TEMP.Length == 1)
                            {
                                TEMP = "0" + TEMP;
                            }
                            TOT = TOT + (Convert.ToInt32(TEMP.Substring(0, 1))) + (Convert.ToInt32(TEMP.Substring(1, 1)));
                        }
                        else
                        {
                            TOT = TOT + (Convert.ToInt32(SaudiID.Substring(i, 1)));
                        }
                    }

                    FIN = TOT.ToString("00");
                    ten = (Convert.ToInt32(SaudiID.Substring(9, 1)));

                    if ((Convert.ToInt32(FIN.Substring(1, 1)) == ten) || (ten == 10 - Convert.ToInt32(FIN.Substring(1, 1))))
                    {
                        return Tuple.Create("Valid");
                    }
                    else
                    {
                        return Tuple.Create("Invalid");
                    }
                }
                else
                {
                    return Tuple.Create("Invalid");
                }
            }
        }

        // 6. Database query executions with delimiter sanitation and exception handling
        public static DataView UsersGetByUserName(string email, string pass)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("UsersGetByUserName", CleanParam(email) + "#~~#" + CleanParam(pass));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView LoginHistoryInsert(string userid, string ips, string devtype, string browtype, string browver, string loginsuccess)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("LoginHistoryInsert", CleanParam(userid) + "#~~#" + CleanParam(ips) + "#~~#" + CleanParam(devtype) + "#~~#" + CleanParam(browtype) + "#~~#" + CleanParam(browver) + "#~~#" + CleanParam(loginsuccess));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView UsersInsert(string FullName, string Username, string Pass, string MobileNo, string Gender, string Nationality)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("UsersInsert", CleanParam(FullName) + "#~~#" + CleanParam(Username) + "#~~#" + CleanParam(Pass) + "#~~#" + CleanParam(MobileNo) + "#~~#" + CleanParam(Gender) + "#~~#" + CleanParam(Nationality));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView UsersInsertV2(string FullName, string Username, string Pass, string MobileNo, string Gender, string Nationality, string Linkedin)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("UsersInsertV2", CleanParam(FullName) + "#~~#" + CleanParam(Username) + "#~~#" + CleanParam(Pass) + "#~~#" + CleanParam(MobileNo) + "#~~#" + CleanParam(Gender) + "#~~#" + CleanParam(Nationality) + "#~~#" + CleanParam(Linkedin));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView ContactUsInsert(string FullName, string Email, string Mobile, string Message)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("ContactUsInsert", CleanParam(FullName) + "#~~#" + CleanParam(Email) + "#~~#" + CleanParam(Mobile) + "#~~#" + CleanParam(Message));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView UsersGetByEmail(string email)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("UsersGetByEmail", CleanParam(email));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataSet LanguagesGet()
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("LanguagesGet", string.Empty);
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DSet;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView SponsorsGet(string lang)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("SponsorsGet", CleanParam(lang));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView WinnersGet(string cat)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("WinnersGet", CleanParam(cat));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView SchedulesGetVideoLink(string id)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("SchedulesGetVideoLink", CleanParam(id));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView UsersGetByID(string id)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("UsersGetByID", CleanParam(id));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView UsersUpdatePass(string userid, string pass)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("UsersUpdatePass", CleanParam(userid) + "#~~#" + CleanParam(pass));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }

        public static DataView UsersUpdateInfo(string userid, string MobileNo, string Gender, string Nationality, string Linkedn)
        {
            try
            {
                DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
                dbFun.ExecSelectProc("UsersUpdateInfo", CleanParam(userid) + "#~~#" + CleanParam(MobileNo) + "#~~#" + CleanParam(Gender) + "#~~#" + CleanParam(Nationality) + "#~~#" + CleanParam(Linkedn));
                if (dbFun.blnError)
                {
                    SetError(true, dbFun.strError);
                    return null;
                }
                return dbFun.DV;
            }
            catch (Exception)
            {
                SetError(true, "Database operation failed.");
                return null;
            }
        }
    }

    public class EmailSetting
    {
        public string SMTP { get; set; }
        public string EmailUser { get; set; }
        public string EmailPass { get; set; }
        public string EmailSubject { get; set; }
        public string EmailBody { get; set; }
        public string EmailCC { get; set; }
        public string EmailBCC { get; set; }
    }
}
