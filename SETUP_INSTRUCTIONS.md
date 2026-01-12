# Setup Instructions

## For End Users

### Schritt 1: Repo clonen

```bash
git clone https://github.com/chronicleforge/claude-memories.git
cd claude-memories
```

### Schritt 2: Create Account & API Key

- Go to https://memory.chronicleforge.app
- Sign Up
- API Keys → New Key → Copy key (gm_xxxxx)

### Schritt 3: Tell Claude to Setup

Open Claude Code:

```bash
claude
```

Sag:

```
setz mir memories auf.
api key: gm_xxxxx
```

Claude wird dann automatisch:
1. ✅ .claude/settings.json erstellen (from template)
2. ✅ Hook-Scripts installieren
3. ✅ Test mit `namespaces()`
4. ✅ Fertig - ready to use!

---

## What Each File Does

| File | Purpose |
|------|---------|
| **README.md** | Overview + Getting Started |
| **QUICKSTART.md** | 4-step guide (read this first!) |
| **CLAUDE.md** | Workflow guidelines |
| **.claude/settings.json.example** | MCP config + hooks template |
| **scripts/hydrate-memory.sh** | SessionStart hook (loads context) |
| **scripts/validate-memory-write.sh** | PostToolUse hook (validates writes) |

---

## How Hooks Work

### SessionStart Hook (hydrate-memory.sh)
- Runs when Claude Code session starts
- Prepares environment
- **Transparent** - you won't see anything
- **Non-blocking** - session runs even if offline

### PostToolUse Hook (validate-memory-write.sh)
- Runs after `remember()` call
- Validates that write succeeded
- **Blocking** - stops if write failed
- **Error clear** - user sees what went wrong

---

## Next Steps

1. [QUICKSTART.md](QUICKSTART.md) - Start here!
2. [CLAUDE.md](CLAUDE.md) - Learn the workflow
3. Begin using `namespaces()`, `recall()`, `remember()`

Done! 🎉
