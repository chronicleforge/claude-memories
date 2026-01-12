# Memories Knowledge Base

Persistent memory system for Claude Code sessions. Store patterns, gotchas, and learnings.

> **Full API Reference** → [MCP_API_REFERENCE.md](MCP_API_REFERENCE.md)

---

## CRITICAL: Mandatory Checklist

**Every response involving this project MUST start with:**

```
**Memory Check [x/3]:**
- [ ] Session Start: Called `namespaces()` to get available group_ids
- [ ] Before Work: Called `recall()` with relevant keywords
- [ ] After Discovery: Called `remember()` for any new patterns/fixes
```

**If this checklist is missing, the response is INVALID.**

---

## MANDATORY: Session Start Protocol

**FIRST THING** in every session - no exceptions:

```python
namespaces()
# → Returns available group_ids - COPY these for all subsequent calls
```

❌ **Skipping this = All memory operations will fail**

---

## MANDATORY: When to Use Recall

**BEFORE touching any code or answering questions:**

| User Says | You MUST Run |
|-----------|--------------|
| "What's the status?" | `recall(query="status implementation features")` |
| "Is everything committed?" | `recall(query="recent changes uncommitted pending")` |
| "How does X work?" | `recall(query="X implementation pattern")` |
| Before any build | `recall(query="pending changes blockers")` |
| "What did we do last time?" | `recall(query="recent session progress")` |
| Any architecture question | `recall(query="architecture decisions patterns")` |

### Recall API

```python
mcp__memories__recall(
    query="your search terms",
    group_ids=["your_namespace"],  # From namespaces() call
    max_tokens=0  # Peek first (free), then set budget
)
```

**Workflow:**
1. Peek: `max_tokens=0` → Get count + token estimate (FREE)
2. Load: `max_tokens=2000` → Actually retrieve content

---

## MANDATORY: When to Use Remember

**IMMEDIATELY after discovering:**

| Discovery | Action |
|-----------|--------|
| Bug fix with root cause | `remember()` with cause + solution |
| New pattern learned | `remember()` with pattern + example |
| API/layout change | `remember()` with before/after |
| Gotcha/edge case | `remember()` with trigger + fix |
| Architecture decision | `remember()` with rationale |

### Remember API

```python
mcp__memories__remember(
    content="What you discovered (be specific)",
    group_id="your_namespace",  # From namespaces() call
    context="Source/citation (optional)"
)
```

❌ **Waiting until session end = Forgotten learnings**
✅ **Remember immediately after discovery**

---

## Critical Rules

| Rule | Consequence |
|------|-------------|
| No `namespaces()` at session start | All memory calls fail |
| Wrong `group_id` | 0 results returned |
| `remember()` without `group_id` | Write fails |
| Large `recall()` without `max_tokens` | Token explosion |
| Guessing namespaces | Wrong or missing data |

---

## Quick Reference

```python
# 1. Session start (ALWAYS FIRST)
namespaces()

# 2. Check what's available (FREE)
recall(query="keywords", group_ids=["ns"], max_tokens=0)

# 3. Load memories (BUDGET)
recall(query="keywords", group_ids=["ns"], max_tokens=2000)

# 4. Save discovery (IMMEDIATE)
remember(content="finding", group_id="ns", context="source")

# 5. List recent
list(group_ids=["ns"], max_items=10)

# 6. Delete old
forget(id="memory_id")
```

---

## Hooks (Automatic)

- **SessionStart**: Prepares memory environment (transparent)
- **PostToolUse**: Validates `remember()` succeeded (shows error if failed)

---

## Full API Documentation

→ **[MCP_API_REFERENCE.md](MCP_API_REFERENCE.md)**

Covers: All 8 tools, parameters, response formats, error handling, rate limits, best practices.
