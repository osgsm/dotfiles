#!/bin/bash
# web-dev-layout.sh

set -euo pipefail

# --- 1. Split left → run dev (Neovim) ---
SELF=$(cmux --json identify | jq -r '.caller.surface_ref')
S_DEV=$(cmux --json new-split left --surface "$SELF" | jq -r '.surface_ref')
cmux send --surface "$S_DEV" "dev -s ."
cmux send-key --surface "$S_DEV" enter

# --- 2. Split down from SELF (right side) → for URL detection ---
S3=$(cmux --json new-split down --surface "$SELF" | jq -r '.surface_ref')

# --- 3. Split right from SELF → second Claude Code ---
S4=$(cmux --json new-split right --surface "$SELF" | jq -r '.surface_ref')

# --- 4. Focus the dev pane ---
P_DEV=$(cmux --json tree | jq -r --arg s "$S_DEV" '
  .windows[].workspaces[] | select(.selected) |
  .panes[] | select(.surfaces[].ref == $s) | .ref
' | head -1)
cmux focus-pane --pane "$P_DEV"

# --- 5. Rename workspace to cwd ---
cmux rename-workspace "$(basename "$PWD")"

# --- 6. Start URL detection on S3 ---
sleep 1
cmux send --surface "$S3" "~/.config/cmux/scripts/detect-dev-url.sh $S_DEV"
cmux send-key --surface "$S3" enter

# --- 7. Launch Claude Code ---
cmux send --surface "$S4" "clear"
cmux send-key --surface "$S4" enter
cmux send --surface "$S4" "claude"
cmux send-key --surface "$S4" enter
cmux send --surface "$SELF" "clear"
cmux send-key --surface "$SELF" enter
cmux send --surface "$SELF" "claude"
cmux send-key --surface "$SELF" enter
