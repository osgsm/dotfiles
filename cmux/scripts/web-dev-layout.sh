#!/bin/bash
# web-dev-layout.sh

set -euo pipefail

# --- 0. Close all other surfaces in the current workspace ---
SELF=$(cmux --json identify | jq -r '.caller.surface_ref')
cmux --json tree | jq -r --arg self "$SELF" '
  .windows[].workspaces[] | select(.selected) |
  .panes[].surfaces[] | select(.ref != $self) | .ref
' | while read -r surf; do
  cmux close-surface --surface "$surf"
done

# --- 1. Split left → run dev (Neovim) ---
S_DEV=$(cmux --json new-split left --surface "$SELF" | jq -r '.surface_ref')
cmux send --surface "$S_DEV" "dev -s ."
cmux send-key --surface "$S_DEV" enter

# --- 2. Split right from SELF → second Claude Code ---
S4=$(cmux --json new-split right --surface "$SELF" | jq -r '.surface_ref')

# --- 3. Focus the dev pane ---
P_DEV=$(cmux --json tree | jq -r --arg s "$S_DEV" '
  .windows[].workspaces[] | select(.selected) |
  .panes[] | select(.surfaces[].ref == $s) | .ref
' | head -1)
cmux focus-pane --pane "$P_DEV"

# --- 4. Rename workspace to cwd ---
cmux rename-workspace "$(basename "$PWD")"

# --- 5. Detect dev URL in the background and open it in the external browser ---
nohup ~/.config/cmux/scripts/detect-dev-url.sh "$S_DEV" >/dev/null 2>&1 &
disown

# --- 6. Launch Claude Code ---
cmux send --surface "$S4" "clear"
cmux send-key --surface "$S4" enter
cmux send --surface "$S4" "claude"
cmux send-key --surface "$S4" enter
cmux send --surface "$SELF" "clear"
cmux send-key --surface "$SELF" enter
cmux send --surface "$SELF" "claude"
cmux send-key --surface "$SELF" enter
