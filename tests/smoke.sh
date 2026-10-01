#!/usr/bin/env bash
# Smoke test: syntax, version, and help.
set -euo pipefail
cd "$(dirname "$0")/.."
bash -n GmapsXploit.sh
./GmapsXploit.sh --version | grep -q "GmapsXploit"
./GmapsXploit.sh --help | grep -q "Usage"
echo "smoke ok"
