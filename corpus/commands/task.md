# Task Command → Implement skill

**Deprecated as the primary entry point.** Use the **`implement`** skill:

| Old | New |
|-----|-----|
| `/task` (bare status) | `/implement --status` |
| `/task` wanting full run | `/implement` (bare — all remaining) |
| `/task next` | `/implement next` |
| `/task N` | `/implement N` |

**Skill path:** `~/.cursor/skills/implement/SKILL.md`

Hard rules carried forward (and strengthened):

- **No auto-commit** — show diff, suggest message, wait for the human
- **Operator handoff** — CloudShell / Console / Deck steps are explicit human gates
- **One task per turn** (RED+GREEN pair exception)
- Plan leads; FR-driven Ready groups do not require seven-field expand first

If this command file is invoked, **read and follow the implement skill** instead
of the legacy long-form below.

---

## Legacy reference (archived)

The former `/task` command body lived here (~600 lines). Behavior is now
maintained only in `implement/SKILL.md`. Do not extend this file — edit the skill.
