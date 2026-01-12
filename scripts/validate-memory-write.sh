#!/bin/bash
# PostToolUse Hook: Validate remember() write succeeded
# Blocking: Stop if write failed, User sieht Error sofort

set -euo pipefail

# Hook input vom Claude Code System
INPUT=$(cat)

# Extrahiere Error aus Tool Result
ERROR=$(echo "$INPUT" | jq -r '.tool_result.error // empty' 2>/dev/null || echo "")

# Wenn Error vorhanden: Blocking Error (continue: false)
if [ -n "$ERROR" ]; then
  echo '{
    "continue": false,
    "stopReason": "Memory write failed - check API key and network: '"$ERROR"'"
  }' | jq .
  exit 0
fi

# Success: Continue (silent)
echo '{"continue":true,"suppressOutput":true}' | jq .
exit 0
