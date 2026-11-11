#!/usr/bin/env bash
# Dev-Execution host block. Run with: sudo ./block-distractions.sh
# Edit DOMAINS first. Friction tool, not a security control.
set -euo pipefail
HOSTS_FILE="${HOSTS_FILE:-/etc/hosts}"
MARKER_START="# >>> dev-execution-block >>>"
MARKER_END="# <<< dev-execution-block <<<"
DOMAINS=(
  "twitter.com" "x.com" "reddit.com"
  "news.ycombinator.com" "facebook.com"
  "instagram.com" "youtube.com"
)
sed -i.bak "/$MARKER_START/,/$MARKER_END/d" "$HOSTS_FILE"
{
  echo "$MARKER_START"
  for d in "${DOMAINS[@]}"; do
    echo "127.0.0.1 $d"
    echo "127.0.0.1 www.$d"
  done
  echo "$MARKER_END"
} >> "$HOSTS_FILE"
if command -v dscacheutil &> /dev/null; then
  dscacheutil -flushcache
  killall -HUP mDNSResponder 2>/dev/null || true
elif command -v resolvectl &> /dev/null; then
  resolvectl flush-caches || true
fi
echo "Dev-Execution block active."
