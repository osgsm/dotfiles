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
printf " ${CYAN}󰉋 %s${RESET}\n" "$display_cwd"

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
  used_rounded=$(printf '%.1f' "$used")
  context_part="${MAGENTA}󰧑 ${bar_color}${bar}${RESET} ${used_rounded}%"
else
  context_part="${MAGENTA}󰧑 ${WHITE}░░░░░░░░░░${RESET} 0%"
fi

# Rate limit info
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
five_hour_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
seven_day_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

rate_color() {
  local pct="${1:-0}"
  local int_pct=$(printf '%.0f' "$pct")
  if [ "$int_pct" -ge 80 ] 2>/dev/null; then
    printf "%s" "$RED"
  elif [ "$int_pct" -ge 60 ] 2>/dev/null; then
    printf "%s" "$YELLOW"
  else
    printf "%s" "$GREEN"
  fi
}

five_hour_part=""
if [ -n "$five_hour_reset" ]; then
  five_hour_time=$(date -r "$five_hour_reset" +%H:%M 2>/dev/null || date -d "@$five_hour_reset" +%H:%M 2>/dev/null)
  five_hour_color=$(rate_color "$five_hour_used")
  five_hour_rounded=$(printf '%.1f' "${five_hour_used:-0}")
  five_hour_part="${WHITE}5h ${five_hour_color}${five_hour_rounded}%${WHITE} ${five_hour_time}"
else
  five_hour_part="${WHITE}5h ${GREEN}0%${WHITE} --:--"
fi

seven_day_part=""
if [ -n "$seven_day_reset" ]; then
  seven_day_time=$(date -r "$seven_day_reset" +"%m/%d %H:%M" 2>/dev/null || date -d "@$seven_day_reset" +"%m/%d %H:%M" 2>/dev/null)
  seven_day_color=$(rate_color "$seven_day_used")
  seven_day_rounded=$(printf '%.1f' "${seven_day_used:-0}")
  seven_day_part="${WHITE}7d ${seven_day_color}${seven_day_rounded}%${WHITE} ${seven_day_time}"
else
  seven_day_part="${WHITE}7d ${GREEN}0%${WHITE} --"
fi

rate_limit_part="${WHITE}󰔛 ${five_hour_part}  ${seven_day_part}${RESET}"

# Model
model_part="${BLUE}󱜚 ${model}${RESET}"

# Line 2: git info, Line 3: context + model, Line 4: rate limit resets
if [ -n "$repo_name" ]; then
  printf "  ${YELLOW}󰳏 %s${RESET} ${GREEN} %s${RESET}  %b\n" "$repo_name" "$branch_name" "$diff_part"
  printf "  %b  %b\n" "$context_part" "$model_part"
else
  printf "  %b  %b\n" "$context_part" "$model_part"
fi
printf "  %b\n" "$rate_limit_part"
