#!/usr/bin/env node
/**
 * SAIRH 2026 - Standalone Node.js Database Speakers Synchronizer
 * Connects directly to SQL Server database 'SAIRH', queries [dbo].[vw_SummitSpeakers],
 * and writes the active speakers to Content/data/speakers.json.
 */

const fs = require('fs');
const path = require('path');

const ROOT_DIR = path.dirname(__dirname);
const BASE_DIR = path.join(ROOT_DIR, 'AIE', 'AIE');
const SPEAKERS_JSON = path.join(BASE_DIR, 'Content', 'data', 'speakers.json');

async function syncSpeakers() {
  console.log('==================================================================');
  console.log('   SAIRH 2026 - Database Speakers Synchronizer (Node.js)         ');
  console.log('==================================================================');

  let sql;
  try {
    sql = require(path.join(BASE_DIR, 'node_modules', 'mssql'));
  } catch (e) {
    try {
      sql = require('mssql');
    } catch (e2) {
      console.error('[ERROR] Could not load mssql module:', e2.message);
      process.exit(1);
    }
  }

  // Parse Web.config connection string
  let host = 'localhost';
  let port = 14333;
  let database = 'SAIRH';
  let user = 'sa';
  let password = process.env.SA_PASSWORD || 'SAdaleenRH@1013';

  const webConfig = path.join(BASE_DIR, 'Web.config');
  if (fs.existsSync(webConfig)) {
    const content = fs.readFileSync(webConfig, 'utf8');
    const m = content.match(/name=["']AIEConnectionString["']\s+connectionString=["']([^"']+)["']/i);
    if (m) {
      const parts = {};
      m[1].split(';').forEach(p => {
        const idx = p.indexOf('=');
        if (idx > -1) parts[p.slice(0, idx).trim().toLowerCase()] = p.slice(idx + 1).trim();
      });
      const srv = parts['server'] || parts['data source'] || 'localhost';
      if (srv.includes(',')) {
        const sp = srv.split(',');
        host = sp[0].trim();
        port = parseInt(sp[1].trim(), 10) || 14333;
      }
      database = parts['database'] || parts['initial catalog'] || 'SAIRH';
      user = parts['user id'] || parts['uid'] || 'sa';
      password = parts['password'] || parts['pwd'] || password;
    }
  }

  const configs = [
    { user, password, server: host, port, database, options: { trustServerCertificate: true, encrypt: false, connectTimeout: 5000 } },
    { user: 'sa', password: 'SAdaleenRH@1013', server: 'localhost', port: 14333, database: 'SAIRH', options: { trustServerCertificate: true, encrypt: false, connectTimeout: 5000 } },
    { user: 'sa', password: 'SairhPass2026!', server: 'localhost', port: 14333, database: 'SAIRH_DB', options: { trustServerCertificate: true, encrypt: false, connectTimeout: 5000 } }
  ];

  let pool = null;
  for (const cfg of configs) {
    try {
      console.log(`[Connecting] SQL Server at ${cfg.server}:${cfg.port}/${cfg.database}...`);
      pool = await new sql.ConnectionPool(cfg).connect();
      console.log(`[+] Connected successfully to ${cfg.database}!`);
      break;
    } catch (e) {
      // try next
    }
  }

  if (!pool) {
    console.error('[-] Could not connect to SQL Server on any tested configuration.');
    process.exit(1);
  }

  try {
    const q = `
      IF OBJECT_ID(N'[dbo].[vw_SummitSpeakers]', N'V') IS NOT NULL
      BEGIN
          SELECT * FROM [dbo].[vw_SummitSpeakers] ORDER BY [Sorting] ASC, [SpeakerID] ASC;
      END
      ELSE IF OBJECT_ID(N'[dbo].[Sessions]', N'U') IS NOT NULL
      BEGIN
          SELECT s.*, 
                 sess.[SessionID],
                 sess.[TitleEn] AS [LectureTitleEn],
                 sess.[TitleAr] AS [LectureTitleAr],
                 sess.[Track] AS [Track],
                 sess.[TrackNameEn] AS [TrackNameEn],
                 sess.[TrackNameAr] AS [TrackNameAr],
                 sess.[RoomEn], sess.[RoomAr],
                 sess.[DayNumber], sess.[StartTime], sess.[EndTime],
                 sess.[RoleEn] AS [SessionRoleEn], sess.[RoleAr] AS [SessionRoleAr]
          FROM [dbo].[Speakers] s
          LEFT JOIN [dbo].[Sessions] sess ON s.[SpeakerID] = sess.[SpeakerID]
          WHERE s.[IsActive] = 1
          ORDER BY s.[Sorting] ASC, s.[SpeakerID] ASC;
      END
      ELSE
      BEGIN
          SELECT * FROM [dbo].[Speakers] WHERE [IsActive] = 1 ORDER BY [Sorting] ASC, [SpeakerID] ASC;
      END
    `;

    const res = await pool.request().query(q);
    const speakers = res.recordset || [];
    console.log(`[+] Retrieved ${speakers.length} active speakers from database.`);

    fs.writeFileSync(SPEAKERS_JSON, JSON.stringify(speakers, null, 2), 'utf8');
    console.log(`[+] Successfully wrote updated speakers to ${SPEAKERS_JSON}!`);

    const trackA = speakers.filter(s => (s.Track || '').toLowerCase() === 'track-a').length;
    const trackB = speakers.filter(s => (s.Track || '').toLowerCase() === 'track-b').length;
    const trackC = speakers.filter(s => (s.Track || '').toLowerCase() === 'track-c').length;
    console.log(`    * Track A: ${trackA}`);
    console.log(`    * Track B: ${trackB}`);
    console.log(`    * Track C: ${trackC}`);
    console.log(`    * Total:   ${speakers.length}`);

    await pool.close();
    process.exit(0);
  } catch (err) {
    console.error('[-] Query execution error:', err.message);
    if (pool) await pool.close();
    process.exit(1);
  }
}

syncSpeakers();
