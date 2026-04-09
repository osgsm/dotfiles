#!/bin/bash
# detect-dev-url.sh
# Detect the dev server URL and open a browser in the caller's pane
#
# Usage:
#   ./detect-dev-url.sh <monitor-surface>

set -euo pipefail

MONITOR_SURFACE="${1:?Usage: detect-dev-url.sh <surface-ref>}"

echo "⏳ Waiting for dev server on $MONITOR_SURFACE..."

# --- Detect URL ---
URL=""
for i in $(seq 1 60); do
  OUTPUT=$(cmux read-screen --surface "$MONITOR_SURFACE" --scrollback 2>/dev/null || true)
  URL=$(echo "$OUTPUT" | grep -oE 'https?://localhost:[0-9]+' | head -1)
  if [ -n "$URL" ]; then
    break
  fi
  sleep 1
done

if [ -z "$URL" ]; then
  echo "⚠️ URL not detected after 60s"
  cmux notify --title "⚠️ detect-dev-url" --body "URL not detected after 60s"
  exit 1
fi

echo "🌐 Detected: $URL"

# --- Get own surface and pane ---
SELF=$(cmux --json identify)
SELF_SURFACE=$(echo "$SELF" | jq -r '.caller.surface_ref')
SELF_PANE=$(echo "$SELF" | jq -r '.caller.pane_ref')

# --- Open browser in own pane ---
cmux --json new-surface --type browser --pane "$SELF_PANE" --url "$URL"

# --- Close own terminal ---
cmux close-surface --surface "$SELF_SURFACE"
