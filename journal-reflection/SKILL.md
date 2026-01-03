---
name: journal-reflection
description: Guidance for post-response journaling. Runs after state reflection to capture insights not already in state files. Like a therapist's session notes - capture what's worth remembering, not transcripts.
model: flash
---

# Journal Reflection

You are reflecting on a conversation to decide what should be journaled.

## The Journal's Purpose

Your journal is **temporal memory** - it persists when context is pruned. Think
of it like a therapist's session notes: capture insights, not transcripts.

The journal helps you remember:

- What the user said (their words, intentions)
- What you learned (discoveries, decisions)
- Patterns that emerged
- Important context for future conversations

## When to Log

**Log to journal when:**

- User stated plans, intentions, or commitments (capture their words)
- You discovered something worth remembering (calendar events, search results,
  file contents)
- A decision was made that affects future behavior
- A pattern was identified or reinforced
- An error or blocker was encountered worth tracking

**Examples of journal-worthy moments:**

```
User: "I'm planning to take a vacation in March"
→ Log: plans/intentions, user's travel plans

User asked about deadlines, you checked calendar and found 3 upcoming
→ Log: discovery, what you found in calendar

User mentioned they prefer async communication
→ Log: pattern, communication preference

Tool error when accessing calendar
→ Log: error, what failed and why
```

## When NOT to Log

**Skip journaling if:**

- Casual conversation with no actionable content
- Greetings, thanks, small talk
- Simple informational queries
- Already captured in state files (check {{state_updates}})
- Would duplicate a recent journal entry

**Examples of skippable moments:**

- "What's 2+2?" → Skip (pure info, no insight)
- "Thanks!" → Skip (acknowledgment only)
- Added task to inbox.md → Skip (already in state file)
- "How do I use git?" → Skip (tutorial, no personal context)

**Output:** If nothing to journal, return `[NO_JOURNAL]`

## Journal Entry Format

Use the `journal_log` tool with:

```
topics: 2-4 descriptive tags for filtering later
user_stated: What the user said or requested (their words)
my_intent: Your understanding and what you plan to do
```

### Topic Guidelines

Pick 2-4 tags that will help you find this entry later:

- **Categories:** work, personal, health, finance, travel, family, project
- **Actions:** plan, decision, reminder, deadline, pattern, discovery
- **People:** names if relevant to a person

**Examples:**

```
topics: ["travel", "plan", "march"]
topics: ["work", "deadline", "project-x"]
topics: ["pattern", "communication", "preference"]
topics: ["error", "calendar", "icloud"]
```

### user_stated Guidelines

Capture the user's actual words or intent, not your interpretation:

- Use quotes if capturing exact phrasing
- Summarize if the message was long
- Focus on what matters for future context

**Examples:**

```
user_stated: "Planning vacation in March, maybe Italy"
user_stated: "Needs quarterly report by Friday"
user_stated: "Prefers Slack over email for quick questions"
```

### my_intent Guidelines

Document your understanding and any actions taken or planned:

- What did you learn?
- What will you do differently?
- What should you remember?

**Examples:**

```
my_intent: "Note travel plans for March. May need to adjust calendar reminders."
my_intent: "Added deadline to commitments.md. Will check in on Wednesday."
my_intent: "Update communication preferences. Use Slack for quick follow-ups."
```

## Decision Tree

```
Did the user share something personal/actionable?
  YES → Continue to next question
  NO  → [NO_JOURNAL]

Is it already captured in state files?
  YES → [NO_JOURNAL]
  NO  → Continue to next question

Will this context be useful in future conversations?
  YES → Log to journal
  NO  → [NO_JOURNAL]
```

## Best Practices

- **Signal over noise:** Only log what's worth remembering
- **User's voice:** Capture their words, not just your interpretation
- **Future-oriented:** Ask "will I need this context later?"
- **Brief entries:** Journal should be scannable, not verbose
- **Complement state files:** Journal captures what state files don't

## Model Recommendation

Use Flash for journal reflection (fast, cost-effective for simple decisions).
Falls back to Haiku if Flash unavailable.
