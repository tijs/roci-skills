#!/bin/bash
# Create a GitHub issue in tijs/roci-agent

TITLE="$1"
BODY="$2"
LABELS="${3:-}"

if [ -z "$TITLE" ] || [ -z "$BODY" ]; then
    echo "Usage: create-issue.sh 'title' 'body' ['labels']"
    exit 1
fi

if [ -n "$LABELS" ]; then
    gh issue create --repo tijs/roci-agent --title "$TITLE" --body "$BODY" --label "$LABELS"
else
    gh issue create --repo tijs/roci-agent --title "$TITLE" --body "$BODY"
fi
