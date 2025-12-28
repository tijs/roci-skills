# Manage State Files

Guidance for working with Roci's state files (inbox, today, commitments, backlog).

## State Directory

**All state files live at:** `/home/tijs/roci/state/`

Never use relative paths - always use full absolute paths.

## State Files

### inbox.md
**Purpose:** Temporary holding area for tasks mentioned by user
**When to write:** User mentions a task, reminder, or something to remember
**Format:** Simple bullet points, no overthinking
**Example:**
```bash
echo "- Call mom about birthday dinner" >> /home/tijs/roci/state/inbox.md
```

### today.md
**Purpose:** Time-sensitive items for today
**When to write:** During watch rotation, move urgent items from inbox
**Format:** Prioritized list with context
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
**Purpose:** Deadlines and dated commitments
**When to write:** User mentions a deadline or commitment with a date
**Format:** Date-stamped items
**Example:**
```bash
cat >> /home/tijs/roci/state/commitments.md << 'EOF'
- [ ] Q1 Planning deck - due Jan 15
- [ ] Amsterdam trip flights - book by Dec 31
EOF
```

### backlog.md
**Purpose:** Tasks for autonomous processing (no deadline)
**When to write:** During watch rotation, move non-urgent items from inbox
**Format:** Categorized if helpful
**Example:**
```bash
cat >> /home/tijs/roci/state/backlog.md << 'EOF'
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
2. For each item, decide: today / backlog / commitments / delete
3. Move items to the appropriate file
4. Clear inbox when done

Goal: Empty inbox after each watch rotation.

## Important Notes

- Always use absolute paths: `/home/tijs/roci/state/`
- State files are plain markdown - keep them readable
- Don't overthink formatting - simple bullet points work fine
- The memory service reads these files and injects contents into your system prompt
- You write to them using Read/Write/Bash tools
