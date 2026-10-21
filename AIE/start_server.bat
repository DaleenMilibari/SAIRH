@echo off
setlocal
cd /d "%~dp0AIE"

echo ==========================================================
echo   Starting SAIRH AI in Radiology Platform Local Server
echo   HTTPS: https://localhost:7198
echo   HTTP:  http://localhost:52541
echo ==========================================================

where node >nul 2>nul
if %ERRORLEVEL% equ 0 (
    node server.js
    goto :eof
)

where python >nul 2>nul
if %ERRORLEVEL% equ 0 (
    python dev_server.py
    goto :eof
)

where py >nul 2>nul
if %ERRORLEVEL% equ 0 (
    py dev_server.py
    goto :eof
)

echo [ERROR] Neither Node.js nor Python was found on PATH.
echo Please install Node.js (https://nodejs.org) or Python (https://python.org).
pause
