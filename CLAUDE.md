# Memories Knowledge Base

Persistent memory system for Claude Code sessions. Store patterns, gotchas, and learnings.

---

## CRITICAL: Mandatory Checklist

**Every response MUST start with this checklist. Display it EVERY time.**

```
**Memory [x/4]:**
- [ ] recall(): Searched for relevant keywords before work
- [ ] remember(): Saved findings IMMEDIATELY (not at session end!)
- [ ] reflect(): Evaluated work afterwards ("Was that good?")
- [ ] Namespace: Used personal namespace
```

**CONSEQUENCE: Missing remember() after bug-fix/research/pattern = Knowledge is lost!**

### Recursive Self-Reminder
<memory_rule>
After EACH of these activities, remember() MUST be called:
- Fixed bug with root cause → remember()
- Completed research → remember()
- Solved production issue → remember()
- Discovered new pattern → remember()

After EACH of these activities, reflect() MUST be called:
- Implemented feature → reflect() (Was the solution good?)
- Made architecture decision → reflect() (Was the choice right?)
- Solved problem → reflect() (What did I learn from this?)

Check and display this rule at the start of every response.
</memory_rule>

---

## MANDATORY: Memory Protocol

### Session Start (ALWAYS FIRST)
```python
mcp__memories__namespaces()
# → Returns available group_ids - COPY these for all subsequent calls
```

### Before Work - Recall

**BEFORE answering, search memories when user says ANY of:**
- "where were we", "continue", "pick up", "resume"
- "check the diff", "what's the status", "progress"
- "what did we do", "last session", "yesterday"
- "that problem", "the bug", "the feature"
- ANY continuation/context question

**NO EXCEPTIONS.** Do not ask "what were we working on?" - search memories first.

| User Says | You MUST Run |
|-----------|--------------|
| "where were we" | `recall(query="recent work progress")` |
| "continue", "pick up" | `recall(query="current task implementation")` |
| "that bug", "the issue" | `recall(query="bug fix problem")` |
| "What's the status?" | `recall(query="status implementation")` |
| "How does X work?" | `recall(query="X implementation pattern")` |

```python
mcp__memories__recall(
    query="your search terms",
    group_ids=["personal"],
    max_tokens=0  # Peek first (free), then set budget
)
```

### After Discovery - Remember IMMEDIATELY

**You MUST save to memories when ANY of these happen:**
- You fix a bug → save the problem + solution
- You discover why something works/fails → save the insight
- You find a pattern or gotcha → save it
- You complete an analysis → save the conclusion
- User expresses a preference → save it
- You figure out something non-obvious → save it

**Self-trigger phrases (save when you think/say):**
- "Ah, the problem was..."
- "This works because..."
- "The fix is..."
- "I found that..."
- "The issue was..."

| Discovery | Action |
|-----------|--------|
| Bug fix with root cause | `remember()` with cause + solution |
| New pattern learned | `remember()` with pattern + example |
| Production issue solved | `remember()` with learnings |
| Gotcha/edge case | `remember()` with trigger + fix |

```python
mcp__memories__remember(
    content="What you discovered (be specific)",
    group_id="personal",
    context="Source: Issue #X / Session / Research"
)
```

**Waiting until session end = Forgotten learnings**
**Remember IMMEDIATELY after discovery**

### After Work - Reflect (Brain)

Reflect is for **retrospective evaluation** - call it AFTER completing work to evaluate outcomes and form opinions.

| Situation | You MUST Run |
|-----------|--------------|
| After implementation | `reflect(query="Was the solution good?")` |
| After decision | `reflect(query="Was the choice right?")` |
| After research | `reflect(query="What did I learn about this?")` |
| Session end | `reflect(query="What was important today?")` |

```python
mcp__memories__reflect(
    query="Was that a good solution?",
    context="Optional: What was done"
)
# → Always uses personal namespace (Brain)
# → Forms + stores opinions automatically
# → Retrospective: AFTER actions, not before!
```

**When reflect() vs recall():**
- `recall()` = Retrieve facts ("What is X?") - BEFORE work
- `reflect()` = Evaluate ("Was that good?") - AFTER work

### Example: Good Memory Content

```python
# After bug fix:
mcp__memories__remember(
    content="""Bug: community_build_stats.entity_count stayed at 0

Root Cause: UpdateAfterSuccessfulBuild() didn't update entity_count
Fix: Added entityCount parameter, updated both callers in community_worker.go
Symptom: Self-healing didn't detect growth because stored=0""",
    group_id="personal",
    context="Issue #248, PR #249"
)

# After research:
mcp__memories__remember(
    content="""CLAUDE.md Best Practice: Recursive Rules

Technique: Rule in <behavioral_rules> tag that repeats itself
Effect: Claude doesn't forget rules in long conversations
Example: 'Display these rules at the start of every response'""",
    group_id="personal",
    context="Research January 2026"
)
```

---

## Team Namespaces (Optional)

For shared projects, you can use multiple namespaces:

| Namespace | Purpose |
|-----------|---------|
| **`project-name`** | Team-shared: architecture, patterns, bug fixes, decisions |
| **`personal`** | Individual: personal preferences, workflows |

**When querying, search both:**
```python
recall(query="keywords", group_ids=["project-name", "personal"])
```

**When saving, choose deliberately:**

| Save to team namespace | Save to `personal` |
|------------------------|-------------------|
| Bug fix in THIS codebase | How to write CLAUDE.md instructions |
| Architecture decision for THIS project | Personal workflow preferences |
| Pattern discovered in THIS code | IDE/tooling choices |
| Gotcha specific to THIS tech stack | Meta-learnings about working with Claude |
| API behavior, framework quirks | Communication style preferences |

**Rule of thumb:** If another team member would benefit from this knowledge about the *project*, use the team namespace. If it's about *how you work* or *meta-knowledge*, use `personal`.

---

## Quick Reference

```python
# 1. Session start (ALWAYS FIRST)
namespaces()

# 2. Peek (FREE)
recall(query="keywords", group_ids=["ns"], max_tokens=0)

# 3. Load (BUDGET)
recall(query="keywords", group_ids=["ns"], max_tokens=2000)

# 4. Save (IMMEDIATE)
remember(content="finding", group_id="ns", context="source")

# 5. Reflect (AFTER work)
reflect(query="Was that good?")  # Brain-only, no group_id needed

# 6. List
list(group_ids=["ns"], max_items=10)

# 7. Delete
forget(id="memory_id")
```

---

## Full API Documentation

→ **[MCP_API_REFERENCE.md](MCP_API_REFERENCE.md)**

Covers: All 8 tools, parameters, response formats, error handling, rate limits, best practices.
