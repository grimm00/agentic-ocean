# Transition Plan Command → write-plan

**Deprecated.** Use the **write-plan** skill family:

| Old | New |
|-----|-----|
| `/transition-plan` (new plan) | **write-plan-start** / `/write-plan` |
| `/transition-plan --expand` | **write-plan-amend** (deepen) |
| Skeleton “setup” mode | **Removed** — start produces a self-sufficient plan |
| Execute tasks | **implement** / `/implement` |

**Skills:** `~/.cursor/skills/write-plan/SKILL.md` and children `write-plan-start`,
`write-plan-amend`.

If this command is invoked, **read and follow write-plan-start** (or amend when
the user is clearly editing an existing plan). Do not revive setup-only scaffolding.
