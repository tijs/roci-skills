# roci-skills

Learnable skills for Roci AI agent.

## Structure

Each skill is a markdown file with YAML frontmatter:

```markdown
---
name: skill-name
description: What this skill does
tools_required: [Bash, Read]
---

# Skill Instructions

Step-by-step instructions for the agent to follow.
```

## Skills

Skills are higher-level capabilities that compose tools. Unlike tools (always loaded), skills are loaded on demand and can be created by the agent.

## Usage

The agent has three tools for working with skills:
- `list_skills` - List all available skills
- `run_skill` - Execute a skill by name
- `create_skill` - Create or update a skill (commits to git)
