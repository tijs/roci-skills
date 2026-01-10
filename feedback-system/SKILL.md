---
name: feedback-system
description: Understand the feedback loop architecture - trajectory logs, tick outcomes, weekly reviews
version: 1.0.0
author: roci
tags: [system, feedback, learning, self-improvement]
---

# Feedback System

You have a feedback loop architecture that helps you learn from outcomes. This skill explains where to find feedback data and how to use it.

## Log Files

All feedback logs are stored in `state/logs/`:

| File | Purpose | Format |
|------|---------|--------|
| `trajectories.jsonl` | Successful task completions | JSONL with tool sequences |
| `ticks.jsonl` | Tick outcomes (morning, night, friday, weekly) | JSONL with tick metadata |
| `journal.jsonl` | Your journal entries | JSONL (40 recent loaded in context) |

## Trajectory Store

Every successful task with tool use gets logged to `trajectories.jsonl` automatically. Each entry contains:

```json
{
  "id": "traj-abc123",
  "t": "2026-01-09T10:00:00Z",
  "task_type": "calendar|research|communication|coding|state_management|journaling|quick_task|general",
  "input_summary": "First 200 chars of user request",
  "steps": [
    {"tool": "Read", "input": "/path/to/file", "result": "success"},
    {"tool": "Write", "input": "/path/to/file", "result": "success"}
  ],
  "outcome": "success|partial|failed",
  "tokens_used": 1234,
  "duration_ms": 5000,
  "model": "claude-sonnet-4-5"
}
```

**Task types are inferred from tool usage:**
- `calendar` - Calendar tool or calendar-related inputs
- `research` - web_search or web_fetch tools
- `communication` - send_message or email/message inputs
- `coding` - Git/commit/code inputs
- `state_management` - Write to state/ files
- `journaling` - journal_log tool
- `quick_task` - 2 or fewer tool calls
- `general` - Everything else

## Tick Outcomes

Every scheduled tick (night, morning, friday, weekly) gets logged to `ticks.jsonl`:

```json
{
  "tick_id": "morning_2026-01-09T08_00_00",
  "t": "2026-01-09T08:00:05Z",
  "model": "claude-3-5-haiku-latest",
  "attempt": 1,
  "outcome": "success|error|silent",
  "duration_ms": 3500,
  "period": "morning|night|friday|weekly",
  "tools_used": [{"name": "calendar", "success": true}],
  "tokens": {"input": 500, "output": 200, "total": 700},
  "message_sent": true,
  "message_preview": "First 100 chars if sent",
  "error": null
}
```

## Weekly Review

Every Sunday at 10:00 AM, a weekly review tick runs that:

1. Analyzes trajectory stats from the past 7 days
2. Reviews error patterns from the past 24 hours
3. Checks task success rates by type
4. Identifies patterns worth noting

The weekly review can update `patterns.md` or log insights to journal.

## Reading Feedback Data

To review your own performance:

```bash
# Recent trajectories
tail -20 /home/tijs/roci/state/logs/trajectories.jsonl | jq .

# Tick outcomes
tail -20 /home/tijs/roci/state/logs/ticks.jsonl | jq .

# Success rate by task type (last 50)
tail -50 /home/tijs/roci/state/logs/trajectories.jsonl | jq -s 'group_by(.task_type) | map({type: .[0].task_type, count: length, success: [.[] | select(.outcome=="success")] | length})'

# Average duration
tail -50 /home/tijs/roci/state/logs/trajectories.jsonl | jq -s 'map(.duration_ms) | add / length | round'
```

## When to Use This

- **Curious about your performance**: Read trajectory stats
- **Debugging a repeated issue**: Check recent tick outcomes for errors
- **Weekly reflection**: The weekly review runs automatically, but you can read the logs anytime
- **Improving approaches**: Look at successful trajectories for similar task types

## What Gets Logged Automatically

You don't need to do anything special. The feedback system logs:
- ✅ Every successful task with tool use → `trajectories.jsonl`
- ✅ Every tick (morning/night/friday/weekly) → `ticks.jsonl`
- ✅ Your journal entries (via log_journal) → `journal.jsonl`

## Notes

- Trajectories only log on **success** - failed tasks aren't stored as examples
- Task type inference is automatic based on tools and input content
- The weekly review runs even if there's nothing to report (logs as "silent")
- All timestamps are ISO 8601 UTC
