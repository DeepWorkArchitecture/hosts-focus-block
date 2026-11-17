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
# Make sure the block starts on its own line.
if [ -s "$HOSTS_FILE" ] && [ -n "$(tail -c1 "$HOSTS_FILE")" ]; then echo >> "$HOSTS_FILE"; fi
{
  echo "$MARKER_START"
  for d in "${DOMAINS[@]}"; do
    # IPv4 and IPv6, so the site can't load over IPv6 instead.
    echo "127.0.0.1 $d"
    echo "127.0.0.1 www.$d"
    echo "::1 $d"
    echo "::1 www.$d"
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
