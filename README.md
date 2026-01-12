# memories für Claude Code

Claude merkt sich euer Code. Patterns. Learnings. Session zu Session.

> **TL;DR:**
> ```bash
> git clone https://github.com/chronicleforge/claude-memories.git && cd claude-memories
> # Folgt QUICKSTART.md - fertig in 5 Minuten
> ```

---

## How It Works

- **remember**: Speichert Findings, Patterns, Gotchas
- **recall**: Claude holt relevant Context automatisch
- **namespaces**: personal, projects, shared (organized)
- **Token Budget**: Ladet nur was nötig ist (effizient)

---

## Setup in 3 Schritten

1. **Create Account** → https://memory.chronicleforge.app
2. **Get API Key** → gm_xxxxx (copy-paste)
3. **Add to Claude Code** → .claude/settings.json (fertig!)

See [QUICKSTART.md](QUICKSTART.md) for detailed steps (2 minutes).

---

## How to Use

```python
# Session Start
namespaces()  # → get your group_ids

# Before Coding (Peek - no tokens!)
recall(query="keywords", group_ids=["personal"], max_tokens=0)

# Load if Needed
recall(query="keywords", group_ids=["personal"], max_tokens=2000)

# After Finding Something
remember(content="What you found", group_id="personal")
```

See [CLAUDE.md](CLAUDE.md) for complete workflow guide.

---

## Files in This Repo

| File | Purpose |
|------|---------|
| **QUICKSTART.md** | 4-step setup guide (start here!) |
| **SETUP_INSTRUCTIONS.md** | Detailed setup overview |
| **CLAUDE.md** | Workflow guidelines for Claude sessions |
| **.claude/settings.json.example** | MCP config template + hooks |
| **scripts/hydrate-memory.sh** | SessionStart hook (auto-context) |
| **scripts/validate-memory-write.sh** | PostToolUse hook (write validation) |

---

## What is memories?

memories is a persistent memory system for Claude Code. It:

- **Remembers** your code patterns, learnings, and gotchas
- **Recalls** relevant context automatically in new sessions
- **Organizes** memories in namespaces (personal, projects)
- **Budgets** tokens to load only what's needed
- **Works** via MCP (Model Context Protocol)

Once set up, Claude will automatically:
1. Load relevant context when you start a session
2. Help you save important discoveries
3. Suggest patterns from previous work

---

## Getting Started

**New to memories?** → Start with [QUICKSTART.md](QUICKSTART.md)

**Already familiar?** → See [CLAUDE.md](CLAUDE.md) for workflow guide

**Need to troubleshoot?** → Check the FAQs section below

---

## FAQs

**Q: Do I need to install anything?**
A: No! Just the memories API key (created in 1 minute).

**Q: Is my data private?**
A: Yes. Namespaces are private by default. You control who can access what.

**Q: Can I use multiple namespaces?**
A: Yes! Use `group_ids=["personal", "project-x"]` to search multiple at once.

**Q: What if the API is down?**
A: Sessions continue normally. Hooks are non-blocking.

---

**Need help?** → Open an issue on [GitHub](https://github.com/chronicleforge/claude-memories)

Happy coding! 🚀
