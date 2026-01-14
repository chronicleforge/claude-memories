# MCP API Reference

Complete reference for the memories MCP server. 8 backend-agnostic tools for AI agent integration.

---

## Overview

The memories MCP server exposes 8 tools for managing persistent memory:

| Tool | Permission | Purpose |
|------|-----------|---------|
| `remember` | WRITE | Store information in memory |
| `recall` | READ | Retrieve memories based on query |
| `reflect` | READ | Generate insights using LLM synthesis |
| `forget` | WRITE | Delete a memory by ID |
| `list` | READ | List memories with pagination |
| `namespaces` | READ | List accessible namespaces |
| `status` | READ | Get service health and queue stats |
| `clear` | WRITE | Clear all memories from namespace |

---

## Authentication

All MCP calls require authentication via API Key in the `Authorization` header:

```
Authorization: Bearer gm_xxxxx...
```

**Format:**
- Keys start with `gm_` prefix
- Followed by 64 hex characters
- Example: `gm_a1b2c3d4e5f6...`

---

## Tool Reference

### remember

**Store information in memory.**

The content will be processed and indexed for later retrieval via `recall`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `content` | string | ✅ Yes | The content/information to remember. Can be plain text, code, patterns, findings, etc. |
| `group_id` | string | ✅ Yes | Namespace identifier (e.g., `"personal"`, `"my_project"`, `"shared_notes"`). Determines who can access this memory. |
| `context` | string | ❌ No | Source citation (e.g., `"BGB § 312k"`, `"Issue #123"`). Stored as `source_description`, retrieved via `include_source=true` on recall. |
| `source` | string | ❌ No | Source type: `"text"`, `"json"`, `"message"` (default: `"text"`). Affects how content is indexed. |

**Response:**

```json
{
  "content": "String with type, or Error object",
  "example": "Memory stored successfully"
}
```

**Examples:**

```python
# Simple remember
remember(
    content="React hook rule: always call hooks at top level",
    group_id="personal"
)

# With citation
remember(
    content="Deadlocks happen when Tasks don't await properly",
    group_id="personal",
    context="Issue #456 - async/await debugging"
)

# JSON data
remember(
    content={"title": "API Design", "version": "2.0"},
    group_id="personal",
    source="json"
)
```

---

### recall

**Retrieve memories based on search query.**

Searches memories and returns relevant results. Use `max_tokens` to control token spending.

**Parameters:**

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `query` | string | ✅ Yes | — | Search query to find relevant memories. Use keywords, phrases, or questions. |
| `group_ids` | array[string] | ❌ No | [] (all accessible) | Filter by namespaces. Empty array searches all accessible namespaces. |
| `max_items` | number | ❌ No | 10 | Maximum memories to return. Set higher for broader searches. |
| `max_tokens` | number | ❌ No | null (unlimited) | Token budget control: `null` = no limit, `0` = peek mode, `>0` = budget in tokens |
| `include_source` | boolean | ❌ No | false | Include source citations and original episode content. Requires additional DB lookups. |

**Token Budget Modes:**

| Value | Mode | Cost | Use Case |
|-------|------|------|----------|
| `null` or omitted | Unlimited | Full token count | Simple recalls without cost concern |
| `0` | Peek | 0 tokens | Check what's available without loading |
| `>0` | Budget | Up to max_tokens | Load within specific token limit |

**Response:**

```json
{
  "memories": [
    {
      "id": "memory_uuid",
      "content": "The remembered information",
      "source_description": "Optional citation if include_source=true",
      "episode_content": "Full original text if include_source=true",
      "created_at": "2025-01-12T15:00:00Z"
    }
  ],
  "total_available": 15,
  "token_count": 1850,
  "token_estimate": 3200
}
```

**Field Explanations:**

- `memories`: Array of matching memories (limited by `max_items` and `max_tokens`)
- `total_available`: Total memories found (beyond max_items limit)
- `token_count`: Tokens in returned memories (for unlimited/budget modes)
- `token_estimate`: Estimated tokens for all available memories (peek mode only)

**Examples:**

```python
# Peek mode - check what's available (free)
result = recall(
    query="async patterns",
    group_ids=["personal"],
    max_tokens=0
)
print(f"Found {result['total_available']} memories, {result['token_estimate']} tokens needed")

# Budget mode - load within token limit
result = recall(
    query="async patterns",
    group_ids=["personal"],
    max_tokens=2000
)
# Returns up to 2000 tokens of relevant memories

# Unlimited mode - load everything
result = recall(
    query="async patterns",
    group_ids=["personal"]
)
# Returns all matching memories

# With source citations
result = recall(
    query="cancellation button",
    group_ids=["regulations"],
    include_source=True
)
# Returns memories with original citations and full text

# Search multiple namespaces
result = recall(
    query="type guards",
    group_ids=["personal", "project-auth", "project-api"],
    max_tokens=2000
)
# Searches across multiple projects
```

---

### reflect

**Generate insights from memory using LLM reflection. Brain-only operation.**

Reflect is for **retrospective evaluation** - call it AFTER completing work to evaluate outcomes and form opinions. Always uses your personal namespace (Brain) - no group_id parameter needed.

**Key Concept:** Reflect enables opinion formation. Unlike recall (which retrieves facts), reflect uses LLM synthesis to evaluate and form opinions based on your stored knowledge.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `query` | string | ✅ Yes | Question or topic to reflect on. Best for retrospective questions like "Was that good?" or "What did I learn?" |
| `context` | string | ❌ No | Additional context to guide the reflection (e.g., `"Just finished implementing the auth feature"`) |

**Note:** No `group_id` or `group_ids` parameter - reflect always operates on your personal namespace (Brain).

**Response:**

```json
{
  "answer": "Claude's synthesized insight/opinion based on memories",
  "sources": [
    {
      "id": "hs:memory_id",
      "content": "Source memory content",
      "type": "opinion|fact|experience"
    }
  ],
  "message": "Reflected on personal namespace (Brain)"
}
```

**When to Use:**

| Situation | Example Query |
|-----------|--------------|
| After implementing a feature | `"Was the solution I just built good?"` |
| After making a decision | `"Was choosing X over Y the right call?"` |
| After research/debugging | `"What did I learn about this bug?"` |
| Session end | `"What was important today?"` |

**Examples:**

```python
# Evaluate a solution (retrospective)
reflect(
    query="Was that a good implementation?",
    context="Just finished adding the caching layer"
)

# Form opinion on approach
reflect(
    query="Should I prefer composition over inheritance?",
    context="After refactoring the auth module"
)

# Session reflection
reflect(query="What patterns worked well today?")
```

**Reflect vs Recall:**

| Tool | Purpose | When |
|------|---------|------|
| `recall()` | Retrieve facts | BEFORE work |
| `reflect()` | Evaluate & form opinions | AFTER work |

---

### forget

**Remove a memory by ID.**

Deletes a specific memory. The exact deletion behavior depends on the backend (soft or hard delete).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `id` | string | ✅ Yes | UUID of the memory to forget |

**Response:**

```json
{
  "content": "Memory forgotten successfully" or Error object
}
```

**Examples:**

```python
# Remove outdated memory
forget(id="550e8400-e29b-41d4-a716-446655440000")
```

---

### list

**List memories with pagination.**

Browse memories from specified namespaces.

**Parameters:**

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `group_ids` | array[string] | ❌ No | [] (all accessible) | Filter by namespaces |
| `max_items` | number | ❌ No | 10 | Maximum memories per page |
| `offset` | number | ❌ No | 0 | Pagination offset (start position) |

**Response:**

```json
{
  "memories": [
    {
      "id": "memory_uuid",
      "content": "...",
      "created_at": "2025-01-12T15:00:00Z"
    }
  ],
  "total_count": 150,
  "offset": 0,
  "limit": 10
}
```

**Examples:**

```python
# List recent memories
list(group_ids=["personal"], max_items=10)

# Paginate through memories
list(group_ids=["personal"], max_items=10, offset=0)    # First page
list(group_ids=["personal"], max_items=10, offset=10)   # Second page

# List from all namespaces
list(max_items=20)
```

---

### namespaces

**List all accessible namespaces.**

Returns personal, project, and shared namespaces the current user can access.

**Parameters:**

None

**Response:**

```json
{
  "groups": [
    {
      "group_id": "personal",
      "display_name": "Personal",
      "backend": "hindsight|graphiti",
      "created_at": "2025-01-12T10:00:00Z"
    },
    {
      "group_id": "project_myapp",
      "display_name": "My App",
      "backend": "graphiti",
      "created_at": "2025-01-12T11:00:00Z"
    }
  ]
}
```

**Field Explanations:**

- `group_id`: Internal namespace identifier (use for API calls)
- `display_name`: Human-readable name
- `backend`: Storage backend (`hindsight` = short-term, `graphiti` = knowledge graph)
- `created_at`: When namespace was created

**Important:** Always call `namespaces()` at session start to get available `group_ids`.

**Examples:**

```python
# Get all accessible namespaces
result = namespaces()

# List available group_ids
for ns in result['groups']:
    print(f"{ns['display_name']}: {ns['group_id']}")
```

---

### status

**Get memory service status.**

Returns health of the memory service, backend status, and queue statistics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `group_ids` | array[string] | ❌ No | Filter queue stats to specific namespaces |

**Response:**

```json
{
  "status": "healthy|unhealthy",
  "backends": {
    "graphiti": {"status": "healthy", "latency_ms": 45},
    "hindsight": {"status": "healthy", "latency_ms": 120}
  },
  "queue": {
    "pending_jobs": 5,
    "active_workers": 2,
    "per_namespace": [
      {
        "group_id": "personal",
        "pending": 2,
        "processing": 1
      }
    ]
  },
  "uptime_seconds": 86400
}
```

**Field Explanations:**

- `status`: Overall health (`"healthy"` = all systems OK, `"unhealthy"` = something failed)
- `backends`: Health of each storage backend (graphiti, hindsight)
- `queue`: Background job queue statistics
- `uptime_seconds`: How long the service has been running

**Examples:**

```python
# Check overall health
result = status()
if result['status'] == 'healthy':
    print("Memory service is healthy")

# Check specific namespace queue
result = status(group_ids=["personal"])
for ns in result['queue']['per_namespace']:
    print(f"{ns['group_id']}: {ns['pending']} pending jobs")
```

---

### clear

**Clear all memories from a namespace.**

**WARNING: Destructive operation. Removes all stored memories from the specified namespace.**

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `group_id` | string | ✅ Yes | Namespace to clear (e.g., `"personal"`, `"old_project"`) |

**Response:**

```json
{
  "content": "Cleared X memories from namespace" or Error object
}
```

**Examples:**

```python
# Clear old project memories
clear(group_id="old_project")
```

---

## Common Workflows

### Workflow 1: Save a Bug Fix

```python
# 1. Save the fix
remember(
    content="Fixed async deadlock in updateUser() by adding proper await",
    group_id="personal",
    context="Issue #789"
)
```

### Workflow 2: Check & Load Context

```python
# 1. Peek first (free)
peek = recall(
    query="async patterns",
    group_ids=["personal"],
    max_tokens=0
)

# 2. Load if needed
if peek['token_estimate'] < 2000:
    result = recall(
        query="async patterns",
        group_ids=["personal"],
        max_tokens=peek['token_estimate']
    )
else:
    result = recall(
        query="async patterns",
        group_ids=["personal"],
        max_tokens=2000
    )
```

### Workflow 3: Session-End Reflection

```python
# Reflect on today's work (Brain-only, uses personal namespace)
insights = reflect(
    query="What was important today?",
    context="Worked on auth refactoring and bug fixes"
)
print(insights['answer'])
```

### Workflow 4: Mandatory Session Start

```python
# ALWAYS do this at session start
namespaces_result = namespaces()

# Extract group_ids for later use
group_ids = [ns['group_id'] for ns in namespaces_result['groups']]

# Now safe to use recall/remember
recall(query="...", group_ids=group_ids)
```

---

## Error Handling

All tools return errors in this format:

```json
{
  "content": {
    "type": "error",
    "error": "Error description"
  }
}
```

**Common Errors:**

| Error | Cause | Solution |
|-------|-------|----------|
| `"unauthorized"` | Invalid API key | Check key format (gm_xxxxx) and expiration |
| `"namespace not found"` | Wrong group_id | Call `namespaces()` to get valid IDs |
| `"permission denied"` | No access to namespace | Check namespace sharing settings |
| `"backend unavailable"` | Service offline | Check `status()` or wait for recovery |

---

## Response Format

All responses follow this structure:

**Success:**
```json
{
  "content": "String response or Object response"
}
```

**Error:**
```json
{
  "content": {
    "type": "error",
    "error": "Error message"
  }
}
```

**Tool Return Type:** The MCP protocol wraps responses in a `ToolResult` envelope. The actual content is in the `content` field above.

---

## Rate Limits

The memories API has soft rate limits based on your account tier:

- **Free tier**: 100 API calls per minute
- **Pro tier**: 1,000 API calls per minute
- **Enterprise**: Custom limits

Rate limit headers are returned in responses:
```
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1234567890
```

---

## Best Practices

1. **Always call `namespaces()` at session start** - Never guess namespace IDs
2. **Use peek mode before large recalls** - `max_tokens=0` costs nothing
3. **Save discoveries immediately** - Don't wait until end of session
4. **Use citations in context** - Makes memories more useful later
5. **Group related memories** - Use consistent naming (e.g., `"project-x"`)
6. **Monitor service status** - Call `status()` if something seems wrong

---

## Example Complete Session

```python
# Session start
nss = namespaces()
group_id = nss['groups'][0]['group_id']

# Check what's available
peek = recall(query="async patterns", group_ids=[group_id], max_tokens=0)

# Load if needed
if peek['token_estimate'] < 2000:
    context = recall(
        query="async patterns",
        group_ids=[group_id],
        max_tokens=peek['token_estimate']
    )

# Do work...

# Save discoveries
remember(
    content="Found the bug: missing await in updateUser()",
    group_id=group_id,
    context="Issue #789"
)

# Done!
```

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-01-12 | Initial release: 8 tools, token budgeting, multi-namespace support |
