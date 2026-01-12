# memories Workflow Guide

Persistent memory system for Claude Code sessions. Store patterns, gotchas, and learnings.

> **For complete API reference** → See [MCP_API_REFERENCE.md](MCP_API_REFERENCE.md)

## Mandatory: Every Session Start

```python
namespaces()
# → {"groups": [{"group_id": "personal"}, ...]}
```

**Important**: Remember the `group_id` for all subsequent calls!

---

## Typical Workflow

### 1. Before Coding (Peek Mode - Free!)
```python
recall(query="what you need", group_ids=["personal"], max_tokens=0)
# → {"total_available": 5, "token_estimate": 2400}
# Zero tokens spent - just checking what's available
```

### 2. Load if Needed (Budget Mode)
```python
recall(query="what you need", group_ids=["personal"], max_tokens=2000)
# → Load up to 2000 tokens of relevant context
```

### 3. After Finding Something Important
```python
remember(
  content="What you discovered (bug fix, pattern, gotcha)",
  group_id="personal",
  context="Where this came from (optional citation)"
)
```

---

## How Hooks Work

### SessionStart Hook
- Automatically runs when Claude Code session starts
- **Transparent** - you won't see anything
- Prepares memory environment
- Non-blocking - session runs even if memory is offline

### PostToolUse Hook
- Automatically runs after `remember()` call
- Validates that write succeeded
- **Shows error** if remember() failed
- Stops execution if error detected

---

## Common Patterns

| Situation | Command |
|-----------|---------|
| "What did I learn before?" | `recall(query="learnings", group_ids=["personal"], max_tokens=0)` → peek first |
| "Remember this bug fix" | `remember(content="Bug in X was Y, fix is Z", group_id="personal")` |
| "Remove old note" | `forget(id="memory_id")` |
| "List my namespaces" | `namespaces()` |
| "Show recent memories" | `list(group_ids=["personal"], max_items=10)` |
| "Search multiple projects" | `recall(query="pattern", group_ids=["personal", "project-x"])` |

---

## Important Rules

❌ **New session without calling namespaces()?** → Error!
✅ **Always call namespaces() FIRST**

❌ **recall() with wrong group_id?** → 0 results
✅ **Copy group_id from namespaces() response**

❌ **remember() without group_id?** → Error!
✅ **Always include group_id**

❌ **Large recalls without max_tokens?** → Token explosion
✅ **Always peek first (max_tokens=0), then decide budget**

---

## Pro Tips

- **Peek is free**: `max_tokens=0` gives you count + estimate, no tokens spent
- **Multiple namespaces**: `group_ids=["personal", "project-a", "project-b"]` searches all
- **Original content**: `include_source=true` gives you full episode text (not just extracted facts)
- **Save immediately**: Don't wait until end of session - remember() right after discovery
- **Use context**: Add citations so you remember where ideas came from

---

## Examples

### Peek Before Load
```python
# Check what's available
result = recall(query="async patterns", group_ids=["personal"], max_tokens=0)
print(f"Found {result['total_available']} memories, {result['token_estimate']} tokens")

# If many tokens, maybe be more specific
if result['token_estimate'] > 4000:
    result = recall(
        query="async patterns for websockets",
        group_ids=["personal"],
        max_tokens=2000
    )
```

### Remember with Citation
```python
remember(
    content="React hook deps array: include all values used in effect body",
    group_id="personal",
    context="React Hooks Rules - ESLint plugin docs"
)
```

### Search Multiple Projects
```python
# Search across personal + all projects
recall(
    query="type guards",
    group_ids=["personal", "project-auth", "project-api"],
    max_tokens=3000
)
```

---

## Gotchas to Avoid

- Don't guess namespaces - always call `namespaces()` first
- `max_tokens=null` (or omit) = unlimited - watch your token budget!
- `include_source=true` has overhead - only use when needed
- Sessions are isolated - each session has fresh context (hooks help with this)

---

Start with `namespaces()` in your next session. Enjoy! 🚀

---

## Full API Documentation

Need details on all 8 tools, parameters, response formats, and error handling?

→ See **[MCP_API_REFERENCE.md](MCP_API_REFERENCE.md)**

Also covers:
- Token budget control (peek/budget/unlimited)
- Rate limits
- Common workflows
- Error handling guide
- Best practices
