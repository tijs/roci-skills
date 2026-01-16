---
name: email
description: Guidance for sending emails. Use when composing emails to Tijs, deciding when to send proactive notifications, or understanding email best practices.
---

# Email Management

This skill provides guidance for email operations via the `send_email` tool.

## When to Send Emails

**Good reasons to send an email:**

- User explicitly requests an email be sent
- Routine notifications (morning reports, weekly summaries) if configured
- Important reminders that shouldn't be lost (e.g., deadline approaching)
- Information that benefits from a permanent record
- Content that's too long or structured for chat

**Not appropriate for email:**

- Quick confirmations ("done", "got it")
- Real-time conversation or back-and-forth
- Information that's already in chat
- Trivial notifications

## User Confirmation

**Always confirm before sending** unless:

- User explicitly requested the email in their message
- It's a pre-configured routine notification
- User has previously approved this type of email

Example confirmation:

> I'll send an email to you with the weekly summary. The subject will be
> "Weekly Summary - Jan 15, 2026". Should I proceed?

## Email Composition Guidelines

### Subject Lines

- **Be specific:** "Meeting notes from Jan 15 standup" not "Notes"
- **Include dates** when relevant for searchability
- **Front-load important words:** Most important info first
- **Keep under 50 characters** when possible

Good examples:

- "Weekly Summary - Jan 13-19, 2026"
- "Reminder: Dentist appointment tomorrow 10am"
- "Flight details for Amsterdam trip"

### Body Content

- **Plain text first:** Always provide a plain text body
- **HTML optional:** Add HTML only when formatting significantly helps
- **Be concise:** Get to the point quickly
- **Structure with sections:** Use headers for longer emails
- **Include context:** Don't assume the reader remembers everything

### Format for Different Types

**Summaries/Reports:**

```
# Weekly Summary (Jan 13-19, 2026)

## Accomplishments
- Completed X
- Finished Y

## Upcoming
- Task A due Jan 22
- Meeting B on Jan 20

## Notes
Any additional context...
```

**Reminders:**

```
Reminder: [Event] tomorrow at [Time]

Location: [Address or link]
Notes: [Any prep needed]
```

**Information Delivery:**

```
Here's the [information type] you requested:

[Content organized clearly]

Let me know if you need anything else.
```

## Tool Usage

The `send_email` tool accepts:

- `subject` (required): Email subject line
- `body` (required): Plain text body
- `html_body` (optional): HTML version for rich formatting

**Note:** The recipient is hardcoded to `hello@tijs.org` for safety.

## Integration with Other Systems

### With Calendar

If sending meeting reminders:

1. Check calendar for event details
2. Include time, location, and any notes
3. Send reminder at appropriate time (day before or morning of)

### With Task System

If sending task summaries:

1. Review relevant state files (inbox, today, commitments)
2. Categorize by priority or type
3. Include actionable items first

### With Journal

After sending important emails:

1. Log the email in journal with topics: ["email", relevant-topic]
2. Note what was sent and why
3. Record any expected follow-up

## Error Handling

If email fails:

1. Report the error to user
2. Suggest alternatives (Matrix message, try again later)
3. Don't retry automatically without user permission

If API key is missing:

1. Inform user that email is not configured
2. Suggest adding RESEND_API_KEY to configuration
