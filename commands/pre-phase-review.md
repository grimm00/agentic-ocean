# Pre-Phase Review Command (Deprecated)

**This command has been renamed.** Use `/plan-review` instead.

---

## Migration

| Old | New |
|-----|-----|
| `/pre-phase-review [phase-number]` | `/plan-review [feature]` |
| `/pre-phase-review 4` | `/plan-review my-feature` |
| `/pre-phase-review 3 --feature X` | `/plan-review X` or `/plan-review --feature X` |
| `/pre-phase-review 2 --check-dependencies` | `/plan-review --check-deps` |

**Key changes:**

- Reviews entire implementation plan, not individual phases.
- Use `--group N` to review a specific task group.
- Reads `implementation-plan.md` + `tasks/` instead of `phase-N.md`.
- Review output: `plan-review-YYYY-MM-DD.md` instead of `phase-N-review.md`.

See [Migration Guide](../../docs/MIGRATION-v0.10.md) for full details.

---

**Deprecated in:** v0.10.0
**Replacement:** `/plan-review`
