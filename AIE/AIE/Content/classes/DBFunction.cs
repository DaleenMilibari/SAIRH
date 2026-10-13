using System;
using System.Collections;
using System.Collections.Generic;
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
        private static string _connString = System.Configuration.ConfigurationManager.ConnectionStrings["AIEConnectionString"].ConnectionString;
        private static bool _blnError = false;
        private static string _strError = "";
        private static Random random = new Random();
        public static bool BlnError
        {
            get
            {
                if (_blnError == true)
                {
                    _blnError = false;
                    return true;
                }
                else
                {
                    return false;
                }
            }
            set
            {
                //blnError = value;
            }
        }
        public static string StrError
        {
            get
            {
                if (_strError != "")
                {
                    string str = _strError;
                    _strError = "";
                    return str;
                }
                else
                {
                    return "";
                }

            }
            set { }
        }
        public static string encrypt(string encryptString)
        {

            string EncryptionKey = "@iau#amc@year2022";
            byte[] clearBytes = Encoding.Unicode.GetBytes(encryptString);
            using (Aes encryptor = Aes.Create()) //Advanced Encryption Standard
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
                    encryptString = Convert.ToBase64String(ms.ToArray());
                }
            }
            return encryptString;
        }
        public static string Decrypt(string cipherText)
        {
            string EncryptionKey = "@iau#amc@year2022";
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
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }
        public static string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, length)
                .Select(s => s[random.Next(s.Length)]).ToArray());
        }


        [Serializable]
        public class Users
        {
            public Int32 UserID { get; set; }
            public string UserName { get; set; }
            public string FullName { get; set; }
            public string UserLevel { get; set; }
            public bool IsAdmin { get { return string.Equals(UserLevel, "Admin", StringComparison.OrdinalIgnoreCase); } }
            public string MobileNo { get; set; }
            public string Organization { get; set; }
            public string JobTitle { get; set; }
            public string Specialty { get; set; }
            public string LinkedInUrl { get; set; }
            public string SecurityStamp { get; set; }
        }
        /// <summary>
        /// The signed-in user, or null. The encrypted Forms auth cookie is the source of truth
        /// (its name is the AttendeeID); the session is only a cache and is ignored if it does
        /// not belong to the authenticated user.
        /// </summary>
        public static Users UserDetails
        {
            get
            {
                HttpContext ctx = HttpContext.Current;
                if (ctx == null || ctx.User == null || ctx.User.Identity == null || !ctx.User.Identity.IsAuthenticated)
                    return null;

                int userId;
                if (!int.TryParse(ctx.User.Identity.Name, System.Globalization.NumberStyles.None,
                                  System.Globalization.CultureInfo.InvariantCulture, out userId))
                    return null;

                Users cached = ctx.Session == null ? null : ctx.Session["UserDetails"] as Users;
                if (cached != null && cached.UserID == userId)
                    return cached;

                AIE.AuthService.Account account = AIE.AuthService.GetById(userId);
                if (account == null || account.IsBlocked)
                    return null;

                Users user = AIE.AuthService.ToUserDetails(account);
                if (ctx.Session != null) ctx.Session["UserDetails"] = user;
                return user;
            }
            set
            {
                HttpContext ctx = HttpContext.Current;
                if (ctx != null && ctx.Session != null) ctx.Session["UserDetails"] = value;
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
                return (HttpContext.Current.Session["UsersRolesDetails"] == null) ? null : (IList<UsersRoles>)HttpContext.Current.Session["UsersRolesDetails"];
            }
            set { HttpContext.Current.Session["UsersRolesDetails"] = value; }
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

                string SaudiID = SaudiIqamaId;
                int i = 0; int TOT = 0; int ten = 0;
                string TEMP = ""; string FIN;

                if (SaudiID.Length == 10 && IsNumeric(SaudiID) == true)
                {
                    for (i = 0; i < 9; i++)
                    {
                        if ((i + 1) % 2 != 0)
                        {
                            TEMP = (Convert.ToInt32(SaudiID.Substring(i, 1)) * 2).ToString();

                            if (TEMP.Length == 1)
                            {
                                TEMP = "0" + (Convert.ToInt32(SaudiID.Substring(i, 1)) * 2).ToString();

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

      

        public static DataView ContactUsInsert(string FullName, string Email, string Mobile, string Message)
        {
            DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
            dbFun.ExecSelectProc("ContactUsInsert", FullName + "#~~#" + Email + "#~~#" + Mobile + "#~~#" + Message);
            if (dbFun.blnError)
            {
                BlnError = true;
                _blnError = dbFun.blnError;
                _strError = dbFun.strError;
                return null;
            }
            return dbFun.DV;
        }
        // NOTE: user/account data access now lives in AIE.AuthService (hashed passwords, parameterized SQL).
        public static DataSet LanguagesGet()
        {
            DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
            dbFun.ExecSelectProc("LanguagesGet", "");
            if (dbFun.blnError)
            {
                BlnError = true;
                _blnError = dbFun.blnError;
                _strError = dbFun.strError;
                return null;
            }
            return dbFun.DSet;
        }
        public static DataView SponsorsGet(string lang)
        {
            DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
            dbFun.ExecSelectProc("SponsorsGet", lang);
            if (dbFun.blnError)
            {
                BlnError = true;
                _blnError = dbFun.blnError;
                _strError = dbFun.strError;
                return null;
            }
            return dbFun.DV;
        }
        public static DataView WinnersGet(string cat)
        {
            DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
            dbFun.ExecSelectProc("WinnersGet", cat);
            if (dbFun.blnError)
            {
                BlnError = true;
                _blnError = dbFun.blnError;
                _strError = dbFun.strError;
                return null;
            }
            return dbFun.DV;
        }
        //
        public static DataView SchedulesGetVideoLink(string id)
        {
            DBFun.dbFunctions dbFun = new DBFun.dbFunctions(_connString);
            dbFun.ExecSelectProc("SchedulesGetVideoLink", id);
            if (dbFun.blnError)
            {
                BlnError = true;
                _blnError = dbFun.blnError;
                _strError = dbFun.strError;
                return null;
            }
            return dbFun.DV;
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

