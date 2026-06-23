#!/usr/bin/env bash
#
# serve.sh — serve "murder to go" locally and print a URL you can open on your phone.
#
# Usage:
#   ./serve.sh            # serves on port 8000
#   ./serve.sh 9000       # serves on a custom port
#
# Your phone must be on the SAME Wi-Fi as this computer. Then open the
# "On your phone" URL printed below in your phone's browser.

set -euo pipefail

PORT="${1:-8000}"
SITE_DIR="murder to go"

# Run from the repo root (the directory this script lives in).
cd "$(dirname "$0")"

if [ ! -d "$SITE_DIR" ]; then
  echo "Could not find '$SITE_DIR' next to this script." >&2
  exit 1
fi

# Best-effort detection of this machine's LAN IP across macOS and Linux.
detect_ip() {
  if command -v ipconfig >/dev/null 2>&1; then          # macOS
    ipconfig getifaddr en0 2>/dev/null && return 0
    ipconfig getifaddr en1 2>/dev/null && return 0
  fi
  if command -v hostname >/dev/null 2>&1; then           # Linux (most distros)
    hostname -I 2>/dev/null | awk '{print $1}' | grep -E '^[0-9]' && return 0
  fi
  if command -v ip >/dev/null 2>&1; then                 # Linux fallback
    ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' | grep -E '^[0-9]' && return 0
  fi
  return 1
}

IP="$(detect_ip || true)"

echo
echo "Serving '$SITE_DIR' on port $PORT"
echo "  On this computer: http://localhost:$PORT"
if [ -n "${IP:-}" ]; then
  echo "  On your phone:    http://$IP:$PORT   (same Wi-Fi required)"
else
  echo "  On your phone:    http://<this-computer's-IP>:$PORT   (couldn't auto-detect IP)"
fi
echo
echo "Press Ctrl+C to stop."
echo

cd "$SITE_DIR"
exec python3 -m http.server "$PORT"
