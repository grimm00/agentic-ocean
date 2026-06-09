# Task Phase Command (Deprecated)

**This command has been renamed.** Use `/task` instead.

---

## Migration

| Old | New |
|-----|-----|
| `/task-phase [phase] [task]` | `/task next` or `/task N` |
| `/task-phase 4 1` | `/task 7` (use global task number) |
| `/task-phase 4 1 --feature X` | `/task 7 --feature X` |

**Key changes:**

- Phase numbers are gone. Tasks use a single global number (1 to N).
- Three modes: `next` (sequential), `N` (explicit), bare (status view).
- Reads `implementation-plan.md` + `tasks/` instead of `phase-N.md`.
- Branch names drop phase numbers: `feat/[feature]-[desc]`.
- Commit scopes use feature names: `feat([feature]): ...`.

See [Migration Guide](../../docs/MIGRATION-v0.10.md) for full details.

---

**Deprecated in:** v0.10.0
**Replacement:** `/task`
