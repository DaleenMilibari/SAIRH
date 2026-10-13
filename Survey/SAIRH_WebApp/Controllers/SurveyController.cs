using Microsoft.AspNetCore.Mvc;
using SAIRH_WebApp.Models;

namespace SAIRH_WebApp.Controllers
{
    public class SurveyController : Controller
    {
        // =====================================================
        // ENGLISH SURVEY
        // =====================================================

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }


        // =====================================================
        // ARABIC SURVEY
        // =====================================================

        [HttpGet]
        public IActionResult IndexArabic()
        {
            return View("IndexArabic");
        }


        // =====================================================
        // GENERATE ROADMAP
        // Used by BOTH English and Arabic surveys
        // =====================================================

        [HttpPost]
        public IActionResult GenerateRoadmap(
            List<string>? interests,
            List<string>? boothTypes,
            List<string>? goals,
            int boothCount,
            string? language)
        {
            interests ??= new List<string>();
            boothTypes ??= new List<string>();
            goals ??= new List<string>();


            var booths = new List<Booth>();


            // =====================================================
            // 15 SPONSOR BOOTHS
            // Temporary information until official sponsor data
            // becomes available.
            // =====================================================

            var sponsorData = new[]
            {
                new
                {
                    Name = "Sponsor Booth S1",
                    Organization = "AI Imaging Sponsor",
                    Categories = new[]
                    {
                        "AI & Digital Technology",
                        "Medical Imaging & Radiology",
                        "AI Companies",
                        "New Technology"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S2",
                    Organization = "Radiology Technology Sponsor",
                    Categories = new[]
                    {
                        "Medical Imaging & Radiology",
                        "Healthcare Technology",
                        "Medical Imaging Companies",
                        "Products"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S3",
                    Organization = "Healthcare Innovation Sponsor",
                    Categories = new[]
                    {
                        "Health Innovation",
                        "Healthcare Technology",
                        "Healthcare Organizations",
                        "Healthcare Solutions"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S4",
                    Organization = "AI Solutions Sponsor",
                    Categories = new[]
                    {
                        "AI & Digital Technology",
                        "AI Companies",
                        "Healthcare Technology",
                        "New Technology"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S5",
                    Organization = "Medical Imaging Sponsor",
                    Categories = new[]
                    {
                        "Medical Imaging & Radiology",
                        "Medical Imaging Companies",
                        "Products",
                        "New Technology"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S6",
                    Organization = "University Partner",
                    Categories = new[]
                    {
                        "Research & Education",
                        "Universities & Colleges",
                        "Research",
                        "Networking"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S7",
                    Organization = "Health Organization Partner",
                    Categories = new[]
                    {
                        "Health Innovation",
                        "Healthcare Organizations",
                        "Healthcare Solutions",
                        "Networking"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S8",
                    Organization = "Medical Technology Sponsor",
                    Categories = new[]
                    {
                        "Healthcare Technology",
                        "Medical Imaging & Radiology",
                        "Medical Imaging Companies",
                        "Products"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S9",
                    Organization = "AI Healthcare Sponsor",
                    Categories = new[]
                    {
                        "AI & Digital Technology",
                        "Health Innovation",
                        "AI Companies",
                        "Healthcare Solutions"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S10",
                    Organization = "Startup Sponsor",
                    Categories = new[]
                    {
                        "Startups & Innovation",
                        "Startups",
                        "Innovation",
                        "Networking"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S11",
                    Organization = "Digital Health Sponsor",
                    Categories = new[]
                    {
                        "AI & Digital Technology",
                        "Health Innovation",
                        "Healthcare Technology",
                        "New Technology"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S12",
                    Organization = "Research Partner",
                    Categories = new[]
                    {
                        "Research & Education",
                        "Universities & Colleges",
                        "Research",
                        "Networking"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S13",
                    Organization = "Clinical Technology Sponsor",
                    Categories = new[]
                    {
                        "Medical Imaging & Radiology",
                        "Healthcare Organizations",
                        "Healthcare Solutions",
                        "Products"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S14",
                    Organization = "Innovation Sponsor",
                    Categories = new[]
                    {
                        "Startups & Innovation",
                        "Health Innovation",
                        "Innovation",
                        "New Technology"
                    }
                },

                new
                {
                    Name = "Sponsor Booth S15",
                    Organization = "AI Research Sponsor",
                    Categories = new[]
                    {
                        "AI & Digital Technology",
                        "Research & Education",
                        "AI Companies",
                        "Research"
                    }
                }
            };


            for (int i = 0; i < sponsorData.Length; i++)
            {
                booths.Add(new Booth
                {
                    Id = i + 1,
                    Name = sponsorData[i].Name,
                    Organization = sponsorData[i].Organization,
                    Type = "SponsorBooth",
                    Categories = sponsorData[i].Categories.ToList()
                });
            }


            // =====================================================
            // 30 RESEARCH PROJECT SCREENS
            // =====================================================

            string[][] researchCategories =
            {
                new[]
                {
                    "AI & Digital Technology",
                    "Research & Education",
                    "Research Displays",
                    "Research"
                },

                new[]
                {
                    "Medical Imaging & Radiology",
                    "Research & Education",
                    "Research Displays",
                    "Research"
                },

                new[]
                {
                    "Health Innovation",
                    "Research & Education",
                    "Research Displays",
                    "Research"
                },

                new[]
                {
                    "AI & Digital Technology",
                    "Medical Imaging & Radiology",
                    "Research Displays",
                    "New Technology"
                },

                new[]
                {
                    "Healthcare Technology",
                    "Health Innovation",
                    "Research Displays",
                    "Healthcare Solutions"
                },

                new[]
                {
                    "AI & Digital Technology",
                    "Research & Education",
                    "Research Displays",
                    "New Technology"
                }
            };


            for (int i = 1; i <= 30; i++)
            {
                var categorySet =
                    researchCategories[(i - 1) % researchCategories.Length];


                booths.Add(new Booth
                {
                    Id = 15 + i,
                    Name = $"Research Screen R{i}",
                    Organization = "Research Project",
                    Type = "ResearchScreen",
                    Categories = categorySet.ToList()
                });
            }


            // =====================================================
            // RECOMMENDATION SCORING
            // =====================================================

            foreach (var booth in booths)
            {
                int score = 0;


                // 1. MAIN INTERESTS

                score += booth.Categories
                    .Count(category => interests.Contains(category)) * 3;


                // 2. EXHIBITION AREA TYPE

                score += booth.Categories
                    .Count(category => boothTypes.Contains(category)) * 2;


                // 3. VISITOR GOALS

                score += booth.Categories
                    .Count(category => goals.Contains(category));


                // =================================================
                // RESEARCH SCREEN BONUSES
                // =================================================

                if (booth.Type == "ResearchScreen")
                {
                    if (boothTypes.Contains("Research Displays"))
                    {
                        score += 5;
                    }


                    if (interests.Contains("Research & Education"))
                    {
                        score += 3;
                    }


                    if (goals.Contains("Research"))
                    {
                        score += 3;
                    }
                }


                booth.MatchScore = score;
            }


            // =====================================================
            // SEPARATE SPONSORS AND RESEARCH SCREENS
            // =====================================================

            var matchingSponsors = booths
                .Where(booth =>
                    booth.Type == "SponsorBooth" &&
                    booth.MatchScore > 0)
                .OrderByDescending(booth => booth.MatchScore)
                .ThenBy(booth => booth.Id)
                .ToList();


            var matchingResearch = booths
                .Where(booth =>
                    booth.Type == "ResearchScreen" &&
                    booth.MatchScore > 0)
                .OrderByDescending(booth => booth.MatchScore)
                .ThenBy(booth => booth.Id)
                .ToList();


            // =====================================================
            // BUILD BALANCED RECOMMENDATION LIST
            // =====================================================

            var recommendedBooths = new List<Booth>();


            // Guarantee representation from both halls when possible.

            if (boothCount >= 2)
            {
                if (matchingSponsors.Any() &&
                    matchingResearch.Any())
                {
                    recommendedBooths.Add(
                        matchingSponsors.First()
                    );

                    recommendedBooths.Add(
                        matchingResearch.First()
                    );
                }
            }


            // Safety in case boothCount is ever 1.

            if (boothCount == 1)
            {
                var bestMatch = booths
                    .Where(booth => booth.MatchScore > 0)
                    .OrderByDescending(booth => booth.MatchScore)
                    .FirstOrDefault();


                if (bestMatch != null)
                {
                    recommendedBooths.Add(bestMatch);
                }
            }


            // =====================================================
            // FILL REMAINING POSITIONS BY SCORE
            // =====================================================

            var remainingMatches = booths
                .Where(booth =>
                    booth.MatchScore > 0 &&
                    !recommendedBooths
                        .Any(selected => selected.Id == booth.Id))
                .OrderByDescending(booth => booth.MatchScore)

                // Research screens come first in a perfect tie.
                .ThenByDescending(booth =>
                    booth.Type == "ResearchScreen")

                .ThenBy(booth => booth.Id)
                .ToList();


            foreach (var booth in remainingMatches)
            {
                if (recommendedBooths.Count >= boothCount)
                {
                    break;
                }


                recommendedBooths.Add(booth);
            }


            // =====================================================
            // FALLBACK
            // Ensures exactly 3 / 5 / 8 recommendations.
            // =====================================================

            if (recommendedBooths.Count < boothCount)
            {
                var fallbackBooths = booths
                    .Where(booth =>
                        !recommendedBooths
                            .Any(selected => selected.Id == booth.Id))
                    .OrderByDescending(booth => booth.MatchScore)
                    .ThenByDescending(booth =>
                        booth.Type == "ResearchScreen")
                    .ThenBy(booth => booth.Id)
                    .ToList();


                foreach (var booth in fallbackBooths)
                {
                    if (recommendedBooths.Count >= boothCount)
                    {
                        break;
                    }


                    recommendedBooths.Add(booth);
                }
            }


            // =====================================================
            // FINAL ORDER
            // =====================================================

            recommendedBooths = recommendedBooths
                .OrderByDescending(booth => booth.MatchScore)
                .ToList();


            // =====================================================
            // SEND RESULTS TO ROADMAP
            // =====================================================

            ViewBag.RecommendedIds = recommendedBooths
                .Select(booth => booth.Id)
                .ToList();


            ViewBag.RecommendedBooths = recommendedBooths;


            // =====================================================
            // CHOOSE ENGLISH OR ARABIC ROADMAP
            // =====================================================

            if (language == "ar")
            {
                return View("RoadmapArabic", booths);
            }


            return View("Roadmap", booths);
        }
    }
}