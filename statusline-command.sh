#!/usr/bin/env bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# ANSI color codes
RESET="\033[0m"
CYAN="\033[36m"
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
BLUE="\033[34m"
MAGENTA="\033[35m"
WHITE="\033[37m"

# Shorten home directory to ~
home_dir="$HOME"
display_cwd="${cwd/#$home_dir/~}"

# Line 1: current directory
printf " ${CYAN}󰉋  %s${RESET}\n" "$display_cwd"

# Git info
repo_name=""
branch_name=""
diff_part=""

if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  repo_name=$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null)
  branch_name=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  diff_count=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$diff_count" -gt 0 ] 2>/dev/null; then
    diff_part="${YELLOW} *${diff_count}${RESET}"
  else
    diff_part="${GREEN} clean${RESET}"
  fi
fi

# Context progress bar (10 blocks wide)
context_part=""
if [ -n "$used" ]; then
  filled=$(echo "$used" | awk '{printf "%d", ($1 / 10 + 0.5)}')
  empty=$((10 - filled))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty); do bar="${bar}░"; done
  # Color bar based on usage level
  if [ "$filled" -ge 8 ]; then
    bar_color="$RED"
  elif [ "$filled" -ge 6 ]; then
    bar_color="$YELLOW"
  else
    bar_color="$GREEN"
  fi
  context_part="${MAGENTA}󰧑 ${bar_color}${bar}${RESET} ${used}%"
else
  context_part="${MAGENTA}󰧑 ${WHITE}░░░░░░░░░░${RESET} -%"
fi

# Rate limit reset time
reset_hour=$(date -v+1H +%H:00 2>/dev/null || date -d '+1 hour' +%H:00 2>/dev/null)
reset_part="${WHITE}󰔛 ${reset_hour}${RESET}"

# Model
model_part="${BLUE}󱜚 ${model}${RESET}"

# Line 2: git info (repo | branch  diff), Line 3: context  reset  model
if [ -n "$repo_name" ]; then
  printf "  ${YELLOW}󰳏 %s${RESET} ${GREEN} %s${RESET}  %b\n" "$repo_name" "$branch_name" "$diff_part"
  printf "  %b  %b  %b\n" "$context_part" "$reset_part" "$model_part"
else
  printf "  %b  %b  %b\n" "$context_part" "$reset_part" "$model_part"
fi
