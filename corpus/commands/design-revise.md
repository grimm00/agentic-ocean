# Design Revise Command

Thin entry point for the **design-revise** skill.

**Skill:** `~/.cursor/skills/design/design-revise/SKILL.md` — **read and follow
that file** (and parent `~/.cursor/skills/design/SKILL.md` when instructed).

Reshapes an existing **design.md** in place. This is a **mutable shape**, not
an amend ledger — rewrite sections; do not append amendment records.
New design → `/design-start`. Diagrams only → `/design-visual`.

| Invocation | Behavior |
|------------|----------|
| `/design-revise [topic] "…"` | Apply quoted intent to live design |
| `/design-revise [topic]` | Intent from the rest of the message |
| `/design-revise [topic] --dry-run` | Planned section diffs in chat; no write |

**Hard rules:** no `## Amendments` / changelog body; no silent full rescaffold
(`design-start --force` for Draft wipe); keep Status unless accepting via
`/design-start --accept`.
