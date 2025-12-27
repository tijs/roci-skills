# Skill Creation Best Practices

Detailed patterns and guidelines for creating effective skills.

## Progressive Disclosure

Skills use a loading system to manage context efficiently:

1. **Metadata** (name + description) - Always visible for skill discovery
2. **SKILL.md body** - Loaded when skill is invoked
3. **References** - Loaded only when needed

### Pattern: High-level guide with references

```markdown
# PDF Processing

## Quick start

Extract text with pdfplumber: [code example]

## Advanced features

- **Form filling**: See [references/forms.md](references/forms.md)
- **API reference**: See [references/api.md](references/api.md)
```

### Pattern: Domain-specific organization

For skills with multiple domains, organize by domain:

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md
    ├── sales.md
    └── product.md
```

When asked about sales, only read sales.md.

## Writing Guidelines

### Use Imperative Form

```markdown
# Good

Run the backup script. Check the service status.

# Bad

You should run the backup script. The backup script can be run.
```

### Be Specific in Descriptions

```markdown
# Good

description: Check VPS system versions including Node.js, Python, and kernel.
Use when asked about server specs, versions, or system health.

# Bad

description: Check server stuff.
```

### Include "When to Use" in Description

The description is the ONLY thing visible before the skill loads. Include
triggers:

```markdown
description: Create timestamped backups of the state directory. Use when asked
to backup memory, before making risky changes, or for regular state snapshots.
```

## Script Guidelines

### When to Create Scripts

Create scripts when:

- Same code is rewritten repeatedly
- Deterministic reliability is needed
- Complex command sequences must be preserved

### Script Best Practices

```bash
#!/bin/bash
# Always include shebang

# Add helpful output
echo "=== Starting backup ==="

# Handle errors gracefully
if [ ! -d "$DIR" ]; then
  echo "Error: Directory not found"
  exit 1
fi

# Show results
echo "=== Complete ==="
```

### Test Before Including

Always run scripts manually before adding to a skill:

```bash
chmod +x scripts/check.sh
./scripts/check.sh
```

## What NOT to Include

- README.md (SKILL.md is the documentation)
- CHANGELOG.md
- Installation guides
- User-facing docs (skills are for agents)

The skill should only contain what's needed for the agent to do the job.

## Common Mistakes

### Too Verbose

```markdown
# Bad - unnecessary explanation

This skill is designed to help you check the server version. When you use this
skill, it will gather information about...

# Good - direct instructions

Run the check script: \`\`\`bash bash scripts/check.sh \`\`\`
```

### Missing Triggers in Description

```markdown
# Bad - when would this be used?

description: Handles server operations

# Good - clear triggers

description: Check server uptime and resource usage. Use when asked about server
health, memory usage, disk space, or how long the server has been running.
```

### Hardcoded Paths

```markdown
# Bad - might break

bash check.sh

# Good - absolute path

bash /home/tijs/roci/skills/server-version/scripts/check.sh
```

## Iteration Workflow

1. Create initial skill with `create_skill`
2. Test with real tasks
3. Notice struggles or inefficiencies
4. Update skill with `create_skill` (it handles updates)
5. Test again
