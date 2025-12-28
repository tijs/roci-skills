---
name: watch-tick-behavior
description: Guidance for watch rotation behavior and decision-making. Use when deciding how to handle autonomous 2-hour check-ins, routing between models, deciding what to process, and managing agent autonomy during different times of day.
---

# Watch Tick Behavior

Operational guidance for Roci's 2-hour autonomous watch rotations.

## Time-Aware Focus

### Morning (6:00 - 11:00 AM)

**Briefing Focus:**

- Review today's schedule, deadlines, and commitments
- Check inbox for anything that arrived overnight
- Look for items from yesterday that might need follow-up
- Are there any meetings or deadlines Tijs should be aware of?

**Typical actions:**

- Triage inbox → today.md
- Note upcoming meetings from calendar
- Flag approaching deadlines

### Midday (11:00 AM - 5:00 PM)

**Check-in Focus:**

- Quick scan of inbox for urgent items
- Is today progressing as expected?
- If everything is on track, consider picking **one small task from patterns**
- Check for any time-sensitive deadlines approaching

**Typical actions:**

- Triage inbox (if any new items)
- Pick ONE patterns task if: inbox is clear, today.md is under control, no
  urgent deadlines
- Avoid: picking complex tasks, multiple tasks, tasks requiring external
  coordination

### Evening (5:00 PM - 10:00 PM)

**Review Focus:**

- End-of-day review: Did today's commitments get completed?
- Are there loose ends that should be captured before tomorrow?
- Anything that should move to tomorrow's focus?
- Brief summary of the day if something significant happened

**Typical actions:**

- Review today.md for completion
- Move incomplete items to tomorrow or patterns
- Capture any new items from the day
- Brief summary if meaningful events occurred

### Night (10:00 PM - 6:00 AM)

**No action:** Watch ticks are skipped during night hours to avoid disturbing
Tijs.

## Calendar-First Workflow

**Always start with calendar check:**

1. Use `get_calendar_events` with default 7-day lookahead
2. Note meetings or events happening today
3. Be aware of upcoming deadlines with calendar entries
4. Use calendar context when triaging inbox

**Why calendar first:**

- Provides temporal context for priorities
- Helps identify urgent vs important
- Informs patterns task selection (don't start something if meetings coming up)

## Inbox Triage

**Process inbox.md at every watch rotation:**

For each item in inbox, decide:

- **→ today.md**: Time-sensitive, urgent, or needed today
- **→ patterns.md**: Can wait, recurring patterns, or autonomous work
- **→ commitments.md**: Has a specific date/deadline
- **→ Delete**: No longer relevant, already handled, or duplicated

**Goal:** Inbox should be empty or near-empty after each watch rotation.

**Load manage-state skill for file operations:**

```
run_skill("manage-state")
```

## Silence Decision Tree

**Definitely message if:**

- ✅ Deadline within 24 hours that might be forgotten
- ✅ A commitment was discovered that needs attention NOW
- ✅ Something urgent in inbox requiring immediate action
- ✅ You completed a patterns task worth mentioning
- ✅ Calendar conflict or important meeting in next few hours
- ✅ Something broke or needs fixing

**Never message if:**

- ❌ Everything looks fine (don't say "all clear")
- ❌ Only minor observations
- ❌ Would just be a status update
- ❌ Tijs is likely already aware
- ❌ Just triaged inbox with nothing urgent
- ❌ Routine maintenance completed

**Philosophy:** Only speak when you have signal. Most ticks should be silent.

## Patterns Processing (Midday Only)

**When to pick a patterns task:**

- ✅ Inbox is empty
- ✅ today.md items are under control or completed
- ✅ No urgent deadlines in next 2-4 hours
- ✅ Calendar shows clear block of time
- ✅ Task is small and self-contained

**What to pick:**

- ✅ Small, focused tasks (< 1 hour estimated)
- ✅ No external dependencies
- ✅ Clear completion criteria
- ✅ Valuable but not urgent

**What to avoid:**

- ❌ Complex multi-step tasks
- ❌ Tasks requiring external coordination
- ❌ Tasks that might take multiple hours
- ❌ Anything that could create interruptions

**After completing a patterns task:**

- Remove from patterns.md
- Consider mentioning if it's meaningful (but don't over-report)

## Output Format

**If something worth messaging:** Write your message naturally as you would in
conversation. Be concise, specific, and actionable.

**If nothing meaningful:** Respond with exactly: `[NO_MESSAGE]`

**DO NOT:**

- Say "everything looks good" or similar platitudes
- Provide status updates just to report activity
- Mention routine maintenance or triage

**Example good messages:**

- "Deadline reminder: Q1 planning deck due tomorrow (Jan 15)"
- "Completed patterns task: refactored calendar sync, now 40% faster"
- "Urgent: Amsterdam flight booking expires tonight"

**Example bad messages (use [NO_MESSAGE] instead):**

- "Everything looks fine today"
- "Triaged inbox, nothing urgent"
- "All clear, continuing to monitor"
