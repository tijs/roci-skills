---
name: manage-state
description: Guide to Roci's state file system. Explains core task files (always loaded) vs reference files (on-demand). Use when user asks about state, tasks, or wants to track information.
---

# Manage State Files

Guide for working with Roci's state files.

## State Architecture

**State directory:** `/home/tijs/roci/state/`

Always use absolute paths when reading/writing state files.

### Two Types of State Files

1. **Core files** (4 files, always loaded in context)
   - `inbox.md`, `today.md`, `commitments.md`, `patterns.md`
   - These drive the GTD-style task workflow
   - Updated frequently, kept minimal

2. **Reference files** (on-demand, not auto-loaded)
   - Any other `.md` file in the state directory
   - Read when relevant to conversation
   - For persistent knowledge tracking

### Structured Directories

- `people/` - One file per person (see `people` skill)
- `research/` - Deep research outputs by topic (see `research` skill)
- `drafts/` - Work-in-progress documents

## File Frontmatter Convention

All state files have YAML frontmatter with a `description` field:

```yaml
---
description: Short explanation of what this file is for
---
```

This allows dynamic discovery - the agent learns what each file is for by
reading its frontmatter.

## Discovering Available State

**Use bash to discover what state files exist:**

```bash
# List all state files
ls -1 /home/tijs/roci/state/*.md

# See what a file is for (read frontmatter)
head -5 /home/tijs/roci/state/filename.md

# List subdirectories
ls -d /home/tijs/roci/state/*/

# List people files
ls -1 /home/tijs/roci/state/people/*.md

# Find research outputs
find /home/tijs/roci/state/research -name "*.md" -type f
```

**Before assuming a file exists, check first:**

```bash
test -f /home/tijs/roci/state/filename.md && echo "exists" || echo "not found"
```

## Core Files (Always Loaded)

These 4 files are hardcoded and stable:

### inbox.md

**Purpose:** Temporary holding area for tasks mentioned by user

```bash
# Append task
echo "- Call mom about dinner" >> /home/tijs/roci/state/inbox.md
```

### today.md

**Purpose:** Time-sensitive items for today

```bash
# View today's tasks
cat /home/tijs/roci/state/today.md
```

### commitments.md

**Purpose:** Deadlines and dated commitments

```bash
# Add commitment with date
echo "- [ ] Q1 Planning deck - due Jan 15" >> /home/tijs/roci/state/commitments.md
```

### patterns.md

**Purpose:** Recurring patterns and task backlog (no deadline)

```bash
# Add to backlog
echo "- Add calendar sync feature" >> /home/tijs/roci/state/patterns.md
```

## Common Operations

### Read state file

```bash
cat /home/tijs/roci/state/inbox.md
```

### Append to state file

```bash
echo "- New task" >> /home/tijs/roci/state/today.md
```

### Replace entire state file

```bash
cat > /home/tijs/roci/state/inbox.md << 'EOF'
---
description: Temporary holding area for tasks and items to triage
---

# Inbox

- Task 1
- Task 2
EOF
```

## Watch Rotation Triage

During watch rotation, process inbox.md:

1. Read inbox: `cat /home/tijs/roci/state/inbox.md`
2. For each item, decide: today / patterns / commitments / delete
3. Move items to the appropriate file
4. Clear inbox when done

Goal: Empty inbox after each watch rotation.

## Reference Files

Reference files store persistent knowledge that doesn't change daily.

**When to read reference files:**

- User explicitly asks ("what's in my reading list?")
- Context suggests relevance (discussing books → check for books file)
- Establishing context for a task

**When to update reference files:**

- User provides information worth persisting
- User asks to track something new

**To work with reference files:**

1. First discover what exists: `ls -1 /home/tijs/roci/state/*.md`
2. Read frontmatter to understand purpose: `head -5 /home/tijs/roci/state/file.md`
3. Read, update, or create as needed

**Creating a new reference file:**

```bash
cat > /home/tijs/roci/state/newfile.md << 'EOF'
---
description: What this file tracks
---

# Title

Content here...
EOF
```

## Searching State Files

```bash
# Search for keyword across all state
grep -r "keyword" /home/tijs/roci/state/

# Search people files
grep -r "topic" /home/tijs/roci/state/people/

# Search with context
grep -r -C2 "keyword" /home/tijs/roci/state/

# Case-insensitive search
grep -ri "keyword" /home/tijs/roci/state/

# Find recently modified files
find /home/tijs/roci/state/ -name "*.md" -mtime -7
```

## Git Version Control

State files are automatically version-controlled.

- Changes are auto-committed after each agent response
- Commits are pushed to GitHub asynchronously
- Database files live in `/home/tijs/roci/data/` (not in git)

**Manual git operations:**

```bash
# View recent changes
cd /home/tijs/roci/state && git log --oneline -10

# View uncommitted changes
cd /home/tijs/roci/state && git status
```

## Important Notes

- Always use absolute paths: `/home/tijs/roci/state/`
- State files are plain markdown - keep them readable
- Core files are always in context; reference files are read on-demand
- Use `people` skill for people tracking, `research` skill for deep research
- Discover available files with bash before assuming they exist
