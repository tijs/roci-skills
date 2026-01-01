---
name: response-reflection
description: Guidance for post-response reflection on user messages. Use when deciding whether to update state files (inbox, today, patterns, commitments) after responding to user. Analyzes conversations to identify tasks, patterns, and insights worth remembering.
---

# Response Reflection

Post-response reflection for proactive state file updates after user messages.

## Purpose

After responding to the user, reflect on the conversation to identify:
- Tasks or reminders that should be captured
- Patterns or preferences worth noting
- Commitments with specific dates
- Time-sensitive items for today
- Insights about Tijs's work or preferences

## When to Update State Files

### inbox.md - Task Capture

**Update if:**
- User mentions a task, even casually ("I should...")
- User requests a reminder
- Follow-up action is needed
- Something to research or investigate
- User wants to try something later

**Examples:**
- "Remind me to call mom" → Add to inbox
- "I should clean up that code" → Add to inbox
- "Need to review the PR" → Add to inbox

**Format:**
```markdown
## Tasks
- [ ] Call mom (mentioned in conversation)
- [ ] Clean up authentication code
- [ ] Review PR #123
```

### today.md - Time-Sensitive Items

**Update if:**
- User mentions something urgent for today
- Task explicitly said to be "today"
- Time-sensitive deadline approaching soon
- User mentions "this morning" or "this afternoon"

**Examples:**
- "I need to finish this today" → Add to today
- "Meeting at 2pm" → Add to today
- "Report due this afternoon" → Add to today

**Format:**
```markdown
## Time-Sensitive
- [ ] Finish quarterly report (due 2pm)
- [ ] Review slides before 2pm meeting
```

### commitments.md - Dated Deadlines

**Update if:**
- User mentions a specific date ("by Friday", "January 15th")
- Calendar event with a deadline
- Commitment with time constraints
- Recurring obligation starting on a date

**Examples:**
- "Report due Friday" → Add with date
- "Launch on Jan 15th" → Add with date
- "Meeting every Tuesday" → Add pattern with start date

**Format:**
```markdown
## Deadlines
- [ ] Quarterly report - Due: 2025-01-03
- [ ] Product launch - Due: 2025-01-15
- [ ] Weekly team sync - Every Tuesday starting 2025-01-07
```

### patterns.md - Recurring Patterns & Backlog

**Update if:**
- User mentions a recurring preference ("I always...", "I usually...")
- Pattern in how user works or thinks
- Feature idea or improvement suggestion
- Task for later (not urgent, not dated)
- User mentions forgetting something repeatedly

**Examples:**
- "I always forget to check email" → Add pattern
- "I usually work on weekends" → Add pattern
- "Would be nice to have dark mode" → Add to backlog
- "Need to refactor this eventually" → Add to backlog

**Format:**
```markdown
## Patterns
- Prefers async communication over meetings
- Forgets to check email in mornings → Consider morning reminder

## Backlog
- [ ] Add dark mode to dashboard
- [ ] Refactor authentication system
- [ ] Research better calendar integration
```

## When NOT to Update (Silence Criteria)

**Skip reflection if:**
- Casual conversation with no actionable items
- Informational query answered completely
- User just saying thanks or acknowledging
- Small talk or greetings
- Simple questions with no follow-up needed

**Examples of skippable conversations:**
- "What's the weather?"
- "Thanks!"
- "How do I use git?"
- "Explain how async works"

**Output:** If nothing to capture, return `[SKIP_REFLECTION]` to save tokens.

## Integration with manage-state Skill

For detailed file operations, use the `manage-state` skill:
- Reading current state files
- Appending to sections
- Bash commands for updates

**Example workflow:**
1. Identify what needs updating (this skill)
2. Load `manage-state` for file operations (if needed)
3. Execute updates via Write or Bash tools

## Cross-Referencing

**Check for connections to:**
- Existing projects (read `projects.md`)
- People mentioned (check `people/*.md`)
- Research topics (check `research/`)

If the conversation relates to existing context, note the connection in the state file update.

## Example Reflection Decision Tree

```
User said: "Remind me to call Sarah next week about the project"

Decision:
1. Task mentioned? YES ("call Sarah")
2. Specific date? YES ("next week")
3. Related to project? Check projects.md
4. Person mentioned? Check people/sarah.md

Actions:
- Add to inbox.md: "[ ] Call Sarah about project (next week)"
- Update people/sarah.md: "Follow-up needed re: project"
- (Optional) Check projects.md to see which project
```

```
User said: "I'm thinking about switching to Neovim"

Decision:
1. Task mentioned? NO (just thinking)
2. Pattern/preference? YES (interest in tools)
3. Commitment? NO

Actions:
- Add to patterns.md: "Interested in exploring Neovim"
- Could add to backlog: "[ ] Try Neovim for a week"
```

```
User said: "What's 2 + 2?"

Decision:
1. Task mentioned? NO
2. Pattern? NO
3. Insight? NO
4. Casual/informational? YES

Action:
- Output: [SKIP_REFLECTION]
```

## Output Format

If updates made:
- Use Write tool to update state files
- Log brief summary: "Updated inbox.md with 2 tasks, patterns.md with preference"

If no updates needed:
- Output: `[SKIP_REFLECTION]`
- No tools called, save tokens

## Best Practices

- **Be selective:** Not everything needs capturing
- **Signal over noise:** Only capture what's actionable or insightful
- **Short entries:** State files should be scannable
- **Cross-reference:** Connect to existing state when relevant
- **Respect silence:** Many conversations need no reflection

## Model Recommendation

Use Sonnet for reflection (better judgment, pattern recognition) rather than Haiku (may miss subtle patterns).
