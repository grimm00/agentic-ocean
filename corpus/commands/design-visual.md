# Design Visual Command

Thin entry point for the **design-visual** skill.

**Skill:** `~/.cursor/skills/design/design-visual/SKILL.md` — **read and follow
that file** (and parent `~/.cursor/skills/design/SKILL.md` when instructed).

Adds or refreshes diagrams **inside an existing design.md** after sections 1–4
have substance. In-transcript-only pictures → `/visualize`. New or empty design
→ `/design-start`.

| Invocation | Behavior |
|------------|----------|
| `/design-visual [topic]` | Write/refresh Visuals section |
| `/design-visual [topic] --dry-run` | Propose figures in chat; no write |
| `/design-visual [topic] --replace` | Replace Visuals body |

**Hard rules:** refuse unless sections 1–4 are real; do not invent architecture
absent from the prose; keep to 1–3 figures unless the user raises the budget.
