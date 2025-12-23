---
name: skill-creator
description: Guide for creating effective skills. Use when asked to create a new skill, update an existing skill, or learn a new capability that should be saved for reuse.
---

# Skill Creator

This skill provides guidance for creating effective skills following the Agent Skills open standard.

## What are Skills?

Skills are modular packages that extend my capabilities with specialized knowledge, workflows, and scripts. They transform me from a general-purpose agent into one equipped with procedural knowledge for specific tasks.

### What Skills Provide

1. **Specialized workflows** - Multi-step procedures for specific tasks
2. **Scripts** - Executable code for deterministic, repeatable operations
3. **Domain knowledge** - Server-specific info, schemas, procedures

## Core Principles

### Concise is Key

Context is precious. Only add information I don't already have. Challenge each piece: "Do I really need this?" Prefer concise examples over verbose explanations.

### Match Freedom to Task Fragility

- **High freedom** (text instructions): Multiple approaches valid, context-dependent
- **Medium freedom** (pseudocode): Preferred pattern exists, some variation OK
- **Low freedom** (specific scripts): Operations fragile, consistency critical

### Skill Anatomy

```
skill-name/
├── SKILL.md           # Required: frontmatter + instructions
├── scripts/           # Optional: executable scripts
└── references/        # Optional: detailed documentation
```

## Creating Skills

Use the `create_skill` tool with:

```javascript
create_skill({
  name: "skill-name",           // lowercase, hyphens only
  description: "What AND when", // max 1024 chars, critical for discovery
  instructions: "# Steps...",   // markdown instructions
  scripts: [                    // optional
    { name: "run.sh", content: "#!/bin/bash\n..." }
  ]
})
```

### Step 1: Understand the Task

Before creating a skill, understand concrete examples:
- What specific tasks should this skill handle?
- What would trigger using this skill?
- What steps are involved?

### Step 2: Plan Contents

For each task, identify:
- **Scripts**: Code that gets rewritten repeatedly
- **References**: Documentation needed during execution

### Step 3: Write the Skill

#### YAML Frontmatter

```yaml
---
name: skill-name
description: What it does AND when to use it. Be specific about triggers.
---
```

The description is critical - it's how I know when to use the skill.

#### Instructions (Body)

Write clear, step-by-step instructions. Reference scripts as:
```bash
bash /home/tijs/roci/skills/skill-name/scripts/run.sh
```

### Step 4: Test and Iterate

After creating, test the skill with real tasks. Notice struggles and improve.

## Best Practices

See [references/best-practices.md](references/best-practices.md) for detailed patterns.

### Quick Tips

1. **Keep SKILL.md lean** - Move detailed docs to references/
2. **Scripts for repetitive code** - Don't rewrite the same bash each time
3. **Specific descriptions** - "Check server versions" not "Do server stuff"
4. **Test scripts first** - Run them manually before including
5. **One skill, one purpose** - Don't combine unrelated tasks
