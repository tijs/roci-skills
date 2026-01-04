---
name: beans
description: Manage development issues with beans CLI
triggers:
  - create a bean
  - track issue
  - update bean
  - list beans
  - find bugs
  - check backlog
  - development priorities
---

# Beans Skill

Use the beans CLI to manage development issues and track work on the Roci project.

## Location

Beans directory: `~/roci/beans` (set via BEANS_DIR environment variable)

Always run beans commands from the beans directory or use `--beans-path`:

```bash
cd ~/roci/beans && beans <command>
# OR
beans --beans-path ~/roci/beans/.beans <command>
```

## Common Operations

### List actionable beans

Find beans that are ready to work on (not completed, not blocked):

```bash
cd ~/roci/beans && beans query '{ beans(filter: { excludeStatus: ["completed", "scrapped", "draft"], isBlocked: false }) { id title status type priority } }'
```

### Show bean details

```bash
cd ~/roci/beans && beans show <id>
# OR for structured output:
cd ~/roci/beans && beans query '{ bean(id: "<id>") { title status type priority body } }'
```

### Create a new bean

When you discover a bug or have an idea for improvement:

```bash
cd ~/roci/beans && beans create "Title" -t <type> -d "Description" -s todo
```

Types: `bug`, `feature`, `task`, `epic`, `milestone`

Example:
```bash
cd ~/roci/beans && beans create "Calendar sync fails on recurring events" -t bug -d "The CalDAV sync misses events with RRULE patterns that span multiple months" -s todo -p high
```

### Update bean status

When starting work:
```bash
cd ~/roci/beans && beans update <id> --status in-progress
```

When completing:
```bash
cd ~/roci/beans && beans update <id> --status completed
```

### Search beans

```bash
cd ~/roci/beans && beans query '{ beans(filter: { search: "keyword" }) { id title status } }'
```

### Filter by type or priority

```bash
# High priority bugs
cd ~/roci/beans && beans query '{ beans(filter: { type: ["bug"], priority: ["critical", "high"] }) { id title status } }'

# All features
cd ~/roci/beans && beans query '{ beans(filter: { type: ["feature"] }) { id title status priority } }'
```

## When to Use Beans

**Create a bean when:**
- You discover a bug while working on something else
- You have an idea for improvement that's not the current task
- User reports an issue worth tracking
- You identify technical debt

**Update a bean when:**
- Starting work on a tracked issue
- Completing work on a tracked issue
- Adding notes or findings to an issue

**Query beans when:**
- Looking for work to do during watch rotation
- Checking if an issue is already tracked
- Understanding project priorities

## After Making Changes

Always commit and push bean changes so they sync:

```bash
cd ~/roci/beans && git add . && git commit -m "Update beans" && git push
```

This ensures changes are available locally when the developer pulls.

## Bean Structure

Beans are markdown files with YAML frontmatter:

```yaml
---
title: Human readable title
status: todo|in-progress|completed|scrapped|draft
type: bug|feature|task|epic|milestone
priority: critical|high|normal|low|deferred
created_at: ISO timestamp
updated_at: ISO timestamp
---

Description and notes in markdown...

## Checklist
- [ ] Uncompleted item
- [x] Completed item
```

## Priorities

- `critical` - Drop everything, fix now
- `high` - Important, do before normal work
- `normal` - Standard priority (default)
- `low` - Nice to have, do when time permits
- `deferred` - Explicitly pushed back

## GraphQL Reference

For complex queries, use the GraphQL interface:

```bash
cd ~/roci/beans && beans query '<graphql>'
```

Useful fields: `id`, `title`, `status`, `type`, `priority`, `body`, `parent { title }`, `children { id title }`, `blockedBy { title }`, `blocking { title }`

Filter options: `search`, `status`, `excludeStatus`, `type`, `priority`, `isBlocked`, `hasParent`, `noParent`
