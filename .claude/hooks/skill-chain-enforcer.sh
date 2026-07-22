#!/bin/bash
# Remind the next workflow phase on UserPromptSubmit.
set -e
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

CHAIN_DIR="/tmp/toktrack-chain-$SESSION_ID"
[ ! -d "$CHAIN_DIR" ] && exit 0

CURRENT=$(cat "$CHAIN_DIR/current" 2>/dev/null || echo "")

case "$CURRENT" in
  "implement")
    if [ ! -f "$CHAIN_DIR/verify-started" ]; then
      cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "## Skill Chain: /verify required\n\nAfter `/implement` completes, always call `/verify`.\n**Run it immediately without asking the user.**"
  }
}
EOF
      exit 0
    fi
    ;;
  "verify")
    if [ ! -f "$CHAIN_DIR/review-started" ]; then
      cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "## Skill Chain: /review required\n\nAfter `/verify` passes, always call `/review`.\n**Run it immediately without asking the user.**"
  }
}
EOF
      exit 0
    fi
    ;;
  "review")
    if [ ! -f "$CHAIN_DIR/wrap-started" ]; then
      cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "## Skill Chain: /wrap required\n\nAfter `/review` passes, always call `/wrap`.\n**Run it immediately without asking the user.**"
  }
}
EOF
      exit 0
    fi
    ;;
esac

echo '{}'
