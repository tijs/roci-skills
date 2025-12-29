---
name: manage-state
description: Comprehensive guide to Roci's state file system. Explains core task files (auto-loaded) vs reference files (on-demand). Use when user asks about state, mentions tasks, or references tracked topics like projects, books, family, etc.
---

# Manage State Files

Guidance for working with Roci's state files (inbox, today, commitments,
patterns).

## State Directory

**All state files live at:** `/home/tijs/roci/state/`

Never use relative paths - always use full absolute paths.

## State Files

### inbox.md

**Purpose:** Temporary holding area for tasks mentioned by user **When to
write:** User mentions a task, reminder, or something to remember **Format:**
Simple bullet points, no overthinking **Example:**

```bash
echo "- Call mom about birthday dinner" >> /home/tijs/roci/state/inbox.md
```

### today.md

**Purpose:** Time-sensitive items for today **When to write:** During watch
rotation, move urgent items from inbox **Format:** Prioritized list with context
**Example:**

```bash
cat > /home/tijs/roci/state/today.md << 'EOF'
# Today

## High Priority
- Finish PR review for James (#234) - blocking deployment

## Scheduled
- 14:00 Team standup
EOF
```

### commitments.md

**Purpose:** Deadlines and dated commitments **When to write:** User mentions a
deadline or commitment with a date **Format:** Date-stamped items **Example:**

```bash
cat >> /home/tijs/roci/state/commitments.md << 'EOF'
- [ ] Q1 Planning deck - due Jan 15
- [ ] Amsterdam trip flights - book by Dec 31
EOF
```

### patterns.md

**Purpose:** Recurring patterns and task backlog (no deadline) **When to
write:** During watch rotation, move non-urgent items or patterns from inbox
**Format:** Categorized if helpful **Example:**

```bash
cat >> /home/tijs/roci/state/patterns.md << 'EOF'
## Roci Features
- Implement calendar sync for external calendars
- Add support for recurring tasks
EOF
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
# Inbox

- Task 1
- Task 2
EOF
```

### Move item between files

```bash
# Read inbox
INBOX=$(cat /home/tijs/roci/state/inbox.md)

# Extract item and add to today.md
echo "- Item from inbox" >> /home/tijs/roci/state/today.md

# Remove from inbox (rewrite without that line)
cat > /home/tijs/roci/state/inbox.md << 'EOF'
# Inbox

(remaining items)
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

Beyond core task files, you have reference files for persistent knowledge
tracking.

**Reference files are NOT loaded in context automatically** - you read them
on-demand using the Read tool.

### When to Use Reference Files

**Read reference files when:**

- User explicitly mentions a topic ("what's in my reading list?", "check
  projects")
- Context suggests relevance (discussing books → read `books.md`)
- Establishing context for research

**Update reference files when:**

- User provides information that belongs in a reference file
- You learn something worth persisting
- User asks you to track something ("keep a reading list")

### Reference File Paths

All paths use `/home/tijs/roci/state/` prefix:

- **Projects:** `/home/tijs/roci/state/projects.md`
- **Family:** `/home/tijs/roci/state/family.md`
- **Books:** `/home/tijs/roci/state/books.md`
- **Music:** `/home/tijs/roci/state/music.md`
- **Podcasts:** `/home/tijs/roci/state/podcasts.md`
- **Travel:** `/home/tijs/roci/state/travel.md`

### Example Operations

**Read reference file:**

```bash
cat /home/tijs/roci/state/books.md
```

**Update reference file:**

```bash
cat > /home/tijs/roci/state/books.md << 'EOF'
# Books

## Currently Reading
- The Expanse series - Book 3

## Reading List
- Project Hail Mary by Andy Weir

## Completed (2025)
- 2025-12-15: Neuromancer - Excellent
EOF
```

**Append to reference file:**

```bash
cat >> /home/tijs/roci/state/books.md << 'EOF'

## Reading List
- New book just added
EOF
```

## Structured Directories

### People Directory

Track people in Tijs's life. One file per person.

**See the `people` skill** for detailed workflow (file structure, when to
update, etc.)

**List all people:**

```bash
ls -1 /home/tijs/roci/state/people/*.md
```

**Read person file:**

```bash
cat /home/tijs/roci/state/people/john-smith.md
```

**Check if person file exists:**

```bash
test -f /home/tijs/roci/state/people/john-smith.md && echo "exists" || echo "not found"
```

### Research Directory

Deep research outputs organized by topic (wellness/, tech/, finance/,
productivity/).

**See the `research` skill** for detailed research workflow.

**List research outputs:**

```bash
find /home/tijs/roci/state/research -name "*.md" -type f
```

**Read research file:**

```bash
cat /home/tijs/roci/state/research/wellness/sleep-2025-12.md
```

### Drafts Directory

Work-in-progress documents and proposals.

**List drafts:**

```bash
ls -1 /home/tijs/roci/state/drafts/
```

**Create draft:**

```bash
cat > /home/tijs/roci/state/drafts/DRAFT-roci-v3.md << 'EOF'
# Roci v3 Architecture (DRAFT)

Work in progress...
EOF
```

## Important Notes

- Always use absolute paths: `/home/tijs/roci/state/`
- State files are plain markdown - keep them readable
- Don't overthink formatting - simple bullet points work fine
- **Core files** (inbox, today, commitments, patterns) are loaded in EVERY
  message
- **Reference files** are read on-demand (not auto-loaded) to prevent context
  bloat
- You write to ALL files using Read/Write/Bash tools
- Use `people` skill for people tracking, `research` skill for deep research
