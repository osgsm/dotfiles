#!/bin/bash
# dev-layout.sh

set -euo pipefail

# --- 1. Split left → run dev (Neovim) ---
SELF=$(cmux --json identify | jq -r '.caller.surface_ref')
S_DEV=$(cmux --json new-split left --surface "$SELF" | jq -r '.surface_ref')
cmux send --surface "$S_DEV" "dev ."
cmux send-key --surface "$S_DEV" enter

# --- 2. Split right from SELF (right side) → second Claude Code ---
S3=$(cmux --json new-split right --surface "$SELF" | jq -r '.surface_ref')

# --- 3. Focus the dev pane ---
P_DEV=$(cmux --json tree | jq -r --arg s "$S_DEV" '
  .windows[].workspaces[] | select(.selected) |
  .panes[] | select(.surfaces[].ref == $s) | .ref
' | head -1)
cmux focus-pane --pane "$P_DEV"

# --- 4. Rename workspace to cwd ---
cmux rename-workspace "$(basename "$PWD")"

# --- 5. Launch Claude Code ---
cmux send --surface "$S3" "clear"
cmux send-key --surface "$S3" enter
cmux send --surface "$S3" "claude"
cmux send-key --surface "$S3" enter
cmux send --surface "$SELF" "clear"
cmux send-key --surface "$SELF" enter
cmux send --surface "$SELF" "claude"
cmux send-key --surface "$SELF" enter
