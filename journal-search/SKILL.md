---
name: journal-search
description: Search through Roci's journal history using jq. Use when you need to find past entries by topic, date, keyword, or pattern.
---

# Journal Search

Search through historical journal entries using jq. The journal contains all
logged interactions - what was discussed, what actions were taken, and when.

## Journal Location

```
/home/tijs/roci/state/logs/journal.jsonl
```

## Entry Format

Each line is a JSON object with 4 fields:

| Field         | Type     | Description                                           |
| ------------- | -------- | ----------------------------------------------------- |
| `t`           | string   | ISO 8601 timestamp (e.g., `2025-12-28T05:05:22.943Z`) |
| `topics`      | string[] | Tags for filtering (e.g., `["deadline", "work"]`)     |
| `user_stated` | string   | What Tijs said (verbatim or paraphrased)              |
| `my_intent`   | string   | What I understood or planned to do                    |

## Search by Topic

```bash
# Entries tagged "deadline"
jq -c 'select(.topics | contains(["deadline"]))' /home/tijs/roci/state/logs/journal.jsonl

# Entries with either "task" OR "follow-up"
jq -c 'select(.topics | map(. == "task" or . == "follow-up") | any)' /home/tijs/roci/state/logs/journal.jsonl

# Entries with BOTH "work" AND "deadline"
jq -c 'select(.topics | contains(["work", "deadline"]))' /home/tijs/roci/state/logs/journal.jsonl
```

## Search by Date

```bash
# Entries from specific date
jq -c 'select(.t | startswith("2025-12-28"))' /home/tijs/roci/state/logs/journal.jsonl

# Entries from specific month
jq -c 'select(.t | startswith("2025-12"))' /home/tijs/roci/state/logs/journal.jsonl

# Entries from today (replace YYYY-MM-DD)
jq -c 'select(.t | startswith("2026-01-03"))' /home/tijs/roci/state/logs/journal.jsonl
```

## Search by Keyword

```bash
# User mentioned "tomorrow" (case-insensitive)
jq -c 'select(.user_stated | test("tomorrow"; "i"))' /home/tijs/roci/state/logs/journal.jsonl

# I planned to "follow up" or "check in"
jq -c 'select(.my_intent | test("follow up|check in"; "i"))' /home/tijs/roci/state/logs/journal.jsonl

# User mentioned specific word (case-sensitive)
jq -c 'select(.user_stated | contains("Friday"))' /home/tijs/roci/state/logs/journal.jsonl
```

## Recent Entries

```bash
# Last 20 entries (compact)
tail -20 /home/tijs/roci/state/logs/journal.jsonl | jq -c '.'

# Last 10 entries (pretty)
tail -10 /home/tijs/roci/state/logs/journal.jsonl | jq '.'

# Last 5 entries (topics only)
tail -5 /home/tijs/roci/state/logs/journal.jsonl | jq -c '{t: .t, topics: .topics}'
```

## Statistics

```bash
# Count entries by topic (frequency)
jq -r '.topics[]' /home/tijs/roci/state/logs/journal.jsonl | sort | uniq -c | sort -rn

# List all unique topics ever used
jq -r '.topics[]' /home/tijs/roci/state/logs/journal.jsonl | sort -u

# Total entry count
wc -l < /home/tijs/roci/state/logs/journal.jsonl

# Find days with most activity
jq -r '.t | split("T")[0]' /home/tijs/roci/state/logs/journal.jsonl | sort | uniq -c | sort -rn
```

## Combined Queries

```bash
# Silent watch rotations (no user interaction)
jq -c 'select(.topics | contains(["watch-rotation"])) | select(.user_stated == "")' /home/tijs/roci/state/logs/journal.jsonl

# Deadlines from specific date
jq -c 'select(.topics | contains(["deadline"])) | select(.t | startswith("2025-12"))' /home/tijs/roci/state/logs/journal.jsonl

# User commitments that I added to commitments.md
jq -c 'select(.user_stated != "") | select(.my_intent | contains("commitments.md"))' /home/tijs/roci/state/logs/journal.jsonl
```

## Time-Based Queries

Note: The `fromdateiso8601` function doesn't support millisecond timestamps. Use
the `startswith` approach above for date filtering - it's simpler and more
reliable.

If you need relative time (e.g., "last 24 hours"), strip milliseconds first:

```bash
# Last 24 hours (86400 seconds)
jq -c 'select((.t | split(".")[0] + "Z" | fromdateiso8601) > (now - 86400))' /home/tijs/roci/state/logs/journal.jsonl

# Last 7 days (604800 seconds)
jq -c 'select((.t | split(".")[0] + "Z" | fromdateiso8601) > (now - 604800))' /home/tijs/roci/state/logs/journal.jsonl
```

## Common Use Cases

**"What did we discuss about X?"**

```bash
jq -c 'select(.user_stated | test("X"; "i"))' /home/tijs/roci/state/logs/journal.jsonl
```

**"When did I last mention Y?"**

```bash
jq -c 'select(.user_stated | test("Y"; "i"))' /home/tijs/roci/state/logs/journal.jsonl | tail -1
```

**"What actions did I take on topic Z?"**

```bash
jq -c 'select(.topics | contains(["Z"]))' /home/tijs/roci/state/logs/journal.jsonl | jq '.my_intent'
```

**"Show all entries from this week"**

```bash
jq -c 'select(.t | startswith("2026-01"))' /home/tijs/roci/state/logs/journal.jsonl
```
