#!/usr/bin/env python3
"""
SAIRH - Local Development Server & ASPX Engine
Supports HTTPS on port 7198 and HTTP on port 52541
Dynamically parses Master pages and ASPX pages, serves static assets,
and provides full interactive mock authentication (Register, Login, Profile).
"""

import base64
import hashlib
import hmac
import html as html_lib
import json
import os
import re
import secrets
import ssl
import sys
import threading
from http.cookies import SimpleCookie
from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import parse_qs, urlparse

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
USERS_FILE = os.path.join(BASE_DIR, 'mock_users.json')

DEV_USERS = {}
try:
    if os.path.exists(USERS_FILE):
        with open(USERS_FILE, 'r', encoding='utf-8') as f:
            DEV_USERS = json.load(f)
except Exception:
    DEV_USERS = {}


def save_users():
    try:
        with open(USERS_FILE, 'w', encoding='utf-8') as f:
            json.dump(DEV_USERS, f, ensure_ascii=False, indent=2)
    except Exception as e:
        print(f"Error saving users file: {e}")


COMMON_PASSWORDS = {
    'password', 'password1', 'password12', 'password123', 'password1234', 'passw0rd', 'p@ssw0rd',
    '12345678', '123456789', '1234567890', '87654321', '11111111', '00000000', '12341234',
    'qwertyui', 'qwerty12', 'qwerty123', 'qwertyuiop', 'admin123', 'admin@123', 'welcome123',
    'sairh2026', 'sairh123', 'sairh@2026', 'sairh2026!', 'radiology', 'radiology1', 'radiology2026'
}

# -----------------------------------------------------------------------------
# Exhibition Floor Booths & Balanced Recommendation Engine (SAIRH.SiteMap & Survey)
# -----------------------------------------------------------------------------
ALL_BOOTHS = []
BOOTH_COOLDOWNS = {}
USER_VISITS = {}
RESET_TOKENS = {}

def _init_booths():
    global ALL_BOOTHS
    sponsors = [
        {"code": "S1", "nameEn": "Sponsor Booth S1", "nameAr": "جناح الراعي S1", "orgEn": "AI Imaging Sponsor", "orgAr": "راعي الذكاء الاصطناعي والتصوير", "catEn": ["AI & Digital Technology", "Medical Imaging & Radiology", "AI Companies", "New Technology"], "catAr": ["الذكاء الاصطناعي والتقنية الرقمية", "التصوير الطبي والأشعة", "شركات الذكاء الاصطناعي", "تقنيات جديدة"], "x": 755, "y": 195},
        {"code": "S2", "nameEn": "Sponsor Booth S2", "nameAr": "جناح الراعي S2", "orgEn": "Radiology Technology Sponsor", "orgAr": "راعي تقنيات الأشعة", "catEn": ["Medical Imaging & Radiology", "Healthcare Technology", "Medical Imaging Companies", "Products"], "catAr": ["التصوير الطبي والأشعة", "تقنية الرعاية الصحية", "شركات التصوير الطبي", "منتجات وخدمات"], "x": 755, "y": 235},
        {"code": "S3", "nameEn": "Sponsor Booth S3", "nameAr": "جناح الراعي S3", "orgEn": "Healthcare Innovation Sponsor", "orgAr": "راعي الابتكار الصحي", "catEn": ["Health Innovation", "Healthcare Technology", "Healthcare Organizations", "Healthcare Solutions"], "catAr": ["الابتكار الصحي", "تقنية الرعاية الصحية", "المنظمات الصحية", "حلول الرعاية الصحية"], "x": 755, "y": 275},
        {"code": "S4", "nameEn": "Sponsor Booth S4", "nameAr": "جناح الراعي S4", "orgEn": "AI Solutions Sponsor", "orgAr": "راعي حلول الذكاء الاصطناعي", "catEn": ["AI & Digital Technology", "AI Companies", "Healthcare Technology", "New Technology"], "catAr": ["الذكاء الاصطناعي والتقنية الرقمية", "شركات الذكاء الاصطناعي", "تقنية الرعاية الصحية", "تقنيات جديدة"], "x": 755, "y": 315},
        {"code": "S5", "nameEn": "Sponsor Booth S5", "nameAr": "جناح الراعي S5", "orgEn": "Medical Imaging Sponsor", "orgAr": "راعي التصوير الطبي", "catEn": ["Medical Imaging & Radiology", "Medical Imaging Companies", "Products", "New Technology"], "catAr": ["التصوير الطبي والأشعة", "شركات التصوير الطبي", "منتجات وخدمات", "تقنيات جديدة"], "x": 755, "y": 355},
        {"code": "S6", "nameEn": "Sponsor Booth S6", "nameAr": "جناح الراعي S6", "orgEn": "University Partner", "orgAr": "الشريك الأكاديمي والجامعي", "catEn": ["Research & Education", "Universities & Colleges", "Research", "Networking"], "catAr": ["البحث والتعليم", "الجامعات والكليات", "أبحاث سريرية", "تواصل مهني"], "x": 755, "y": 395},
        {"code": "S7", "nameEn": "Sponsor Booth S7", "nameAr": "جناح الراعي S7", "orgEn": "Health Organization Partner", "orgAr": "شريك المنظمات الصحية", "catEn": ["Health Innovation", "Healthcare Organizations", "Healthcare Solutions", "Networking"], "catAr": ["الابتكار الصحي", "المنظمات الصحية", "حلول الرعاية الصحية", "تواصل مهني"], "x": 755, "y": 435},
        {"code": "S8", "nameEn": "Sponsor Booth S8", "nameAr": "جناح الراعي S8", "orgEn": "Medical Technology Sponsor", "orgAr": "راعي التقنيات الطبية المتقدمة", "catEn": ["Healthcare Technology", "Medical Imaging & Radiology", "Medical Imaging Companies", "Products"], "catAr": ["تقنية الرعاية الصحية", "التصوير الطبي والأشعة", "شركات التصوير الطبي", "منتجات وخدمات"], "x": 920, "y": 115},
        {"code": "S9", "nameEn": "Sponsor Booth S9", "nameAr": "جناح الراعي S9", "orgEn": "AI Healthcare Sponsor", "orgAr": "راعي الذكاء الاصطناعي الصحي", "catEn": ["AI & Digital Technology", "Health Innovation", "AI Companies", "Healthcare Solutions"], "catAr": ["الذكاء الاصطناعي والتقنية الرقمية", "الابتكار الصحي", "شركات الذكاء الاصطناعي", "حلول الرعاية الصحية"], "x": 920, "y": 155},
        {"code": "S10", "nameEn": "Sponsor Booth S10", "nameAr": "جناح الراعي S10", "orgEn": "Startup Sponsor", "orgAr": "راعي الشركات الناشئة والريادة", "catEn": ["Startups & Innovation", "Startups", "Innovation", "Networking"], "catAr": ["الشركات الناشئة والابتكار", "الشركات الناشئة", "ابتكار وتقنيات واعدة", "تواصل مهني"], "x": 920, "y": 195},
        {"code": "S11", "nameEn": "Sponsor Booth S11", "nameAr": "جناح الراعي S11", "orgEn": "Digital Health Sponsor", "orgAr": "راعي الصحة الرقمية", "catEn": ["AI & Digital Technology", "Health Innovation", "Healthcare Technology", "New Technology"], "catAr": ["الذكاء الاصطناعي والتقنية الرقمية", "الابتكار الصحي", "تقنية الرعاية الصحية", "تقنيات جديدة"], "x": 920, "y": 235},
        {"code": "S12", "nameEn": "Sponsor Booth S12", "nameAr": "جناح الراعي S12", "orgEn": "Research Partner", "orgAr": "الشريك البحثي الوطني", "catEn": ["Research & Education", "Universities & Colleges", "Research", "Networking"], "catAr": ["البحث والتعليم", "الجامعات والكليات", "أبحاث سريرية", "تواصل مهني"], "x": 920, "y": 275},
        {"code": "S13", "nameEn": "Sponsor Booth S13", "nameAr": "جناح الراعي S13", "orgEn": "Clinical Technology Sponsor", "orgAr": "راعي التقنيات السريرية", "catEn": ["Medical Imaging & Radiology", "Healthcare Organizations", "Healthcare Solutions", "Products"], "catAr": ["التصوير الطبي والأشعة", "المنظمات الصحية", "حلول الرعاية الصحية", "منتجات وخدمات"], "x": 920, "y": 315},
        {"code": "S14", "nameEn": "Sponsor Booth S14", "nameAr": "جناح الراعي S14", "orgEn": "Innovation Sponsor", "orgAr": "راعي الابتكار المستقبلي", "catEn": ["Startups & Innovation", "Health Innovation", "Innovation", "New Technology"], "catAr": ["الشركات الناشئة والابتكار", "الابتكار الصحي", "ابتكار وتقنيات واعدة", "تقنيات جديدة"], "x": 920, "y": 355},
        {"code": "S15", "nameEn": "Sponsor Booth S15", "nameAr": "جناح الراعي S15", "orgEn": "AI Research Sponsor", "orgAr": "راعي أبحاث الذكاء الاصطناعي", "catEn": ["AI & Digital Technology", "Research & Education", "AI Companies", "Research"], "catAr": ["الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "شركات الذكاء الاصطناعي", "أبحاث سريرية"], "x": 920, "y": 395},
    ]

    for idx, s in enumerate(sponsors, start=1):
        ALL_BOOTHS.append({
            "id": idx,
            "boothCode": s["code"],
            "nameEn": s["nameEn"],
            "nameAr": s["nameAr"],
            "organizationEn": s["orgEn"],
            "organizationAr": s["orgAr"],
            "type": "SponsorBooth",
            "hallEn": "Sponsor Hall",
            "hallAr": "قاعة الرعاة والشركاء",
            "categoriesEn": s["catEn"],
            "categoriesAr": s["catAr"],
            "x": s["x"],
            "y": s["y"]
        })

    res_cat_en = [
        ["AI & Digital Technology", "Research & Education", "Research Displays", "Research"],
        ["Medical Imaging & Radiology", "Research & Education", "Research Displays", "Research"],
        ["Health Innovation", "Research & Education", "Research Displays", "Research"],
        ["AI & Digital Technology", "Medical Imaging & Radiology", "Research Displays", "New Technology"],
        ["Healthcare Technology", "Health Innovation", "Research Displays", "Healthcare Solutions"],
        ["AI & Digital Technology", "Research & Education", "Research Displays", "New Technology"]
    ]
    res_cat_ar = [
        ["الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية"],
        ["التصوير الطبي والأشعة", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية"],
        ["الابتكار الصحي", "البحث والتعليم", "منصات عرض الأبحاث", "أبحاث سريرية"],
        ["الذكاء الاصطناعي والتقنية الرقمية", "التصوير الطبي والأشعة", "منصات عرض الأبحاث", "تقنيات جديدة"],
        ["تقنية الرعاية الصحية", "الابتكار الصحي", "منصات عرض الأبحاث", "حلول الرعاية الصحية"],
        ["الذكاء الاصطناعي والتقنية الرقمية", "البحث والتعليم", "منصات عرض الأبحاث", "تقنيات جديدة"]
    ]

    for i in range(1, 31):
        if i <= 12:
            x = 90 + (i - 1) * 50
            y = 35
        elif i <= 18:
            x = 35
            y = 70 + (i - 13) * 28
        else:
            x = 90 + (i - 19) * 50
            y = 220

        cat_idx = (i - 1) % 6
        ALL_BOOTHS.append({
            "id": 15 + i,
            "boothCode": f"R{i}",
            "nameEn": f"Research Display R{i}",
            "nameAr": f"شاشة عرض أبحاث R{i}",
            "organizationEn": f"Academic & Clinical Research {i}",
            "organizationAr": f"الأبحاث الأكاديمية والسريرية {i}",
            "type": "ResearchScreen",
            "hallEn": "Research Screen Hall",
            "hallAr": "قاعة شاشات الأبحاث",
            "categoriesEn": res_cat_en[cat_idx],
            "categoriesAr": res_cat_ar[cat_idx],
            "x": x,
            "y": y
        })

_init_booths()

def calculate_recommendations(interests, booth_types, goals, booth_count=5):
    interests_set = {str(s).strip().lower() for s in (interests or [])}
    types_set = {str(s).strip().lower() for s in (booth_types or [])}
    goals_set = {str(s).strip().lower() for s in (goals or [])}
    if booth_count <= 0:
        booth_count = 5

    scored = []
    for b in ALL_BOOTHS:
        item = dict(b)
        score = 0
        cat_en = [c.lower() for c in item['categoriesEn']]
        score += sum(3 for c in cat_en if c in interests_set)
        score += sum(2 for c in cat_en if c in types_set)
        score += sum(1 for c in cat_en if c in goals_set)

        if item['type'] == 'ResearchScreen':
            if any('research' in t for t in types_set):
                score += 5
            if any('research' in i for i in interests_set):
                score += 3
            if any('research' in g for g in goals_set):
                score += 3

        item['matchScore'] = score
        scored.append(item)

    matching_sponsors = sorted([b for b in scored if b['type'] == 'SponsorBooth' and b['matchScore'] > 0], key=lambda x: (-x['matchScore'], x['id']))
    matching_research = sorted([b for b in scored if b['type'] == 'ResearchScreen' and b['matchScore'] > 0], key=lambda x: (-x['matchScore'], x['id']))

    recommended = []
    if booth_count >= 2 and matching_sponsors and matching_research:
        recommended.append(matching_sponsors[0])
        recommended.append(matching_research[0])
    elif booth_count == 1:
        best = sorted([b for b in scored if b['matchScore'] > 0], key=lambda x: -x['matchScore'])
        if best:
            recommended.append(best[0])

    rec_codes = {r['boothCode'] for r in recommended}
    remaining = sorted([b for b in scored if b['matchScore'] > 0 and b['boothCode'] not in rec_codes],
                       key=lambda x: (-x['matchScore'], 0 if x['type'] == 'ResearchScreen' else 1, x['id']))
    for b in remaining:
        if len(recommended) >= booth_count:
            break
        recommended.append(b)
        rec_codes.add(b['boothCode'])

    if len(recommended) < booth_count:
        fallbacks = sorted([b for b in scored if b['boothCode'] not in rec_codes],
                           key=lambda x: (-x['matchScore'], 0 if x['type'] == 'ResearchScreen' else 1, x['id']))
        for b in fallbacks:
            if len(recommended) >= booth_count:
                break
            recommended.append(b)
            rec_codes.add(b['boothCode'])

    return sorted(recommended, key=lambda x: -x['matchScore'])

import time

def get_map_status(email, is_arabic=False):
    email = (email or '').strip().lower()
    user_roadmap = []
    if email and email in DEV_USERS:
        user_roadmap = DEV_USERS[email].get('surveyRoadmap', [])
    roadmap_set = set(user_roadmap)

    visited_set = set()
    if email:
        if email in USER_VISITS:
            visited_set = USER_VISITS[email]
        elif email in DEV_USERS:
            visited_set = set(DEV_USERS[email].get('visitedBooths', []))

    now_ts = time.time()
    result = []
    for b in ALL_BOOTHS:
        code = b['boothCode']
        last_scanned = BOOTH_COOLDOWNS.get(code, 0)
        elapsed = now_ts - last_scanned
        is_busy = elapsed < 300
        remaining = int(300 - elapsed) if is_busy else 0

        name = b['nameAr'] if is_arabic else b['nameEn']
        org = b['organizationAr'] if is_arabic else b['organizationEn']
        hall = b['hallAr'] if is_arabic else b['hallEn']
        cats = b['categoriesAr'] if is_arabic else b['categoriesEn']

        result.append({
            'boothCode': code,
            'name': name,
            'organization': org,
            'type': b['type'],
            'hall': hall,
            'categories': cats,
            'status': 1 if is_busy else 0,
            'isVisitedByCurrentUser': code in visited_set,
            'isRecommended': code in roadmap_set,
            'remainingBusySeconds': remaining
        })
    return result

def register_scan(booth_code, email=None):
    booth_code = (booth_code or '').strip().upper()
    if not booth_code:
        return
    BOOTH_COOLDOWNS[booth_code] = time.time()
    if email:
        email = email.strip().lower()
        if email not in USER_VISITS:
            USER_VISITS[email] = set()
        USER_VISITS[email].add(booth_code)
        if email in DEV_USERS:
            visited = set(DEV_USERS[email].get('visitedBooths', []))
            visited.add(booth_code)
            DEV_USERS[email]['visitedBooths'] = list(visited)
            save_users()


def hash_password(password):
    salt = secrets.token_bytes(16)
    iterations = 210000
    derived = hashlib.pbkdf2_hmac('sha512', password.encode('utf-8'), salt, iterations, dklen=32)
    salt_b64 = base64.b64encode(salt).decode('ascii')
    hash_b64 = base64.b64encode(derived).decode('ascii')
    return f"PBKDF2-SHA512${iterations}${salt_b64}${hash_b64}"


def verify_password(password, stored_hash):
    if not password or not stored_hash:
        return False
    parts = stored_hash.split('$')
    if len(parts) != 4 or parts[0] != 'PBKDF2-SHA512':
        return False
    try:
        iterations = int(parts[1])
        if iterations < 1:
            return False
        salt = base64.b64decode(parts[2].encode('ascii'))
        expected = base64.b64decode(parts[3].encode('ascii'))
        actual = hashlib.pbkdf2_hmac('sha512', password.encode('utf-8'), salt, iterations, dklen=len(expected))
        return hmac.compare_digest(actual, expected)
    except Exception:
        return False


def has_sequential_run(s, min_length=4):
    if not s or len(s) < min_length:
        return False
    asc_count = 1
    desc_count = 1
    for i in range(1, len(s)):
        prev = ord(s[i - 1])
        curr = ord(s[i])
        def is_alnum(c):
            return (48 <= c <= 57) or (65 <= c <= 90) or (97 <= c <= 122)
        if is_alnum(prev) and is_alnum(curr):
            if curr == prev + 1:
                asc_count += 1
                if asc_count >= min_length:
                    return True
            else:
                asc_count = 1
            if curr == prev - 1:
                desc_count += 1
                if desc_count >= min_length:
                    return True
            else:
                desc_count = 1
        else:
            asc_count = 1
            desc_count = 1
    return False


def validate_password_strength(password, email=None, full_name=None, is_arabic=False):
    errors = []
    if not password:
        errors.append('يرجى إدخال كلمة المرور.' if is_arabic else 'Please enter a password.')
        return errors

    if len(password) < 8:
        errors.append('يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.' if is_arabic else 'Password must be at least 8 characters long.')
    if len(password) > 128:
        errors.append('يجب ألا تتجاوز كلمة المرور 128 حرفاً.' if is_arabic else 'Password must be 128 characters or fewer.')
    if not re.search(r'[A-Z]', password):
        errors.append('يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل (A-Z).' if is_arabic else 'Password must contain at least one uppercase letter (A-Z).')
    if not re.search(r'[a-z]', password):
        errors.append('يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل (a-z).' if is_arabic else 'Password must contain at least one lowercase letter (a-z).')
    if not re.search(r'[0-9]', password):
        errors.append('يجب أن تحتوي كلمة المرور على رقم واحد على الأقل (0-9).' if is_arabic else 'Password must contain at least one number (0-9).')
    if not re.search(r'[^A-Za-z0-9]', password):
        errors.append('يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل (!@#$%^&*...).' if is_arabic else 'Password must contain at least one special symbol (!@#$%^&*...).')
    if re.search(r'(.)\1{3,}', password):
        errors.append('يجب ألا تحتوي كلمة المرور على أحرف مكررة متتالية (مثل aaaa أو 1111).' if is_arabic else 'Password must not contain repeated characters (e.g. aaaa or 1111).')
    if has_sequential_run(password, 4):
        errors.append('يجب ألا تحتوي كلمة المرور على تسلسلات متتالية سهلة التخمين (مثل 1234 أو abcd).' if is_arabic else 'Password must not contain predictable sequences (e.g. 1234 or abcd).')

    if password.lower() in COMMON_PASSWORDS:
        errors.append('كلمة المرور هذه شائعة أو سهلة التخمين. يرجى اختيار كلمة مرور أقوى.' if is_arabic else 'This password is too common or easy to guess. Please choose a stronger one.')

    if email:
        local = email.split('@')[0]
        if local and len(local) >= 3 and local.lower() in password.lower():
            errors.append('يجب ألا تحتوي كلمة المرور على اسم بريدك الإلكتروني.' if is_arabic else 'Password must not contain your email username.')

    if full_name:
        parts = re.split(r'[\s\-_]+', full_name)
        for p in parts:
            if len(p) >= 3 and p.lower() in password.lower():
                errors.append('يجب ألا تحتوي كلمة المرور على أجزاء من اسمك.' if is_arabic else 'Password must not contain parts of your name.')
                break

    return errors


def render_error_list(errors):
    if len(errors) == 1:
        return html_lib.escape(errors[0])
    items = ''.join(f'<li>{html_lib.escape(e)}</li>' for e in errors)
    return f'<ul class="auth-alert-list">{items}</ul>'


def get_db_connection_params():
    web_config = os.path.join(BASE_DIR, 'Web.config')
    if not os.path.exists(web_config):
        return None
    try:
        with open(web_config, 'r', encoding='utf-8') as f:
            content = f.read()
        match = re.search(r'name=["\']AIEConnectionString["\']\s+connectionString=["\']([^"\']+)["\']', content)
        if not match:
            return None
        conn_str = match.group(1)
        params = {}
        for part in conn_str.split(';'):
            if '=' in part:
                k, v = part.split('=', 1)
                params[k.strip().lower()] = v.strip()
        return params
    except Exception:
        return None


def fetch_speakers_from_database(params):
    host = params.get('server') or params.get('data source') or 'localhost'
    port = 1433
    if ',' in host:
        host, p = host.split(',', 1)
        try: port = int(p.strip())
        except ValueError: pass
    elif ':' in host:
        host, p = host.split(':', 1)
        try: port = int(p.strip())
        except ValueError: pass

    db = params.get('database') or params.get('initial catalog') or 'SAIRH'
    user = params.get('user id') or params.get('uid') or ''
    pwd = params.get('password') or params.get('pwd') or ''

    # 1. Try pymssql
    try:
        import pymssql
        conn = pymssql.connect(server=host, port=port, user=user, password=pwd, database=db, timeout=4)
        cursor = conn.cursor(as_dict=True)
        cursor.execute("""
            IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL
                SELECT * FROM [dbo].[vw_SummitSpeakers] ORDER BY [Sorting] ASC, [SpeakerID] ASC
            ELSE
                SELECT * FROM [dbo].[Speakers] WHERE [IsActive] = 1 ORDER BY [Sorting] ASC, [SpeakerID] ASC
        """)
        rows = cursor.fetchall()
        conn.close()
        if rows:
            return rows, f"SQL Server database '{db}' via pymssql", None
        return None, None, f"Query executed successfully, but found 0 active speakers ([IsActive] = 1) in database '{db}'"
    except ImportError:
        pass
    except Exception as e:
        return None, None, f"pymssql connection error to {host}:{port}: {e}"

    # 2. Try pyodbc
    try:
        import pyodbc
        conn_str = f"DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={host},{port};DATABASE={db};UID={user};PWD={pwd};TrustServerCertificate=yes;"
        conn = pyodbc.connect(conn_str, timeout=4)
        cursor = conn.cursor()
        cursor.execute("""
            IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL
                SELECT * FROM [dbo].[vw_SummitSpeakers] ORDER BY [Sorting] ASC, [SpeakerID] ASC
            ELSE
                SELECT * FROM [dbo].[Speakers] WHERE [IsActive] = 1 ORDER BY [Sorting] ASC, [SpeakerID] ASC
        """)
        cols = [c[0] for c in cursor.description]
        rows = [dict(zip(cols, r)) for r in cursor.fetchall()]
        conn.close()
        if rows:
            return rows, f"SQL Server database '{db}' via pyodbc", None
        return None, None, f"Query executed successfully, but found 0 active speakers ([IsActive] = 1) in database '{db}'"
    except ImportError:
        pass
    except Exception as e:
        return None, None, f"pyodbc connection error to {host}:{port}: {e}"

    return None, None, "Neither 'pymssql' nor 'pyodbc' is installed in Python."


def get_speakers_dataset():
    params = get_db_connection_params()
    db_err = None
    if params:
        rows, source, err = fetch_speakers_from_database(params)
        if rows:
            print(f"[SAIRH DB] Loaded {len(rows)} speakers LIVE from {source}")
            return rows, source, None
        db_err = err
    else:
        db_err = "No database connection string configured in Web.config"

    # Fallback to JSON
    json_path = os.path.join(BASE_DIR, 'Content', 'data', 'speakers.json')
    if os.path.exists(json_path):
        try:
            with open(json_path, 'r', encoding='utf-8') as f:
                sp_list = json.load(f)
            print(f"[SAIRH Fallback] Loaded {len(sp_list)} speakers from Content/data/speakers.json (DB reason: {db_err})")
            return sp_list, 'static speakers.json cache', db_err
        except Exception as e:
            return [], 'error', str(e)
    return [], 'error', 'speakers.json not found'


def parse_aspx(aspx_path, relative_url, user=None, error_alert=None, success_alert=None, form_data=None, reset_success_url=None, invalid_token=False, reset_done=False):
    """
    Parses an ASPX page, loads its master page if specified,
    merges Content into ContentPlaceHolders, resolves server tags,
    and returns complete rendered HTML.
    """
    if not os.path.exists(aspx_path):
        return None

    if form_data is None:
        form_data = {}

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

    # Convert <form ... runat="server"> to <form ... method="post" action="">
    rendered = re.sub(r'<form\b([^>]*)runat=["\']server["\']([^>]*)>', r'<form\1method="post" action=""\2>', rendered, flags=re.IGNORECASE)

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
    
    # Replace <%= ...ClientID %> expressions
    rendered = re.sub(r'<%=\s*([a-zA-Z0-9_]+)\.ClientID\s*%>', r'\1', rendered)

    # Remove any remaining server tags <% ... %>
    rendered = re.sub(r'<%@[^%]*%>', '', rendered)
    rendered = re.sub(r'<asp:ScriptManager[^>]*></asp:ScriptManager>', '', rendered)
    rendered = re.sub(r'<asp:ScriptManager[^>]*/>', '', rendered)

    # Handle Literal tags
    rendered = re.sub(r'<asp:Literal[^>]*ID=["\']LitUserName["\'][^>]*>.*?</asp:Literal>', lambda m: user['fullName'] if user else 'Attendee', rendered, flags=re.IGNORECASE)

    # Replace <asp:TextBox> with <input> or <textarea>
    def replace_textbox(match):
        attrs = match.group(1)
        css_class = ""
        placeholder = ""
        textmode = ""
        rows = "3"
        name = ""
        extra = ""

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
        ac_m = re.search(r'autocomplete=["\']([^"\']+)["\']', attrs)
        if ac_m: extra += f' autocomplete="{ac_m.group(1)}"'
        req_m = re.search(r'required(?:=["\']([^"\']*)["\'])?', attrs)
        if req_m: extra += ' required="required"'

        val = form_data.get(name, '')
        if not val and user:
            if name == 'TxtEditFullName':
                val = user.get('fullName', '')
            elif name == 'TxtEditMobile':
                val = user.get('mobile', '')

        val_attr = f' value="{html_lib.escape(val)}"' if val else ''

        if textmode == 'multiline':
            return f'<textarea name="{name}" id="{name}" class="{css_class}" placeholder="{placeholder}" rows="{rows}"{extra}>{html_lib.escape(val)}</textarea>'
        elif textmode == 'password':
            return f'<input type="password" name="{name}" id="{name}" class="{css_class}" placeholder="{placeholder}"{extra} />'
        elif textmode in ['phone', 'tel']:
            return f'<input type="tel" name="{name}" id="{name}" class="{css_class}" placeholder="{placeholder}"{extra}{val_attr} />'
        elif textmode == 'email':
            return f'<input type="email" name="{name}" id="{name}" class="{css_class}" placeholder="{placeholder}"{extra}{val_attr} />'
        else:
            return f'<input type="text" name="{name}" id="{name}" class="{css_class}" placeholder="{placeholder}"{extra}{val_attr} />'

    rendered = re.sub(r'<asp:TextBox([^>]*)(?:/>|>(?:.*?)</asp:TextBox>)', replace_textbox, rendered, flags=re.DOTALL | re.IGNORECASE)

    # Replace <asp:Button> with <button>
    def replace_button(match):
        attrs = match.group(1)
        name = ""
        css_class = ""
        text = ""
        extra = ""

        id_m = re.search(r'ID=["\']([^"\']+)["\']', attrs)
        if id_m: name = id_m.group(1)
        cls_m = re.search(r'CssClass=["\']([^"\']+)["\']', attrs)
        if cls_m: css_class = cls_m.group(1)
        txt_m = re.search(r'Text=["\']([^"\']+)["\']', attrs)
        if txt_m: text = txt_m.group(1)
        ld_m = re.search(r'data-loading-text=["\']([^"\']+)["\']', attrs)
        if ld_m: extra += f' data-loading-text="{ld_m.group(1)}"'

        return f'<button type="submit" name="{name}" id="{name}" class="{css_class}"{extra}>{text}</button>'

    rendered = re.sub(r'<asp:Button([^>]*)(?:/>|>(?:.*?)</asp:Button>)', replace_button, rendered, flags=re.DOTALL | re.IGNORECASE)

    # Replace <asp:Label> with <span>
    def replace_label(match):
        attrs = match.group(1)
        body = match.group(2) if match.lastindex and match.lastindex >= 2 and match.group(2) else ""
        name = ""
        css_class = ""
        text = ""
        visible = True

        id_m = re.search(r'ID=["\']([^"\']+)["\']', attrs)
        if id_m: name = id_m.group(1)
        cls_m = re.search(r'CssClass=["\']([^"\']+)["\']', attrs)
        if cls_m: css_class = cls_m.group(1)
        txt_m = re.search(r'Text=["\']([^"\']*)["\']', attrs)
        if txt_m: text = txt_m.group(1)
        vis_m = re.search(r'Visible=["\']false["\']', attrs, re.IGNORECASE)
        if vis_m: visible = False

        if not visible:
            return ""

        if user:
            if name == 'LblName':
                text = user.get('fullName', text)
            elif name == 'TxtEmail':
                text = user.get('email', text)
            elif name == 'TxtMobile':
                text = user.get('mobile', text) or '-'

        content = text if text else body
        cls_attr = f' class="{css_class}"' if css_class else ""
        return f'<span id="{name}"{cls_attr}>{content}</span>'

    rendered = re.sub(r'<asp:Label([^>]*)(?:/>|>(.*?)</asp:Label>)', replace_label, rendered, flags=re.DOTALL | re.IGNORECASE)

    # Replace <asp:LinkButton> with <a>
    def replace_linkbutton(match):
        attrs = match.group(1)
        body = match.group(2)
        css_class = ""
        postback = "#"
        name = ""

        id_m = re.search(r'ID=["\']([^"\']+)["\']', attrs)
        if id_m: name = id_m.group(1)
        cls_m = re.search(r'CssClass=["\']([^"\']+)["\']', attrs)
        if cls_m: css_class = cls_m.group(1)
        pb_m = re.search(r'PostBackUrl=["\']([^"\']+)["\']', attrs)
        if pb_m: 
            postback = pb_m.group(1).replace('~/', '/')

        # Handle language switch links
        is_ar_url = '/ar_sa' in relative_url.lower()
        if name == 'BtnToAr':
            postback = '/Ar_Sa/'
        elif name == 'BtnToEn':
            postback = '/'
        elif name == 'BtnDashboard':
            postback = '/Ar_Sa/Dashboard' if is_ar_url else '/Dashboard'
        elif name == 'BtnProfile':
            postback = '/Ar_Sa/Profile' if is_ar_url else '/Profile'
        elif name == 'BtnSignOut':
            postback = ('/Ar_Sa/Login' if is_ar_url else '/Login') + '?logout=1'

        return f'<a href="{postback}" id="{name}" class="{css_class}">{body}</a>'

    rendered = re.sub(r'<asp:LinkButton([^>]*)>(.*?)</asp:LinkButton>', replace_linkbutton, rendered, flags=re.DOTALL | re.IGNORECASE)

    # Handle Alert Banners
    if error_alert:
        rendered = re.sub(r'<div[^>]*id=["\']divError(?:Profile)?["\'][^>]*>.*?</div>', f'<div id="divError" class="auth-alert alert alert-danger" style="display:block;" role="alert">{error_alert}</div>', rendered, flags=re.DOTALL | re.IGNORECASE)
    elif success_alert:
        rendered = re.sub(r'<div[^>]*id=["\']divError(?:Profile)?["\'][^>]*>.*?</div>', f'<div id="divError" class="auth-alert alert alert-success" style="display:block;" role="alert">{success_alert}</div>', rendered, flags=re.DOTALL | re.IGNORECASE)

    # Header user dropdown vs signin link visibility
    if user:
        rendered = rendered.replace('id="liLogin"', 'id="liLogin" style="display:none;"')
    else:
        rendered = rendered.replace('id="liProfile"', 'id="liProfile" style="display:none;"')

    # Convert <asp:UpdatePanel> and <ContentTemplate> to simple divs
    rendered = re.sub(r'</?asp:UpdatePanel[^>]*>', '', rendered, flags=re.IGNORECASE)
    rendered = re.sub(r'</?ContentTemplate>', '', rendered, flags=re.IGNORECASE)

    # Render <asp:Repeater ID="rptSpeakers"> dynamically
    if 'rptSpeakers' in rendered:
        is_ar_page = '/ar_sa' in relative_url.lower() or 'ar_sa' in aspx_path.lower()
        sp_list_raw, source, db_err = get_speakers_dataset()
        
        def normalize_speaker(s):
            d = {str(k).lower(): v for k, v in s.items()}
            def g(key, default=''):
                val = d.get(key.lower())
                return val if val is not None else default
            return {
                'SpeakerID': g('SpeakerID', 0),
                'FullNameEn': str(g('FullNameEn', '')),
                'FullNameAr': str(g('FullNameAr', '')),
                'JobTitleEn': str(g('JobTitleEn', '')),
                'JobTitleAr': str(g('JobTitleAr', '')),
                'OrganizationEn': str(g('OrganizationEn', '')),
                'OrganizationAr': str(g('OrganizationAr', '')),
                'LectureTitleEn': str(g('LectureTitleEn', '') or g('BioEn', '')),
                'LectureTitleAr': str(g('LectureTitleAr', '') or g('BioAr', '')),
                'Track': str(g('Track', 'track-a')),
                'TrackNameEn': str(g('TrackNameEn', '')),
                'TrackNameAr': str(g('TrackNameAr', '')),
                'Sector': str(g('Sector', 'clinical')),
                'SectorNameEn': str(g('SectorNameEn', '')),
                'SectorNameAr': str(g('SectorNameAr', '')),
                'Region': str(g('Region', 'national')),
                'RegionNameEn': str(g('RegionNameEn', '')),
                'RegionNameAr': str(g('RegionNameAr', '')),
                'ImagePath': str(g('ImagePath', '/Content/images/speakers/Speaker-Photo.png')),
                'CvPdfPath': str(g('CvPdfPath', '')),
                'Flag': str(g('Flag', '🇸🇦')),
                'Initials': str(g('Initials', '')),
                'Sorting': g('Sorting', 0),
                'IsActive': g('IsActive', True),
                'RoomEn': str(g('RoomEn', '')),
                'RoomAr': str(g('RoomAr', '')),
                'DayNumber': g('DayNumber', 1),
                'StartTime': str(g('StartTime', '')),
                'EndTime': str(g('EndTime', '')),
                'RoleEn': str(g('RoleEn', 'Speaker')),
                'RoleAr': str(g('RoleAr', 'متحدث'))
            }

        sp_list = [normalize_speaker(s) for s in sp_list_raw]
        cards_html = []
        track_icons = {'track-a': 'bi bi-cpu', 'track-b': 'bi bi-activity', 'track-c': 'bi bi-lightbulb'}
        sector_icons = {'clinical': 'bi bi-hospital', 'academic': 'bi bi-mortarboard', 'industry': 'bi bi-building', 'international': 'bi bi-globe'}

        for s in sp_list:
            track = (s.get('Track') or 'track-a').lower().strip()
            sector = (s.get('Sector') or 'clinical').lower().strip()
            region = (s.get('Region') or 'national').lower().strip()

            name = html_lib.escape(s.get('FullNameAr') if is_ar_page and s.get('FullNameAr') else s.get('FullNameEn', ''))
            role = html_lib.escape(s.get('JobTitleAr') if is_ar_page and s.get('JobTitleAr') else s.get('JobTitleEn', ''))
            org = html_lib.escape(s.get('OrganizationAr') if is_ar_page and s.get('OrganizationAr') else s.get('OrganizationEn', ''))
            lecture = html_lib.escape(s.get('LectureTitleAr') if is_ar_page and s.get('LectureTitleAr') else s.get('LectureTitleEn', ''))

            track_name = html_lib.escape(s.get('TrackNameAr') if is_ar_page and s.get('TrackNameAr') else s.get('TrackNameEn', ''))
            sector_name = html_lib.escape(s.get('SectorNameAr') if is_ar_page and s.get('SectorNameAr') else s.get('SectorNameEn', ''))
            region_name = html_lib.escape(s.get('RegionNameAr') if is_ar_page and s.get('RegionNameAr') else s.get('RegionNameEn', ''))

            room_val = s.get('RoomAr') if is_ar_page and s.get('RoomAr') else s.get('RoomEn', '')
            room = html_lib.escape(room_val)
            start_t = s.get('StartTime', '')
            end_t = s.get('EndTime', '')
            time_val = f"{start_t} - {end_t}" if start_t and end_t else start_t
            time_str = html_lib.escape(time_val)
            day = str(s.get('DayNumber', 1))
            session_role = html_lib.escape(s.get('RoleAr') if is_ar_page and s.get('RoleAr') else s.get('RoleEn', 'Speaker'))

            photo = s.get('ImagePath', '')
            if photo.startswith('~'): photo = photo[1:]
            cv = s.get('CvPdfPath', '')
            if cv and cv.startswith('~'): cv = cv[1:]

            flag = s.get('Flag', '🇸🇦')
            initials = html_lib.escape(s.get('Initials') or 'SP')

            t_badge = ('المسار أ' if track == 'track-a' else 'المسار ب' if track == 'track-b' else 'المسار ج') if is_ar_page else ('Track A' if track == 'track-a' else 'Track B' if track == 'track-b' else 'Track C')
            t_icon = track_icons.get(track, 'bi bi-cpu')

            s_badge = ('قطاع سريري' if sector == 'clinical' else 'قطاع أكاديمي' if sector == 'academic' else 'قطاع صناعي' if sector == 'industry' else 'دولي') if is_ar_page else ('Clinical' if sector == 'clinical' else 'Academic' if sector == 'academic' else 'Industry' if sector == 'industry' else 'International')
            s_icon = sector_icons.get(sector, 'bi bi-hospital')

            lec_label = 'عنوان المحاضرة' if is_ar_page else 'Lecture Presentation'
            quick_btn = 'نظرة سريعة' if is_ar_page else 'Quick Overview'


            lec_html = f'''<div class="speaker-lecture-card">
                    <div class="speaker-lecture-label"><i class="bi bi-mic-fill"></i> {lec_label}</div>
                    <p class="speaker-lecture-title">{lecture}</p>
                </div>''' if lecture else ''

            track_filter_title = 'تصفية حسب هذا المسار' if is_ar_page else 'Filter by this track'

            card = f'''<article class="speaker-card {track}"
                     data-photo="{photo}"
                     data-cv="{cv}"
                     data-track="{track}"
                     data-sector="{sector}"
                     data-region="{region}"
                     data-name="{name}"
                     data-role="{role}"
                     data-org="{org}"
                     data-lecture="{lecture}"
                     data-track-name="{track_name}"
                     data-sector-name="{sector_name}"
                     data-region-name="{region_name}"
                     data-flag="{flag}"
                     data-initials="{initials}"
                     data-room="{room}"
                     data-time="{time_str}"
                     data-day="{day}"
                     data-session-role="{session_role}">
                <div class="speaker-card-header">
                    <span class="speaker-track-tag tag-{track}" onclick="filterToTrack('{track}')" style="cursor:pointer;" title="{track_filter_title}">
                        <i class="{t_icon}"></i> {t_badge}
                    </span>
                    <span class="speaker-sector-tag">
                        <i class="{s_icon}"></i> {s_badge}
                    </span>
                </div>
                <div class="speaker-avatar-wrap">
                    <img src="{photo}" alt="{name}" class="speaker-avatar-img" onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'flex\';" />
                    <div class="speaker-monogram" style="display:none;">{initials}</div>
                    <span class="speaker-badge-flag" title="{region_name}">{flag}</span>
                </div>
                <div class="speaker-body">
                    <h3 class="speaker-name">{name}</h3>
                    <p class="speaker-title">{role}</p>
                    <p class="speaker-org">
                        <i class="bi bi-bank sairh-organization-icon"></i>
                        <span>{org}</span>
                    </p>
                    {lec_html}
                </div>
                <div class="speaker-card-actions">
                    <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest(\'.speaker-card\'))">
                        <i class="bi bi-info-circle"></i> {quick_btn}
                    </button>
                </div>
            </article>'''
            cards_html.append(card)

        rendered = re.sub(r'<asp:Repeater[^>]*ID=["\']rptSpeakers["\'][^>]*>.*?</asp:Repeater>', '\n'.join(cards_html), rendered, flags=re.DOTALL | re.IGNORECASE)

        # Update initial tab counts and totals dynamically in HTML
        total_cnt = len(sp_list)
        track_a_cnt = sum(1 for s in sp_list if (s.get('Track') or '').lower().strip() == 'track-a')
        track_b_cnt = sum(1 for s in sp_list if (s.get('Track') or '').lower().strip() == 'track-b')
        track_c_cnt = sum(1 for s in sp_list if (s.get('Track') or '').lower().strip() == 'track-c')

        rendered = re.sub(r'(data-track="all"[^>]*>.*?<span class="tab-count">)\d+(</span>)', rf'\g<1>{total_cnt}\2', rendered, flags=re.DOTALL)
        rendered = re.sub(r'(data-track="track-a"[^>]*>.*?<span class="tab-count">)\d+(</span>)', rf'\g<1>{track_a_cnt}\2', rendered, flags=re.DOTALL)
        rendered = re.sub(r'(data-track="track-b"[^>]*>.*?<span class="tab-count">)\d+(</span>)', rf'\g<1>{track_b_cnt}\2', rendered, flags=re.DOTALL)
        rendered = re.sub(r'(data-track="track-c"[^>]*>.*?<span class="tab-count">)\d+(</span>)', rf'\g<1>{track_c_cnt}\2', rendered, flags=re.DOTALL)
        rendered = re.sub(r'(id="speakersCount"[^>]*>)\d+(<)', rf'\g<1>{total_cnt}\2', rendered)
        rendered = re.sub(r'(id="speakersTotalCount"[^>]*>)\d+(<)', rf'\g<1>{total_cnt}\2', rendered)

        # Inject developer console telemetry
        escaped_source = html_lib.escape(str(source))
        escaped_note = html_lib.escape(str(db_err or ''))
        if source.startswith('SQL Server'):
            diag_script = f'<script>console.info("[SAIRH Dev Server] Loaded {total_cnt} speakers LIVE from {escaped_source}.");</script>'
        else:
            diag_script = f'<script>console.warn("[SAIRH Dev Server] Loaded {total_cnt} speakers from {escaped_source}. DB note: {escaped_note}");</script>'
        rendered = rendered.replace('</body>', f'{diag_script}\n</body>')

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
            rendered = rendered.replace('id="linkSpeakersAr"', 'id="linkSpeakersAr" class="active"').replace('id="linkJudgesAr"', 'id="linkJudgesAr" class="active"')
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
            rendered = rendered.replace('id="linkSpeakers"', 'id="linkSpeakers" class="active"').replace('id="linkJudges"', 'id="linkJudges" class="active"')
        elif 'sponsors' in req_lower:
            rendered = rendered.replace('id="linkSponsors"', 'id="linkSponsors" class="active"')
        elif 'contactus' in req_lower:
            rendered = rendered.replace('id="linkContactUs"', 'id="linkContactUs" class="active"')
        else:
            rendered = rendered.replace('id="linkHome"', 'id="linkHome" class="active"')

    # First-time welcome banner for Survey.aspx
    is_first_time = 'first=1' in relative_url
    if is_first_time:
        rendered = re.sub(r'id=["\']pnlFirstTimeBanner["\'][^>]*visible=["\']false["\']', 'id="pnlFirstTimeBanner" style="display:flex;"', rendered, flags=re.IGNORECASE)
    else:
        rendered = re.sub(r'<div[^>]*id=["\']pnlFirstTimeBanner["\'][^>]*>.*?</div>\s*</div>', '', rendered, flags=re.DOTALL | re.IGNORECASE)

    # Schedules.aspx personalized roadmap rendering
    if 'schedules' in aspx_path.lower():
        roadmap = user.get('surveyRoadmap', []) if user else []
        if roadmap:
            rendered = re.sub(r'id=["\']pnlRoadmap["\'][^>]*visible=["\']false["\']', 'id="pnlRoadmap" style="display:block;"', rendered, flags=re.IGNORECASE)
            rendered = re.sub(r'id=["\']pnlSurveyCTA["\']', 'id="pnlSurveyCTA" style="display:none;"', rendered, flags=re.IGNORECASE)
            is_ar = '/ar_sa' in relative_url.lower() or 'ar_sa' in aspx_path.lower()
            cards = []
            for code in roadmap:
                booth = next((b for b in ALL_BOOTHS if b['boothCode'] == code), None)
                if booth:
                    hall = booth['hallAr'] if is_ar else booth['hallEn']
                    name = booth['nameAr'] if is_ar else booth['nameEn']
                    org = booth['organizationAr'] if is_ar else booth['organizationEn']
                    cards.append(f'''
                    <div class="recommended-stop-card" onclick="openBoothModal('{code}')" style="cursor:pointer;">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="badge badge-info">{html_lib.escape(hall)}</span>
                            <strong class="text-white">{code}</strong>
                        </div>
                        <div class="text-white font-weight-bold">{html_lib.escape(name)}</div>
                        <div class="text-secondary small">{html_lib.escape(org)}</div>
                    </div>
                    ''')
            rendered = re.sub(r'<div[^>]*id=["\']recCardsContainer["\'][^>]*>.*?</div>', f'<div class="recommended-cards-grid" id="recCardsContainer">{"".join(cards)}</div>', rendered, flags=re.DOTALL | re.IGNORECASE)
        else:
            rendered = re.sub(r'id=["\']pnlRoadmap["\']', 'id="pnlRoadmap" style="display:none;"', rendered, flags=re.IGNORECASE)

    # Profile.aspx exhibition roadmap box rendering
    if 'profile' in aspx_path.lower():
        is_ar = '/ar_sa' in relative_url.lower() or 'ar_sa' in aspx_path.lower()
        roadmap = user.get('surveyRoadmap', []) if user else []
        if roadmap:
            cnt = len(roadmap)
            badge_text = f"مكتمل ({cnt} محطات)" if is_ar else f"Completed ({cnt} stops)"
            desc_text = f"مسارك المخصص في المعرض نشط ويتضمن {cnt} محطة استكشافية موصى بها." if is_ar else f"Your personalized roadmap is active with {cnt} recommended booth and research stops."
            action_text = '<i class="bi bi-arrow-repeat ml-1"></i> إعادة الاستبيان' if is_ar else '<i class="bi bi-arrow-repeat mr-1"></i> Retake Survey'
            chips = "".join([f'<span class="badge badge-primary {"ml-1" if is_ar else "mr-1"} mb-1" style="background:#0284c7;font-size:0.75rem;">{c}</span>' for c in roadmap])
            rendered = re.sub(r'<span[^>]*id=["\']LblSurveyBadge["\'][^>]*>.*?</span>', f'<span id="LblSurveyBadge" class="badge badge-success">{badge_text}</span>', rendered, flags=re.IGNORECASE | re.DOTALL)
            rendered = re.sub(r'<p[^>]*id=["\']pRoadmapDesc["\'][^>]*>.*?</p>', f'<p class="text-secondary small mb-3" id="pRoadmapDesc">{desc_text}</p>', rendered, flags=re.IGNORECASE | re.DOTALL)
            rendered = re.sub(r'id=["\']pnlSurveyStops["\'][^>]*visible=["\']false["\']', 'id="pnlSurveyStops" style="display:block;"', rendered, flags=re.IGNORECASE)
            rendered = re.sub(r'<div[^>]*id=["\']pnlStopsChips["\'][^>]*>.*?</div>', f'<div id="pnlStopsChips" class="d-flex flex-wrap gap-1">{chips}</div>', rendered, flags=re.IGNORECASE | re.DOTALL)
            rendered = re.sub(r'<a[^>]*id=["\']lnkSurveyAction["\'][^>]*>.*?</a>', f'<a href="Survey" id="lnkSurveyAction" class="btn btn-sm btn-outline-light rounded-pill font-weight-semibold">{action_text}</a>', rendered, flags=re.IGNORECASE | re.DOTALL)
        else:
            badge_text = "لم يكتمل بعد" if is_ar else "Not Completed"
            desc_text = "أكمل استبيان التخصيص القصير للحصول على جولة مخصصة للأجنحة وشاشات الأبحاث على خريطة المعرض." if is_ar else "Take our short survey to get a tailored tour of sponsor booths and research displays on the Exhibition Map."
            action_text = '<i class="bi bi-magic ml-1"></i> بناء مساري المخصص' if is_ar else '<i class="bi bi-magic mr-1"></i> Build My Roadmap'
            rendered = re.sub(r'<span[^>]*id=["\']LblSurveyBadge["\'][^>]*>.*?</span>', f'<span id="LblSurveyBadge" class="badge badge-warning">{badge_text}</span>', rendered, flags=re.IGNORECASE | re.DOTALL)
            rendered = re.sub(r'<p[^>]*id=["\']pRoadmapDesc["\'][^>]*>.*?</p>', f'<p class="text-secondary small mb-3" id="pRoadmapDesc">{desc_text}</p>', rendered, flags=re.IGNORECASE | re.DOTALL)
            rendered = re.sub(r'id=["\']pnlSurveyStops["\']', 'id="pnlSurveyStops" style="display:none;"', rendered, flags=re.IGNORECASE)
            rendered = re.sub(r'<a[^>]*id=["\']lnkSurveyAction["\'][^>]*>.*?</a>', f'<a href="Survey" id="lnkSurveyAction" class="btn btn-sm btn-outline-light rounded-pill font-weight-semibold">{action_text}</a>', rendered, flags=re.IGNORECASE | re.DOTALL)

    # ForgotPassword.aspx state handling
    if reset_success_url:
        rendered = re.sub(r'id=["\']pnlForm["\']', 'id="pnlForm" style="display:none;"', rendered, flags=re.IGNORECASE)
        rendered = re.sub(r'id=["\']pnlSuccess["\'][^>]*visible=["\']false["\']', 'id="pnlSuccess" style="display:block;"', rendered, flags=re.IGNORECASE)
        rendered = re.sub(r'<(?:asp:HyperLink|a)[^>]*id=["\']LnkResetAction["\'][^>]*>.*?</(?:asp:HyperLink|a)>', f'<a href="{reset_success_url}" id="LnkResetAction" class="cyan-glow-btn d-inline-block px-4 py-3 text-white font-weight-bold text-decoration-none"><i class="bi bi-arrow-right-circle mr-1"></i> Proceed to Reset Password</a>', rendered, flags=re.IGNORECASE | re.DOTALL)

    # ResetPassword.aspx state handling
    if invalid_token:
        rendered = re.sub(r'id=["\']pnlForm["\']', 'id="pnlForm" style="display:none;"', rendered, flags=re.IGNORECASE)
        rendered = re.sub(r'id=["\']pnlInvalidToken["\'][^>]*visible=["\']false["\']', 'id="pnlInvalidToken" style="display:block;"', rendered, flags=re.IGNORECASE)
    elif reset_done:
        rendered = re.sub(r'id=["\']pnlForm["\']', 'id="pnlForm" style="display:none;"', rendered, flags=re.IGNORECASE)
        rendered = re.sub(r'id=["\']pnlSuccess["\'][^>]*visible=["\']false["\']', 'id="pnlSuccess" style="display:block;"', rendered, flags=re.IGNORECASE)
    elif 'ResetPassword' in aspx_path:
        t_match = re.search(r'[?&]token=([^&]+)', relative_url)
        if t_match:
            t_val = html_lib.escape(t_match.group(1))
            rendered = re.sub(r'(<div[^>]*id=["\']pnlForm["\'][^>]*>)', rf'\1<input type="hidden" name="token" value="{t_val}" />', rendered, flags=re.IGNORECASE)

    return rendered


class SairhRequestHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=BASE_DIR, **kwargs)

    def get_current_user(self):
        cookie_header = self.headers.get('Cookie')
        if not cookie_header:
            return None
        cookie = SimpleCookie()
        try:
            cookie.load(cookie_header)
            if 'sairh_user' in cookie:
                email = cookie['sairh_user'].value.lower()
                if email in DEV_USERS:
                    return DEV_USERS[email]
                return {'fullName': email.split('@')[0], 'email': email, 'mobile': ''}
        except Exception:
            return None
        return None

    def handle_chat_ask(self, post_body):
        try:
            payload = json.loads(post_body)
        except Exception:
            post_data = parse_qs(post_body)
            payload = {k: v[0] for k, v in post_data.items()}

        message = payload.get('message', '').strip()
        language = 'ar' if payload.get('language') == 'ar' else 'en'

        if not message:
            self.send_response(400)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            res_data = json.dumps({'error': 'Message cannot be empty.'}).encode('utf-8')
            self.send_header('Content-Length', str(len(res_data)))
            self.end_headers()
            self.wfile.write(res_data)
            return

        faqs_path = os.path.join(BASE_DIR, 'Content/data/faqs.json')
        faqs = []
        if os.path.exists(faqs_path):
            try:
                with open(faqs_path, 'r', encoding='utf-8') as f:
                    faqs = json.load(f)
            except Exception:
                faqs = []

        def norm(s):
            return (s or '').strip().rstrip('?؟!.').strip().lower()

        clean_msg = norm(message)
        for cat in faqs:
            for q in cat.get('questions', []):
                if norm(q.get('questionEn')) == clean_msg or norm(q.get('questionAr')) == clean_msg:
                    ans = q.get('answerAr') if language == 'ar' else q.get('answerEn')
                    self.send_response(200)
                    self.send_header('Content-Type', 'application/json; charset=utf-8')
                    res_data = json.dumps({'answer': ans, 'source': 'faq'}, ensure_ascii=False).encode('utf-8')
                    self.send_header('Content-Length', str(len(res_data)))
                    self.end_headers()
                    self.wfile.write(res_data)
                    return

        # Call Gemini
        api_key = os.environ.get("GEMINI_API_KEY", "")
        model = os.environ.get("GEMINI_MODEL", "gemini-1.5-flash")
        if not api_key:
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            msg = "عذراً، خدمة المساعد الذكي غير مهيأة حالياً. يمكنك اختيار أحد الأسئلة المتاحة في القائمة أعلاه." if language == 'ar' else "The AI assistant service is currently not configured. Please choose from the suggested questions above or contact the summit organizers."
            res_data = json.dumps({'answer': msg, 'source': 'info'}, ensure_ascii=False).encode('utf-8')
            self.send_header('Content-Length', str(len(res_data)))
            self.end_headers()
            self.wfile.write(res_data)
            return
        system_prompt = (
            "You are the AI assistant for SAIRH (the Saudi 1st AI Summit in Radiology & Health Innovation, 2026).\n"
            "Answer concisely and professionally. Use ONLY the summit information below.\n"
            "If the answer is not covered by it, say you do not have that information and suggest contacting the summit organizers. Do not invent dates, names, prices or links.\n"
            "Always reply in the same language as the user's question (Arabic or English).\n\nSUMMIT INFORMATION:\n"
        )
        for cat in faqs:
            system_prompt += f"## {cat.get('categoryNameEn', '')}\n"
            for q in cat.get('questions', []):
                system_prompt += f"Q: {q.get('questionEn', '')}\nA: {q.get('answerEn', '')}\nQ (Arabic): {q.get('questionAr', '')}\nA (Arabic): {q.get('answerAr', '')}\n"

        req_payload = {
            "systemInstruction": {"parts": [{"text": system_prompt}]},
            "contents": [{"role": "user", "parts": [{"text": message}]}],
            "generationConfig": {"temperature": 0.3, "maxOutputTokens": 600}
        }

        endpoint = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent"
        try:
            import urllib.request
            req = urllib.request.Request(
                endpoint,
                data=json.dumps(req_payload).encode('utf-8'),
                headers={
                    'Content-Type': 'application/json',
                    'x-goog-api-key': api_key
                },
                method='POST'
            )
            with urllib.request.urlopen(req, timeout=25) as response:
                resp_data = json.loads(response.read().decode('utf-8'))
                candidates = resp_data.get('candidates', [])
                if candidates:
                    parts = candidates[0].get('content', {}).get('parts', [])
                    if parts and 'text' in parts[0]:
                        ans = parts[0]['text'].strip()
                        self.send_response(200)
                        self.send_header('Content-Type', 'application/json; charset=utf-8')
                        res_data = json.dumps({'answer': ans, 'source': 'gemini'}, ensure_ascii=False).encode('utf-8')
                        self.send_header('Content-Length', str(len(res_data)))
                        self.end_headers()
                        self.wfile.write(res_data)
                        return
        except Exception as e:
            print(f"Gemini call error: {e}")

        fallback = 'عذراً، لم أتمكن من العثور على إجابة دقيقة. يمكنك تصفح الأسئلة الشائعة أعلاه.' if language == 'ar' else 'Sorry, no exact answer is available. Please check the suggested topics above.'
        self.send_response(200)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        res_data = json.dumps({'answer': fallback, 'source': 'gemini'}, ensure_ascii=False).encode('utf-8')
        self.send_header('Content-Length', str(len(res_data)))
        self.end_headers()
        self.wfile.write(res_data)

    def do_POST(self):
        parsed = urlparse(self.path)
        path = parsed.path.strip('/')

        # Handle Chatbot ask API
        if path.lower() == 'api/chat/ask':
            content_length = int(self.headers.get('Content-Length', 0))
            post_body = self.rfile.read(content_length).decode('utf-8', errors='ignore')
            self.handle_chat_ask(post_body)
            return

        # Handle NFC / Map Scan API
        if path.lower() == 'api/map/scan':
            query_params = parse_qs(parsed.query)
            booth_code = query_params.get('boothCode', [''])[0].strip().upper()
            content_length = int(self.headers.get('Content-Length', 0))
            if content_length > 0:
                post_body = self.rfile.read(content_length).decode('utf-8', errors='ignore')
                try:
                    payload = json.loads(post_body)
                    booth_code = payload.get('boothCode', booth_code).strip().upper()
                except Exception:
                    pass
            current_user = self.get_current_user()
            if booth_code:
                register_scan(booth_code, current_user['email'] if current_user else None)
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            res_data = json.dumps({'success': True, 'boothCode': booth_code}).encode('utf-8')
            self.send_header('Content-Length', str(len(res_data)))
            self.end_headers()
            self.wfile.write(res_data)
            return

        is_arabic = path.lower().startswith('ar_sa')
        subpath = path[5:].strip('/') if is_arabic else path
        page = subpath.lower()

        # Read POST body
        content_length = int(self.headers.get('Content-Length', 0))
        post_body = self.rfile.read(content_length).decode('utf-8', errors='ignore')
        post_data = parse_qs(post_body)
        form = {k: v[0] for k, v in post_data.items()}

        current_user = self.get_current_user()

        # Registration POST
        if page in ['register', 'register.aspx']:
            full_name = form.get('TxtFullName', '').strip()
            email = form.get('TxtEmail', '').strip().lower()
            mobile = form.get('TxtMobile', '').strip()
            password = form.get('TxtPassword', '')
            password_again = form.get('TxtPasswordAgain', '')

            validation_errors = []
            if not full_name or len(full_name) < 3:
                validation_errors.append('يرجى إدخال الاسم الكامل (3 أحرف على الأقل).' if is_arabic else 'Please enter your full name (at least 3 characters).')
            if not email or not re.match(r'^[^\s@]+@[^\s@]+\.[^\s@]+$', email):
                validation_errors.append('يرجى إدخال بريد إلكتروني صالح.' if is_arabic else 'Please enter a valid email address.')

            pwd_errors = validate_password_strength(password, email, full_name, is_arabic)
            validation_errors.extend(pwd_errors)

            if password and password != password_again:
                validation_errors.append('كلمتا المرور غير متطابقتين.' if is_arabic else 'Passwords do not match.')

            if validation_errors:
                template = 'Ar_Sa/Register.aspx' if is_arabic else 'Register.aspx'
                html = parse_aspx(os.path.join(BASE_DIR, template), self.path, error_alert=render_error_list(validation_errors), form_data=form)
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                encoded = html.encode('utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

            # Success: store password as PBKDF2 hash, redirect first-time attendee to Survey
            p_hash = hash_password(password)
            DEV_USERS[email] = {
                'fullName': full_name,
                'email': email,
                'mobile': mobile,
                'passwordHash': p_hash,
                'hasCompletedSurvey': False,
                'surveyRoadmap': []
            }
            save_users()

            redirect_target = '/Ar_Sa/Survey?first=1' if is_arabic else '/Survey?first=1'
            self.send_response(302)
            self.send_header('Set-Cookie', f'sairh_user={email}; Path=/; HttpOnly')
            self.send_header('Location', redirect_target)
            self.end_headers()
            return

        # Survey POST
        if page in ['survey', 'survey.aspx']:
            interests = post_data.get('interests', [])
            booth_types = post_data.get('boothTypes', [])
            goals = post_data.get('goals', [])
            count_str = form.get('boothCount', '5')
            try:
                booth_count = int(count_str)
            except Exception:
                booth_count = 5

            recommended = calculate_recommendations(interests, booth_types, goals, booth_count)
            rec_codes = [b['boothCode'] for b in recommended]

            if current_user:
                current_user['hasCompletedSurvey'] = True
                current_user['surveyRoadmap'] = rec_codes
                DEV_USERS[current_user['email']] = current_user
                save_users()

            redirect_target = '/Ar_Sa/Schedules?survey=completed' if is_arabic else '/Schedules?survey=completed'
            self.send_response(302)
            self.send_header('Location', redirect_target)
            self.end_headers()
            return

        # ForgotPassword POST
        if page in ['forgotpassword', 'forgotpassword.aspx']:
            email = form.get('TxtEmail', '').strip().lower()
            if not email or not re.match(r'^[^\s@]+@[^\s@]+\.[^\s@]+$', email):
                err = 'يرجى إدخال بريد إلكتروني صالح.' if is_arabic else 'Please enter a valid email address.'
                template = 'Ar_Sa/ForgotPassword.aspx' if is_arabic else 'ForgotPassword.aspx'
                html = parse_aspx(os.path.join(BASE_DIR, template), self.path, error_alert=err, form_data=form)
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                encoded = html.encode('utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

            token = secrets.token_urlsafe(32)
            RESET_TOKENS[token] = {
                'email': email,
                'expires': dt.now().timestamp() + 3600,
                'used': False
            }
            reset_url = f'/Ar_Sa/ResetPassword?token={token}' if is_arabic else f'/ResetPassword?token={token}'
            template = 'Ar_Sa/ForgotPassword.aspx' if is_arabic else 'ForgotPassword.aspx'
            html = parse_aspx(os.path.join(BASE_DIR, template), self.path, reset_success_url=reset_url)
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            encoded = html.encode('utf-8')
            self.send_header('Content-Length', str(len(encoded)))
            self.end_headers()
            self.wfile.write(encoded)
            return

        # ResetPassword POST
        if page in ['resetpassword', 'resetpassword.aspx']:
            query_params = parse_qs(parsed.query)
            token = query_params.get('token', [''])[0] or form.get('token', '')
            token_info = RESET_TOKENS.get(token)

            if not token_info or token_info.get('used') or token_info.get('expires', 0) < dt.now().timestamp():
                template = 'Ar_Sa/ResetPassword.aspx' if is_arabic else 'ResetPassword.aspx'
                html = parse_aspx(os.path.join(BASE_DIR, template), self.path, invalid_token=True)
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                encoded = html.encode('utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

            pwd = form.get('TxtPassword', '')
            pwd_again = form.get('TxtPasswordAgain', '')
            target_email = token_info['email']
            user_obj = DEV_USERS.get(target_email, {})

            val_errors = validate_password_strength(pwd, target_email, user_obj.get('fullName', ''), is_arabic)
            if pwd and pwd != pwd_again:
                val_errors.append('كلمتا المرور غير متطابقتين.' if is_arabic else 'Passwords do not match.')

            if val_errors:
                template = 'Ar_Sa/ResetPassword.aspx' if is_arabic else 'ResetPassword.aspx'
                html = parse_aspx(os.path.join(BASE_DIR, template), self.path, error_alert=render_error_list(val_errors), form_data=form)
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                encoded = html.encode('utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

            # Success
            token_info['used'] = True
            new_hash = hash_password(pwd)
            if target_email in DEV_USERS:
                DEV_USERS[target_email]['passwordHash'] = new_hash
            else:
                DEV_USERS[target_email] = {'fullName': target_email.split('@')[0], 'email': target_email, 'mobile': '', 'passwordHash': new_hash}
            save_users()

            template = 'Ar_Sa/ResetPassword.aspx' if is_arabic else 'ResetPassword.aspx'
            html = parse_aspx(os.path.join(BASE_DIR, template), self.path, reset_done=True)
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            encoded = html.encode('utf-8')
            self.send_header('Content-Length', str(len(encoded)))
            self.end_headers()
            self.wfile.write(encoded)
            return

        # Login POST
        if page in ['login', 'login.aspx']:
            email = form.get('TxtEmail', '').strip().lower()
            password = form.get('TxtPassword', '')

            error = None
            if not email or not password:
                error = 'يرجى إدخال البريد الإلكتروني وكلمة المرور.' if is_arabic else 'Please enter both your email address and password.'
            else:
                user = DEV_USERS.get(email)
                if user and user.get('passwordHash'):
                    if not verify_password(password, user['passwordHash']):
                        error = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.' if is_arabic else 'Incorrect email or password.'
                elif not user:
                    # Mock dev mode fallback: create user with hash
                    DEV_USERS[email] = {'fullName': email.split('@')[0], 'email': email, 'mobile': '', 'passwordHash': hash_password(password)}
                    save_users()

            if error:
                template = 'Ar_Sa/Login.aspx' if is_arabic else 'Login.aspx'
                html = parse_aspx(os.path.join(BASE_DIR, template), self.path, error_alert=error, form_data=form)
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                encoded = html.encode('utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

            redirect_target = '/Ar_Sa/Profile' if is_arabic else '/Profile'
            self.send_response(302)
            self.send_header('Set-Cookie', f'sairh_user={email}; Path=/; HttpOnly')
            self.send_header('Location', redirect_target)
            self.end_headers()
            return

        # Profile POST
        if page in ['profile', 'profile.aspx']:
            if not current_user:
                self.send_response(302)
                self.send_header('Location', '/Ar_Sa/Login' if is_arabic else '/Login')
                self.end_headers()
                return

            template = 'Ar_Sa/Profile.aspx' if is_arabic else 'Profile.aspx'

            if 'BtnPudateProfile' in form or 'TxtEditFullName' in form:
                name = form.get('TxtEditFullName', '').strip()
                mobile = form.get('TxtEditMobile', '').strip()
                if len(name) >= 3:
                    current_user['fullName'] = name
                    current_user['mobile'] = mobile
                    DEV_USERS[current_user['email']] = current_user
                    save_users()
                msg = 'تم تحديث البيانات الشخصية بنجاح!' if is_arabic else 'Your profile has been updated successfully!'
                html = parse_aspx(os.path.join(BASE_DIR, template), self.path, user=current_user, success_alert=msg)
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                encoded = html.encode('utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

            if 'BtnUpdate' in form or 'TxtPass' in form:
                cur_pass = form.get('TxtPassCurrent', '')
                new_pass = form.get('TxtPass', '')
                new_pass_re = form.get('TxtPassRe', '')

                errors = []
                if not cur_pass:
                    errors.append('يرجى إدخال كلمة المرور الحالية.' if is_arabic else 'Please enter your current password.')
                elif current_user.get('passwordHash') and not verify_password(cur_pass, current_user['passwordHash']):
                    errors.append('كلمة المرور الحالية غير صحيحة.' if is_arabic else 'Your current password is incorrect.')

                str_errors = validate_password_strength(new_pass, current_user.get('email'), current_user.get('fullName'), is_arabic)
                errors.extend(str_errors)

                if new_pass and new_pass != new_pass_re:
                    errors.append('كلمتا المرور غير متطابقتين.' if is_arabic else 'The passwords do not match.')

                if errors:
                    html = parse_aspx(os.path.join(BASE_DIR, template), self.path, user=current_user, error_alert=render_error_list(errors))
                    self.send_response(200)
                    self.send_header('Content-Type', 'text/html; charset=utf-8')
                    encoded = html.encode('utf-8')
                    self.send_header('Content-Length', str(len(encoded)))
                    self.end_headers()
                    self.wfile.write(encoded)
                    return

                # Update password hash
                current_user['passwordHash'] = hash_password(new_pass)
                DEV_USERS[current_user['email']] = current_user
                save_users()

                msg = 'تم تغيير كلمة المرور بنجاح!' if is_arabic else 'Your password has been changed successfully!'
                html = parse_aspx(os.path.join(BASE_DIR, template), self.path, user=current_user, success_alert=msg)
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                encoded = html.encode('utf-8')
                self.send_header('Content-Length', str(len(encoded)))
                self.end_headers()
                self.wfile.write(encoded)
                return

        # Fallback to GET
        self.do_GET()

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path.strip('/')

        # Handle Chatbot FAQ API
        if path.lower() == 'api/chat/faqs':
            faqs_path = os.path.join(BASE_DIR, 'Content/data/faqs.json')
            if os.path.exists(faqs_path):
                with open(faqs_path, 'r', encoding='utf-8') as f:
                    content = f.read().encode('utf-8')
            else:
                content = b'[]'
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.send_header('Content-Length', str(len(content)))
            self.end_headers()
            self.wfile.write(content)
            return

        # Handle Interactive Map Status API (Sponsor & Research Booths)
        if path.lower() == 'api/map/status':
            query_params = parse_qs(parsed.query)
            is_ar = query_params.get('lang', [''])[0].lower() == 'ar' or '/ar_sa' in self.path.lower()
            current_user = self.get_current_user()
            user_email = current_user['email'] if current_user else ''
            status_list = get_map_status(user_email, is_arabic=is_ar)
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            res_data = json.dumps(status_list, ensure_ascii=False).encode('utf-8')
            self.send_header('Content-Length', str(len(res_data)))
            self.end_headers()
            self.wfile.write(res_data)
            return

        # Handle Logout
        if 'logout=1' in parsed.query:
            is_arabic = path.lower().startswith('ar_sa')
            self.send_response(302)
            self.send_header('Set-Cookie', 'sairh_user=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT')
            self.send_header('Location', '/Ar_Sa/Login' if is_arabic else '/Login')
            self.end_headers()
            return

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

        current_user = self.get_current_user()

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
                aspx_file = 'Ar_Sa/Speakers.aspx'
            elif subpath.lower() in ['sponsors', 'sponsors.aspx']:
                aspx_file = 'Ar_Sa/Sponsors.aspx'
            elif subpath.lower() in ['contactus', 'contactus.aspx']:
                aspx_file = 'Ar_Sa/ContactUs.aspx'
            elif subpath.lower() in ['login', 'login.aspx']:
                aspx_file = 'Ar_Sa/Login.aspx'
            elif subpath.lower() in ['register', 'register.aspx']:
                aspx_file = 'Ar_Sa/Register.aspx'
            elif subpath.lower() in ['profile', 'profile.aspx']:
                if not current_user:
                    self.send_response(302)
                    self.send_header('Location', '/Ar_Sa/Login')
                    self.end_headers()
                    return
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
                aspx_file = 'Speakers.aspx'
            elif path.lower() in ['sponsors', 'sponsors.aspx']:
                aspx_file = 'Sponsors.aspx'
            elif path.lower() in ['contactus', 'contactus.aspx']:
                aspx_file = 'ContactUs.aspx'
            elif path.lower() in ['login', 'login.aspx']:
                aspx_file = 'Login.aspx'
            elif path.lower() in ['register', 'register.aspx']:
                aspx_file = 'Register.aspx'
            elif path.lower() in ['profile', 'profile.aspx']:
                if not current_user:
                    self.send_response(302)
                    self.send_header('Location', '/Login')
                    self.end_headers()
                    return
                aspx_file = 'Profile.aspx'
            elif path.lower() in ['dashboard', 'dashboard.aspx']:
                aspx_file = 'Dashboard.aspx'
            else:
                target = os.path.join(BASE_DIR, path + '.aspx')
                aspx_file = f'{path}.aspx' if os.path.exists(target) else None

        if aspx_file:
            full_path = os.path.join(BASE_DIR, aspx_file)
            inv_tok = False
            if 'resetpassword' in aspx_file.lower():
                query_params = parse_qs(parsed.query)
                tok = query_params.get('token', [''])[0]
                token_info = RESET_TOKENS.get(tok)
                if not token_info or token_info.get('used') or token_info.get('expires', 0) < dt.now().timestamp():
                    inv_tok = True

            html = parse_aspx(full_path, parsed.path, user=current_user, invalid_token=inv_tok)
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
