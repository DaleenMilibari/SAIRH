#!/usr/bin/env python3
"""
SAIRH - Local Development Server & ASPX Engine
Supports HTTPS on port 7198 and HTTP on port 52541
Dynamically parses Master pages and ASPX pages, serves static assets,
and enables full interactive browsing on localhost.
"""

import os
import re
import ssl
import sys
import threading
from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import urlparse

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def parse_aspx(aspx_path, relative_url):
    """
    Parses an ASPX page, loads its master page if specified,
    merges Content into ContentPlaceHolders, resolves server tags,
    and returns complete rendered HTML.
    """
    if not os.path.exists(aspx_path):
        return None

    with open(aspx_path, 'r', encoding='utf-8', errors='ignore') as f:
        aspx_content = f.read()

    # Remove server-side comments <%-- ... --%>
    aspx_content = re.sub(r'<%--.*?--%>', '', aspx_content, flags=re.DOTALL)

    # Check for MasterPageFile
    master_match = re.search(r'MasterPageFile=["\']([^"\']+)["\']', aspx_content, re.IGNORECASE)
    
    if master_match:
        master_rel = master_match.group(1).replace('~/', '').replace('\\', '/')
        master_path = os.path.normpath(os.path.join(BASE_DIR, master_rel))
        
        if os.path.exists(master_path):
            with open(master_path, 'r', encoding='utf-8', errors='ignore') as mf:
                rendered = mf.read()
        else:
            rendered = aspx_content
    else:
        rendered = aspx_content

    # Remove comments from master page
    rendered = re.sub(r'<%--.*?--%>', '', rendered, flags=re.DOTALL)

    # Extract Content blocks from ASPX
    head_content = ""
    head_match = re.search(r'<asp:Content[^>]*ContentPlaceHolderID=["\']head["\'][^>]*>(.*?)</asp:Content>', aspx_content, flags=re.DOTALL | re.IGNORECASE)
    if head_match:
        head_content = head_match.group(1)

    main_content = ""
    main_match = re.search(r'<asp:Content[^>]*ContentPlaceHolderID=["\']ContentPlaceHolder1["\'][^>]*>(.*?)</asp:Content>', aspx_content, flags=re.DOTALL | re.IGNORECASE)
    if main_match:
        main_content = main_match.group(1)
    elif not master_match:
        main_content = aspx_content

    # Inject Content into Master Placeholders
    rendered = re.sub(r'<asp:ContentPlaceHolder[^>]*ID=["\']head["\'][^>]*>.*?</asp:ContentPlaceHolder>', lambda m: head_content, rendered, flags=re.DOTALL | re.IGNORECASE)
    rendered = re.sub(r'<asp:ContentPlaceHolder[^>]*ID=["\']ContentPlaceHolder1["\'][^>]*>.*?</asp:ContentPlaceHolder>', lambda m: main_content, rendered, flags=re.DOTALL | re.IGNORECASE)

    # Replace <%= ResolveUrl("~/path") %> or <%= ResolveUrl("path") %>
    rendered = re.sub(r'<%=\s*ResolveUrl\(["\']~?/([^"\']+)["\']\)\s*%>', r'/\1', rendered)
    rendered = re.sub(r'<%=\s*ResolveUrl\(["\']([^"\']+)["\']\)\s*%>', r'/\1', rendered)
    
    # Replace <%=DateTime... %> expressions
    from datetime import datetime as dt
    now_dt = dt.now()
    year_str = now_dt.strftime("%Y")
    today_iso = now_dt.strftime("%Y-%m-%d")
    rendered = re.sub(r'<%=\s*DateTime\.Now\.Year\.ToString\(\)\s*%>', year_str, rendered)
    rendered = re.sub(r'<%=\s*DateTime\.Today\.ToString\([^\)]*\)\s*%>', today_iso, rendered, flags=re.IGNORECASE)
    rendered = re.sub(r'<%=\s*DateTime\.Now\.ToString\([^\)]*\)\s*%>', today_iso, rendered, flags=re.IGNORECASE)
    rendered = re.sub(r'<%=\s*DateTime\.(?:Today|Now)(?:\.ToString\([^)]*\))?\s*%>', today_iso, rendered, flags=re.IGNORECASE)
    
    # Remove any remaining server tags <% ... %>
    rendered = re.sub(r'<%@[^%]*%>', '', rendered)
    rendered = re.sub(r'<asp:ScriptManager[^>]*></asp:ScriptManager>', '', rendered)
    rendered = re.sub(r'<asp:ScriptManager[^>]*/>', '', rendered)

    # Replace <asp:TextBox> with <input> or <textarea>
    def replace_textbox(match):
        attrs = match.group(1)
        css_class = ""
        placeholder = ""
        textmode = ""
        rows = "3"
        name = ""

        id_m = re.search(r'ID=["\']([^"\']+)["\']', attrs)
        if id_m: name = id_m.group(1)
        cls_m = re.search(r'CssClass=["\']([^"\']+)["\']', attrs)
        if cls_m: css_class = cls_m.group(1)
        ph_m = re.search(r'placeholder=["\']([^"\']+)["\']', attrs)
        if ph_m: placeholder = ph_m.group(1)
        tm_m = re.search(r'TextMode=["\']([^"\']+)["\']', attrs)
        if tm_m: textmode = tm_m.group(1).lower()
        rw_m = re.search(r'Rows=["\']([^"\']+)["\']', attrs)
        if rw_m: rows = rw_m.group(1)

        if textmode == 'multiline':
            return f'<textarea name="{name}" id="{name}" class="{css_class}" placeholder="{placeholder}" rows="{rows}"></textarea>'
        elif textmode == 'password':
            return f'<input type="password" name="{name}" id="{name}" class="{css_class}" placeholder="{placeholder}" />'
        else:
            return f'<input type="text" name="{name}" id="{name}" class="{css_class}" placeholder="{placeholder}" />'

    rendered = re.sub(r'<asp:TextBox([^>]*)(?:/>|>(?:.*?)</asp:TextBox>)', replace_textbox, rendered, flags=re.DOTALL | re.IGNORECASE)

    # Replace <asp:LinkButton> with <a>
    def replace_linkbutton(match):
        attrs = match.group(1)
        body = match.group(2)
        css_class = ""
        postback = "#"
        name = ""
        onclick = ""

        id_m = re.search(r'ID=["\']([^"\']+)["\']', attrs)
        if id_m: name = id_m.group(1)
        cls_m = re.search(r'CssClass=["\']([^"\']+)["\']', attrs)
        if cls_m: css_class = cls_m.group(1)
        pb_m = re.search(r'PostBackUrl=["\']([^"\']+)["\']', attrs)
        if pb_m: 
            postback = pb_m.group(1).replace('~/', '/')
        clk_m = re.search(r'OnClick=["\']([^"\']+)["\']', attrs)
        if clk_m: onclick = clk_m.group(1)

        # Handle language switch links
        if name == 'BtnToAr':
            postback = '/Ar_Sa/'
        elif name == 'BtnToEn':
            postback = '/'
        elif name == 'BtnDashboard':
            postback = '/Dashboard'
        elif name == 'BtnProfile':
            postback = '/Profile'
        elif name == 'BtnSignOut':
            postback = '/Login'

        return f'<a href="{postback}" id="{name}" class="{css_class}">{body}</a>'

    rendered = re.sub(r'<asp:LinkButton([^>]*)>(.*?)</asp:LinkButton>', replace_linkbutton, rendered, flags=re.DOTALL | re.IGNORECASE)

    # Convert <asp:UpdatePanel> and <ContentTemplate> to simple divs
    rendered = re.sub(r'</?asp:UpdatePanel[^>]*>', '', rendered, flags=re.IGNORECASE)
    rendered = re.sub(r'</?ContentTemplate>', '', rendered, flags=re.IGNORECASE)

    # Set active navigation state dynamically based on requested URL
    req_lower = relative_url.lower()
    is_ar = '/ar_sa' in req_lower

    if is_ar:
        if 'publication' in req_lower:
            rendered = rendered.replace('id="linkPublicationAr"', 'id="linkPublicationAr" class="active"')
        elif 'schedules' in req_lower:
            rendered = rendered.replace('id="linkSchedulesAr"', 'id="linkSchedulesAr" class="active"')
        elif 'ceremony' in req_lower:
            rendered = rendered.replace('id="linkCeremonyAr"', 'id="linkCeremonyAr" class="active"')
        elif 'judges' in req_lower or 'speaker' in req_lower:
            rendered = rendered.replace('id="linkJudgesAr"', 'id="linkJudgesAr" class="active"')
        elif 'sponsors' in req_lower:
            rendered = rendered.replace('id="linkSponsorsAr"', 'id="linkSponsorsAr" class="active"')
        elif 'contactus' in req_lower:
            rendered = rendered.replace('id="linkContactUsAr"', 'id="linkContactUsAr" class="active"')
        else:
            rendered = rendered.replace('id="linkHomeAr"', 'id="linkHomeAr" class="active"')
    else:
        if 'publication' in req_lower:
            rendered = rendered.replace('id="linkPublication"', 'id="linkPublication" class="active"')
        elif 'schedules' in req_lower:
            rendered = rendered.replace('id="linkSchedules"', 'id="linkSchedules" class="active"')
        elif 'ceremony' in req_lower:
            rendered = rendered.replace('id="linkCeremony"', 'id="linkCeremony" class="active"')
        elif 'judges' in req_lower or 'speaker' in req_lower:
            rendered = rendered.replace('id="linkJudges"', 'id="linkJudges" class="active"')
        elif 'sponsors' in req_lower:
            rendered = rendered.replace('id="linkSponsors"', 'id="linkSponsors" class="active"')
        elif 'contactus' in req_lower:
            rendered = rendered.replace('id="linkContactUs"', 'id="linkContactUs" class="active"')
        else:
            rendered = rendered.replace('id="linkHome"', 'id="linkHome" class="active"')

    # Fix relative paths for ~/ or href links
    rendered = rendered.replace('href="~/"', 'href="/"')
    rendered = rendered.replace('href="~/Ar_Sa/"', 'href="/Ar_Sa/"')
    rendered = rendered.replace('href="~/Ar_sa/"', 'href="/Ar_Sa/"')

    return rendered


class SairhRequestHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=BASE_DIR, **kwargs)

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path.strip('/')

        # Normalize paths
        is_arabic = path.lower().startswith('ar_sa')
        subpath = path[5:].strip('/') if is_arabic else path

        # Check if requesting static assets (including relative to Ar_Sa)
        static_path = path
        if static_path.lower().startswith('ar_sa/content/'):
            static_path = static_path[6:]
        elif static_path.lower().startswith('ar_sa/scripts/'):
            static_path = static_path[6:]

        if static_path.startswith('Content/') or static_path.startswith('Scripts/') or any(static_path.lower().endswith(ext) for ext in ['.css', '.js', '.png', '.jpg', '.jpeg', '.svg', '.woff', '.woff2', '.ttf', '.ico', '.mp4', '.pdf']):
            self.path = '/' + static_path
            return super().do_GET()

        # Route matching to ASPX files
        if is_arabic:
            if not subpath or subpath.lower() in ['default', 'default.aspx', 'home']:
                aspx_file = 'Ar_Sa/Default.aspx'
            elif subpath.lower() in ['publication', 'publication.aspx']:
                aspx_file = 'Ar_Sa/Publication.aspx'
            elif subpath.lower() in ['schedules', 'schedules.aspx']:
                aspx_file = 'Ar_Sa/Schedules.aspx'
            elif subpath.lower() in ['ceremony', 'ceremony.aspx']:
                aspx_file = 'Ar_Sa/Ceremony.aspx'
            elif subpath.lower() in ['judges', 'judges.aspx', 'speakers', 'speakers.aspx']:
                aspx_file = 'Ar_Sa/Judges.aspx'
            elif subpath.lower() in ['sponsors', 'sponsors.aspx']:
                aspx_file = 'Ar_Sa/Sponsors.aspx'
            elif subpath.lower() in ['contactus', 'contactus.aspx']:
                aspx_file = 'Ar_Sa/ContactUs.aspx'
            elif subpath.lower() in ['login', 'login.aspx']:
                aspx_file = 'Ar_Sa/Login.aspx'
            elif subpath.lower() in ['profile', 'profile.aspx']:
                aspx_file = 'Ar_Sa/Profile.aspx'
            elif subpath.lower() in ['dashboard', 'dashboard.aspx']:
                aspx_file = 'Ar_Sa/Dashboard.aspx'
            else:
                target = os.path.join(BASE_DIR, 'Ar_Sa', subpath + '.aspx')
                aspx_file = f'Ar_Sa/{subpath}.aspx' if os.path.exists(target) else None
        else:
            if not path or path.lower() in ['default', 'default.aspx', 'home']:
                aspx_file = 'Default.aspx'
            elif path.lower() in ['publication', 'publication.aspx']:
                aspx_file = 'Publication.aspx'
            elif path.lower() in ['schedules', 'schedules.aspx']:
                aspx_file = 'Schedules.aspx'
            elif path.lower() in ['ceremony', 'ceremony.aspx']:
                aspx_file = 'Ceremony.aspx'
            elif path.lower() in ['judges', 'judges.aspx', 'speakers', 'speakers.aspx']:
                aspx_file = 'Judges.aspx'
            elif path.lower() in ['sponsors', 'sponsors.aspx']:
                aspx_file = 'Sponsors.aspx'
            elif path.lower() in ['contactus', 'contactus.aspx']:
                aspx_file = 'ContactUs.aspx'
            elif path.lower() in ['login', 'login.aspx']:
                aspx_file = 'Login.aspx'
            elif path.lower() in ['profile', 'profile.aspx']:
                aspx_file = 'Profile.aspx'
            elif path.lower() in ['dashboard', 'dashboard.aspx']:
                aspx_file = 'Dashboard.aspx'
            else:
                target = os.path.join(BASE_DIR, path + '.aspx')
                aspx_file = f'{path}.aspx' if os.path.exists(target) else None

        if aspx_file:
            full_path = os.path.join(BASE_DIR, aspx_file)
            html = parse_aspx(full_path, parsed.path)
            if html:
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                encoded = html.encode('utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

        # Fallback to standard file handler
        return super().do_GET()

    def end_headers(self):
        # Enable CORS and caching headers for local testing
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        super().end_headers()


def run_https(port=7198):
    cert_file = os.path.join(BASE_DIR, '.certs', 'cert.pem')
    key_file = os.path.join(BASE_DIR, '.certs', 'key.pem')
    
    server_address = ('0.0.0.0', port)
    httpd = HTTPServer(server_address, SairhRequestHandler)
    
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain(certfile=cert_file, keyfile=key_file)
    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
    
    print(f"[*] SAIRH HTTPS Server active on https://localhost:{port}")
    httpd.serve_forever()


def run_http(port=52541):
    server_address = ('0.0.0.0', port)
    httpd = HTTPServer(server_address, SairhRequestHandler)
    print(f"[*] SAIRH HTTP Server active on http://localhost:{port}")
    httpd.serve_forever()


if __name__ == '__main__':
    https_port = 7198
    http_port = 52541

    print("==========================================================")
    print("  SAIRH - Saudi AI in Radiology Platform Local Server    ")
    print(f"  HTTPS: https://localhost:{https_port}")
    print(f"  HTTP:  http://localhost:{http_port}")
    print("==========================================================")

    # Start HTTP server in a background thread
    http_thread = threading.Thread(target=run_http, args=(http_port,), daemon=True)
    http_thread.start()

    # Start HTTPS server on main thread
    run_https(https_port)
