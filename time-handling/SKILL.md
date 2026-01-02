---
name: time-handling
description: Calculate age, date duration, date arithmetic, and day of week. Use when asked about someone's age, days until/since a date, adding/subtracting time from a date, or finding what day of the week a date falls on.
allowed-tools: bash read write
---

# Time Handling

This skill provides timezone-aware date calculations for age, duration, date
arithmetic, and day-of-week lookups. All operations use the Europe/Amsterdam
timezone and ISO 8601 date format (YYYY-MM-DD).

## Operations

### 1. Age Calculation

Calculate age from a birthdate:

```bash
bash /home/tijs/roci/skills/time-handling/scripts/age.sh YYYY-MM-DD [--format=years|full]
```

**Examples:**

- `age.sh 1985-06-15` → "39 years old"
- `age.sh 1985-06-15 --format=full` → "39 years, 6 months, 13 days"

**When to use:**

- Calculating someone's age from their birthdate in `state/people/*.md`
- Checking age milestones
- Age-based context for tasks

### 2. Duration Calculation

Calculate days between two dates:

```bash
bash /home/tijs/roci/skills/time-handling/scripts/duration.sh DATE1 DATE2 [--format=days|weeks|human]
```

**Examples:**

- `duration.sh 2025-01-01 2025-12-31` → "364 days"
- `duration.sh 2025-01-01 2025-12-31 --format=weeks` → "52 weeks"
- `duration.sh 2025-01-01 2025-12-31 --format=human` → "11 months, 30 days"

**When to use:**

- Calculating days until a deadline in `state/commitments.md`
- Time since a project started
- Duration between any two dates

### 3. Date Arithmetic

Add or subtract time from a date:

```bash
bash /home/tijs/roci/skills/time-handling/scripts/add-date.sh DATE AMOUNT UNIT [--format=iso|human]
```

**Examples:**

- `add-date.sh 2025-12-28 7 days` → "2026-01-04"
- `add-date.sh 2025-12-28 -2 weeks` → "2025-12-14"
- `add-date.sh 2025-12-28 3 months --format=human` → "Saturday, March 28, 2026"

**Units:** `days`, `weeks`, `months` (negative values to subtract)

**When to use:**

- Setting new deadlines (X days from now)
- Calculating reminder dates
- Project planning with relative dates

### 4. Day of Week

Determine the day of week for any date:

```bash
bash /home/tijs/roci/skills/time-handling/scripts/day-of-week.sh DATE [--format=short|full]
```

**Examples:**

- `day-of-week.sh 2025-12-28` → "Sunday"
- `day-of-week.sh 2025-12-28 --format=short` → "Sun"
- `day-of-week.sh 2025-12-28 --format=full` → "Sunday, December 28, 2025"

**When to use:**

- Context for scheduling ("Next meeting is on a Friday")
- Understanding deadline timing
- Calendar context

## Common Use Cases

### Age Tracking

When someone mentions a birthdate or you read one from `state/people/NAME.md`:

```bash
bash /home/tijs/roci/skills/time-handling/scripts/age.sh 1985-06-15
```

### Deadline Calculations

When asked "How many days until X?" or processing `state/commitments.md`:

```bash
# Days until deadline
bash /home/tijs/roci/skills/time-handling/scripts/duration.sh 2025-12-28 2026-01-15

# Set deadline 2 weeks from now
bash /home/tijs/roci/skills/time-handling/scripts/add-date.sh 2025-12-28 2 weeks
```

### Scheduling Context

When you need day-of-week context for a date:

```bash
bash /home/tijs/roci/skills/time-handling/scripts/day-of-week.sh 2026-01-15
```

## Error Handling

All scripts handle invalid input gracefully:

- Invalid date formats → Error message + exit code 1
- Future birthdates (age.sh) → Error message + exit code 1
- Invalid units (add-date.sh) → Error message + exit code 1
- Missing arguments → Usage message + exit code 1

## Integration with State Files

- **`state/people/*.md`** - Read birthdates, calculate ages
- **`state/commitments.md`** - Calculate days until deadlines
- **`state/today.md`** - Add time-based context to tasks
- **Journal** - Log significant date calculations via `log_journal`

## Timezone

All operations use **Europe/Amsterdam** timezone for consistency with the user's
location.
