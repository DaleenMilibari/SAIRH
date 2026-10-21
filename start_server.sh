#!/bin/bash
# ==============================================================================
# SAIRH - Saudi AI in Radiology Platform Local Server Launcher (Root)
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR/AIE/AIE"

echo "=========================================================="
echo "  Starting SAIRH AI in Radiology Platform Local Server    "
echo "  HTTPS: https://localhost:7198"
echo "  HTTP:  http://localhost:52541"
echo "=========================================================="

if command -v node &> /dev/null; then
    node server.js
elif command -v python3 &> /dev/null; then
    python3 dev_server.py
elif command -v python &> /dev/null; then
    python dev_server.py
else
    echo "Error: Neither Node.js nor Python 3 found."
    exit 1
fi
