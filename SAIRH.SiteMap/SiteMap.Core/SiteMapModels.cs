namespace SiteMap.Core.Models;

public enum BoothAvailabilityStatus
{
    Available,
    Busy
}

public class BoothNode
{
    public string BoothCode { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Hall { get; set; } = string.Empty;
    public int CooldownMinutes { get; set; } = 5;
    public DateTime? LastScannedAt { get; set; }
}

public class BoothMapStateDto
{
    public string BoothCode { get; set; } = string.Empty;
    public BoothAvailabilityStatus Status { get; set; }
    public bool IsVisitedByCurrentUser { get; set; }
    public bool IsRecommended { get; set; }
    public int RemainingBusySeconds { get; set; }
}