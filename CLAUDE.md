# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Overview

This is the skills repository for Roci, an AI productivity agent. Skills follow
the **Agent Skills open standard** ([agentskills.io](https://agentskills.io)).

## What are Skills?

Skills are directories containing instructions and optional scripts that teach
the agent how to perform specific tasks. They are:

- **Higher-level** than tools (compose multiple tools)
- **Loaded on demand** (not always in context)
- **Learnable** (agent can create new skills via `create_skill` tool)
- **Interoperable** (work with Claude Code, Cursor, other compatible agents)

## Skill Structure

```
skill-name/
├── SKILL.md         # Required: frontmatter + instructions
├── scripts/         # Optional: executable scripts (.sh, .js, .py)
├── references/      # Optional: supporting docs
└── assets/          # Optional: binary resources
```

## SKILL.md Format

```markdown
---
name: skill-name
description: What it does AND when to use it
---

# Title

Instructions the agent follows when this skill is invoked.
```

### Required Fields

- **name**: Lowercase, hyphens only, 1-64 chars, must match directory name
- **description**: 1-1024 chars, include both "what" and "when to use"

### Optional Fields

- **license**: License identifier
- **compatibility**: Environment requirements
- **allowed-tools**: Pre-approved tools (space-delimited)

## How Skills Execute

1. User asks agent to do something
2. Agent calls `run_skill` to load the skill
3. Agent receives SKILL.md instructions
4. Agent follows instructions, executing scripts via Bash as needed
5. Agent reports results to user

**Key insight**: Skills don't auto-execute. The agent reads instructions and
decides how to proceed, which may include running scripts in `scripts/`.

## Creating Skills

### Via create_skill Tool

The agent can create skills programmatically:

```javascript
create_skill({
  name: "new-skill",
  description: "Does X. Use when Y.",
  instructions: "# Steps\n1. First...\n2. Then...",
  scripts: [{ name: "run.sh", content: "#!/bin/bash\n..." }],
});
```

This creates the directory, writes SKILL.md and scripts, and commits to git.

### Manually

1. Create directory: `mkdir skill-name`
2. Create `skill-name/SKILL.md` with frontmatter + instructions
3. Optionally add `scripts/` with executable scripts
4. Commit and push

## Available Skills

| Skill          | Purpose                 | Scripts             |
| -------------- | ----------------------- | ------------------- |
| server-version | System version info     | check.sh            |
| uptime         | Server health/resources | check.sh            |
| service-status | Roci service status     | status.sh           |
| deploy         | Deploy services         | (instructions only) |
| check-logs     | View service logs       | (instructions only) |

## Git Workflow

This repo has a deploy key on the VPS with write access. When the agent creates
or updates skills via `create_skill`, changes are automatically committed and
pushed.

To pull updates on VPS:

```bash
ssh roci 'cd ~/roci/skills && git pull'
```

## Development Notes

- Scripts must be executable (`chmod +x`)
- Use absolute paths in instructions (e.g., `/home/tijs/roci/skills/...`)
- Keep descriptions under 1024 chars but be specific about "when to use"
- Test scripts manually before committing
