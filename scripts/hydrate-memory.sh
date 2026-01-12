#!/bin/bash
# SessionStart Hook: Prepare memory context for session
# Non-blocking: Session läuft auch wenn Memory nicht verfügbar ist

# Einfache Hook - bereitet Umgebung vor
# Die eigentliche recall() wird der User in der Session machen

echo '{"continue":true,"suppressOutput":true}' | jq .
exit 0
