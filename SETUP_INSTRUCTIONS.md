# Setup Instructions

## For End Users

### Step 1: Clone Repository

```bash
git clone https://github.com/chronicleforge/claude-memories.git
cd claude-memories
```

### Step 2: Create Account & API Key

- Go to https://memory.chronicleforge.app
- Sign Up
- API Keys → New Key → Copy key (gm_xxxxx)

### Step 3: Tell Claude to Set Up

Open Claude Code:

```bash
claude
```

Say:

```
set up memories for me.
api key: gm_xxxxx
```

Claude will then automatically:
1. ✅ Create `.claude/settings.json` (from template)
2. ✅ Install hook scripts
3. ✅ Test with `namespaces()`
4. ✅ Done - ready to use!

---

## What Each File Does

| File | Purpose |
|------|---------|
| **README.md** | Overview + Getting Started |
| **QUICKSTART.md** | 4-step setup guide (start here!) |
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
- Validates write succeeded
- **Blocking** - stops if write failed
- **Error clear** - shows what went wrong

---

## Next Steps

1. [QUICKSTART.md](QUICKSTART.md) - Follow this to get started
2. [CLAUDE.md](CLAUDE.md) - Learn the complete workflow
3. Start using `namespaces()`, `recall()`, `remember()`

Done! 🎉
