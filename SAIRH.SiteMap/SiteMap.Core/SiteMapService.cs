using SiteMap.Core.Models;
using System.Collections.Concurrent;

namespace SiteMap.Core.Services;

public interface ISiteMapService
{
    Task RegisterScanAsync(string boothCode, string userId);
    Task<List<BoothMapStateDto>> GetMapStatusAsync(string userId, IEnumerable<string> userRoadmap, IEnumerable<string> userVisitedBooths);
}

public class SiteMapService : ISiteMapService
{
    private readonly ConcurrentDictionary<string, BoothNode> _booths = new();

    public SiteMapService()
    {
        // 30 Research screens (R1 to R30)
        for (int i = 1; i <= 30; i++)
        {
            var code = $"R{i}";
            _booths[code] = new BoothNode { BoothCode = code, Name = $"Research Screen {code}", Hall = "Research Screen Hall" };
        }

        // 15 Sponsor booths (S1 to S15)
        for (int i = 1; i <= 15; i++)
        {
            var code = $"S{i}";
            _booths[code] = new BoothNode { BoothCode = code, Name = $"Sponsor Booth {code}", Hall = "Sponsor Hall" };
        }
    }

    public Task RegisterScanAsync(string boothCode, string userId)
    {
        if (_booths.TryGetValue(boothCode, out var booth))
        {
            booth.LastScannedAt = DateTime.UtcNow;
        }
        return Task.CompletedTask;
    }

    public Task<List<BoothMapStateDto>> GetMapStatusAsync(string userId, IEnumerable<string> userRoadmap, IEnumerable<string> userVisitedBooths)
    {
        var now = DateTime.UtcNow;
        var visitedSet = new HashSet<string>(userVisitedBooths, StringComparer.OrdinalIgnoreCase);
        var roadmapSet = new HashSet<string>(userRoadmap, StringComparer.OrdinalIgnoreCase);

        var result = _booths.Values.Select(b =>
        {
            var elapsed = b.LastScannedAt.HasValue ? (now - b.LastScannedAt.Value) : TimeSpan.FromMinutes(999);
            var isBusy = elapsed < TimeSpan.FromMinutes(b.CooldownMinutes);
            var remaining = isBusy ? (int)(TimeSpan.FromMinutes(b.CooldownMinutes) - elapsed).TotalSeconds : 0;

            return new BoothMapStateDto
            {
                BoothCode = b.BoothCode,
                Status = isBusy ? BoothAvailabilityStatus.Busy : BoothAvailabilityStatus.Available,
                IsVisitedByCurrentUser = visitedSet.Contains(b.BoothCode),
                IsRecommended = roadmapSet.Contains(b.BoothCode),
                RemainingBusySeconds = remaining
            };
        }).ToList();

        return Task.FromResult(result);
    }
}