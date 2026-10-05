# Design Start Command

Thin entry point for the **design-start** skill.

**Skill:** `~/.cursor/skills/design/design-start/SKILL.md` — **read and follow
that file** (and parent `~/.cursor/skills/design/SKILL.md` when instructed).

Creates or accepts a first-win **design.md** (substance only). Reshape →
`/design-revise`. Diagrams → `/design-visual`. Tasks → `/write-plan`.

| Invocation | Behavior |
|------------|----------|
| `/design-start [topic]` | Create Draft design.md under `.scratch/…` |
| `/design-start [topic] --dry-run` | Paths + first-win sentence only |
| `/design-start [topic] --force` | Overwrite existing Draft after stating impact |
| `/design-start [topic] --accept` | Promote Draft → Ready beside Final requirements |

**Hard rules:** plain language before shop IDs; no implementation task lists;
do not commit Draft unless asked; do not run design-revise, design-visual, or
write-plan unless the user asks this turn.
