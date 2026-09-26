/**
 * SAIRH - Saudi AI in Radiology Platform Local Server (Node.js)
 * Supports HTTPS on port 7198 and HTTP on port 52541.
 * Dynamically merges Master pages and ASPX templates, serves static assets.
 */

const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');
const url = require('url');

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
  '.mp4': 'video/mp4'
};

function parseAspx(aspxPath, relativeUrl) {
  if (!fs.existsSync(aspxPath)) return null;

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

  // ResolveUrl
  rendered = rendered.replace(/<%=\s*ResolveUrl\(["']~?\/([^"']+)["']\)\s*%>/g, '/$1');
  rendered = rendered.replace(/<%=\s*ResolveUrl\(["']([^"']+)["']\)\s*%>/g, '/$1');
  rendered = rendered.replace(/<%=\s*DateTime\.Now\.Year\.ToString\(\)\s*%>/g, '2026');

  // Remove ScriptManager & directives
  rendered = rendered.replace(/<%@[\s\S]*?%>/g, '');
  rendered = rendered.replace(/<asp:ScriptManager[^>]*><\/asp:ScriptManager>/gi, '');
  rendered = rendered.replace(/<asp:ScriptManager[^>]*\/>/gi, '');

  // Replace TextBox
  rendered = rendered.replace(/<asp:TextBox([^>]*)(?:\/>|>[\s\S]*?<\/asp:TextBox>)/gi, (m, attrs) => {
    const id = (attrs.match(/ID=["']([^"']+)["']/i) || [])[1] || '';
    const cls = (attrs.match(/CssClass=["']([^"']+)["']/i) || [])[1] || '';
    const ph = (attrs.match(/placeholder=["']([^"']+)["']/i) || [])[1] || '';
    const tm = ((attrs.match(/TextMode=["']([^"']+)["']/i) || [])[1] || '').toLowerCase();
    const rows = (attrs.match(/Rows=["']([^"']+)["']/i) || [])[1] || '3';

    if (tm === 'multiline') {
      return `<textarea name="${id}" id="${id}" class="${cls}" placeholder="${ph}" rows="${rows}"></textarea>`;
    } else if (tm === 'password') {
      return `<input type="password" name="${id}" id="${id}" class="${cls}" placeholder="${ph}" />`;
    }
    return `<input type="text" name="${id}" id="${id}" class="${cls}" placeholder="${ph}" />`;
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
    else if (id === 'BtnDashboard') pb = isAr ? '/Ar_Sa/Dashboard' : '/Dashboard';
    else if (id === 'BtnProfile') pb = isAr ? '/Ar_Sa/Profile' : '/Profile';
    else if (id === 'BtnSignOut') pb = isAr ? '/Ar_Sa/Login' : '/Login';

    return `<a href="${pb}" id="${id}" class="${cls}">${body}</a>`;
  });

  // Remove UpdatePanel
  rendered = rendered.replace(/<\/?asp:UpdatePanel[^>]*>/gi, '');
  rendered = rendered.replace(/<\/?ContentTemplate>/gi, '');

  // Dynamic active navigation highlight
  const reqLower = relativeUrl.toLowerCase();
  const isAr = reqLower.includes('/ar_sa');

  if (isAr) {
    if (reqLower.includes('publication')) rendered = rendered.replace('id="linkPublicationAr"', 'id="linkPublicationAr" class="active"');
    else if (reqLower.includes('schedules')) rendered = rendered.replace('id="linkSchedulesAr"', 'id="linkSchedulesAr" class="active"');
    else if (reqLower.includes('ceremony')) rendered = rendered.replace('id="linkCeremonyAr"', 'id="linkCeremonyAr" class="active"');
    else if (reqLower.includes('judges')) rendered = rendered.replace('id="linkJudgesAr"', 'id="linkJudgesAr" class="active"');
    else if (reqLower.includes('sponsors')) rendered = rendered.replace('id="linkSponsorsAr"', 'id="linkSponsorsAr" class="active"');
    else if (reqLower.includes('contactus')) rendered = rendered.replace('id="linkContactUsAr"', 'id="linkContactUsAr" class="active"');
    else rendered = rendered.replace('id="linkHomeAr"', 'id="linkHomeAr" class="active"');
  } else {
    if (reqLower.includes('publication')) rendered = rendered.replace('id="linkPublication"', 'id="linkPublication" class="active"');
    else if (reqLower.includes('schedules')) rendered = rendered.replace('id="linkSchedules"', 'id="linkSchedules" class="active"');
    else if (reqLower.includes('ceremony')) rendered = rendered.replace('id="linkCeremony"', 'id="linkCeremony" class="active"');
    else if (reqLower.includes('judges')) rendered = rendered.replace('id="linkJudges"', 'id="linkJudges" class="active"');
    else if (reqLower.includes('sponsors')) rendered = rendered.replace('id="linkSponsors"', 'id="linkSponsors" class="active"');
    else if (reqLower.includes('contactus')) rendered = rendered.replace('id="linkContactUs"', 'id="linkContactUs" class="active"');
    else rendered = rendered.replace('id="linkHome"', 'id="linkHome" class="active"');
  }

  rendered = rendered.replace(/href="~\/"/g, 'href="/"');
  rendered = rendered.replace(/href="~\/Ar_Sa\/"/gi, 'href="/Ar_Sa/"');

  return rendered;
}

function handleRequest(req, res) {
  const parsed = url.parse(req.url);
  let pathname = decodeURIComponent(parsed.pathname).replace(/^\/+/, '');

  // Enable CORS & no-cache
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');

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

  // Routing
  const isArabic = pathname.toLowerCase().startsWith('ar_sa');
  const sub = isArabic ? pathname.slice(5).replace(/^\/+/, '') : pathname;
  let aspxFile = null;

  if (isArabic) {
    if (!sub || ['default', 'default.aspx', 'home'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Default.aspx';
    else if (['publication', 'publication.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Publication.aspx';
    else if (['schedules', 'schedules.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Schedules.aspx';
    else if (['ceremony', 'ceremony.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Ceremony.aspx';
    else if (['judges', 'judges.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Judges.aspx';
    else if (['sponsors', 'sponsors.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Sponsors.aspx';
    else if (['contactus', 'contactus.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/ContactUs.aspx';
    else if (['login', 'login.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Login.aspx';
    else if (['dashboard', 'dashboard.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Dashboard.aspx';
    else if (['profile', 'profile.aspx'].includes(sub.toLowerCase())) aspxFile = 'Ar_Sa/Profile.aspx';
  } else {
    if (!pathname || ['default', 'default.aspx', 'home'].includes(pathname.toLowerCase())) aspxFile = 'Default.aspx';
    else if (['publication', 'publication.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Publication.aspx';
    else if (['schedules', 'schedules.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Schedules.aspx';
    else if (['ceremony', 'ceremony.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Ceremony.aspx';
    else if (['judges', 'judges.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Judges.aspx';
    else if (['sponsors', 'sponsors.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Sponsors.aspx';
    else if (['contactus', 'contactus.aspx'].includes(pathname.toLowerCase())) aspxFile = 'ContactUs.aspx';
    else if (['login', 'login.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Login.aspx';
    else if (['dashboard', 'dashboard.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Dashboard.aspx';
    else if (['profile', 'profile.aspx'].includes(pathname.toLowerCase())) aspxFile = 'Profile.aspx';
  }

  if (aspxFile) {
    const full = path.join(BASE_DIR, aspxFile);
    const html = parseAspx(full, req.url);
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
