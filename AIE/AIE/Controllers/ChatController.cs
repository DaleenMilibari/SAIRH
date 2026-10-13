using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Configuration;
using System.Web.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AIE.Controllers
{
    public class ChatRequest
    {
        public string Message { get; set; }
        public string Language { get; set; }
    }

    [RoutePrefix("api/chat")]
    public class ChatController : ApiController
    {
        private const int MaxMessageLength = 500;
        private static string _faqsCache = null;
        private static DateTime _faqsCacheTime = DateTime.MinValue;
        private static readonly HttpClient _httpClient = new HttpClient { Timeout = TimeSpan.FromSeconds(30) };

        [HttpGet]
        [Route("faqs")]
        public IHttpActionResult GetFaqs()
        {
            try
            {
                var json = LoadFaqsJson();
                var data = JToken.Parse(json);
                return Ok(data);
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpPost]
        [Route("ask")]
        public async Task<IHttpActionResult> Ask([FromBody] ChatRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Message))
                return BadRequest("Message cannot be empty.");

            if (request.Message.Length > MaxMessageLength)
                return BadRequest($"Message is too long (max {MaxMessageLength} characters).");

            var language = request.Language == "ar" ? "ar" : "en";
            var normalized = Normalize(request.Message);

            // 1. Check exact FAQ match first
            var faqAnswer = FindExactFaqAnswer(normalized, language);
            if (!string.IsNullOrEmpty(faqAnswer))
            {
                return Ok(new { answer = faqAnswer, source = "faq" });
            }

            // 2. Call Gemini
            var aiAnswer = await CallGeminiAsync(request.Message.Trim(), language);
            return Ok(new { answer = aiAnswer, source = "gemini" });
        }

        private string LoadFaqsJson()
        {
            if (_faqsCache != null && (DateTime.UtcNow - _faqsCacheTime).TotalMinutes < 10)
            {
                return _faqsCache;
            }

            var path = HttpContext.Current.Server.MapPath("~/Content/data/faqs.json");
            if (File.Exists(path))
            {
                _faqsCache = File.ReadAllText(path, Encoding.UTF8);
                _faqsCacheTime = DateTime.UtcNow;
                return _faqsCache;
            }

            return "[]";
        }

        private string FindExactFaqAnswer(string normalizedQuery, string language)
        {
            try
            {
                var json = LoadFaqsJson();
                var categories = JArray.Parse(json);
                foreach (var cat in categories)
                {
                    var questions = cat["questions"] as JArray;
                    if (questions == null) continue;

                    foreach (var q in questions)
                    {
                        var qEn = Normalize((string)q["questionEn"]);
                        var qAr = Normalize((string)q["questionAr"]);

                        if (qEn == normalizedQuery || qAr == normalizedQuery)
                        {
                            return language == "ar" ? (string)q["answerAr"] : (string)q["answerEn"];
                        }
                    }
                }
            }
            catch
            {
                // Fallback gracefully
            }
            return null;
        }

        private async Task<string> CallGeminiAsync(string userMessage, string language)
        {
            var isArabic = language == "ar";
            var apiKey = WebConfigurationManager.AppSettings["Gemini:ApiKey"];
            if (string.IsNullOrWhiteSpace(apiKey))
            {
                apiKey = Environment.GetEnvironmentVariable("GEMINI_API_KEY");
            }
            var model = WebConfigurationManager.AppSettings["Gemini:Model"]
                ?? Environment.GetEnvironmentVariable("GEMINI_MODEL")
                ?? "gemini-1.5-flash";

            if (string.IsNullOrWhiteSpace(apiKey))
            {
                return isArabic
                    ? "عذراً، خدمة المساعد الذكي غير مهيأة حالياً. يمكنك اختيار أحد الأسئلة المتاحة في القائمة أعلاه أو التواصل مع المنظمين."
                    : "The AI assistant service is currently not configured. Please choose from the suggested questions above or contact the summit organizers.";
            }

            var endpoint = $"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent";
            var systemPrompt = BuildSystemPrompt();

            var requestBody = new
            {
                systemInstruction = new { parts = new[] { new { text = systemPrompt } } },
                contents = new[]
                {
                    new { role = "user", parts = new[] { new { text = userMessage } } }
                },
                generationConfig = new { temperature = 0.3, maxOutputTokens = 600 }
            };

            try
            {
                using (var req = new HttpRequestMessage(HttpMethod.Post, endpoint))
                {
                    req.Headers.Add("x-goog-api-key", apiKey);
                    req.Content = new StringContent(JsonConvert.SerializeObject(requestBody), Encoding.UTF8, "application/json");

                    using (var res = await _httpClient.SendAsync(req))
                    {
                        var resBody = await res.Content.ReadAsStringAsync();
                        if (!res.IsSuccessStatusCode)
                        {
                            return isArabic
                                ? "عذراً، حدث خطأ في معالجة طلبك. حاول مرة أخرى لاحقاً."
                                : "Sorry, I am having trouble connecting right now. Please try again later.";
                        }

                        var doc = JObject.Parse(resBody);
                        var candidates = doc["candidates"] as JArray;
                        if (candidates != null && candidates.Count > 0)
                        {
                            var parts = candidates[0]?["content"]?["parts"] as JArray;
                            if (parts != null && parts.Count > 0)
                            {
                                var text = (string)parts[0]?["text"];
                                if (!string.IsNullOrWhiteSpace(text)) return text.Trim();
                            }
                        }

                        return isArabic ? "لا توجد إجابة متاحة." : "No response available.";
                    }
                }
            }
            catch
            {
                return isArabic
                    ? "عذراً، حدث خطأ في معالجة طلبك. يمكنك اختيار أحد الأسئلة المتاحة في القائمة أعلاه."
                    : "Sorry, I am having trouble connecting right now. Please choose from the suggested questions above.";
            }
        }

        private string BuildSystemPrompt()
        {
            var sb = new StringBuilder();
            sb.AppendLine("You are the AI assistant for SAIRH (the Saudi 1st AI Summit in Radiology & Health Innovation, 2026).");
            sb.AppendLine("Answer concisely and professionally. Use ONLY the summit information below.");
            sb.AppendLine("If the answer is not covered by it, say you do not have that information and suggest contacting the summit organizers. Do not invent dates, names, prices or links.");
            sb.AppendLine("Always reply in the same language as the user's question (Arabic or English).");
            sb.AppendLine();
            sb.AppendLine("SUMMIT INFORMATION:");

            try
            {
                var json = LoadFaqsJson();
                var categories = JArray.Parse(json);
                foreach (var cat in categories)
                {
                    sb.AppendLine($"## {(string)cat["categoryNameEn"]}");
                    var questions = cat["questions"] as JArray;
                    if (questions != null)
                    {
                        foreach (var q in questions)
                        {
                            sb.AppendLine($"Q: {(string)q["questionEn"]}");
                            sb.AppendLine($"A: {(string)q["answerEn"]}");
                            sb.AppendLine($"Q (Arabic): {(string)q["questionAr"]}");
                            sb.AppendLine($"A (Arabic): {(string)q["answerAr"]}");
                        }
                    }
                }
            }
            catch
            {
                // Return basic prompt if parsing fails
            }

            return sb.ToString();
        }

        private static string Normalize(string s)
        {
            if (string.IsNullOrWhiteSpace(s)) return string.Empty;
            return s.Trim().TrimEnd('?', '؟', '.', '!').Trim().ToLowerInvariant();
        }
    }
}
