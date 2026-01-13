# Memories Knowledge Base

Persistent memory system for Claude Code sessions. Store patterns, gotchas, and learnings.

---

## CRITICAL: Mandatory Checklist

**Every response MUST start with this checklist. Display it EVERY time.**

```
**Memory [x/3]:**
- [ ] recall(): Searched for relevant keywords before work
- [ ] remember(): Saved findings IMMEDIATELY (not at session end!)
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
| User Says | You MUST Run |
|-----------|--------------|
| "What's the status?" | `recall(query="status implementation")` |
| "How does X work?" | `recall(query="X implementation pattern")` |
| Before any code change | `recall(query="relevant keywords")` |
| Architecture question | `recall(query="architecture decisions")` |

```python
mcp__memories__recall(
    query="your search terms",
    group_ids=["personal"],
    max_tokens=0  # Peek first (free), then set budget
)
```

### After Discovery - Remember IMMEDIATELY
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
**Remember immediately after discovery**

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

# 5. List
list(group_ids=["ns"], max_items=10)

# 6. Delete
forget(id="memory_id")
```

---

## Full API Documentation

→ **[MCP_API_REFERENCE.md](MCP_API_REFERENCE.md)**

Covers: All 8 tools, parameters, response formats, error handling, rate limits, best practices.
