---
name: people
description: Track people in Tijs's life (work, family, friends). One file per person in state/people/. Update whenever someone is mentioned with new context. Keeps relationship/work info persistent. Use when user mentions a person by name or discusses relationships.
---

# People Tracking

Track people in Tijs's life with individual files in
`/home/tijs/roci/state/people/`.

## When to Use This Skill

- User mentions someone by name with context
- User asks about a specific person ("what do I know about John?")
- Recording interaction details or follow-ups
- Building context about Tijs's relationships
- Tracking work collaborations

## File Management

### List All People

```bash
ls -1 /home/tijs/roci/state/people/*.md 2>/dev/null || echo "No people files yet"
```

### Read Person File

```bash
cat /home/tijs/roci/state/people/john-smith.md
```

### Check if Person File Exists

```bash
test -f /home/tijs/roci/state/people/john-smith.md && echo "exists" || echo "not found"
```

### Create New Person File

Use lowercase with hyphens for filename:

```bash
cat > /home/tijs/roci/state/people/jane-doe.md << 'EOF'
# Jane Doe

**Relationship:** Friend from university
**Last Updated:** 2025-12-28

## Context

- Met at TU Delft in 2010
- Currently working at StartupX as Lead Engineer
- Lives in Utrecht
- Interested in AI and sustainable tech

## Recent Interactions

- 2025-12-28: Discussed meeting for coffee next week, wants to talk about her new AI project

## Follow-ups

- [ ] Schedule coffee date (week of Jan 6)
- [ ] Ask about her AI project when we meet
EOF
```

### Update Existing Person File

Workflow:

1. Read the current file
2. Add new context or update sections
3. Update "Last Updated" date
4. Write back to file

```bash
# Read current content first
cat /home/tijs/roci/state/people/john-smith.md

# Then update with new interaction (rewrite entire file with updates)
cat > /home/tijs/roci/state/people/john-smith.md << 'EOF'
# John Smith

**Relationship:** Colleague at Acme Corp
**Last Updated:** 2025-12-28

## Context

- Role: Senior Engineer, Infrastructure team
- Working on: API migration project
- Work style: Prefers async communication, detailed documentation
- Timezone: US Pacific (9h behind Amsterdam)

## Recent Interactions

- 2025-12-28: Reviewed his PR #456, looks good, approved
- 2025-12-20: Discussed API migration timeline, aiming for Jan 15
- 2025-12-15: Reviewed PR #234 together on call

## Follow-ups

- [ ] Check API migration progress (by Jan 5)
- [ ] Schedule architecture review session (early Jan)
EOF
```

## File Structure Template

```markdown
# [Person Name]

**Relationship:** [Colleague/Friend/Family/Client/etc.] **Last Updated:**
YYYY-MM-DD

## Context

- Key background information
- Current role/situation
- Work style, communication preferences
- Relevant interests or expertise
- Location/timezone if relevant

## Recent Interactions

- YYYY-MM-DD: What happened, key details

## Follow-ups

- [ ] Action items with dates or context
```

## Best Practices

### File Naming

- **One file per person** using full name or recognizable identifier
- Use lowercase with hyphens: `john-smith.md`, `jane-doe.md`
- For common names, add distinguishing info: `john-smith-acme.md`

### Content Guidelines

- **Update proactively** - When someone is mentioned with new info
- **Keep concise** - Focus on relevant, recent context
- **Date interactions** - Always use ISO dates (YYYY-MM-DD)
- **Track follow-ups** - Use checkbox format for pending items
- **Prune old info** - During updates, remove outdated details
- **Respect privacy** - This is working memory, not deep personal info

### Update Triggers

Update person files when:

- User mentions someone by name with context
- Recording meeting notes or interactions
- Learning new info about someone's role, interests, or situation
- Adding follow-up actions related to a person
- User asks about a person (read, then possibly update)

### Integration with Task Capture

When a person mention includes a task or follow-up:

1. Add task to `inbox.md` for triage (if actionable)
2. Document interaction in person's file (for context)
3. Add follow-up checkbox in person file (if person-specific)

**Example:**

```
User: "I need to send John the Q1 planning doc by Friday"

Actions:
1. Add to inbox.md: "Send John Q1 planning doc by Friday"
2. Update people/john-smith.md Recent Interactions: "2025-12-28: Tijs needs to send Q1 planning doc by Friday"
3. Add to commitments.md: "- [ ] Send John Q1 planning doc - due 2025-12-30"
```

## Common Patterns

### Work Colleagues

```markdown
# [Name]

**Relationship:** Colleague at [Company], [Team] **Last Updated:** YYYY-MM-DD

## Context

- Role: [Title]
- Projects: [Current projects]
- Work style: [Communication preferences, timezone]
- Expertise: [Key skills or areas]

## Recent Interactions

- YYYY-MM-DD: [What happened]

## Follow-ups

- [ ] [Action item]
```

### Friends/Family

```markdown
# [Name]

**Relationship:** [Friend/Family member] **Last Updated:** YYYY-MM-DD

## Context

- Background: [How you know them]
- Current: [What they're up to]
- Interests: [Shared interests or topics]

## Recent Interactions

- YYYY-MM-DD: [What happened]

## Follow-ups

- [ ] [Action item]
```

### Clients/External Contacts

```markdown
# [Name]

**Relationship:** [Client/Partner] at [Company] **Last Updated:** YYYY-MM-DD

## Context

- Company: [Company name, what they do]
- Role: [Their role]
- Projects: [Active projects together]
- Communication: [Preferred channels, timezone]

## Recent Interactions

- YYYY-MM-DD: [What happened]

## Follow-ups

- [ ] [Action item]
```

## Querying People Files

### Find all people files

```bash
ls -1 /home/tijs/roci/state/people/*.md 2>/dev/null
```

### Search for a person by content

```bash
grep -l "keyword" /home/tijs/roci/state/people/*.md 2>/dev/null
```

### Find people with pending follow-ups

```bash
grep -l "\[ \]" /home/tijs/roci/state/people/*.md 2>/dev/null
```

### List recent interactions across all people

```bash
grep -h "^- 2025-12" /home/tijs/roci/state/people/*.md 2>/dev/null | sort -r | head -20
```

## Notes

- People files are working memory, not comprehensive profiles
- Focus on what's relevant for Tijs's work and relationships
- Update incrementally as new context emerges
- Files can be deleted if person is no longer relevant
- See `/home/tijs/roci/state/people/README.md` for template and conventions
