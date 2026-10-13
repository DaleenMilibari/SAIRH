/**
 * SAIRH - Saudi AI in Radiology Platform Local Server (Node.js)
 * Supports HTTPS on port 7198 and HTTP on port 52541.
 * Dynamically merges Master pages and ASPX templates, serves static assets,
 * and provides full interactive mock authentication (Register, Login, Profile)
 * with OWASP PBKDF2-SHA512 password hashing and strong password scheme enforcement.
 */

const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');
const url = require('url');
const querystring = require('querystring');
const crypto = require('crypto');

const BASE_DIR = __dirname;

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.mp4': 'video/mp4',
  '.pdf': 'application/pdf'
};

const COMMON_PASSWORDS = new Set([
  'password', 'password1', 'password12', 'password123', 'password1234', 'passw0rd', 'p@ssw0rd',
  '12345678', '123456789', '1234567890', '87654321', '11111111', '00000000', '12341234',
  'qwertyui', 'qwerty12', 'qwerty123', 'qwertyuiop', 'admin123', 'admin@123', 'welcome123',
  'sairh2026', 'sairh123', 'sairh@2026', 'sairh2026!', 'radiology', 'radiology1', 'radiology2026'
]);

// In-memory mock user database with hashed password storage
const USERS_FILE = path.join(BASE_DIR, 'mock_users.json');
let DEV_USERS = {};

try {
  if (fs.existsSync(USERS_FILE)) {
    DEV_USERS = JSON.parse(fs.readFileSync(USERS_FILE, 'utf8'));
  }
} catch (e) {
  DEV_USERS = {};
}

function saveUsers() {
  try {
    fs.writeFileSync(USERS_FILE, JSON.stringify(DEV_USERS, null, 2), 'utf8');
  } catch (e) {
    console.error('Error saving users file:', e);
  }
}

function seedDefaultAccounts() {
  const seeds = [
    {
      email: 'admin@sairh.com',
      fullName: 'SAIRH System Administrator',
      mobile: '+966 50 000 0001',
      organization: 'SAIRH Organizing Committee',
      jobTitle: 'Chief Technology Officer',
      specialty: 'Health AI',
      role: 'Administrator',
      isAdmin: true,
      passwordHash: 'PBKDF2-SHA512$210000$SzIEvmPTW7K3sWS0dszu1Q==$EobVOQGvH3Dd3DMdlrWu8NBA2aN/M+03faGIHFnpIMQ='
    },
    {
      email: 'attendee@sairh.com',
      fullName: 'Dr. Sarah Al-Ahmad',
      mobile: '+966 50 123 4567',
      organization: 'King Faisal Specialist Hospital',
      jobTitle: 'Radiology Consultant',
      specialty: 'Neuroradiology & AI',
      role: 'Attendee',
      isAdmin: false,
      passwordHash: 'PBKDF2-SHA512$210000$OmA5KPTUEKDSf291nAbGMg==$YCg6a7S9ScfG+99qu+MkHMdfknV4ilgG7lyFhyMky5U='
    }
  ];

  let modified = false;
  for (const s of seeds) {
    const k = s.email.toLowerCase();
    if (!DEV_USERS[k]) {
      DEV_USERS[k] = {
        ...s,
        linkedIn: '',
        passwordHistory: [s.passwordHash],
        failedAttempts: 0,
        lockoutUntil: null,
        lastLogin: new Date().toISOString(),
        passwordChangedDate: new Date().toISOString(),
        hasCompletedSurvey: false,
        surveyRoadmap: []
      };
      modified = true;
    }
  }
  if (modified) saveUsers();
}
seedDefaultAccounts();

// -----------------------------------------------------------------------------
// Exhibition Floor Booths & Balanced Recommendation Engine (SAIRH.SiteMap & Survey)
// -----------------------------------------------------------------------------
const ALL_BOOTHS = [];
const BOOTH_COOLDOWNS = {};
const USER_VISITS = {};
const RESET_TOKENS = {};

(function initBooths() {
  const sponsors = [
    { code: "S1", nameEn: "Sponsor Booth S1", nameAr: "جناح الراعي S1", orgEn: "AI Imaging Sponsor", orgAr: "راعي الذكاء الاصطناعي والتصوير", catEn: ["AI & Digital Technology", "Medical Imaging & Radiology", "AI Companies", "New Technology"], catAr: ["الذكاء الاصطناعي والتقنية الرقمية", "التصوير الطبي والأشعة", "شركات الذكاء الاصطناعي", "تقنيات جديدة"], x: 755, y: 195 },
    { code: "S2", nameEn: "Sponsor Booth S2", nameAr: "جناح الراعي S2", orgEn: "Radiology Technology Sponsor", orgAr: "راعي تقنيات الأشعة", catEn: ["Medical Imaging & Radiology", "Healthcare Technology", "Medical Imaging Companies", "Products"], catAr: ["التصوير الطبي والأشعة", "تقنية الرعاية الصحية", "شركات التصوير الطبي", "منتجات وخدمات"], x: 755, y: 235 },
    { code: "S3", nameEn: "Sponsor Booth S3", nameAr: "جناح الراعي S3", orgEn: "Healthcare Innovation Sponsor", orgAr: "راعي الابتكار الصحي", catEn: ["Health Innovation", "Healthcare Technology", "Healthcare Organizations", "Healthcare Solutions"], catAr: ["الابتكار الصحي", "تقنية الرعاية الصحية", "المنظمات الصحية", "حلول الرعاية الصحية"], x: 755, y: 275 },
    { code: "S4", nameEn: "Sponsor Booth S4", nameAr: "جناح الراعي S4", orgEn: "AI Solutions Sponsor", orgAr: "راعي حلول الذكاء الاصطناعي", catEn: ["AI & Digital Technology", "AI Companies", "Healthcare Technology", "New Technology"], catAr: ["الذكاء الاصطناعي والتقنية الرقمية", "شركات الذكاء الاصطناعي", "تقنية الرعاية الصحية", "تقنيات جديدة"], x: 755, y: 315 },
    { code: "S5", nameEn: "Sponsor Booth S5", nameAr: "جناح الراعي S5", orgEn: "Medical Imaging Sponsor", orgAr: "راعي التصوير الطبي", catEn: ["Medical Imaging & Radiology", "Medical Imaging Companies", "Products", "New Technology"], catAr: ["التصوير الطبي والأشعة", "شركات التصوير الطبي", "منتجات وخدمات", "تقنيات جديدة"], x: 755, y: 355 },
    { code: "S6", nameEn: "Sponsor Booth S6", nameAr: "جناح الراعي S6", orgEn: "University Partner", orgAr: "الشريك الأكاديمي والجامعي", catEn: ["Research & Education", "Universities & Colleges", "Research", "Networking"], catAr: ["البحث والتعليم", "الجامعات والكليات", "أبحاث سريرية", "تواصل مهني"], x: 755, y: 395 },
    { code: "S7", nameEn: "Sponsor Booth S7", nameAr: "جناح الراعي S7", orgEn: "Health Organization Partner", orgAr: "شريك المنظمات الصحية", catEn: ["Health Innovation", "Healthcare Organizations", "Healthcare Solutions", "Networking"], catAr: ["الابتكار الصحي", "المنظمات الصحية", "حلول الرعاية الصحية", "تواصل مهني"], x: 755, y: 435 },
    { code: "S8", nameEn: "Sponsor Booth S8", nameAr: "جناح الراعي S8", orgEn: "Medical Technology Sponsor", orgAr: "راعي التقنيات الطبية المتقدمة", catEn: ["Healthcare Technology", "Medical Imaging & Radiology", "Medical Imaging Companies", "Products"], catAr: ["تقنية الرعاية الصحية", "التصوير الطبي والأشعة", "شركات التصوير الطبي", "منتجات وخدمات"], x: 920, y: 115 },
    { code: "S9", nameEn: "Sponsor Booth S9", nameAr: "جناح الراعي S9", orgEn: "AI Healthcare Sponsor", orgAr: "راعي الذكاء الاصطناعي الصحي", catEn: ["AI & Digital Technology", "Health Innovation", "AI Companies", "Healthcare Solutions"], catAr: ["الذكاء الاصطناعي والتقنية الرقمية", "الابتكار الصحي", "شركات الذكاء الاصطناعي", "حلول الرعاية الصحية"], x: 920, y: 155 },
    { code: "S10", nameEn: "Sponsor Booth S10", nameAr: "جناح الراعي S10", orgEn: "Startup Sponsor", orgAr: "راعي الشركات الناشئة والريادة", catEn: ["Startups & Innovation", "Startups", "Innovation", "Networking"], catAr: ["الشركات الناشئة والابتكار", "الشركات الناشئة", "ابتكار وتقنيات واعدة", "تواصل مهني"], x: 920, y: 195 },
    { code: "S11", nameEn: "Sponsor Booth S11", nameAr: "جناح الراعي S11", orgEn: "Digital Health Sponsor", orgAr: "راعي الصحة الرقمية", catEn: ["AI & Digital Technology", "Health Innovation", "Healthcare Technology", "New Technology"], catAr: ["الذكاء الاصطناعي والتقنية الرقمية", "الابتكار الصحي", "تقنية الرعاية الصحية", "تقنيات جديدة"], x: 920, y: 235 },
    { code: "S12", nameEn: "Sponsor Booth S12", nameAr: "جناح الراعي S12", orgEn: "Research Partner", orgAr: "الشريك البحثي الوطني", catEn: ["Research & Education", "Universities & Colleges", "Research", "Networking"], catAr: ["البحث والتعليم", "الجامعات والكليات", "أبحاث سريرية", "تواصل مهني"], x: 920, y: 275 },
    { code: "S13", nameEn: "Sponsor Booth S13", nameAr: "جناح الراعي S13", orgEn: "Clinical Technology Sponsor", orgAr: "راعي التقنيات السريرية", catEn: ["Medical Imaging & Radiology", "Healthcare Organizations", "Healthcare Solutions", "Products"], catAr: ["التصوير الطبي والأشعة", "المنظمات الصحية", "حلول الرعاية الصحية", "منتجات وخدمات"], x: 920, y: 315 },
    { code: "S14", nameEn: "Sponsor Booth S14", nameAr: "جناح الراعي S14", orgEn: "Innovation Sponsor", orgAr: "راعي الابتكار المستقبلي", catEn: ["Startups & Innovation", "Health Innovation", "Innovation", "New Technology"], catAr: ["الشركات الناشئة والابتكار", "الابتكار الصحي", "ابتكار وتقنيات واعدة", "تقنيات جديدة"], x: 920, y: 355 },
    { code: "S15", nameEn: "Sponsor Booth S15", nameAr: "جناح الراعي S15", orgEn: "AI Research Sponsor", orgAr: "راعي أبحاث الذكاء الاصطناعي", catEn: ["AI & Digital Technology", "Research & Education", "AI Companies", "Research"], catAr: ["الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "شركات الذكاء الاصطناعي", "أبحاث سريرية"], x: 920, y: 395 }
  ];

  sponsors.forEach((s, idx) => {
    ALL_BOOTHS.push({
      id: idx + 1,
      boothCode: s.code,
      nameEn: s.nameEn,
      nameAr: s.nameAr,
      organizationEn: s.orgEn,
      organizationAr: s.orgAr,
      type: "SponsorBooth",
      hallEn: "Sponsor Hall",
      hallAr: "قاعة الرعاة والشركاء",
      categoriesEn: s.catEn,
      categoriesAr: s.catAr,
      projectedAvgMinutes: 5,
      x: s.x,
      y: s.y
    });
  });

  const resCatEn = [
    ["AI & Digital Technology", "Research & Education", "Research Displays", "Research"],
    ["Medical Imaging & Radiology", "Research & Education", "Research Displays", "Research"],
    ["Health Innovation", "Research & Education", "Research Displays", "Research"],
    ["AI & Digital Technology", "Medical Imaging & Radiology", "Research Displays", "New Technology"],
    ["Healthcare Technology", "Health Innovation", "Research Displays", "Healthcare Solutions"],
    ["AI & Digital Technology", "Research & Education", "Research Displays", "New Technology"]
  ];
  const resCatAr = [
    ["الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية"],
    ["التصوير الطبي والأشعة", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية"],
    ["الابتكار الصحي", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية"],
    ["الذكاء الاصطناعي والتقنية الرقمية", "التصوير الطبي والأشعة", "منصات عرض الأبحاث", "تقنيات جديدة"],
    ["تقنية الرعاية الصحية", "الابتكار الصحي", "منصات عرض الأبحاث", "حلول الرعاية الصحية"],
    ["الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "منصات عرض الأبحاث", "تقنيات جديدة"]
  ];

  for (let i = 1; i <= 30; i++) {
    let x, y;
    if (i <= 12) { x = 90 + (i - 1) * 50; y = 35; }
    else if (i <= 18) { x = 35; y = 70 + (i - 13) * 28; }
    else { x = 90 + (i - 19) * 50; y = 220; }

    const catIdx = (i - 1) % 6;
    ALL_BOOTHS.push({
      id: 15 + i,
      boothCode: `R${i}`,
      nameEn: `Research Display R${i}`,
      nameAr: `شاشة عرض أبحاث R${i}`,
      organizationEn: `Academic & Clinical Research ${i}`,
      organizationAr: `الأبحاث الأكاديمية والسريرية ${i}`,
      type: "ResearchScreen",
      hallEn: "Research Screen Hall",
      hallAr: "قاعة شاشات الأبحاث",
      categoriesEn: resCatEn[catIdx],
      categoriesAr: resCatAr[catIdx],
      projectedAvgMinutes: 5,
      x,
      y
    });
  }
})();

const BOOTH_VISITS_LOG = [];
let SUMMIT_SETTINGS = {
  titleEn: "Saudi AI in Radiology & Healthcare Summit 2026",
  titleAr: "ملتقى الذكاء الاصطناعي في الأشعة والرعاية الصحية 2026",
  startDate: "2026-11-18",
  endDate: "2026-11-19",
  venueEn: "Crowne Plaza RDC Hotel & Convention, Riyadh",
  venueAr: "فندق كراون بلازا آر دي سي ومركز المؤتمرات، الرياض"
};

function calculateRecommendations(interests = [], boothTypes = [], goals = [], boothCount = 5) {
  const normInterests = (Array.isArray(interests) ? interests : [interests]).map(s => String(s).toLowerCase().trim());
  const normTypes = (Array.isArray(boothTypes) ? boothTypes : [boothTypes]).map(s => String(s).toLowerCase().trim());
  const normGoals = (Array.isArray(goals) ? goals : [goals]).map(s => String(s).toLowerCase().trim());
  let count = parseInt(boothCount, 10);
  if (isNaN(count) || count <= 0) count = 5;

  const scored = ALL_BOOTHS.map(b => {
    let score = 0;
    const catEn = b.categoriesEn.map(c => c.toLowerCase());
    score += catEn.filter(c => normInterests.includes(c)).length * 3;
    score += catEn.filter(c => normTypes.includes(c)).length * 2;
    score += catEn.filter(c => normGoals.includes(c)).length;

    if (b.type === 'ResearchScreen') {
      if (normTypes.some(t => t.includes('research'))) score += 5;
      if (normInterests.some(i => i.includes('research'))) score += 3;
      if (normGoals.some(g => g.includes('research'))) score += 3;
    }
    return { ...b, matchScore: score };
  });

  const matchingSponsors = scored.filter(b => b.type === 'SponsorBooth' && b.matchScore > 0)
    .sort((a, b) => b.matchScore - a.matchScore || a.id - b.id);
  const matchingResearch = scored.filter(b => b.type === 'ResearchScreen' && b.matchScore > 0)
    .sort((a, b) => b.matchScore - a.matchScore || a.id - b.id);

  const recommended = [];
  if (count >= 2 && matchingSponsors.length > 0 && matchingResearch.length > 0) {
    recommended.push(matchingSponsors[0]);
    recommended.push(matchingResearch[0]);
  } else if (count === 1) {
    const best = [...scored].filter(b => b.matchScore > 0).sort((a, b) => b.matchScore - a.matchScore)[0];
    if (best) recommended.push(best);
  }

  const recCodes = new Set(recommended.map(r => r.boothCode));
  const remaining = scored.filter(b => b.matchScore > 0 && !recCodes.has(b.boothCode))
    .sort((a, b) => b.matchScore - a.matchScore || (b.type === 'ResearchScreen' ? 0 : 1) || a.id - b.id);

  for (const b of remaining) {
    if (recommended.length >= count) break;
    recommended.push(b);
    recCodes.add(b.boothCode);
  }

  if (recommended.length < count) {
    const fallbacks = scored.filter(b => !recCodes.has(b.boothCode))
      .sort((a, b) => b.matchScore - a.matchScore || (b.type === 'ResearchScreen' ? 0 : 1) || a.id - b.id);
    for (const b of fallbacks) {
      if (recommended.length >= count) break;
      recommended.push(b);
      recCodes.add(b.boothCode);
    }
  }

  return recommended.sort((a, b) => b.matchScore - a.matchScore);
}

function getMapStatus(email = '', isArabic = false) {
  const normEmail = (email || '').trim().toLowerCase();
  const userRoadmap = normEmail && DEV_USERS[normEmail] ? (DEV_USERS[normEmail].surveyRoadmap || []) : [];
  const roadmapSet = new Set(userRoadmap);

  const visitedSet = new Set(
    normEmail && USER_VISITS[normEmail] ? Array.from(USER_VISITS[normEmail]) :
    (normEmail && DEV_USERS[normEmail] && DEV_USERS[normEmail].visitedBooths ? DEV_USERS[normEmail].visitedBooths : [])
  );

  const nowSec = Date.now() / 1000;
  return ALL_BOOTHS.map(b => {
    const lastScanned = BOOTH_COOLDOWNS[b.boothCode] || 0;
    const elapsed = nowSec - lastScanned;
    const isBusy = elapsed < 300;
    const remaining = isBusy ? Math.floor(300 - elapsed) : 0;

    return {
      boothCode: b.boothCode,
      name: isArabic ? b.nameAr : b.nameEn,
      organization: isArabic ? b.organizationAr : b.organizationEn,
      type: b.type,
      hall: isArabic ? b.hallAr : b.hallEn,
      categories: isArabic ? b.categoriesAr : b.categoriesEn,
      status: isBusy ? 1 : 0,
      isVisitedByCurrentUser: visitedSet.has(b.boothCode),
      isRecommended: roadmapSet.has(b.boothCode),
      remainingBusySeconds: remaining
    };
  });
}

function registerScan(boothCode, email = null) {
  const code = (boothCode || '').trim().toUpperCase();
  if (!code) return;
  BOOTH_COOLDOWNS[code] = Date.now() / 1000;
  if (email) {
    const e = email.trim().toLowerCase();
    if (!USER_VISITS[e]) USER_VISITS[e] = new Set();
    USER_VISITS[e].add(code);
    if (DEV_USERS[e]) {
      const v = new Set(DEV_USERS[e].visitedBooths || []);
      v.add(code);
      DEV_USERS[e].visitedBooths = Array.from(v);
      saveUsers();
    }
  }
}

// -----------------------------------------------------------------------------
// Cryptographic Password Hashing (PBKDF2-HMAC-SHA512)
// -----------------------------------------------------------------------------
function hashPassword(password) {
  const salt = crypto.randomBytes(16);
  const iterations = 210000;
  const hash = crypto.pbkdf2Sync(password, salt, iterations, 32, 'sha512');
  return `PBKDF2-SHA512$${iterations}$${salt.toString('base64')}$${hash.toString('base64')}`;
}

function verifyPassword(password, storedHash) {
  if (!password || !storedHash) return false;
  const parts = storedHash.split('$');
  if (parts.length !== 4 || parts[0] !== 'PBKDF2-SHA512') return false;
  const iterations = parseInt(parts[1], 10);
  if (isNaN(iterations) || iterations < 1) return false;
  try {
    const salt = Buffer.from(parts[2], 'base64');
    const expected = Buffer.from(parts[3], 'base64');
    const actual = crypto.pbkdf2Sync(password, salt, iterations, expected.length, 'sha512');
    return crypto.timingSafeEqual(actual, expected);
  } catch (e) {
    return false;
  }
}

function isPasswordInHistory(newPassword, historyArray, max = 3) {
  if (!historyArray || !Array.isArray(historyArray)) return false;
  const recent = historyArray.slice(0, max);
  for (const h of recent) {
    if (verifyPassword(newPassword, h)) return true;
  }
  return false;
}

function hasSequentialRun(s, minLength = 4) {
  if (!s || s.length < minLength) return false;
  let ascCount = 1;
  let descCount = 1;
  for (let i = 1; i < s.length; i++) {
    const prev = s.charCodeAt(i - 1);
    const curr = s.charCodeAt(i);
    const isAlphanumeric = (c) => (c >= 48 && c <= 57) || (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
    if (isAlphanumeric(prev) && isAlphanumeric(curr)) {
      if (curr === prev + 1) {
        ascCount++;
        if (ascCount >= minLength) return true;
      } else {
        ascCount = 1;
      }
      if (curr === prev - 1) {
        descCount++;
        if (descCount >= minLength) return true;
      } else {
        descCount = 1;
      }
    } else {
      ascCount = 1;
      descCount = 1;
    }
  }
  return false;
}

// -----------------------------------------------------------------------------
// Strong Password Scheme Validation
// -----------------------------------------------------------------------------
function validatePasswordStrength(password, email, fullName, isArabic) {
  const errors = [];
  if (!password) {
    errors.push(isArabic ? 'يرجى إدخال كلمة المرور.' : 'Please enter a password.');
    return errors;
  }

  if (password.length < 8) {
    errors.push(isArabic ? 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.' : 'Password must be at least 8 characters long.');
  }
  if (password.length > 128) {
    errors.push(isArabic ? 'يجب ألا تتجاوز كلمة المرور 128 حرفاً.' : 'Password must be 128 characters or fewer.');
  }
  if (!/[A-Z]/.test(password)) {
    errors.push(isArabic ? 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل (A-Z).' : 'Password must contain at least one uppercase letter (A-Z).');
  }
  if (!/[a-z]/.test(password)) {
    errors.push(isArabic ? 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل (a-z).' : 'Password must contain at least one lowercase letter (a-z).');
  }
  if (!/[0-9]/.test(password)) {
    errors.push(isArabic ? 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل (0-9).' : 'Password must contain at least one number (0-9).');
  }
  if (!/[^A-Za-z0-9]/.test(password)) {
    errors.push(isArabic ? 'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل (!@#$%^&*...).' : 'Password must contain at least one special symbol (!@#$%^&*...).');
  }
  if (/(.)\1{3,}/.test(password)) {
    errors.push(isArabic ? 'يجب ألا تحتوي كلمة المرور على أحرف مكررة متتالية (مثل aaaa أو 1111).' : 'Password must not contain repeated characters (e.g. aaaa or 1111).');
  }
  if (hasSequentialRun(password, 4)) {
    errors.push(isArabic ? 'يجب ألا تحتوي كلمة المرور على تسلسلات متتالية سهلة التخمين (مثل 1234 أو abcd).' : 'Password must not contain predictable sequences (e.g. 1234 or abcd).');
  }

  // Common passwords check
  if (COMMON_PASSWORDS.has(password.toLowerCase())) {
    errors.push(isArabic ? 'كلمة المرور هذه شائعة أو سهلة التخمين. يرجى اختيار كلمة مرور أقوى.' : 'This password is too common or easy to guess. Please choose a stronger one.');
  }

  // Email username check
  if (email) {
    const local = email.split('@')[0];
    if (local && local.length >= 3 && password.toLowerCase().includes(local.toLowerCase())) {
      errors.push(isArabic ? 'يجب ألا تحتوي كلمة المرور على اسم بريدك الإلكتروني.' : 'Password must not contain your email username.');
    }
  }

  // Full name check
  if (fullName) {
    const parts = fullName.split(/[\s\-_]+/);
    for (const p of parts) {
      if (p.length >= 3 && password.toLowerCase().includes(p.toLowerCase())) {
        errors.push(isArabic ? 'يجب ألا تحتوي كلمة المرور على أجزاء من اسمك.' : 'Password must not contain parts of your name.');
        break;
      }
    }
  }

  return errors;
}

function getCookie(req, name) {
  const cookieHeader = req.headers.cookie;
  if (!cookieHeader) return null;
  const match = cookieHeader.match(new RegExp('(?:^|; )' + name + '=([^;]*)'));
  return match ? decodeURIComponent(match[1]) : null;
}

function render403AccessDenied(isAr) {
  const title = isAr ? '403 - الوصول محظور | أمن النظام' : '403 - Forbidden | Security Protected';
  const heading = isAr ? '403 - تم حظر الوصول' : '403 - Access Denied';
  const msg1 = isAr ? 'لا تملك صلاحيات المشرف للوصول إلى هذه اللوحة الإدارية.' : 'You do not have administrative privileges to access this control panel.';
  const msg2 = isAr ? 'تم منع التصفح القسري المباشر (Forced Browsing) وفقاً لمعايير التحكم في الوصول OWASP BAC.' : 'Forced browsing to administrative endpoints is strictly blocked in accordance with OWASP Broken Access Control (BAC) standards.';
  const loginText = isAr ? 'تسجيل الدخول كمشرف' : 'Sign in as Administrator';
  const homeText = isAr ? 'العودة للصفحة الرئيسية' : 'Return to Summit Home';
  const loginUrl = isAr ? '/Ar_Sa/Login' : '/Login';
  const homeUrl = isAr ? '/Ar_Sa/' : '/';
  const dir = isAr ? 'dir="rtl"' : '';

  return `<!DOCTYPE html>
<html lang="${isAr ? 'ar' : 'en'}" ${dir}>
<head>
  <meta charset="utf-8" />
  <title>${title}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <style>
    body {
      background: #0a0f1d;
      color: #fff;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
      margin: 0;
      padding: 20px;
      box-sizing: border-box;
    }
    .card {
      max-width: 520px;
      width: 100%;
      background: rgba(15, 23, 42, 0.85);
      border: 1px solid rgba(239, 68, 68, 0.4);
      border-radius: 20px;
      padding: 40px 30px;
      text-align: center;
      box-shadow: 0 20px 50px rgba(0,0,0,0.6);
      backdrop-filter: blur(16px);
    }
    .badge {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 9999px;
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.05em;
      text-transform: uppercase;
      background: rgba(239, 68, 68, 0.2);
      color: #ef4444;
      border: 1px solid rgba(239, 68, 68, 0.4);
      margin-bottom: 16px;
    }
    h1 {
      color: #f87171;
      font-size: 1.8rem;
      margin: 0 0 12px;
    }
    p {
      color: #cbd5e1;
      font-size: 0.95rem;
      line-height: 1.6;
      margin: 0 0 16px;
    }
    .note {
      color: #94a3b8;
      font-size: 0.85rem;
      background: rgba(255,255,255,0.04);
      padding: 10px;
      border-radius: 10px;
      margin-bottom: 24px;
    }
    .links a {
      color: #38bdf8;
      text-decoration: none;
      font-weight: 600;
      margin: 0 10px;
    }
    .links a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="badge">OWASP BAC Protection</div>
    <h1>${heading}</h1>
    <p>${msg1}</p>
    <div class="note">${msg2}</div>
    <div class="links">
      <a href="${loginUrl}">${loginText}</a> |
      <a href="${homeUrl}">${homeText}</a>
    </div>
  </div>
</body>
</html>`;
}

function parseAspx(aspxPath, relativeUrl, options = {}) {
  if (!fs.existsSync(aspxPath)) return null;

  const {
    user = null,
    errorAlert = null,
    successAlert = null,
    formData = {},
    resetSuccessUrl = null,
    invalidToken = false,
    resetDone = false
  } = options;
  let aspxContent = fs.readFileSync(aspxPath, 'utf8');

  // Remove server-side comments <%-- ... --%>
  aspxContent = aspxContent.replace(/<%--[\s\S]*?--%>/g, '');

  // Check for MasterPageFile
  const masterMatch = aspxContent.match(/MasterPageFile=["']([^"']+)["']/i);
  let rendered = aspxContent;

  if (masterMatch) {
    const masterRel = masterMatch[1].replace('~/', '').replace(/\\/g, '/');
    const masterPath = path.normalize(path.join(BASE_DIR, masterRel));
    if (fs.existsSync(masterPath)) {
      rendered = fs.readFileSync(masterPath, 'utf8');
    }
  }

  // Remove comments from master
  rendered = rendered.replace(/<%--[\s\S]*?--%>/g, '');

  // Extract head and main content
  let headContent = '';
  const headMatch = aspxContent.match(/<asp:Content[^>]*ContentPlaceHolderID=["']head["'][^>]*>([\s\S]*?)<\/asp:Content>/i);
  if (headMatch) headContent = headMatch[1];

  let mainContent = '';
  const mainMatch = aspxContent.match(/<asp:Content[^>]*ContentPlaceHolderID=["']ContentPlaceHolder1["'][^>]*>([\s\S]*?)<\/asp:Content>/i);
  if (mainMatch) {
    mainContent = mainMatch[1];
  } else if (!masterMatch) {
    mainContent = aspxContent;
  }

  // Inject into placeholders
  rendered = rendered.replace(/<asp:ContentPlaceHolder[^>]*ID=["']head["'][^>]*>[\s\S]*?<\/asp:ContentPlaceHolder>/gi, () => headContent);
  rendered = rendered.replace(/<asp:ContentPlaceHolder[^>]*ID=["']ContentPlaceHolder1["'][^>]*>[\s\S]*?<\/asp:ContentPlaceHolder>/gi, () => mainContent);

  // Convert <form ... runat="server"> to <form ... method="post" action="">
  rendered = rendered.replace(/<form\b([^>]*)runat=["']server["']([^>]*)>/gi, '<form$1method="post" action=""$2>');

  // Resolve dates and expressions
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  const todayIso = `${year}-${month}-${day}`;

  rendered = rendered.replace(/<%=\s*ResolveUrl\(["']~?\/([^"']+)["']\)\s*%>/g, '/$1');
  rendered = rendered.replace(/<%=\s*ResolveUrl\(["']([^"']+)["']\)\s*%>/g, '/$1');
  rendered = rendered.replace(/<%=\s*DateTime\.Now\.Year\.ToString\(\)\s*%>/g, String(year));
  rendered = rendered.replace(/<%=\s*DateTime\.Today\.ToString\([^)]*\)\s*%>/gi, todayIso);
  rendered = rendered.replace(/<%=\s*DateTime\.Now\.ToString\([^)]*\)\s*%>/gi, todayIso);
  rendered = rendered.replace(/<%=\s*DateTime\.(?:Today|Now)(?:\.ToString\([^)]*\))?\s*%>/gi, todayIso);

  // Replace ClientID expressions
  rendered = rendered.replace(/<%=\s*([a-zA-Z0-9_]+)\.ClientID\s*%>/g, '$1');

  // Remove ScriptManager & directives
  rendered = rendered.replace(/<%@[\s\S]*?%>/g, '');
  rendered = rendered.replace(/<asp:ScriptManager[^>]*><\/asp:ScriptManager>/gi, '');
  rendered = rendered.replace(/<asp:ScriptManager[^>]*\/>/gi, '');

  // Handle Literal tags
  rendered = rendered.replace(/<asp:Literal[^>]*ID=["']LitUserName["'][^>]*>[\s\S]*?<\/asp:Literal>/gi, () => {
    return user ? user.fullName : 'Attendee';
  });

  // Replace TextBox
  rendered = rendered.replace(/<asp:TextBox([^>]*)(?:\/>|>[\s\S]*?<\/asp:TextBox>)/gi, (m, attrs) => {
    const id = (attrs.match(/ID=["']([^"']+)["']/i) || [])[1] || '';
    const cls = (attrs.match(/CssClass=["']([^"']+)["']/i) || [])[1] || '';
    const ph = (attrs.match(/placeholder=["']([^"']+)["']/i) || [])[1] || '';
    const tm = ((attrs.match(/TextMode=["']([^"']+)["']/i) || [])[1] || '').toLowerCase();
    const rows = (attrs.match(/Rows=["']([^"']+)["']/i) || [])[1] || '3';
    const ac = (attrs.match(/autocomplete=["']([^"']+)["']/i) || [])[1];
    const req = /required(?:=["'][^"']*["'])?/i.test(attrs);
    let extra = '';
    if (ac) extra += ` autocomplete="${ac}"`;
    if (req) extra += ` required="required"`;

    let val = formData[id] !== undefined ? formData[id] : '';
    if (!val && user) {
      if (id === 'TxtEditFullName') val = user.fullName || '';
      else if (id === 'TxtEditMobile') val = user.mobile || '';
      else if (id === 'TxtEditOrg') val = user.organization || '';
      else if (id === 'TxtEditJobTitle') val = user.jobTitle || '';
      else if (id === 'TxtEditSpecialty') val = user.specialty || '';
      else if (id === 'TxtEditLinkedIn') val = user.linkedIn || user.linkedInUrl || '';
    }

    const valAttr = val ? ` value="${escapeHtml(val)}"` : '';

    if (tm === 'multiline') {
      return `<textarea name="${id}" id="${id}" class="${cls}" placeholder="${ph}" rows="${rows}"${extra}>${escapeHtml(val)}</textarea>`;
    } else if (tm === 'password') {
      return `<input type="password" name="${id}" id="${id}" class="${cls}" placeholder="${ph}"${extra} />`;
    } else if (tm === 'phone' || tm === 'tel') {
      return `<input type="tel" name="${id}" id="${id}" class="${cls}" placeholder="${ph}"${extra}${valAttr} />`;
    } else if (tm === 'email') {
      return `<input type="email" name="${id}" id="${id}" class="${cls}" placeholder="${ph}"${extra}${valAttr} />`;
    }
    return `<input type="text" name="${id}" id="${id}" class="${cls}" placeholder="${ph}"${extra}${valAttr} />`;
  });

  // Replace CheckBox
  rendered = rendered.replace(/<asp:CheckBox([^>]*)(?:\/>|>[\s\S]*?<\/asp:CheckBox>)/gi, (m, attrs) => {
    const id = (attrs.match(/ID=["']([^"']+)["']/i) || [])[1] || '';
    const cls = (attrs.match(/CssClass=["']([^"']+)["']/i) || [])[1] || '';
    const txt = (attrs.match(/Text=["']([^"']*)["']/i) || [])[1] || '';
    const isChecked = /Checked=["']true["']/i.test(attrs) || (formData && (formData[id] === 'true' || formData[id] === 'on'));
    const checkedAttr = isChecked ? ' checked="checked"' : '';
    const inputHtml = `<input type="checkbox" name="${id}" id="${id}" value="true"${cls ? ` class="${cls}"` : ''}${checkedAttr} />`;
    if (txt) {
      return `<label for="${id}" class="sairh-checkbox-label" style="display:inline-flex;align-items:center;gap:0.5rem;cursor:pointer;">${inputHtml}<span>${txt}</span></label>`;
    }
    return inputHtml;
  });

  // Replace Button
  rendered = rendered.replace(/<asp:Button([^>]*)(?:\/>|>[\s\S]*?<\/asp:Button>)/gi, (m, attrs) => {
    const id = (attrs.match(/ID=["']([^"']+)["']/i) || [])[1] || '';
    const cls = (attrs.match(/CssClass=["']([^"']+)["']/i) || [])[1] || '';
    const txt = (attrs.match(/Text=["']([^"']*)["']/i) || [])[1] || '';
    const ld = (attrs.match(/data-loading-text=["']([^"']+)["']/i) || [])[1];
    let extra = '';
    if (ld) extra += ` data-loading-text="${ld}"`;
    return `<button type="submit" name="${id}" id="${id}" class="${cls}"${extra}>${txt}</button>`;
  });

  // Replace Label
  rendered = rendered.replace(/<asp:Label([^>]*)(?:\/>|>([\s\S]*?)<\/asp:Label>)/gi, (m, attrs, body) => {
    const id = (attrs.match(/ID=["']([^"']+)["']/i) || [])[1] || '';
    const cls = (attrs.match(/CssClass=["']([^"']+)["']/i) || [])[1] || '';
    let txt = (attrs.match(/Text=["']([^"']*)["']/i) || [])[1] || '';
    const isVisibleFalse = /Visible=["']false["']/i.test(attrs);
    if (isVisibleFalse) return '';

    if (user) {
      const isArPage = relativeUrl.toLowerCase().includes('/ar_sa');
      if (id === 'LblName') txt = user.fullName;
      else if (id === 'TxtEmail') txt = user.email;
      else if (id === 'TxtMobile') txt = user.mobile || '-';
      else if (id === 'LblUserRoleBadge') {
        const role = user.role || 'Attendee';
        if (isArPage) {
          txt = role === 'Administrator' ? 'مشرف النظام' : (role === 'Speaker' ? 'متحدث رئيسي' : 'حاضر ومشارك');
        } else {
          txt = role;
        }
      }
      else if (id === 'LblOrgTitle') {
        const parts = [user.jobTitle, user.organization].filter(Boolean);
        txt = parts.join(' • ');
      }
      else if (id === 'LblLastLogin') {
        if (user.lastLogin) {
          try {
            const dt = new Date(user.lastLogin);
            txt = isArPage ? dt.toLocaleDateString('ar-SA') + ' ' + dt.toLocaleTimeString('ar-SA') : dt.toLocaleString('en-US');
          } catch (e) {
            txt = user.lastLogin;
          }
        } else {
          txt = isArPage ? 'الجلسة الحالية الأولى' : 'Current active session';
        }
      }
      else if (id === 'LblPasswordAge') {
        if (user.passwordChangedDate) {
          try {
            const dt = new Date(user.passwordChangedDate);
            txt = isArPage ? dt.toLocaleDateString('ar-SA') : dt.toLocaleDateString('en-US');
          } catch (e) {
            txt = user.passwordChangedDate;
          }
        } else {
          txt = isArPage ? 'محدثة (نشطة)' : 'Active / Up to date';
        }
      }
    }

    const content = txt || body || '';
    const clsAttr = cls ? ` class="${cls}"` : '';
    return `<span id="${id}"${clsAttr}>${content}</span>`;
  });

  // Replace LinkButton
  rendered = rendered.replace(/<asp:LinkButton([^>]*)>([\s\S]*?)<\/asp:LinkButton>/gi, (m, attrs, body) => {
    const id = (attrs.match(/ID=["']([^"']+)["']/i) || [])[1] || '';
    const cls = (attrs.match(/CssClass=["']([^"']+)["']/i) || [])[1] || '';
    let pb = (attrs.match(/PostBackUrl=["']([^"']+)["']/i) || [])[1] || '#';
    pb = pb.replace('~/', '/');

    const isAr = relativeUrl.toLowerCase().includes('/ar_sa');
    if (id === 'BtnToAr') pb = '/Ar_Sa/';
    else if (id === 'BtnToEn') pb = '/';
    else if (id === 'BtnDashboard') pb = isAr ? '/Ar_Sa/Admin/ManageSummit' : '/Admin/ManageSummit';
    else if (id === 'BtnProfile') pb = isAr ? '/Ar_Sa/Profile' : '/Profile';
    else if (id === 'BtnSignOut') pb = (isAr ? '/Ar_Sa/Login' : '/Login') + '?logout=1';

    return `<a href="${pb}" id="${id}" class="${cls}">${body}</a>`;
  });

  // Handle Error/Success Alert Banners
  if (errorAlert) {
    rendered = rendered.replace(/<div[^>]*id=["']divError(?:Profile)?["'][^>]*>[\s\S]*?<\/div>/i, `<div id="divError" class="auth-alert alert alert-danger" style="display:block;" role="alert">${errorAlert}</div>`);
  } else if (successAlert) {
    rendered = rendered.replace(/<div[^>]*id=["']divError(?:Profile)?["'][^>]*>[\s\S]*?<\/div>/i, `<div id="divError" class="auth-alert alert alert-success" style="display:block;" role="alert">${successAlert}</div>`);
  }

  // Header user dropdown vs signin link visibility and Admin badge
  const isAdmin = !!(user && (user.role === 'Administrator' || user.role === 'Admin' || user.isAdmin === true));
  if (user) {
    rendered = rendered.replace(/id="liLogin"/g, 'id="liLogin" style="display:none;"');
    if (isAdmin) {
      rendered = rendered.replace(/id="liDashboard"[^>]*style="display:none;"/gi, 'id="liDashboard" style="display:block;"');
    } else {
      rendered = rendered.replace(/<span[^>]*id=["']liDashboard["'][^>]*>[\s\S]*?<\/span>/gi, '');
    }
  } else {
    rendered = rendered.replace(/id="liProfile"/g, 'id="liProfile" style="display:none;"');
    rendered = rendered.replace(/<span[^>]*id=["']liDashboard["'][^>]*>[\s\S]*?<\/span>/gi, '');
  }

  // Remove UpdatePanel
  rendered = rendered.replace(/<\/?asp:UpdatePanel[^>]*>/gi, '');
  rendered = rendered.replace(/<\/?ContentTemplate>/gi, '');

  // Render <asp:Repeater ID="rptSpeakers"> dynamically
  if (rendered.includes('rptSpeakers')) {
    const isArPage = relativeUrl.toLowerCase().includes('/ar_sa');
    const speakersJsonPath = path.join(BASE_DIR, 'Content', 'data', 'speakers.json');
    let cardsHtml = [];
    if (fs.existsSync(speakersJsonPath)) {
      try {
        const spList = JSON.parse(fs.readFileSync(speakersJsonPath, 'utf8'));
        const trackIcons = { 'track-a': 'bi bi-cpu', 'track-b': 'bi bi-activity', 'track-c': 'bi bi-lightbulb' };
        const sectorIcons = { 'clinical': 'bi bi-hospital', 'academic': 'bi bi-mortarboard', 'industry': 'bi bi-building', 'international': 'bi bi-globe' };

        cardsHtml = spList.map(s => {
          const track = (s.Track || 'track-a').toLowerCase().trim();
          const sector = (s.Sector || 'clinical').toLowerCase().trim();
          const region = (s.Region || 'national').toLowerCase().trim();

          const name = escapeHtml(isArPage && s.FullNameAr ? s.FullNameAr : (s.FullNameEn || ''));
          const role = escapeHtml(isArPage && s.JobTitleAr ? s.JobTitleAr : (s.JobTitleEn || ''));
          const org = escapeHtml(isArPage && s.OrganizationAr ? s.OrganizationAr : (s.OrganizationEn || ''));
          const lecture = escapeHtml(isArPage && s.LectureTitleAr ? s.LectureTitleAr : (s.LectureTitleEn || ''));

          const trackName = escapeHtml(isArPage && s.TrackNameAr ? s.TrackNameAr : (s.TrackNameEn || ''));
          const sectorName = escapeHtml(isArPage && s.SectorNameAr ? s.SectorNameAr : (s.SectorNameEn || ''));
          const regionName = escapeHtml(isArPage && s.RegionNameAr ? s.RegionNameAr : (s.RegionNameEn || ''));

          let photo = s.ImagePath || '';
          if (photo.startsWith('~')) photo = photo.slice(1);
          let cv = s.CvPdfPath || '';
          if (cv && cv.startsWith('~')) cv = cv.slice(1);

          const flag = s.Flag || '🇸🇦';
          const initials = escapeHtml(s.Initials || 'SP');
          const roomVal = isArPage && s.RoomAr ? s.RoomAr : (s.RoomEn || '');
          const room = escapeHtml(roomVal);
          const startT = s.StartTime || '';
          const endT = s.EndTime || '';
          const timeVal = (startT && endT) ? `${startT} - ${endT}` : startT;
          const timeStr = escapeHtml(timeVal);
          const day = String(s.DayNumber || 1);
          const sessionRole = escapeHtml(isArPage && s.RoleAr ? s.RoleAr : (s.RoleEn || 'Speaker'));

          const tBadge = isArPage ? (track === 'track-a' ? 'المسار أ' : track === 'track-b' ? 'المسار ب' : 'المسار ج') : (track === 'track-a' ? 'Track A' : track === 'track-b' ? 'Track B' : 'Track C');
          const tIcon = trackIcons[track] || 'bi bi-cpu';

          const sBadge = isArPage ? (sector === 'clinical' ? 'قطاع سريري' : sector === 'academic' ? 'قطاع أكاديمي' : sector === 'industry' ? 'قطاع صناعي' : 'دولي') : (sector === 'clinical' ? 'Clinical' : sector === 'academic' ? 'Academic' : sector === 'industry' ? 'Industry' : 'International');
          const sIcon = sectorIcons[sector] || 'bi bi-hospital';

          const lecLabel = isArPage ? 'عنوان المحاضرة' : 'Lecture Presentation';
          const quickBtn = isArPage ? 'نظرة سريعة' : 'Quick Overview';

          const lecHtml = lecture ? `<div class="speaker-lecture-card">
              <div class="speaker-lecture-label"><i class="bi bi-mic-fill"></i> ${lecLabel}</div>
              <p class="speaker-lecture-title">${lecture}</p>
          </div>` : '';

          return `<article class="speaker-card ${track}"
                   data-photo="${photo}"
                   data-cv="${cv}"
                   data-track="${track}"
                   data-sector="${sector}"
                   data-region="${region}"
                   data-name="${name}"
                   data-role="${role}"
                   data-org="${org}"
                   data-lecture="${lecture}"
                   data-track-name="${trackName}"
                   data-sector-name="${sectorName}"
                   data-region-name="${regionName}"
                   data-flag="${flag}"
                   data-initials="${initials}"
                   data-room="${room}"
                   data-time="${timeStr}"
                   data-day="${day}"
                   data-session-role="${sessionRole}">
              <div class="speaker-card-header">
                  <span class="speaker-track-tag tag-${track}" onclick="filterToTrack('${track}')" style="cursor:pointer;">
                      <i class="${tIcon}"></i> ${tBadge}
                  </span>
                  <span class="speaker-sector-tag">
                      <i class="${sIcon}"></i> ${sBadge}
                  </span>
              </div>
              <div class="speaker-avatar-wrap">
                  <img src="${photo}" alt="${name}" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                  <div class="speaker-monogram" style="display:none;">${initials}</div>
                  <span class="speaker-badge-flag" title="${regionName}">${flag}</span>
              </div>
              <div class="speaker-body">
                  <h3 class="speaker-name">${name}</h3>
                  <p class="speaker-title">${role}</p>
                  <p class="speaker-org">
                      <i class="bi bi-bank sairh-organization-icon"></i>
                      <span>${org}</span>
                  </p>
                  ${lecHtml}
              </div>
              <div class="speaker-card-actions">
                  <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                      <i class="bi bi-info-circle"></i> ${quickBtn}
                  </button>
              </div>
          </article>`;
        });
        // Update tab counts and total counts in HTML
        const totalCnt = spList.length;
        const trackACnt = spList.filter(s => (s.Track || '').toLowerCase().trim() === 'track-a').length;
        const trackBCnt = spList.filter(s => (s.Track || '').toLowerCase().trim() === 'track-b').length;
        const trackCCnt = spList.filter(s => (s.Track || '').toLowerCase().trim() === 'track-c').length;

        rendered = rendered.replace(/(data-track="all"[^>]*>[\s\S]*?<span class="tab-count">)\d+(<\/span>)/gi, `$1${totalCnt}$2`);
        rendered = rendered.replace(/(data-track="track-a"[^>]*>[\s\S]*?<span class="tab-count">)\d+(<\/span>)/gi, `$1${trackACnt}$2`);
        rendered = rendered.replace(/(data-track="track-b"[^>]*>[\s\S]*?<span class="tab-count">)\d+(<\/span>)/gi, `$1${trackBCnt}$2`);
        rendered = rendered.replace(/(data-track="track-c"[^>]*>[\s\S]*?<span class="tab-count">)\d+(<\/span>)/gi, `$1${trackCCnt}$2`);
        rendered = rendered.replace(/(id="speakersCount"[^>]*>)\d+(<)/gi, `$1${totalCnt}$2`);
        rendered = rendered.replace(/(id="speakersTotalCount"[^>]*>)\d+(<)/gi, `$1${totalCnt}$2`);

        rendered = rendered.replace('</body>', `<script>console.warn("[SAIRH Node Server] Loaded ${totalCnt} speakers from speakers.json cache. To sync live database changes, run: ./tools/sync_speakers.sh");</script>\n</body>`);
      } catch (err) {
        console.error('Error reading speakers.json:', err);
      }
    }
    rendered = rendered.replace(/<asp:Repeater[^>]*ID=["']rptSpeakers["'][^>]*>[\s\S]*?<\/asp:Repeater>/gi, cardsHtml.join('\n'));
  }

  // Dynamic active navigation highlight
  const reqLower = relativeUrl.toLowerCase();
  const isAr = reqLower.includes('/ar_sa');

  if (isAr) {
    if (reqLower.includes('publication')) rendered = rendered.replace('id="linkPublicationAr"', 'id="linkPublicationAr" class="active"');
    else if (reqLower.includes('schedules')) rendered = rendered.replace('id="linkSchedulesAr"', 'id="linkSchedulesAr" class="active"');
    else if (reqLower.includes('ceremony')) rendered = rendered.replace('id="linkCeremonyAr"', 'id="linkCeremonyAr" class="active"');
    else if (reqLower.includes('judges') || reqLower.includes('speaker')) rendered = rendered.replace('id="linkSpeakersAr"', 'id="linkSpeakersAr" class="active"').replace('id="linkJudgesAr"', 'id="linkJudgesAr" class="active"');
    else if (reqLower.includes('sponsors')) rendered = rendered.replace('id="linkSponsorsAr"', 'id="linkSponsorsAr" class="active"');
    else if (reqLower.includes('contactus')) rendered = rendered.replace('id="linkContactUsAr"', 'id="linkContactUsAr" class="active"');
    else rendered = rendered.replace('id="linkHomeAr"', 'id="linkHomeAr" class="active"');
  } else {
    if (reqLower.includes('publication')) rendered = rendered.replace('id="linkPublication"', 'id="linkPublication" class="active"');
    else if (reqLower.includes('schedules')) rendered = rendered.replace('id="linkSchedules"', 'id="linkSchedules" class="active"');
    else if (reqLower.includes('ceremony')) rendered = rendered.replace('id="linkCeremony"', 'id="linkCeremony" class="active"');
    else if (reqLower.includes('judges') || reqLower.includes('speaker')) rendered = rendered.replace('id="linkSpeakers"', 'id="linkSpeakers" class="active"').replace('id="linkJudges"', 'id="linkJudges" class="active"');
    else if (reqLower.includes('sponsors')) rendered = rendered.replace('id="linkSponsors"', 'id="linkSponsors" class="active"');
    else if (reqLower.includes('contactus')) rendered = rendered.replace('id="linkContactUs"', 'id="linkContactUs" class="active"');
    else rendered = rendered.replace('id="linkHome"', 'id="linkHome" class="active"');
  }

  rendered = rendered.replace(/href="~\/"/g, 'href="/"');
  rendered = rendered.replace(/href="~\/Ar_Sa\/"/gi, 'href="/Ar_Sa/"');

  // First-time welcome banner for Survey.aspx
  const isFirstTime = relativeUrl.includes('first=1');
  if (isFirstTime) {
    rendered = rendered.replace(/id=["']pnlFirstTimeBanner["'][^>]*visible=["']false["']/gi, 'id="pnlFirstTimeBanner" style="display:flex;"');
  } else {
    rendered = rendered.replace(/<div[^>]*id=["']pnlFirstTimeBanner["'][^>]*>[\s\S]*?<\/div>\s*<\/div>/gi, '');
  }

  // Schedules.aspx personalized roadmap rendering
  if (aspxPath.toLowerCase().includes('schedules')) {
    const roadmap = user && user.surveyRoadmap ? user.surveyRoadmap : [];
    if (roadmap && roadmap.length > 0) {
      rendered = rendered.replace(/id=["']pnlRoadmap["'][^>]*visible=["']false["']/gi, 'id="pnlRoadmap" style="display:block;"');
      rendered = rendered.replace(/id=["']pnlSurveyCTA["']/gi, 'id="pnlSurveyCTA" style="display:none;"');
      const isAr = relativeUrl.toLowerCase().includes('/ar_sa') || aspxPath.toLowerCase().includes('ar_sa');
      const cards = roadmap.map(code => {
        const booth = ALL_BOOTHS.find(b => b.boothCode === code);
        if (!booth) return '';
        const hall = isAr ? booth.hallAr : booth.hallEn;
        const name = isAr ? booth.nameAr : booth.nameEn;
        const org = isAr ? booth.organizationAr : booth.organizationEn;
        return `
          <div class="recommended-stop-card" onclick="openBoothModal('${code}')" style="cursor:pointer;">
              <div class="d-flex justify-content-between align-items-center mb-1">
                  <span class="badge badge-info">${escapeHtml(hall)}</span>
                  <strong class="text-white">${code}</strong>
              </div>
              <div class="text-white font-weight-bold">${escapeHtml(name)}</div>
              <div class="text-secondary small">${escapeHtml(org)}</div>
          </div>`;
      }).join('');
      rendered = rendered.replace(/<div[^>]*id=["']recCardsContainer["'][^>]*>[\s\S]*?<\/div>/i, `<div class="recommended-cards-grid" id="recCardsContainer">${cards}</div>`);
    } else {
      rendered = rendered.replace(/id=["']pnlRoadmap["']/gi, 'id="pnlRoadmap" style="display:none;"');
    }
  }

  // Profile.aspx exhibition roadmap box rendering
  if (aspxPath.toLowerCase().includes('profile')) {
    if (user && (user.organization || user.jobTitle)) {
      rendered = rendered.replace(/<p([^>]*)id=["']pOrgTitle["']([^>]*)style=["']display:none;?["']/gi, '<p$1id="pOrgTitle"$2style="display:block;"');
    }
    const isAr = relativeUrl.toLowerCase().includes('/ar_sa') || aspxPath.toLowerCase().includes('ar_sa');
    const roadmap = user && user.surveyRoadmap ? user.surveyRoadmap : [];
    if (roadmap && roadmap.length > 0) {
      const cnt = roadmap.length;
      const badgeText = isAr ? `مكتمل (${cnt} محطات)` : `Completed (${cnt} stops)`;
      const descText = isAr ? `مسارك المخصص في المعرض نشط ويتضمن ${cnt} محطة استكشافية موصى بها.` : `Your personalized roadmap is active with ${cnt} recommended booth and research stops.`;
      const actionText = isAr ? '<i class="bi bi-arrow-repeat ml-1"></i> إعادة الاستبيان' : '<i class="bi bi-arrow-repeat mr-1"></i> Retake Survey';
      const chips = roadmap.map(c => `<span class="badge badge-primary ${isAr ? 'ml-1' : 'mr-1'} mb-1" style="background:#0284c7;font-size:0.75rem;">${c}</span>`).join('');
      rendered = rendered.replace(/<span[^>]*id=["']LblSurveyBadge["'][^>]*>[\s\S]*?<\/span>/i, `<span id="LblSurveyBadge" class="badge badge-success">${badgeText}</span>`);
      rendered = rendered.replace(/<p[^>]*id=["']pRoadmapDesc["'][^>]*>[\s\S]*?<\/p>/i, `<p class="text-secondary small mb-3" id="pRoadmapDesc">${descText}</p>`);
      rendered = rendered.replace(/id=["']pnlSurveyStops["'][^>]*visible=["']false["']/gi, 'id="pnlSurveyStops" style="display:block;"');
      rendered = rendered.replace(/<div[^>]*id=["']pnlStopsChips["'][^>]*>[\s\S]*?<\/div>/i, `<div id="pnlStopsChips" class="d-flex flex-wrap gap-1">${chips}</div>`);
      rendered = rendered.replace(/<a[^>]*id=["']lnkSurveyAction["'][^>]*>[\s\S]*?<\/a>/i, `<a href="Survey" id="lnkSurveyAction" class="btn btn-sm btn-outline-light rounded-pill font-weight-semibold">${actionText}</a>`);
    } else {
      const badgeText = isAr ? "لم يكتمل بعد" : "Not Completed";
      const descText = isAr ? "أكمل استبيان التخصيص القصير للحصول على جولة مخصصة للأجنحة وشاشات الأبحاث على خريطة المعرض." : "Take our short survey to get a tailored tour of sponsor booths and research displays on the Exhibition Map.";
      const actionText = isAr ? '<i class="bi bi-magic ml-1"></i> بناء مساري المخصص' : '<i class="bi bi-magic mr-1"></i> Build My Roadmap';
      rendered = rendered.replace(/<span[^>]*id=["']LblSurveyBadge["'][^>]*>[\s\S]*?<\/span>/i, `<span id="LblSurveyBadge" class="badge badge-warning">${badgeText}</span>`);
      rendered = rendered.replace(/<p[^>]*id=["']pRoadmapDesc["'][^>]*>[\s\S]*?<\/p>/i, `<p class="text-secondary small mb-3" id="pRoadmapDesc">${descText}</p>`);
      rendered = rendered.replace(/id=["']pnlSurveyStops["']/gi, 'id="pnlSurveyStops" style="display:none;"');
      rendered = rendered.replace(/<a[^>]*id=["']lnkSurveyAction["'][^>]*>[\s\S]*?<\/a>/i, `<a href="Survey" id="lnkSurveyAction" class="btn btn-sm btn-outline-light rounded-pill font-weight-semibold">${actionText}</a>`);
    }
  }

  // ForgotPassword.aspx state handling
  if (resetSuccessUrl) {
    rendered = rendered.replace(/id=["']pnlForm["']/gi, 'id="pnlForm" style="display:none;"');
    rendered = rendered.replace(/id=["']pnlSuccess["'][^>]*visible=["']false["']/gi, 'id="pnlSuccess" style="display:block;"');
    rendered = rendered.replace(/<(?:asp:HyperLink|a)[^>]*id=["']LnkResetAction["'][^>]*>[\s\S]*?<\/(?:asp:HyperLink|a)>/i, `<a href="${resetSuccessUrl}" id="LnkResetAction" class="cyan-glow-btn d-inline-block px-4 py-3 text-white font-weight-bold text-decoration-none"><i class="bi bi-arrow-right-circle mr-1"></i> Proceed to Reset Password</a>`);
  }

  // ResetPassword.aspx state handling
  if (invalidToken) {
    rendered = rendered.replace(/id=["']pnlForm["']/gi, 'id="pnlForm" style="display:none;"');
    rendered = rendered.replace(/id=["']pnlInvalidToken["'][^>]*visible=["']false["']/gi, 'id="pnlInvalidToken" style="display:block;"');
  } else if (resetDone) {
    rendered = rendered.replace(/id=["']pnlForm["']/gi, 'id="pnlForm" style="display:none;"');
    rendered = rendered.replace(/id=["']pnlSuccess["'][^>]*visible=["']false["']/gi, 'id="pnlSuccess" style="display:block;"');
  } else if (aspxPath.toLowerCase().includes('resetpassword')) {
    const tMatch = relativeUrl.match(/[?&]token=([^&]+)/);
    if (tMatch) {
      const tVal = escapeHtml(tMatch[1]);
      rendered = rendered.replace(/(<div[^>]*id=["']pnlForm["'][^>]*>)/i, `$1<input type="hidden" name="token" value="${tVal}" />`);
    }
  }

  return rendered;
}

function escapeHtml(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function renderErrorList(errors) {
  if (errors.length === 1) return escapeHtml(errors[0]);
  return `<ul class="auth-alert-list">${errors.map(e => `<li>${escapeHtml(e)}</li>`).join('')}</ul>`;
}

function readRequestBody(req, callback) {
  let body = '';
  req.on('data', chunk => {
    body += chunk;
    if (body.length > 1e6) req.connection.destroy();
  });
  req.on('end', () => {
    if (!body) return callback({});
    try {
      return callback(JSON.parse(body));
    } catch (e) {
      try {
        return callback(querystring.parse(body));
      } catch (err) {
        return callback({});
      }
    }
  });
}

function handleAuthApi(req, res, pathname, currentUser) {
  const method = req.method.toUpperCase();
  const endpoint = pathname.toLowerCase();

  res.setHeader('Content-Type', 'application/json; charset=utf-8');

  // GET /api/auth/status
  if (endpoint === 'api/auth/status' && method === 'GET') {
    if (!currentUser) {
      res.writeHead(200);
      return res.end(JSON.stringify({ isAuthenticated: false }));
    }
    return res.end(JSON.stringify({ isAuthenticated: true, user: currentUser }));
  }

  // GET /api/auth/profile
  if (endpoint === 'api/auth/profile' && method === 'GET') {
    if (!currentUser) {
      res.writeHead(401);
      return res.end(JSON.stringify({ error: 'Authentication required.' }));
    }
    res.writeHead(200);
    return res.end(JSON.stringify(currentUser));
  }

  readRequestBody(req, payload => {
    // POST /api/auth/logout
    if (endpoint === 'api/auth/logout' && method === 'POST') {
      res.writeHead(200, {
        'Set-Cookie': 'sairh_user=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT'
      });
      return res.end(JSON.stringify({ success: true, message: 'Successfully logged out.' }));
    }

    // POST /api/auth/register
    if (endpoint === 'api/auth/register' && method === 'POST') {
      const fullName = (payload.FullName || payload.fullName || '').trim();
      const email = (payload.Email || payload.email || '').trim().toLowerCase();
      const mobile = (payload.MobileNo || payload.mobile || payload.mobileNo || '').trim();
      const organization = (payload.Organization || payload.organization || '').trim();
      const jobTitle = (payload.JobTitle || payload.jobTitle || '').trim();
      const specialty = (payload.Specialty || payload.specialty || '').trim();
      const linkedIn = (payload.LinkedInUrl || payload.linkedIn || payload.linkedInUrl || '').trim();
      const password = payload.Password || payload.password || '';
      const confirmPassword = payload.ConfirmPassword || payload.confirmPassword || '';

      const errors = [];
      if (!fullName || fullName.length < 3) errors.push('Please enter your full name (at least 3 characters).');
      if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) errors.push('Please enter a valid email address.');
      errors.push(...validatePasswordStrength(password, email, fullName, false));
      if (password && password !== confirmPassword) errors.push('Passwords do not match.');

      if (errors.length > 0) {
        res.writeHead(400);
        return res.end(JSON.stringify({ success: false, errors }));
      }

      if (DEV_USERS[email]) {
        res.writeHead(409);
        return res.end(JSON.stringify({ success: false, error: 'This email is already registered.', code: 'EmailTaken' }));
      }

      const pHash = hashPassword(password);
      const newUser = {
        fullName,
        email,
        mobile,
        organization,
        jobTitle,
        specialty,
        linkedIn,
        role: 'Attendee',
        passwordHash: pHash,
        passwordHistory: [pHash],
        failedAttempts: 0,
        lockoutUntil: null,
        lastLogin: new Date().toISOString(),
        passwordChangedDate: new Date().toISOString(),
        hasCompletedSurvey: false,
        surveyRoadmap: []
      };
      DEV_USERS[email] = newUser;
      saveUsers();

      res.writeHead(201, {
        'Set-Cookie': `sairh_user=${encodeURIComponent(email)}; Path=/; HttpOnly`
      });
      return res.end(JSON.stringify({ success: true, message: 'Welcome to SAIRH!', user: newUser }));
    }

    // POST /api/auth/login
    if (endpoint === 'api/auth/login' && method === 'POST') {
      const email = (payload.Email || payload.email || '').trim().toLowerCase();
      const password = payload.Password || payload.password || '';
      const rememberMe = payload.RememberMe === true || payload.rememberMe === true;

      if (!email || !password) {
        res.writeHead(400);
        return res.end(JSON.stringify({ success: false, error: 'Please enter both your email address and password.' }));
      }

      const user = DEV_USERS[email];
      if (!user) {
        res.writeHead(401);
        return res.end(JSON.stringify({ success: false, error: 'Incorrect email or password.', code: 'InvalidCredentials' }));
      }

      if (user.lockoutUntil && Date.now() < user.lockoutUntil) {
        const remainingMinutes = Math.ceil((user.lockoutUntil - Date.now()) / 60000);
        res.writeHead(403);
        return res.end(JSON.stringify({
          success: false,
          error: `Account is temporarily locked due to multiple failed login attempts. Please try again in ${remainingMinutes} minute(s).`,
          code: 'LockedOut'
        }));
      }

      if (!verifyPassword(password, user.passwordHash)) {
        user.failedAttempts = (user.failedAttempts || 0) + 1;
        if (user.failedAttempts >= 5) {
          user.lockoutUntil = Date.now() + 15 * 60 * 1000;
          saveUsers();
          res.writeHead(403);
          return res.end(JSON.stringify({
            success: false,
            error: 'Account locked for 15 minutes due to 5 consecutive failed login attempts.',
            code: 'LockedOut'
          }));
        }
        saveUsers();
        res.writeHead(401);
        return res.end(JSON.stringify({
          success: false,
          error: 'Incorrect email or password.',
          code: 'InvalidCredentials'
        }));
      }

      // Success
      user.failedAttempts = 0;
      user.lockoutUntil = null;
      user.lastLogin = new Date().toISOString();
      saveUsers();

      const cookieHeader = rememberMe
        ? `sairh_user=${encodeURIComponent(email)}; Path=/; Max-Age=2592000; HttpOnly`
        : `sairh_user=${encodeURIComponent(email)}; Path=/; HttpOnly`;

      res.writeHead(200, { 'Set-Cookie': cookieHeader });
      return res.end(JSON.stringify({ success: true, message: 'Sign in successful.', user }));
    }

    // POST or PUT /api/auth/profile
    if (endpoint === 'api/auth/profile' && (method === 'POST' || method === 'PUT')) {
      if (!currentUser) {
        res.writeHead(401);
        return res.end(JSON.stringify({ error: 'Authentication required.' }));
      }

      const fullName = (payload.FullName || payload.fullName || '').trim();
      const mobile = (payload.MobileNo || payload.mobile || payload.mobileNo || '').trim();
      const organization = (payload.Organization || payload.organization || '').trim();
      const jobTitle = (payload.JobTitle || payload.jobTitle || '').trim();
      const specialty = (payload.Specialty || payload.specialty || '').trim();
      const linkedIn = (payload.LinkedInUrl || payload.linkedIn || payload.linkedInUrl || '').trim();

      if (fullName && fullName.length < 3) {
        res.writeHead(400);
        return res.end(JSON.stringify({ error: 'Please enter your full name (at least 3 characters).' }));
      }

      if (fullName) currentUser.fullName = fullName;
      if (mobile !== undefined) currentUser.mobile = mobile;
      if (organization !== undefined) currentUser.organization = organization;
      if (jobTitle !== undefined) currentUser.jobTitle = jobTitle;
      if (specialty !== undefined) currentUser.specialty = specialty;
      if (linkedIn !== undefined) currentUser.linkedIn = linkedIn;

      DEV_USERS[currentUser.email.toLowerCase()] = currentUser;
      saveUsers();

      res.writeHead(200);
      return res.end(JSON.stringify({ success: true, message: 'Profile saved successfully.', user: currentUser }));
    }

    // POST /api/auth/change-password
    if (endpoint === 'api/auth/change-password' && method === 'POST') {
      if (!currentUser) {
        res.writeHead(401);
        return res.end(JSON.stringify({ error: 'Authentication required.' }));
      }

      const currentPassword = payload.CurrentPassword || payload.currentPassword || '';
      const newPassword = payload.NewPassword || payload.newPassword || '';
      const confirmPassword = payload.ConfirmPassword || payload.confirmPassword || '';

      const errors = [];
      if (!currentPassword) errors.push('Please enter your current password.');
      else if (currentUser.passwordHash && !verifyPassword(currentPassword, currentUser.passwordHash)) {
        errors.push('Your current password is incorrect.');
      }

      if (isPasswordInHistory(newPassword, currentUser.passwordHistory)) {
        errors.push('You cannot reuse any of your last 3 passwords.');
      }

      errors.push(...validatePasswordStrength(newPassword, currentUser.email, currentUser.fullName, false));
      if (newPassword && newPassword !== confirmPassword) errors.push('Passwords do not match.');

      if (errors.length > 0) {
        res.writeHead(400);
        return res.end(JSON.stringify({ success: false, errors }));
      }

      const newHash = hashPassword(newPassword);
      currentUser.passwordHash = newHash;
      if (!currentUser.passwordHistory) currentUser.passwordHistory = [];
      currentUser.passwordHistory.unshift(newHash);
      if (currentUser.passwordHistory.length > 5) currentUser.passwordHistory = currentUser.passwordHistory.slice(0, 5);
      currentUser.passwordChangedDate = new Date().toISOString();
      DEV_USERS[currentUser.email.toLowerCase()] = currentUser;
      saveUsers();

      res.writeHead(200);
      return res.end(JSON.stringify({ success: true, message: 'Password has been successfully changed.' }));
    }

    // POST /api/auth/forgot-password
    if (endpoint === 'api/auth/forgot-password' && method === 'POST') {
      const email = (payload.Email || payload.email || '').trim().toLowerCase();
      if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        res.writeHead(400);
        return res.end(JSON.stringify({ error: 'Please enter a valid email address.' }));
      }

      const token = crypto.randomBytes(24).toString('hex');
      RESET_TOKENS[token] = {
        email,
        expires: Date.now() + 3600 * 1000,
        used: false
      };
      const resetUrl = `/ResetPassword?token=${token}`;
      res.writeHead(200);
      return res.end(JSON.stringify({ success: true, message: 'Reset link sent.', token, resetUrl }));
    }

    // POST /api/auth/reset-password
    if (endpoint === 'api/auth/reset-password' && method === 'POST') {
      const token = (payload.Token || payload.token || '').trim();
      const newPassword = payload.NewPassword || payload.newPassword || '';
      const confirmPassword = payload.ConfirmPassword || payload.confirmPassword || '';

      const tokenInfo = RESET_TOKENS[token];
      if (!tokenInfo || tokenInfo.used || tokenInfo.expires < Date.now()) {
        res.writeHead(400);
        return res.end(JSON.stringify({ success: false, error: 'Password reset link is invalid or has expired.' }));
      }

      const targetEmail = tokenInfo.email;
      const userObj = DEV_USERS[targetEmail.toLowerCase()] || {};

      const errors = [];
      if (isPasswordInHistory(newPassword, userObj.passwordHistory)) {
        errors.push('You cannot reuse any of your last 3 passwords.');
      }
      errors.push(...validatePasswordStrength(newPassword, targetEmail, userObj.fullName || '', false));
      if (newPassword && newPassword !== confirmPassword) errors.push('Passwords do not match.');

      if (errors.length > 0) {
        res.writeHead(400);
        return res.end(JSON.stringify({ success: false, errors }));
      }

      tokenInfo.used = true;
      const newHash = hashPassword(newPassword);
      if (!userObj.passwordHistory) userObj.passwordHistory = [];
      userObj.passwordHistory.unshift(newHash);
      if (userObj.passwordHistory.length > 5) userObj.passwordHistory = userObj.passwordHistory.slice(0, 5);
      userObj.passwordHash = newHash;
      userObj.passwordChangedDate = new Date().toISOString();
      userObj.failedAttempts = 0;
      userObj.lockoutUntil = null;
      DEV_USERS[targetEmail.toLowerCase()] = userObj;
      saveUsers();

      res.writeHead(200);
      return res.end(JSON.stringify({ success: true, message: 'Password has been reset successfully.' }));
    }

    res.writeHead(404);
    res.end(JSON.stringify({ error: 'Endpoint not found.' }));
  });
}

function handleRequest(req, res) {
  const parsed = url.parse(req.url, true);
  let pathname = decodeURIComponent(parsed.pathname).replace(/^\/+/, '');

  // Enable CORS & no-cache
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');

  // Handle Logout
  if (parsed.query.logout) {
    res.writeHead(302, {
      'Set-Cookie': 'sairh_user=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT',
      'Location': pathname.toLowerCase().startsWith('ar_sa') ? '/Ar_Sa/Login' : '/Login'
    });
    return res.end();
  }

  // Normalize static asset paths if requested relative to /Ar_Sa/
  if (pathname.toLowerCase().startsWith('ar_sa/content/')) {
    pathname = pathname.substring(6);
  } else if (pathname.toLowerCase().startsWith('ar_sa/scripts/')) {
    pathname = pathname.substring(6);
  }

  // Check static asset
  const ext = path.extname(pathname).toLowerCase();
  if (MIME_TYPES[ext] && ext !== '.html') {
    const filePath = path.join(BASE_DIR, pathname);
    if (fs.existsSync(filePath)) {
      const stream = fs.createReadStream(filePath);
      res.writeHead(200, { 'Content-Type': MIME_TYPES[ext] });
      return stream.pipe(res);
    }
  }

  // Current authenticated user check
  const userEmail = getCookie(req, 'sairh_user');
  let currentUser = userEmail && DEV_USERS[userEmail.toLowerCase()] ? DEV_USERS[userEmail.toLowerCase()] : null;
  if (!currentUser && userEmail) {
    currentUser = { fullName: userEmail.split('@')[0], email: userEmail, mobile: '' };
  }

  // Handle Auth RESTful API
  if (pathname.toLowerCase().startsWith('api/auth/')) {
    return handleAuthApi(req, res, pathname, currentUser);
  }

  // Handle Interactive Map Status API (Sponsor & Research Booths)
  if (pathname.toLowerCase() === 'api/map/status') {
    const isAr = (parsed.query.lang || '').toLowerCase() === 'ar' || req.url.toLowerCase().includes('/ar_sa');
    const userEmail = currentUser ? currentUser.email : '';
    const statusList = getMapStatus(userEmail, isAr);
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    return res.end(JSON.stringify(statusList));
  }

  // Handle NFC / Map Scan API
  if (pathname.toLowerCase() === 'api/map/scan') {
    let boothCode = (parsed.query.boothCode || '').trim().toUpperCase();
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      if (body.length > 1e6) req.connection.destroy();
    });
    req.on('end', () => {
      if (body) {
        try {
          const payload = JSON.parse(body);
          if (payload.boothCode) boothCode = payload.boothCode.trim().toUpperCase();
        } catch (e) {
          const parsedForm = querystring.parse(body);
          if (parsedForm.boothCode) boothCode = parsedForm.boothCode.trim().toUpperCase();
        }
      }
      if (boothCode) {
        registerScan(boothCode, currentUser ? currentUser.email : null);
      }
      res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ success: true, boothCode }));
    });
    return;
  }

  // Handle NFC Booth Visit Logging & Projected Average Timer API
  if (pathname.toLowerCase() === 'api/booth/visit') {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      if (body.length > 1e6) req.connection.destroy();
    });
    req.on('end', () => {
      let payload = {};
      try {
        payload = JSON.parse(body);
      } catch (e) {
        payload = querystring.parse(body);
      }

      const boothCode = (payload.boothCode || parsed.query.code || '').trim().toUpperCase();
      const action = (payload.action || 'start').toLowerCase();
      const email = currentUser ? currentUser.email : (payload.userEmail || 'guest@sairh.com');

      const booth = ALL_BOOTHS.find(b => b.boothCode === boothCode) || {
        boothCode,
        nameEn: `Summit Exhibition ${boothCode}`,
        nameAr: `معرض الملتقى ${boothCode}`,
        type: boothCode.startsWith('S') ? 'SponsorBooth' : 'ResearchScreen',
        projectedAvgMinutes: 5
      };

      if (action === 'start') {
        registerScan(boothCode, email);
        const visitRecord = {
          visitId: Date.now(),
          userEmail: email,
          boothCode,
          boothType: booth.type,
          boothName: booth.nameEn,
          projectedAvgMinutes: booth.projectedAvgMinutes || 5,
          startedAt: new Date().toISOString(),
          completedAt: null,
          status: 'Active'
        };
        BOOTH_VISITS_LOG.push(visitRecord);

        res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
        return res.end(JSON.stringify({
          success: true,
          action: 'start',
          visit: visitRecord
        }));
      } else if (action === 'complete') {
        const existing = [...BOOTH_VISITS_LOG].reverse().find(v => v.userEmail === email && v.boothCode === boothCode && v.status === 'Active');
        if (existing) {
          existing.status = 'Completed';
          existing.completedAt = new Date().toISOString();
        }
        res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
        return res.end(JSON.stringify({
          success: true,
          action: 'complete',
          boothCode,
          status: 'Completed'
        }));
      }

      res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ success: true, boothCode, booth }));
    });
    return;
  }

  // Handle Admin Summit Settings API (Enforces OWASP BAC server-side)
  if (pathname.toLowerCase() === 'api/admin/summit') {
    const isAdmin = currentUser && (currentUser.role === 'Administrator' || currentUser.role === 'Admin' || currentUser.isAdmin === true);
    if (!isAdmin) {
      res.writeHead(403, { 'Content-Type': 'application/json; charset=utf-8' });
      return res.end(JSON.stringify({ error: 'Forbidden: Administrator privileges required.' }));
    }
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      try {
        const payload = JSON.parse(body);
        SUMMIT_SETTINGS = { ...SUMMIT_SETTINGS, ...payload };
        res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
        res.end(JSON.stringify({ success: true, summit: SUMMIT_SETTINGS }));
      } catch (e) {
        res.writeHead(400, { 'Content-Type': 'application/json; charset=utf-8' });
        res.end(JSON.stringify({ error: 'Invalid payload' }));
      }
    });
    return;
  }

  // Handle Admin Booth Projected Time Settings API (Enforces OWASP BAC server-side)
  if (pathname.toLowerCase() === 'api/admin/booth') {
    const isAdmin = currentUser && (currentUser.role === 'Administrator' || currentUser.role === 'Admin' || currentUser.isAdmin === true);
    if (!isAdmin) {
      res.writeHead(403, { 'Content-Type': 'application/json; charset=utf-8' });
      return res.end(JSON.stringify({ error: 'Forbidden: Administrator privileges required.' }));
    }
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      try {
        const payload = JSON.parse(body);
        const code = (payload.boothCode || '').toUpperCase();
        const b = ALL_BOOTHS.find(x => x.boothCode === code);
        if (b && payload.projectedAvgMinutes) {
          b.projectedAvgMinutes = parseInt(payload.projectedAvgMinutes, 10);
        }
        res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
        res.end(JSON.stringify({ success: true, booth: b }));
      } catch (e) {
        res.writeHead(400, { 'Content-Type': 'application/json; charset=utf-8' });
        res.end(JSON.stringify({ error: 'Invalid payload' }));
      }
    });
    return;
  }

  // Handle Chatbot ask API
  if (pathname.toLowerCase() === 'api/chat/ask') {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      if (body.length > 1e6) req.connection.destroy();
    });
    req.on('end', () => {
      let payload = {};
      try {
        payload = JSON.parse(body);
      } catch (e) {
        payload = querystring.parse(body);
      }
      const message = (payload.message || '').trim();
      const language = payload.language === 'ar' ? 'ar' : 'en';
      if (!message) {
        res.writeHead(400, { 'Content-Type': 'application/json; charset=utf-8' });
        return res.end(JSON.stringify({ error: 'Message cannot be empty.' }));
      }
      const faqsPath = path.join(BASE_DIR, 'Content/data/faqs.json');
      let faqs = [];
      if (fs.existsSync(faqsPath)) {
        try { faqs = JSON.parse(fs.readFileSync(faqsPath, 'utf8')); } catch (e) {}
      }
      const norm = (s) => (s || '').trim().replace(/[?؟!.]$/, '').trim().toLowerCase();
      const cleanMsg = norm(message);
      for (const cat of faqs) {
        for (const q of (cat.questions || [])) {
          if (norm(q.questionEn) === cleanMsg || norm(q.questionAr) === cleanMsg) {
            const ans = language === 'ar' ? q.answerAr : q.answerEn;
            res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
            return res.end(JSON.stringify({ answer: ans, source: 'faq' }));
          }
        }
      }
      const defaultAns = language === 'ar'
        ? 'مرحباً بك في الملتقى السعودي للذكاء الاصطناعي في الأشعة! يمكنك استكشاف جدول الجلسات ومعرض الابتكارات عبر القائمة العلوية.'
        : 'Welcome to SAIRH! You can explore the event schedule and exhibition booths using the navigation bar.';
      res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
      res.end(JSON.stringify({ answer: defaultAns, source: 'default' }));
    });
    return;
  }

  // Handle POST requests
  if (req.method === 'POST') {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      if (body.length > 1e6) req.connection.destroy();
    });

    req.on('end', () => {
      const post = querystring.parse(body);
      handlePostRequest(req, res, pathname, post, currentUser);
    });
    return;
  }

  // Handle GET requests
  handleGetRequest(req, res, pathname, currentUser);
}

function handlePostRequest(req, res, pathname, post, currentUser) {
  const isArabic = pathname.toLowerCase().startsWith('ar_sa');
  const sub = isArabic ? pathname.slice(5).replace(/^\/+/, '') : pathname;
  const page = sub.toLowerCase();

  // Registration POST
  if (['register', 'register.aspx'].includes(page)) {
    const fullName = (post.TxtFullName || '').trim();
    const email = (post.TxtEmail || '').trim().toLowerCase();
    const mobile = (post.TxtMobile || '').trim();
    const organization = (post.TxtOrganization || '').trim();
    const jobTitle = (post.TxtJobTitle || '').trim();
    const password = post.TxtPassword || '';
    const passwordAgain = post.TxtPasswordAgain || '';

    const validationErrors = [];
    if (!fullName || fullName.length < 3) {
      validationErrors.push(isArabic ? 'يرجى إدخال الاسم الكامل (3 أحرف على الأقل).' : 'Please enter your full name (at least 3 characters).');
    }
    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      validationErrors.push(isArabic ? 'يرجى إدخال بريد إلكتروني صالح.' : 'Please enter a valid email address.');
    }
    if (DEV_USERS[email]) {
      validationErrors.push(isArabic ? 'هذا البريد الإلكتروني مسجل بالفعل. يرجى تسجيل الدخول أو استعادة كلمة المرور.' : 'This email is already registered. Please sign in or reset your password.');
    }

    // Enforce stronger password scheme
    const pwdErrors = validatePasswordStrength(password, email, fullName, isArabic);
    validationErrors.push(...pwdErrors);

    if (password && password !== passwordAgain) {
      validationErrors.push(isArabic ? 'كلمتا المرور غير متطابقتين.' : 'Passwords do not match.');
    }

    if (validationErrors.length > 0) {
      const template = isArabic ? 'Ar_Sa/Register.aspx' : 'Register.aspx';
      const html = parseAspx(path.join(BASE_DIR, template), req.url, { errorAlert: renderErrorList(validationErrors), formData: post });
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(html);
    }

    // Success: store password as PBKDF2 hash, redirect first-time attendee to Survey
    const pHash = hashPassword(password);
    DEV_USERS[email] = {
      fullName,
      email,
      mobile,
      organization,
      jobTitle,
      specialty: '',
      linkedIn: '',
      role: 'Attendee',
      passwordHash: pHash,
      passwordHistory: [pHash],
      failedAttempts: 0,
      lockoutUntil: null,
      lastLogin: new Date().toISOString(),
      passwordChangedDate: new Date().toISOString(),
      hasCompletedSurvey: false,
      surveyRoadmap: []
    };
    saveUsers();

    const redirectPath = isArabic ? '/Ar_Sa/Survey?first=1' : '/Survey?first=1';
    res.writeHead(302, {
      'Set-Cookie': `sairh_user=${encodeURIComponent(email)}; Path=/; HttpOnly`,
      'Location': redirectPath
    });
    return res.end();
  }

  // Survey POST
  if (['survey', 'survey.aspx'].includes(page)) {
    const interests = post.interests || [];
    const boothTypes = post.boothTypes || [];
    const goals = post.goals || [];
    const boothCount = parseInt(post.boothCount, 10) || 5;

    const recommended = calculateRecommendations(interests, boothTypes, goals, boothCount);
    const recCodes = recommended.map(b => b.boothCode);

    if (currentUser) {
      currentUser.hasCompletedSurvey = true;
      currentUser.surveyRoadmap = recCodes;
      DEV_USERS[currentUser.email.toLowerCase()] = currentUser;
      saveUsers();
    }

    const redirectPath = isArabic ? '/Ar_Sa/Schedules?survey=completed' : '/Schedules?survey=completed';
    res.writeHead(302, { 'Location': redirectPath });
    return res.end();
  }

  // ForgotPassword POST
  if (['forgotpassword', 'forgotpassword.aspx'].includes(page)) {
    const email = (post.TxtEmail || '').trim().toLowerCase();
    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      const err = isArabic ? 'يرجى إدخال بريد إلكتروني صالح.' : 'Please enter a valid email address.';
      const template = isArabic ? 'Ar_Sa/ForgotPassword.aspx' : 'ForgotPassword.aspx';
      const html = parseAspx(path.join(BASE_DIR, template), req.url, { errorAlert: err, formData: post });
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(html);
    }

    const token = crypto.randomBytes(24).toString('hex');
    RESET_TOKENS[token] = {
      email,
      expires: Date.now() + 3600 * 1000,
      used: false
    };
    const resetUrl = isArabic ? `/Ar_Sa/ResetPassword?token=${token}` : `/ResetPassword?token=${token}`;
    const template = isArabic ? 'Ar_Sa/ForgotPassword.aspx' : 'ForgotPassword.aspx';
    const html = parseAspx(path.join(BASE_DIR, template), req.url, { resetSuccessUrl: resetUrl });
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    return res.end(html);
  }

  // ResetPassword POST
  if (['resetpassword', 'resetpassword.aspx'].includes(page)) {
    const parsedReq = url.parse(req.url, true);
    const token = (parsedReq.query.token || post.token || '').trim();
    const tokenInfo = RESET_TOKENS[token];

    if (!tokenInfo || tokenInfo.used || tokenInfo.expires < Date.now()) {
      const template = isArabic ? 'Ar_Sa/ResetPassword.aspx' : 'ResetPassword.aspx';
      const html = parseAspx(path.join(BASE_DIR, template), req.url, { invalidToken: true });
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(html);
    }

    const pwd = post.TxtPassword || '';
    const pwdAgain = post.TxtPasswordAgain || '';
    const targetEmail = tokenInfo.email;
    const userObj = DEV_USERS[targetEmail.toLowerCase()] || {};

    const valErrors = validatePasswordStrength(pwd, targetEmail, userObj.fullName || '', isArabic);
    if (pwd && pwd !== pwdAgain) {
      valErrors.push(isArabic ? 'كلمتا المرور غير متطابقتين.' : 'Passwords do not match.');
    }

    if (isPasswordInHistory(pwd, userObj.passwordHistory)) {
      valErrors.push(isArabic ? 'لا يمكن إعادة استخدام أي من كلمات المرور الـ 3 الأخيرة الخاصة بك.' : 'You cannot reuse any of your last 3 passwords.');
    }

    if (valErrors.length > 0) {
      const template = isArabic ? 'Ar_Sa/ResetPassword.aspx' : 'ResetPassword.aspx';
      const html = parseAspx(path.join(BASE_DIR, template), req.url, { errorAlert: renderErrorList(valErrors), formData: post });
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(html);
    }

    // Success
    tokenInfo.used = true;
    const newHash = hashPassword(pwd);
    if (DEV_USERS[targetEmail.toLowerCase()]) {
      const u = DEV_USERS[targetEmail.toLowerCase()];
      u.passwordHash = newHash;
      if (!u.passwordHistory) u.passwordHistory = [];
      u.passwordHistory.unshift(newHash);
      if (u.passwordHistory.length > 5) u.passwordHistory = u.passwordHistory.slice(0, 5);
      u.passwordChangedDate = new Date().toISOString();
      u.failedAttempts = 0;
      u.lockoutUntil = null;
    } else {
      DEV_USERS[targetEmail.toLowerCase()] = {
        fullName: targetEmail.split('@')[0],
        email: targetEmail,
        mobile: '',
        organization: '',
        jobTitle: '',
        specialty: '',
        linkedIn: '',
        role: 'Attendee',
        passwordHash: newHash,
        passwordHistory: [newHash],
        failedAttempts: 0,
        lockoutUntil: null,
        lastLogin: new Date().toISOString(),
        passwordChangedDate: new Date().toISOString(),
        hasCompletedSurvey: false,
        surveyRoadmap: []
      };
    }
    saveUsers();

    const template = isArabic ? 'Ar_Sa/ResetPassword.aspx' : 'ResetPassword.aspx';
    const html = parseAspx(path.join(BASE_DIR, template), req.url, { resetDone: true });
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    return res.end(html);
  }

  // Login POST
  if (['login', 'login.aspx'].includes(page)) {
    const email = (post.TxtEmail || '').trim().toLowerCase();
    const password = post.TxtPassword || '';
    const rememberMe = post.ChkRememberMe === 'true' || post.ChkRememberMe === 'on';

    let error = null;
    let user = DEV_USERS[email];

    if (!email || !password) {
      error = isArabic ? 'يرجى إدخال البريد الإلكتروني وكلمة المرور.' : 'Please enter both your email address and password.';
    } else if (user) {
      if (user.lockoutUntil && Date.now() < user.lockoutUntil) {
        const remainingMinutes = Math.ceil((user.lockoutUntil - Date.now()) / 60000);
        error = isArabic
          ? `الحساب مغلق مؤقتاً لحمايته بسبب تكرار المحاولات الخاطئة. يرجى الانتظار لمدة ${remainingMinutes} دقيقة.`
          : `Account is temporarily locked due to multiple failed login attempts. Please try again in ${remainingMinutes} minute(s).`;
      } else {
        if (!verifyPassword(password, user.passwordHash)) {
          user.failedAttempts = (user.failedAttempts || 0) + 1;
          if (user.failedAttempts >= 5) {
            user.lockoutUntil = Date.now() + 15 * 60 * 1000;
            error = isArabic
              ? 'تم قفل الحساب لمدة 15 دقيقة بعد 5 محاولات تسجيل دخول غير صحيحة.'
              : 'Account locked for 15 minutes due to 5 consecutive failed login attempts.';
          } else {
            const left = 5 - user.failedAttempts;
            error = isArabic
              ? `البريد الإلكتروني أو كلمة المرور غير صحيحة. يتبقى لديك ${left} محاولات قبل قفل الحساب.`
              : `Incorrect email or password. You have ${left} attempt(s) remaining before account lockout.`;
          }
          saveUsers();
        } else {
          // Success
          user.failedAttempts = 0;
          user.lockoutUntil = null;
          user.lastLogin = new Date().toISOString();
          saveUsers();
        }
      }
    } else {
      // Mock fallback if user wasn't registered yet in local dev
      const pHash = hashPassword(password);
      user = {
        fullName: email.split('@')[0],
        email,
        mobile: '',
        organization: '',
        jobTitle: '',
        specialty: '',
        linkedIn: '',
        role: 'Attendee',
        passwordHash: pHash,
        passwordHistory: [pHash],
        failedAttempts: 0,
        lockoutUntil: null,
        lastLogin: new Date().toISOString(),
        passwordChangedDate: new Date().toISOString(),
        hasCompletedSurvey: false,
        surveyRoadmap: []
      };
      DEV_USERS[email] = user;
      saveUsers();
    }

    if (error) {
      const template = isArabic ? 'Ar_Sa/Login.aspx' : 'Login.aspx';
      const html = parseAspx(path.join(BASE_DIR, template), req.url, { errorAlert: error, formData: post });
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(html);
    }

    const redirectPath = isArabic ? '/Ar_Sa/Profile' : '/Profile';
    const cookieHeader = rememberMe
      ? `sairh_user=${encodeURIComponent(email)}; Path=/; Max-Age=2592000; HttpOnly`
      : `sairh_user=${encodeURIComponent(email)}; Path=/; HttpOnly`;
    res.writeHead(302, {
      'Set-Cookie': cookieHeader,
      'Location': redirectPath
    });
    return res.end();
  }

  // Profile POST (Edit Profile or Change Password)
  if (['profile', 'profile.aspx'].includes(page)) {
    if (!currentUser) {
      res.writeHead(302, { 'Location': isArabic ? '/Ar_Sa/Login' : '/Login' });
      return res.end();
    }

    const template = isArabic ? 'Ar_Sa/Profile.aspx' : 'Profile.aspx';

    // Update Profile Info
    if (post.BtnPudateProfile !== undefined || post.TxtEditFullName || post.TxtEditOrg !== undefined) {
      const name = (post.TxtEditFullName || '').trim();
      const mobile = (post.TxtEditMobile || '').trim();
      const org = (post.TxtEditOrg || '').trim();
      const jobTitle = (post.TxtEditJobTitle || '').trim();
      const specialty = (post.TxtEditSpecialty || '').trim();
      const linkedIn = (post.TxtEditLinkedIn || '').trim();

      if (name.length >= 3) {
        currentUser.fullName = name;
        currentUser.mobile = mobile;
        currentUser.organization = org;
        currentUser.jobTitle = jobTitle;
        currentUser.specialty = specialty;
        currentUser.linkedIn = linkedIn;
        DEV_USERS[currentUser.email.toLowerCase()] = currentUser;
        saveUsers();
      }
      const successMsg = isArabic ? 'تم تحديث البيانات المهنية والشخصية بنجاح!' : 'Your professional profile has been updated successfully!';
      const html = parseAspx(path.join(BASE_DIR, template), req.url, { user: currentUser, successAlert: successMsg });
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(html);
    }

    // Change Password
    if (post.BtnUpdate !== undefined || post.TxtPass) {
      const curPass = post.TxtPassCurrent || '';
      const newPass = post.TxtPass || '';
      const newPassRe = post.TxtPassRe || '';

      const errors = [];
      if (!curPass) {
        errors.push(isArabic ? 'يرجى إدخال كلمة المرور الحالية.' : 'Please enter your current password.');
      } else if (currentUser.passwordHash && !verifyPassword(curPass, currentUser.passwordHash)) {
        errors.push(isArabic ? 'كلمة المرور الحالية غير صحيحة.' : 'Your current password is incorrect.');
      }

      if (isPasswordInHistory(newPass, currentUser.passwordHistory)) {
        errors.push(isArabic ? 'لا يمكن إعادة استخدام أي من كلمات المرور الـ 3 الأخيرة الخاصة بك.' : 'You cannot reuse any of your last 3 passwords.');
      }

      const strErrors = validatePasswordStrength(newPass, currentUser.email, currentUser.fullName, isArabic);
      errors.push(...strErrors);

      if (newPass && newPass !== newPassRe) {
        errors.push(isArabic ? 'كلمتا المرور غير متطابقتين.' : 'The passwords do not match.');
      }

      if (errors.length > 0) {
        const html = parseAspx(path.join(BASE_DIR, template), req.url, { user: currentUser, errorAlert: renderErrorList(errors) });
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
      }

      // Update password hash and history
      const newHash = hashPassword(newPass);
      currentUser.passwordHash = newHash;
      if (!currentUser.passwordHistory) currentUser.passwordHistory = [];
      currentUser.passwordHistory.unshift(newHash);
      if (currentUser.passwordHistory.length > 5) currentUser.passwordHistory = currentUser.passwordHistory.slice(0, 5);
      currentUser.passwordChangedDate = new Date().toISOString();
      DEV_USERS[currentUser.email.toLowerCase()] = currentUser;
      saveUsers();

      const successMsg = isArabic ? 'تم تغيير كلمة المرور بنجاح!' : 'Your password has been changed successfully!';
      const html = parseAspx(path.join(BASE_DIR, template), req.url, { user: currentUser, successAlert: successMsg });
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(html);
    }
  }

  // Default POST fallback: re-render page
  handleGetRequest(req, res, pathname, currentUser);
}

function handleGetRequest(req, res, pathname, currentUser) {
  const isArabic = pathname.toLowerCase().startsWith('ar_sa');
  const sub = isArabic ? pathname.slice(5).replace(/^\/+/, '') : pathname;
  let aspxFile = null;

  if (isArabic) {
    if (sub.toLowerCase().startsWith('admin')) {
      const isAdmin = !!(currentUser && (currentUser.role === 'Administrator' || currentUser.role === 'Admin' || currentUser.isAdmin === true));
      if (!isAdmin) {
        res.writeHead(403, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(render403AccessDenied(true));
      }
      aspxFile = 'Ar_Sa/Admin/ManageSummit.aspx';
    }
    else if (!sub || ['default', 'default.aspx', 'home'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Default.aspx';
    else if (['publication', 'publication.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Publication.aspx';
    else if (['schedules', 'schedules.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Schedules.aspx';
    else if (['ceremony', 'ceremony.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Ceremony.aspx';
    else if (['judges', 'judges.aspx', 'speakers', 'speakers.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Speakers.aspx';
    else if (['sponsors', 'sponsors.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Sponsors.aspx';
    else if (['contactus', 'contactus.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/ContactUs.aspx';
    else if (['login', 'login.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Login.aspx';
    else if (['register', 'register.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Register.aspx';
    else if (['dashboard', 'dashboard.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Dashboard.aspx';
    else if (['survey', 'survey.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Survey.aspx';
    else if (['forgotpassword', 'forgotpassword.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/ForgotPassword.aspx';
    else if (['resetpassword', 'resetpassword.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/ResetPassword.aspx';
    else if (['boothvisit', 'boothvisit.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/BoothVisit.aspx';
    else if (['profile', 'profile.aspx'].includes(sub.toLowerCase())) {
      if (!currentUser) {
        res.writeHead(302, { 'Location': '/Ar_Sa/Login' });
        return res.end();
      }
      aspxFile = 'Ar_Sa/Profile.aspx';
    } else {
      const target = path.join(BASE_DIR, 'Ar_Sa', sub + '.aspx');
      if (fs.existsSync(target)) aspxFile = `Ar_Sa/${sub}.aspx`;
    }
  } else {
    if (pathname.toLowerCase().startsWith('admin')) {
      const isAdmin = !!(currentUser && (currentUser.role === 'Administrator' || currentUser.role === 'Admin' || currentUser.isAdmin === true));
      if (!isAdmin) {
        res.writeHead(403, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(render403AccessDenied(false));
      }
      aspxFile = 'Admin/ManageSummit.aspx';
    }
    else if (!pathname || ['default', 'default.aspx', 'home'].includes(pathname.toLowerCase())) aspxFile = 'Default.aspx';
    else if (['publication', 'publication.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Publication.aspx';
    else if (['schedules', 'schedules.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Schedules.aspx';
    else if (['ceremony', 'ceremony.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Ceremony.aspx';
    else if (['judges', 'judges.aspx', 'speakers', 'speakers.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Speakers.aspx';
    else if (['sponsors', 'sponsors.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Sponsors.aspx';
    else if (['contactus', 'contactus.aspx'].includes(pathname.toLowerCase())) aspxFile = 'ContactUs.aspx';
    else if (['login', 'login.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Login.aspx';
    else if (['register', 'register.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Register.aspx';
    else if (['dashboard', 'dashboard.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Dashboard.aspx';
    else if (['survey', 'survey.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Survey.aspx';
    else if (['forgotpassword', 'forgotpassword.aspx'].includes(pathname.toLowerCase())) aspxFile = 'ForgotPassword.aspx';
    else if (['resetpassword', 'resetpassword.aspx'].includes(pathname.toLowerCase())) aspxFile = 'ResetPassword.aspx';
    else if (['boothvisit', 'boothvisit.aspx'].includes(pathname.toLowerCase())) aspxFile = 'BoothVisit.aspx';
    else if (['profile', 'profile.aspx'].includes(pathname.toLowerCase())) {
      if (!currentUser) {
        res.writeHead(302, { 'Location': '/Login' });
        return res.end();
      }
      aspxFile = 'Profile.aspx';
    } else {
      const target = path.join(BASE_DIR, pathname + '.aspx');
      if (fs.existsSync(target)) aspxFile = `${pathname}.aspx`;
    }
  }

  if (aspxFile) {
    const full = path.join(BASE_DIR, aspxFile);
    let invTok = false;
    if (aspxFile.toLowerCase().includes('resetpassword')) {
      const parsedReq = url.parse(req.url, true);
      const tok = parsedReq.query.token;
      const tokenInfo = RESET_TOKENS[tok];
      if (!tokenInfo || tokenInfo.used || tokenInfo.expires < Date.now()) {
        invTok = true;
      }
    }
    const html = parseAspx(full, req.url, { user: currentUser, invalidToken: invTok });
    if (html) {
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(html);
    }
  }

  // Fallback 404
  res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
  res.end('404 - Not Found');
}

const httpsPort = 7198;
const httpPort = 52541;

if (require.main === module) {
  // Start HTTP Server
  http.createServer(handleRequest).listen(httpPort, '0.0.0.0', () => {
    console.log(`[*] SAIRH HTTP Server active on http://localhost:${httpPort}`);
  });

  // Start HTTPS Server
  const sslOptions = {
    key: fs.readFileSync(path.join(BASE_DIR, '.certs/key.pem')),
    cert: fs.readFileSync(path.join(BASE_DIR, '.certs/cert.pem'))
  };

  https.createServer(sslOptions, handleRequest).listen(httpsPort, '0.0.0.0', () => {
    console.log(`[*] SAIRH HTTPS Server active on https://localhost:${httpsPort}`);
  });

  console.log('==========================================================');
  console.log('  SAIRH - Saudi AI in Radiology Platform Node Server      ');
  console.log(`  HTTPS: https://localhost:${httpsPort}`);
  console.log(`  HTTP:  http://localhost:${httpPort}`);
  console.log('==========================================================');
}

module.exports = {
  ALL_BOOTHS,
  calculateRecommendations,
  getMapStatus,
  registerScan,
  hashPassword,
  verifyPassword,
  validatePasswordStrength,
  parseAspx,
  DEV_USERS,
  RESET_TOKENS,
  handleRequest
};
