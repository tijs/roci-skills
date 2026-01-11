---
name: calendar
description: Guidance for calendar management. Use when deciding which calendar to use, handling conflicts, or integrating calendar with task tracking.
---

# Calendar Management

This skill provides guidance for calendar operations. For the actual calendar
tools, see:

- `calendar_events` - Read upcoming events (schedule check, availability)
- `calendar` - Create or update events

## Available Calendars

Tijs uses iCloud calendars with the following organization:

| Calendar     | Purpose                                     | Color  |
| ------------ | ------------------------------------------- | ------ |
| **Personal** | Personal appointments, family events        | Blue   |
| **Work**     | Work meetings, deadlines                    | Green  |
| **Fitness**  | Workouts, sports activities                 | Orange |
| **Travel**   | Flights, hotels, travel plans               | Purple |

## Which Calendar to Use

**Personal Calendar:**
- Family events (birthdays, dinners, visits)
- Personal appointments (doctor, dentist, haircut)
- Social events (meetups, parties)
- Home maintenance appointments

**Work Calendar:**
- Work meetings (standups, 1:1s, reviews)
- Deadlines and milestones
- Conference calls
- Work-related travel

**Fitness Calendar:**
- Gym sessions
- Sports activities (cycling, running)
- Health appointments related to fitness

**Travel Calendar:**
- Flight departures and arrivals
- Hotel check-in/check-out
- Train/bus reservations
- Travel-related activities at destination

## Event Creation Guidelines

### Time Formats

- **Timed events:** Use ISO 8601 with timezone offset or UTC
  - `2026-01-15T14:30:00Z` (UTC)
  - Local time is Europe/Amsterdam (CET/CEST)

- **All-day events:** Use date only
  - `2026-01-15`

### Recurring Events

Support for DAILY, WEEKLY, MONTHLY patterns:

```json
{
  "recurrence": {
    "frequency": "WEEKLY",
    "interval": 1,
    "until": "2026-06-01"
  }
}
```

Examples:
- "Every Monday at 19:00" → WEEKLY, no interval, start on Monday
- "Every other week" → WEEKLY, interval: 2
- "Daily standup" → DAILY, no interval

### Event Details

Always include when relevant:
- **Location:** Physical address or video link
- **Description:** Context, agenda, or notes

## Integration with Task System

### Morning Report

During the morning report tick, check calendar for:
1. Today's events (time-sensitive awareness)
2. Upcoming deadlines within 3 days
3. Conflicts or double-bookings

### Task to Calendar Flow

When a task has a specific time:
1. Add to appropriate calendar
2. Update `today.md` with reference to calendar event
3. Log the scheduling in journal

### Calendar to Task Flow

When calendar events generate tasks:
1. Add prep tasks to `inbox.md` (e.g., "Prepare for meeting X")
2. During triage, move to `today.md` if time-sensitive

## Conflict Handling

If conflicting events are detected:
1. Alert Tijs immediately in the response
2. List both events with times
3. Ask which to reschedule or if both can proceed

## Timezone Awareness

- All internal storage is UTC
- Display times are converted to Europe/Amsterdam
- When user says "at 3pm", interpret as Europe/Amsterdam time
- Convert to UTC for storage: 15:00 CET = 14:00 UTC (winter) or 13:00 UTC (summer)

## Example Workflows

### "Schedule a gym session tomorrow at 7am"

1. Convert 7am Europe/Amsterdam to UTC
2. Create event on Fitness calendar
3. Set duration (default: 1 hour for gym)
4. Confirm creation

### "What's on my calendar this week?"

1. Use `calendar_events` with days=7
2. Group by day for readability
3. Highlight any conflicts or busy days

### "Move the dentist appointment to Friday"

1. Use `calendar_events` to find the dentist event
2. Use `calendar` update_event action
3. Specify new date in updates
