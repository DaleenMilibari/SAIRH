namespace SairhChatbot.Models
{
    // One FAQ category (matches the top-level objects in wwwroot/data/faqs.json)
    public class FaqCategory
    {
        public string CategoryId { get; set; } = string.Empty;
        public string CategoryNameAr { get; set; } = string.Empty;
        public string CategoryNameEn { get; set; } = string.Empty;
        public List<FaqItem> Questions { get; set; } = new();
    }

    // One question/answer pair inside a category
    public class FaqItem
    {
        public string Id { get; set; } = string.Empty;
        public string QuestionAr { get; set; } = string.Empty;
        public string QuestionEn { get; set; } = string.Empty;
        public string AnswerAr { get; set; } = string.Empty;
        public string AnswerEn { get; set; } = string.Empty;
    }

    public class ChatRequest
    {
        public string Message { get; set; } = string.Empty;
        public string Language { get; set; } = "en"; // "ar" or "en"
    }

    public class ChatResponse
    {
        public string Answer { get; set; } = string.Empty;
        public string Source { get; set; } = "gemini"; // "faq" or "gemini"
    }
}
