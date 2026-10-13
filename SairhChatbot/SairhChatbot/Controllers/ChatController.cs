using Microsoft.AspNetCore.Mvc;
using SairhChatbot.Models;
using SairhChatbot.Services;

namespace SairhChatbot.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChatController : ControllerBase
    {
        private const int MaxMessageLength = 500;
        private readonly ChatService _chatService;

        public ChatController(ChatService chatService)
        {
            _chatService = chatService;
        }

        [HttpGet("faqs")]
        public async Task<IActionResult> GetFaqs()
        {
            var faqs = await _chatService.GetFaqsAsync();
            return Ok(faqs);
        }

        [HttpPost("ask")]
        public async Task<IActionResult> Ask([FromBody] ChatRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Message))
                return BadRequest(new { error = "Message cannot be empty." });

            if (request.Message.Length > MaxMessageLength)
                return BadRequest(new { error = $"Message is too long (max {MaxMessageLength} characters)." });

            var language = request.Language == "ar" ? "ar" : "en";

            // 1) Exact FAQ match -> answer instantly without calling the AI
            var matchedFaq = await _chatService.FindExactFaqAsync(request.Message);
            if (matchedFaq != null)
            {
                var answer = language == "ar" ? matchedFaq.AnswerAr : matchedFaq.AnswerEn;
                return Ok(new ChatResponse { Answer = answer, Source = "faq" });
            }

            // 2) Otherwise ask Gemini
            var aiAnswer = await _chatService.GetGeminiResponseAsync(request.Message.Trim(), language);
            return Ok(new ChatResponse { Answer = aiAnswer, Source = "gemini" });
        }
    }
}
