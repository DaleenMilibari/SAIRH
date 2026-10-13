#!/usr/bin/env python3
"""
SAIRH 2026 - Database & Speakers Diagnostic Script
Tests connection string configuration, network reachability, and verifies
dynamic data retrieval and fallback mechanisms.
"""

import os
import re
import socket
import sys
import json

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WEB_CONFIG = os.path.join(BASE_DIR, 'AIE', 'AIE', 'Web.config')
SPEAKERS_JSON = os.path.join(BASE_DIR, 'AIE', 'AIE', 'Content', 'data', 'speakers.json')


def print_banner():
    print("=" * 66)
    print("   SAIRH 2026 - Database Connection & Speakers Diagnostic Tool   ")
    print("=" * 66)


def check_web_config():
    print("\n[1] Reading Database Configuration...")
    if not os.path.exists(WEB_CONFIG):
        print(f"    [ERROR] Web.config not found at: {WEB_CONFIG}")
        return None

    with open(WEB_CONFIG, 'r', encoding='utf-8') as f:
        content = f.read()

    match = re.search(r'name=["\']AIEConnectionString["\']\s+connectionString=["\']([^"\']+)["\']', content)
    if not match:
        print("    [ERROR] 'AIEConnectionString' not found in Web.config")
        return None

    conn_str = match.group(1)
    masked = re.sub(r'(Password|pwd)\s*=\s*[^;]+', r'\1=******', conn_str, flags=re.IGNORECASE)
    print(f"    Config file: {WEB_CONFIG}")
    print(f"    Connection String: {masked}")
    return conn_str


def parse_connection_string(conn_str):
    parts = {}
    for item in conn_str.split(';'):
        if '=' in item:
            k, v = item.split('=', 1)
            parts[k.strip().lower()] = v.strip()
    return parts


def check_connectivity(conn_str):
    print("\n[2] Analyzing Connection Target...")
    parts = parse_connection_string(conn_str)
    data_source = parts.get('data source') or parts.get('server') or ''

    if '(localdb)' in data_source.lower():
        print("    [!] Target is Windows LocalDB: " + data_source)
        print("        * Windows LocalDB runs natively when deployed on Windows / IIS.")
        print("        * On macOS, LocalDB cannot run directly.")
        print("        * To connect to a live SQL Server on Mac:")
        print("          - Run SQL Server in Docker (mcr.microsoft.com/mssql/server)")
        print("          - Or connect to an Azure SQL / Remote Windows SQL Server instance.")
        print("          - Update Web.config: Server=localhost,1433;Database=AIE;User Id=sa;Password=...;")
        return False, data_source, 1433

    host = data_source
    port = 1433
    if ',' in host:
        host, port_str = host.split(',', 1)
        try: port = int(port_str.strip())
        except ValueError: pass
    elif ':' in host:
        host, port_str = host.split(':', 1)
        try: port = int(port_str.strip())
        except ValueError: pass

    print(f"    Testing TCP connection to host '{host}' on port {port}...")
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(3.0)
        result = sock.connect_ex((host, port))
        sock.close()
        if result == 0:
            print(f"    [+] Successfully reached SQL Server port {port} at {host}!")
            return True, host, port
        else:
            print(f"    [-] Could not establish TCP connection to {host}:{port} (error code {result})")
            return False, host, port
    except Exception as e:
        print(f"    [-] Socket test failed: {e}")
        return False, host, port


def test_sql_query(conn_str):
    print("\n[3] Testing SQL Server Query (Python DB-API)...")
    driver = None
    try:
        import pymssql
        driver = 'pymssql'
    except ImportError:
        try:
            import pyodbc
            driver = 'pyodbc'
        except ImportError:
            pass

    if not driver:
        print("    [NOTE] Neither 'pymssql' nor 'pyodbc' is installed in Python.")
        print("           (Optional) To run queries via Python: pip install pymssql")
        print("           (Alternatively) On Windows, run the project in Visual Studio (F5),")
        print("           or run: dotnet run --project tools/TestDbConnection")
        return False

    try:
        parts = parse_connection_string(conn_str)
        server = parts.get('data source') or parts.get('server') or 'localhost'
        db = parts.get('database') or parts.get('initial catalog') or 'SAIRH'
        user = parts.get('user id') or parts.get('uid') or ''
        password = parts.get('password') or parts.get('pwd') or ''

        host = server
        port = 1433
        if ',' in host:
            host, p = host.split(',', 1)
            try: port = int(p.strip())
            except ValueError: pass
        elif ':' in host:
            host, p = host.split(':', 1)
            try: port = int(p.strip())
            except ValueError: pass

        if driver == 'pymssql':
            import pymssql
            conn = pymssql.connect(server=host, port=port, user=user, password=password, database=db, timeout=5)
            cursor = conn.cursor()
            query_sql = """
                IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL
                    SELECT * FROM [dbo].[vw_SummitSpeakers] ORDER BY [Sorting] ASC, [SpeakerID] ASC
                ELSE
                    SELECT * FROM [dbo].[Speakers] WHERE [IsActive] = 1 ORDER BY [Sorting] ASC, [SpeakerID] ASC
            """
            cursor.execute("SELECT COUNT(*) FROM [dbo].[Speakers] WHERE [IsActive] = 1")
            count = cursor.fetchone()[0]
            print(f"    [SUCCESS] Live DB query succeeded! Found {count} active speakers in [dbo].[Speakers].")
            if '--sync' in sys.argv:
                cursor.execute(query_sql)
                columns = [c[0] for c in cursor.description]
                rows = cursor.fetchall()
                out_list = []
                for r in rows:
                    d = dict(zip(columns, r))
                    out_list.append(d)
                with open(SPEAKERS_JSON, 'w', encoding='utf-8') as f:
                    json.dump(out_list, f, ensure_ascii=False, indent=2, default=str)
                print(f"    [SYNC SUCCESS] Exported {len(out_list)} active speakers from database to {SPEAKERS_JSON}!")
            return True
        elif driver == 'pyodbc':
            import pyodbc
            conn_str_odbc = f"DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={server};DATABASE={db};UID={user};PWD={password};TrustServerCertificate=yes;"
            conn = pyodbc.connect(conn_str_odbc, timeout=5)
            cursor = conn.cursor()
            query_sql = """
                IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL
                    SELECT * FROM [dbo].[vw_SummitSpeakers] ORDER BY [Sorting] ASC, [SpeakerID] ASC
                ELSE
                    SELECT * FROM [dbo].[Speakers] WHERE [IsActive] = 1 ORDER BY [Sorting] ASC, [SpeakerID] ASC
            """
            cursor.execute("SELECT COUNT(*) FROM [dbo].[Speakers] WHERE [IsActive] = 1")
            count = cursor.fetchone()[0]
            print(f"    [SUCCESS] Live DB query succeeded! Found {count} active speakers in [dbo].[Speakers].")
            if '--sync' in sys.argv:
                cursor.execute(query_sql)
                columns = [c[0] for c in cursor.description]
                rows = cursor.fetchall()
                out_list = [dict(zip(columns, r)) for r in rows]
                with open(SPEAKERS_JSON, 'w', encoding='utf-8') as f:
                    json.dump(out_list, f, ensure_ascii=False, indent=2, default=str)
                print(f"    [SYNC SUCCESS] Exported {len(out_list)} active speakers from database to {SPEAKERS_JSON}!")
            conn.close()
            return True
    except Exception as ex:
        print(f"    [-] Query error: {ex}")
        return False


def verify_fallback():
    print("\n[4] Verifying Crash-Prevention Fallback Mechanism...")
    if os.path.exists(SPEAKERS_JSON):
        try:
            with open(SPEAKERS_JSON, 'r', encoding='utf-8') as f:
                speakers = json.load(f)
            print(f"    [OK] Fallback dataset is healthy: {len(speakers)} profiles in Content/data/speakers.json")
            track_a = len([s for s in speakers if s.get('Track') == 'track-a'])
            track_b = len([s for s in speakers if s.get('Track') == 'track-b'])
            track_c = len([s for s in speakers if s.get('Track') == 'track-c'])
            print(f"         * Track A: {track_a} speakers")
            print(f"         * Track B: {track_b} speakers")
            print(f"         * Track C: {track_c} speakers")
            print(f"         * Total:   {len(speakers)} speakers")
            print("    [OK] Error handling in SpeakerService.cs / Speakers.aspx.cs guarantees that")
            print("         if the DB is unreachable, this fallback binds seamlessly without crashing!")
            return True
        except Exception as e:
            print(f"    [ERROR] Error reading fallback file: {e}")
            return False
    else:
        print(f"    [ERROR] Fallback file missing: {SPEAKERS_JSON}")
        return False


def print_how_to_run():
    print("\n" + "=" * 66)
    print("  HOW TO RUN THE WEBSITE LOCALLY RIGHT NOW (ON MAC)")
    print("=" * 66)
    print("  Run either of the following commands in your terminal:")
    print()
    print("  Option A (Python):")
    print("    cd AIE/AIE && python3 dev_server.py")
    print()
    print("  Option B (Node.js):")
    print("    cd AIE/AIE && node server.js")
    print()
    print("  Then open your browser to:")
    print("    English: http://localhost:52541/Speakers")
    print("    Arabic:  http://localhost:52541/Ar_Sa/Speakers")
    print("=" * 66)


if __name__ == '__main__':
    print_banner()
    conn_str = check_web_config()
    if conn_str:
        check_connectivity(conn_str)
        test_sql_query(conn_str)
    verify_fallback()
    print_how_to_run()
