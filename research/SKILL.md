---
name: research
description: Deep research pattern for Tijs. Establish his context first (projects, work, recent activity, goals), then go deep on 2-3 items rather than broad. Synthesize findings for his specific work, not generic reports. Use when user asks to research a topic or investigate something.
---

# Research Skill

Conduct deep, contextual research synthesized for Tijs's specific situation.

## Research Philosophy

**NOT generic research** - This is about Tijs's specific needs, projects, and
context.

**Pattern:**

1. **Establish context** - What is Tijs working on? What are his goals?
2. **Deep dive** - Go deep on 2-3 specific items, not broad overviews
3. **Synthesize** - Findings relevant to Tijs's work/projects, not generic info
4. **Actionable** - Concrete next steps or recommendations

## Research Process

### Step 1: Establish Tijs's Context

Before researching, understand current situation:

```bash
# Check active projects
cat /home/tijs/roci/state/projects.md

# Check what's on his mind today
cat /home/tijs/roci/state/today.md

# Check recent patterns
cat /home/tijs/roci/state/patterns.md

# Check inbox for related items
cat /home/tijs/roci/state/inbox.md

# Check recent journal for related topics
tail -50 /home/tijs/roci/state/logs/journal.jsonl | jq -c 'select(.topics | contains(["<relevant-topic>"]))'
```

**Optional context checks** (if relevant to research topic):

```bash
# Reading interests
cat /home/tijs/roci/state/books.md

# Podcast interests
cat /home/tijs/roci/state/podcasts.md

# Check if related people exist
ls /home/tijs/roci/state/people/ | grep -i "<name>"
```

### Step 2: Conduct Deep Research

Use available tools for research:

**Search tools:**

- `search_rag` - Search ingested documents for relevant info
- `search_atproto` - Search Bluesky posts/bookmarks for Tijs's own content
- Web search (if available via MCP tools)

**Read tools:**

- `Read` - Read reference docs, codebases, or uploaded files

**Pattern:**

- **Focus:** 2-3 specific angles, not broad overviews
- **Depth:** Go deep on each angle
- **Relevance:** Always tie back to Tijs's specific context

### Step 3: Create Research Output

Save research to `/home/tijs/roci/state/research/<topic>/`:

**Organize by topic area:**

```bash
# Create topic directory if needed
mkdir -p /home/tijs/roci/state/research/wellness
mkdir -p /home/tijs/roci/state/research/tech
mkdir -p /home/tijs/roci/state/research/finance
mkdir -p /home/tijs/roci/state/research/productivity
```

**Create research document** (use dated filename for time-sensitive research):

```bash
cat > /home/tijs/roci/state/research/wellness/sleep-2025-12.md << 'EOF'
# Sleep Optimization for Evening Workers - December 2025

**Research Question:** How can Tijs improve sleep quality given his evening work preference?

## Tijs's Context

- Prefers evening work sessions (from human memory block)
- Works late often, inconsistent sleep schedule (from journal patterns)
- Current challenge: Balancing productivity peak time with sleep consistency
- Timezone: Europe/Amsterdam (CET/CEST)

## Findings

### 1. Sleep Consistency vs Duration for Evening Chronotypes

[Deep dive on research specific to evening chronotypes, not generic sleep advice]

**Key insight:** For evening chronotypes, consistency within a later schedule (e.g., 1am-9am consistently) produces better outcomes than forcing earlier times with high variability.

**Relevant studies:**

- [Cite specific research]
- [Relevant findings for Tijs's situation]

### 2. Pre-Sleep Routine for Knowledge Workers

[Specific findings relevant to Tijs's evening work pattern]

**Key insight:** Wind-down period effectiveness depends on work type. For deep technical work (Tijs's pattern), 60-90 min buffer more effective than standard 30 min.

**Practical implications:**

- [Specific to Tijs's work patterns]

### 3. Blue Light and Screen Time for Evening Workers

[Findings considering Tijs's screen-intensive work]

**Key insight:** Absolute blue light blocking less important than timing and intensity reduction. Gradual reduction in last 90 min more sustainable than hard cutoff.

## Actionable Insights for Tijs

1. **Recommendation: Embrace evening schedule, optimize consistency**
   - Target consistent sleep window: 1:00am - 9:00am
   - Track consistency (more important than shifting earlier)
   - Use patterns.md to track sleep times

2. **Recommendation: 90-minute wind-down protocol**
   - 11:30pm: Reduce screen brightness to 30%
   - 12:00am: Switch to lighter tasks (reading, planning)
   - 12:30am: Non-screen activity (reading physical book, journaling)
   - 1:00am: Sleep

3. **Recommendation: Weekly sleep audit**
   - Add to patterns: "Weekly review of sleep consistency"
   - Use journal entries to correlate work patterns with sleep quality

## Next Steps

- [ ] Add wind-down protocol to patterns.md
- [ ] Create commitment for weekly sleep review
- [ ] Track for 2 weeks, then reassess

## Sources

- [Source 1: Study on chronotype and productivity]
- [Source 2: Research on knowledge worker sleep patterns]
- [Source 3: Blue light meta-analysis]

**Research completed:** 2025-12-28
**For:** Tijs's specific sleep optimization based on evening work preference
EOF
```

### Step 4: Completion

Research output is automatically journaled by the reflection phase after your
response. The journal entry will capture topics, what the user asked, and what
you discovered.

## Directory Organization

```
research/
├── wellness/          # Health, sleep, exercise, nutrition
├── tech/              # Technology, programming, AI, tools
├── finance/           # Financial topics, investing
├── productivity/      # Work methods, tools, systems
├── travel/            # Travel planning, destinations
└── [custom]/          # Other topic areas as needed
```

**Create topic directories on-demand:**

```bash
mkdir -p /home/tijs/roci/state/research/<new-topic>
```

## File Naming Conventions

**For time-sensitive research:**

- Include month/year: `sleep-2025-12.md`
- Allows tracking evolution of research over time

**For evergreen research:**

- Use descriptive topic name: `ai-agents-architecture.md`
- Update in place as new info emerges

**For multi-part research:**

- Use part numbers: `roci-v3-part1-architecture.md`
- Or use subdirectories: `roci-v3/architecture.md`

## Research Output Structure

**Required sections:**

1. **Research Question** - What specific question are you answering?
2. **Tijs's Context** - Why this matters, what's his situation?
3. **Findings** - 2-3 deep dives on specific aspects
4. **Actionable Insights** - Concrete recommendations for Tijs
5. **Sources** - Citations for credibility and follow-up

**Optional sections:**

- Next Steps - Follow-up tasks or experiments
- Related Research - Links to other research files
- Updates - Track evolution if research is ongoing

## Best Practices

### Context First

- **Always** establish Tijs's context before researching
- Read projects.md, today.md, patterns.md at minimum
- Check journal for recent related topics
- Understand WHY this research matters to Tijs specifically

### Deep Not Broad

- **Don't:** Generic Wikipedia-style overviews
- **Do:** Deep dive on 2-3 specific aspects relevant to Tijs
- **Example:** Not "What is sleep?", but "How do evening chronotypes optimize
  sleep consistency?"

### Synthesize for Tijs

- **Don't:** Generic advice ("sleep 8 hours", "avoid screens")
- **Do:** Specific recommendations considering Tijs's constraints and
  preferences
- **Example:** "Given your evening work preference and screen-intensive work,
  here's a 90-min wind-down protocol..."

### Make it Actionable

- Include concrete next steps
- Suggest specific experiments or changes
- Link to task files (inbox, commitments, patterns) where appropriate

### Date Time-Sensitive Research

- Include date in filename for research that may become outdated
- Example: `ai-agents-2025.md` (AI landscape changes rapidly)
- vs `sleep-optimization.md` (sleep science changes slowly)

## Integration with Other Systems

### With Task Capture

Research may generate tasks:

```bash
# Add research-derived task to inbox
echo "- Experiment with 90-min wind-down protocol (from sleep research)" >> /home/tijs/roci/state/inbox.md
```

### With Patterns

Research may identify patterns:

```bash
# Update patterns with research-backed routine
# (Would update patterns.md with wind-down protocol)
```

### With People

Research may involve people:

```bash
# If research involves someone Tijs knows
cat /home/tijs/roci/state/people/expert-name.md
```

### With RAG

Research may use ingested documents:

```bash
# Search ingested docs (example)
search_rag("topic keywords", limit=5)
```

## Common Research Workflows

### Quick Research (User Asked a Question)

1. Establish context (check projects, today, patterns)
2. Use search_rag or search_atproto for quick answers
3. Synthesize answer (may not need full research doc)
4. (Journal logged automatically by reflection phase)

### Deep Research (Substantial Investigation)

1. Establish context comprehensively
2. Conduct multi-source research
3. Create research document in research/<topic>/
4. Generate follow-up tasks
5. (Journal logged automatically by reflection phase)

### Ongoing Research (Multi-Session)

1. Create initial research doc (marked DRAFT or WIP)
2. Add findings incrementally over sessions
3. Update "Last Updated" date
4. Mark complete when done

## Examples

### Wellness Research

```bash
# Context: Tijs asks "How can I improve my sleep?"
# Output: research/wellness/sleep-2025-12.md (shown above)
```

### Tech Research

```bash
# Context: Tijs asks "Research AI agent architectures for me"
# Output: research/tech/ai-agents-2025.md
# Includes: Context (Tijs is building Roci), deep dive on 2-3 architectural patterns relevant to Roci's design, specific recommendations for Roci v3
```

### Productivity Research

```bash
# Context: Tijs asks "How should I structure my week?"
# Output: research/productivity/weekly-structure-2025-12.md
# Includes: Context (current work projects, commitments), research on weekly planning for evening chronotypes, specific weekly template for Tijs
```

## Notes

- Research is about depth, not breadth
- Context is critical - always establish before diving in
- Synthesize for Tijs specifically, not generic advice
- Make it actionable with concrete recommendations
- See `/home/tijs/roci/state/research/README.md` for additional conventions
