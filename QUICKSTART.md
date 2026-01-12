# Quick Start

4 steps, ~5 minutes. Done.

## Step 1: Create Account

Go to [https://memory.chronicleforge.app](https://memory.chronicleforge.app)

- Click "Sign Up"
- Enter email + password
- Verify your email

Done.

## Step 2: Create API Key

Dashboard → API Keys → New Key

- Copy your key (format: `gm_xxxxx`)
- **Security**: Never hardcode it. Use environment variables only.

## Step 3: Tell Claude to Set Up

Open Claude Code:

```bash
claude
```

Say:

> "set up memories for me. api key: gm_xxxxx"

Claude will then:
- Clone the repository
- Create `.claude/settings.json`
- Install hooks
- Test with `namespaces()`

## Step 4: Done!

Now you can use:

```python
namespaces()                                         # See your namespaces
recall(query="...", group_ids=["personal"])        # Load context
remember(content="...", group_id="personal")       # Save findings
```

**Automatic hooks:**
- SessionStart hook loads context
- PostToolUse hook validates writes

---

## Troubleshooting

**"Connection refused"** → Is the backend running?
- Check: `curl https://memory.chronicleforge.app/health`
- Should return: `{"status":"healthy"}`

**"Invalid API key"** → Wrong format?
- Keys must start with `gm_` followed by 64 characters
- Create a new one in the dashboard

**Claude asks for the key?** → Not copied in prompt?
- Say again: "api key is gm_xxxxx"

---

See [CLAUDE.md](CLAUDE.md) for the complete workflow guide.

Enjoy! 🚀
