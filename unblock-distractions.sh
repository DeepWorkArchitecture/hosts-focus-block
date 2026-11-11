#!/usr/bin/env bash
# Removes the block. Run with: sudo ./unblock-distractions.sh
set -euo pipefail
HOSTS_FILE="${HOSTS_FILE:-/etc/hosts}"
sed -i.bak "/# >>> dev-execution-block >>>/,/# <<< dev-execution-block <<</d" "$HOSTS_FILE"
if command -v dscacheutil &> /dev/null; then
  dscacheutil -flushcache
  killall -HUP mDNSResponder 2>/dev/null || true
elif command -v resolvectl &> /dev/null; then
  resolvectl flush-caches || true
fi
echo "Block removed."
