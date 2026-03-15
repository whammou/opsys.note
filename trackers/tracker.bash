#!/usr/bin/env bash
# FZF-based notification viewer with clipboard copy
# Format: $TITLE - $SUMMARY

# Get notification history as JSON
history_json=$(dunstctl history)

# Parse JSON and format for fzf
# Each line: "TITLE - SUMMARY"
echo "$history_json" | jq -r '
  .data[] | 
  .[] | 
  select(.summary != null) |
  "\(.summary.data) - \(.body.data // "")"
' | awk 'NF > 0' | fzf --prompt="Select notification: " \
  --preview='echo "Selected: {}"' \
  --bind='enter:execute(echo "{}" | wl-copy)+abort' \
  --header='Press Enter to copy to clipboard'
