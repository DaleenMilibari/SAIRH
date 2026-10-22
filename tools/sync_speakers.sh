#!/bin/bash
# ==============================================================================
# SAIRH 2026 - Sync Speakers from Database to Website
# Runs TestDbConnection with --sync to fetch all active speakers from SQL Server
# and immediately update AIE/AIE/Content/data/speakers.json
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=================================================================="
echo "   SAIRH 2026 - Database Speakers Synchronizer   "
echo "=================================================================="

cd "$ROOT_DIR" || exit 1

# 1. Try Node.js first since mssql is installed and fast on macOS & Linux
if command -v node &> /dev/null; then
    node "$ROOT_DIR/tools/sync_speakers.js"
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        echo ""
        echo "[DONE] Database changes are now synchronized with the website!"
        echo "Refresh http://localhost:52541/Speakers in your browser."
        exit 0
    fi
fi

echo "Attempting .NET sync..."
DOTNET_CLI_HOME=/tmp dotnet run --project tools/TestDbConnection --sync

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "[DONE] Database changes are now synchronized with the website!"
    echo "Refresh http://localhost:52541/Speakers in your browser."
else
    echo ""
    echo "[!] .NET sync failed (exit code $EXIT_CODE)."
    echo "Attempting Python sync fallback..."
    python3 tools/test_db.py --sync
fi
