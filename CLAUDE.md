# Memories Knowledge Base

Persistent memory system for Claude Code sessions. Store patterns, gotchas, and learnings.

---

## CRITICAL: Mandatory Checklist

**Every response MUST start with this checklist. Display it EVERY time.**

```
**Memory [x/3]:**
- [ ] recall(): Vorher nach relevanten Keywords gesucht
- [ ] remember(): Erkenntnisse SOFORT gespeichert (nicht am Ende!)
- [ ] Namespace: personal verwendet
```

**⚠️ KONSEQUENZ: Wenn remember() fehlt nach Bug-Fix/Recherche/Pattern = Wissen geht verloren!**

### Rekursive Selbst-Erinnerung
<memory_rule>
Nach JEDER dieser Aktivitäten MUSS remember() aufgerufen werden:
- Bug mit Root-Cause gefixed → remember()
- Recherche abgeschlossen → remember()
- Production-Issue gelöst → remember()
- Neues Pattern entdeckt → remember()

Diese Regel bei jeder Antwort prüfen und anzeigen.
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
    context="Source: Issue #X / Session / Recherche"
)
```

❌ **Waiting until session end = Forgotten learnings**
✅ **Remember immediately after discovery**

### Beispiel: Guter Memory-Inhalt

```python
# Nach Bug-Fix:
mcp__memories__remember(
    content="""Bug: community_build_stats.entity_count blieb bei 0

Root Cause: UpdateAfterSuccessfulBuild() hat entity_count nicht aktualisiert
Fix: entityCount Parameter hinzugefügt, beide Caller in community_worker.go angepasst
Symptom: Self-Healing hat Wachstum nicht erkannt weil stored=0""",
    group_id="personal",
    context="Issue #248, PR #249"
)

# Nach Recherche:
mcp__memories__remember(
    content="""CLAUDE.md Best Practice: Rekursive Regeln

Technik: Regel in <behavioral_rules> Tag die sich selbst wiederholt
Effekt: Claude vergisst Regeln nicht bei langen Konversationen
Beispiel: 'Diese Regeln am Anfang jeder Antwort anzeigen'""",
    group_id="personal",
    context="Recherche Januar 2026"
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
