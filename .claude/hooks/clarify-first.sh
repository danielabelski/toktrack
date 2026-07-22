#!/bin/bash
# Require /clarify on the first prompt of each session.
set -e
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
MARKER="/tmp/toktrack-clarify-$SESSION_ID"

[ -f "$MARKER" ] && exit 0
touch "$MARKER"

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "## First prompt: /clarify required\n\nThe first request of a session must run `/clarify` before proceeding."
  }
}
EOF
