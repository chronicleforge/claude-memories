# Quick Start

4 Schritte, ~5 Minuten. Fertig.

## 1. Get Account

Geh zu [https://memory.chronicleforge.app](https://memory.chronicleforge.app)

- Klick "Sign Up"
- Email + Password
- Verify Email

Done.

## 2. Create API Key

Dashboard → API Keys → New Key

- Copy key (format: `gm_xxxxx`)
- Sicherheit: Nie hardcoden, immer in Env-Variablen

## 3. Sag Claude Setup

Starte Claude Code:

```bash
claude
```

Sag:

> "setz mir memories auf. api key: gm_xxxxx"

Claude macht dann:
- Clone Repo von GitHub
- Erstelle `.claude/settings.json`
- Installiere Hooks
- Test `namespaces()`

## 4. Done

Jetzt funktioniert:

```
namespaces()          # Deine Namespaces
recall(query="...", group_ids=["personal"])   # Context laden
remember(content="...", group_id="personal")  # Speichern
```

**Session läuft automatisch:**
- SessionStart Hook lädt Context
- PostToolUse Hook validiert Writes

---

## Troubleshooting

**"Connection refused"** → Backend läuft nicht?
- Mach `curl https://memory.chronicleforge.app/health`
- Sollte `{"status":"healthy"}` zeigen

**"Invalid API key"** → Format falsch?
- Keys sind `gm_` + 64 Zeichen
- Neu erstellen im Dashboard

**Claude fragt nach Key?** → Im Prompt nicht kopiert?
- Sag nochmal: "api key ist gm_xxxxx"

---

See [CLAUDE.md](CLAUDE.md) for workflow guide.

Viel Spaß! 🚀
