using Microsoft.AspNetCore.Mvc;
using SiteMap.Core.Services;

namespace SiteMap.ApiTester.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MapController : ControllerBase
{
    private readonly ISiteMapService _siteMapService;

    public MapController(ISiteMapService siteMapService)
    {
        _siteMapService = siteMapService;
    }

    [HttpGet("status")]
    public async Task<IActionResult> GetStatus([FromQuery] string userId = "test-user")
    {
        var mockRoadmap = new List<string> { "R6", "R12", "R18", "R24", "S15" };
        var mockVisited = new List<string> { "R6" };

        var status = await _siteMapService.GetMapStatusAsync(userId, mockRoadmap, mockVisited);
        return Ok(status);
    }

    [HttpPost("scan")]
    public async Task<IActionResult> RecordScan([FromQuery] string boothCode, [FromQuery] string userId = "test-user")
    {
        await _siteMapService.RegisterScanAsync(boothCode, userId);
        return Ok(new { message = $"Scan registered for booth {boothCode}. 5-minute busy cooldown active." });
    }
}