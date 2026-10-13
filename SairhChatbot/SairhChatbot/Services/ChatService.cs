using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Caching.Memory;
using SairhChatbot.Models;

namespace SairhChatbot.Services
{
    public class ChatService
    {
        private const string FaqCacheKey = "faqs";

        private static readonly JsonSerializerOptions JsonOptions = new()
        {
            PropertyNameCaseInsensitive = true
        };

        private readonly IWebHostEnvironment _env;
        private readonly IConfiguration _config;
        private readonly HttpClient _httpClient;
        private readonly IMemoryCache _cache;
        private readonly ILogger<ChatService> _logger;

        public ChatService(
            IWebHostEnvironment env,
            IConfiguration config,
            HttpClient httpClient,
            IMemoryCache cache,
            ILogger<ChatService> logger)
        {
            _env = env;
            _config = config;
            _httpClient = httpClient;
            _cache = cache;
            _logger = logger;
        }

        public async Task<List<FaqCategory>> GetFaqsAsync()
        {
            if (_cache.TryGetValue(FaqCacheKey, out List<FaqCategory>? cached) && cached != null)
                return cached;

            var filePath = Path.Combine(_env.WebRootPath, "data", "faqs.json");
            if (!File.Exists(filePath))
            {
                _logger.LogWarning("FAQ file not found at {Path}", filePath);
                return new List<FaqCategory>();
            }

            var json = await File.ReadAllTextAsync(filePath, Encoding.UTF8);
            var faqs = JsonSerializer.Deserialize<List<FaqCategory>>(json, JsonOptions) ?? new List<FaqCategory>();

            _cache.Set(FaqCacheKey, faqs, TimeSpan.FromMinutes(10));
            return faqs;
        }

        /// <summary>Returns an FAQ item whose question exactly matches the text (either language).</summary>
        public async Task<FaqItem?> FindExactFaqAsync(string message)
        {
            var text = Normalize(message);
            var faqs = await GetFaqsAsync();

            return faqs
                .SelectMany(c => c.Questions)
                .FirstOrDefault(q => Normalize(q.QuestionEn) == text || Normalize(q.QuestionAr) == text);
        }

        public async Task<string> GetGeminiResponseAsync(string userMessage, string language)
        {
            var isArabic = language == "ar";
            var apiKey = _config["Gemini:ApiKey"];
            if (string.IsNullOrWhiteSpace(apiKey))
            {
                apiKey = Environment.GetEnvironmentVariable("GEMINI_API_KEY");
            }
            var model = _config["Gemini:Model"] 
                ?? Environment.GetEnvironmentVariable("GEMINI_MODEL") 
                ?? "gemini-1.5-flash";

            if (string.IsNullOrWhiteSpace(apiKey))
            {
                _logger.LogError("Gemini:ApiKey is not configured.");
                return isArabic
                    ? "الخدمة الذكية غير مهيأة حالياً."
                    : "The AI service is not configured yet.";
            }

            var endpoint = $"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent";
            var systemPrompt = await BuildSystemPromptAsync();

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
                using var request = new HttpRequestMessage(HttpMethod.Post, endpoint)
                {
                    Content = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json")
                };
                // API key goes in a header so it never ends up in URLs or logs
                request.Headers.Add("x-goog-api-key", apiKey);

                using var response = await _httpClient.SendAsync(request);
                var body = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogError("Gemini API returned {Status}: {Body}", (int)response.StatusCode, body);
                    return isArabic
                        ? "عذراً، حدث خطأ في معالجة طلبك. حاول مرة أخرى لاحقاً."
                        : "Sorry, I am having trouble connecting right now. Please try again later.";
                }

                using var doc = JsonDocument.Parse(body);
                var text = ExtractText(doc.RootElement);

                if (!string.IsNullOrWhiteSpace(text)) return text.Trim();

                _logger.LogWarning("Gemini returned no text. Body: {Body}", body);
                return isArabic ? "لا توجد إجابة متاحة." : "No response available.";
            }
            catch (Exception ex) when (ex is HttpRequestException || ex is TaskCanceledException || ex is JsonException)
            {
                _logger.LogError(ex, "Error calling Gemini API");
                return isArabic
                    ? "عذراً، حدث خطأ في معالجة طلبك. حاول مرة أخرى لاحقاً."
                    : "Sorry, I am having trouble connecting right now. Please try again later.";
            }
        }

        private static string? ExtractText(JsonElement root)
        {
            if (!root.TryGetProperty("candidates", out var candidates) ||
                candidates.ValueKind != JsonValueKind.Array ||
                candidates.GetArrayLength() == 0)
                return null;

            if (!candidates[0].TryGetProperty("content", out var content) ||
                !content.TryGetProperty("parts", out var parts) ||
                parts.ValueKind != JsonValueKind.Array)
                return null;

            var sb = new StringBuilder();
            foreach (var part in parts.EnumerateArray())
            {
                if (part.TryGetProperty("text", out var t) && t.ValueKind == JsonValueKind.String)
                    sb.Append(t.GetString());
            }
            return sb.ToString();
        }

        // Gives Gemini the FAQ content as grounding so answers stay on-topic and consistent.
        private async Task<string> BuildSystemPromptAsync()
        {
            var sb = new StringBuilder();
            sb.AppendLine("You are the AI assistant for SAIRH (the Saudi 1st AI Summit in Radiology & Health Innovation, 2026).");
            sb.AppendLine("Answer concisely and professionally. Use ONLY the summit information below.");
            sb.AppendLine("If the answer is not covered by it, say you do not have that information and suggest contacting the summit organizers. Do not invent dates, names, prices or links.");
            sb.AppendLine("Always reply in the same language as the user's question (Arabic or English).");
            sb.AppendLine();
            sb.AppendLine("SUMMIT INFORMATION:");

            var faqs = await GetFaqsAsync();
            foreach (var category in faqs)
            {
                sb.AppendLine($"## {category.CategoryNameEn}");
                foreach (var q in category.Questions)
                {
                    sb.AppendLine($"Q: {q.QuestionEn}");
                    sb.AppendLine($"A: {q.AnswerEn}");
                    sb.AppendLine($"Q (Arabic): {q.QuestionAr}");
                    sb.AppendLine($"A (Arabic): {q.AnswerAr}");
                }
            }
            return sb.ToString();
        }

        private static string Normalize(string? s) =>
            (s ?? string.Empty).Trim().TrimEnd('?', '؟', '.', '!').Trim().ToLowerInvariant();
    }
}
