namespace SAIRH_WebApp.Models
{
    public class Booth
    {
        public int Id { get; set; }

        public string Name { get; set; } = "";

        public string Organization { get; set; } = "";

        // SponsorBooth or ResearchScreen
        public string Type { get; set; } = "";

        public List<string> Categories { get; set; } = new List<string>();

        // Used later for exact map placement
        public int X { get; set; }

        public int Y { get; set; }

        // Used internally for recommendation ranking
        public int MatchScore { get; set; }
    }
}