---
name: write-plan
description: >-
  Write-plan skill family parent. Orientation for creating a self-sufficient
  implementation plan or amending an existing one. Do NOT invoke directly —
  use write-plan-start (new plan) or write-plan-amend (mutations). Children
  read this file first for path rules and contracts.
disable-model-invocation: true
---

# Write-Plan — Skill Family

Produce or evolve **uniform planning trees** (`implementation-plan.md`,
`status-and-next-steps.md`, `tasks/`) from ADRs, requirements, artifacts, or
design docs.

Plans are **self-sufficient** at the planning level of abstraction: enough
context to run **implement** without a mandatory skeleton→expand ceremony.
Full seven-field task cadence is optional depth via **amend**, not a gate.

```
write-plan-start → (human review) → implement
        ↑
write-plan-amend (add/deepen/fix plan docs — never silent rescaffold)
```

**Removed:** `write-plan-setup` (skeleton-only) and mandatory `write-plan-expand`.
Do not recreate setup mode. Legacy `/transition-plan` without flags →
**write-plan-start**. Legacy `--expand` → **write-plan-amend** with deepen intent.

## Available Skills

| Skill | When to use |
|-------|-------------|
| **write-plan-start** | New planning tree (or new `planning-stageN/`) with usable group context |
| **write-plan-amend** | Append a group, deepen tasks, fix DoD/status, FR-driven readiness notes |

## Family Conventions

### Principles (hard-require)

Before DoD or Acceptance prose, **`read ~/.cursor/principles/documentation-is-ownership.md`**.
For Docs / Mixed operator prose, **`read ~/.cursor/registers/cold-reader-operator.md`**.

### Path Detection

| Layout | Planning root |
|--------|----------------|
| Dev-infra | `admin/services/[service]/features/[feature]/` + `planning/` or `planning-stage{N}/` |
| CatdogServices / scratch feature | `{project}/{feature}/planning/` or `planning-stage{N}/` |
| Template maintainer | `docs/maintainers/planning/features/[feature]/` |

Staged siblings (`planning-stage2/`, …): create a **new** stage directory when
starting a stage — do not overwrite a prior stage without confirmation.

### Plan sufficiency (start bar)

A group file from **start** must be enough for `/implement` when requirements
are Final:

- Clear tasks with FR/C IDs or authority links
- In/Out dependencies
- Gotchas that prevent lived failure (merge cloud-init, fail-closed vars, …)
- Docs checkbox when lived truth changes

Seven-field Purpose/Grounding/Relevance/Steps/Files/Acceptance/Gotcha remains
available via **amend --deepen** for operators who want that cadence — not required
for Ready.

### Commit Discipline

`docs([feature]): …` (or host planner scope). Docs-only may push per repo habit;
never force-push.

## When NOT to Use This Family

| Situation | Use instead |
|-----------|-------------|
| No source material | decision / research / requirements first |
| Execute a task | **implement** |
| Validate consistency only | **plan-review** |

## Related

- **implement** — execute tasks (no auto-commit; operator handoff)
- **plan-review** — readiness before a group
- **decision / research / explore** — upstream

**Contract:** `references/structure.yaml`  
**Templates:** `assets/`
