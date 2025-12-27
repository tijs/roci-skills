# roci-skills

Skills for the Roci AI agent, following the
[Agent Skills open standard](https://agentskills.io).

## What are Skills?

Skills are directories containing instructions and scripts that extend an
agent's capabilities. Unlike tools (low-level primitives always available),
skills are higher-level, loaded on demand, and can be created by the agent
itself.

## Specification

This repository follows the **Agent Skills open standard**
([agentskills.io](https://agentskills.io)), enabling interoperability with
Claude Code, Cursor, and other compatible agents.

### Directory Structure

Each skill is a directory containing:

```
skill-name/
├── SKILL.md         # Required: YAML frontmatter + instructions
├── scripts/         # Optional: executable scripts
├── references/      # Optional: supporting documentation
└── assets/          # Optional: binary resources
```

### SKILL.md Format

```markdown
---
name: skill-name
description: What this skill does AND when to use it (max 1024 chars)
---

# Skill Title

Step-by-step instructions for the agent to follow. Reference scripts as
`scripts/name.sh` for the agent to execute.
```

### Required YAML Fields

| Field         | Description                                                             |
| ------------- | ----------------------------------------------------------------------- |
| `name`        | 1-64 chars, lowercase alphanumeric + hyphens, must match directory name |
| `description` | 1-1024 chars, explains functionality AND when to use it                 |

### Optional YAML Fields

| Field           | Description                                |
| --------------- | ------------------------------------------ |
| `license`       | License identifier                         |
| `compatibility` | Environment requirements (max 500 chars)   |
| `allowed-tools` | Space-delimited list of pre-approved tools |

## Available Skills

| Skill            | Description                         | Has Scripts         |
| ---------------- | ----------------------------------- | ------------------- |
| `server-version` | Check VPS system info and versions  | Yes                 |
| `uptime`         | Check server uptime and resources   | Yes                 |
| `service-status` | Check Roci service status           | Yes                 |
| `deploy`         | Deploy and restart services         | No                  |
| `check-logs`     | View service logs                   | No                  |
| `skill-creator`  | Guide for creating effective skills | No (has references) |

## Usage

The Roci agent has three tools for working with skills:

- **`list_skills`** - Discover available skills
- **`run_skill`** - Load a skill's instructions (agent then follows them)
- **`create_skill`** - Create or update a skill (auto-commits to git)

### How Skills Execute

1. Agent calls `run_skill` with skill name
2. SKILL.md instructions are returned to the agent
3. Agent follows instructions, using Bash to run any referenced scripts
4. Scripts output is used by the agent to complete the task

This follows the standard's "progressive disclosure" pattern - instructions load
on demand, not upfront.

## Creating New Skills

Skills can be created manually or by the agent using `create_skill`:

```javascript
create_skill({
  name: "my-skill",
  description: "What it does. When to use it.",
  instructions: "# Steps\n\n1. Do this\n2. Do that",
  scripts: [
    { name: "run.sh", content: "#!/bin/bash\necho 'Hello'" },
  ],
});
```

## License

MIT
