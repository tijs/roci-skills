---
name: github-issue
description: Create a GitHub issue in the roci-agent repository. Use when you identify a bug, improvement, or feature that should be tracked or implemented. Mention @claude in the body to trigger Claude Code to create a PR.
---

# Create GitHub Issue

Use this skill to file issues for roci-agent improvements.

## Parameters
- **title**: Issue title (required)
- **body**: Issue description (required)
- **labels**: Comma-separated labels (optional, e.g., "enhancement,bug")

## Steps

1. Run the create-issue script from the skill directory:
   ```bash
   cd /home/tijs/roci/state/skills/github-issue && ./scripts/create-issue.sh "TITLE" "BODY" "LABELS"
   ```

2. The script will create the issue and return the URL.

## Tips
- Be specific about what needs to change
- Include file paths if known
- Mention @claude in the body to have Claude Code create a PR
- Available labels: enhancement, bug, documentation
