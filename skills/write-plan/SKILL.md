---
name: write-plan
description: >-
  Write-plan skill family parent. Orientation and shared conventions for scaffolding
  and expanding implementation plans. Do NOT invoke directly — use write-plan-setup
  (scaffold planning tree) or write-plan-expand (deepen one group file). Children
  should read this file first for path rules and contracts.
disable-model-invocation: true
---

# Write-Plan — Skill Family

Create or evolve **uniform planning trees** (`implementation-plan.md`,
`status-and-next-steps.md`, `tasks/`) sourced from ADRs, artifacts, reflections,
or design docs. Mirrors the retired `/transition-plan` command as two focused
skills so each invocation carries less procedural surface area.

```
write-plan-setup → (human review of scaffolding) → write-plan-expand → (repeat expand) → execution workflow
```

## Available Skills

| Skill | When to use |
|-------|-------------|
| **write-plan-setup** | **Setup mode:** scaffold `implementation-plan.md`, `status-and-next-steps.md`, and skeletized `tasks/NN-group.md` files |
| **write-plan-expand** | **Expand mode:** turn one scaffolding group file into detailed steps / acceptance criteria |

## Family Conventions

Child skills live in `write-plan-setup/` and `write-plan-expand/`. Before running a
workflow, **`read ../SKILL.md`** in that child loads this orientation (path detection,
templates location, parity rules).

### Path Detection

Pick **one** planning root and use it for the whole subtree:

| Layout | Planning root |
|--------|----------------|
| Dev-infra feature | `admin/services/[service]/features/[feature]/` + **`planning/`** or **`planning-stage{N}/`** |
| Template maintainer | `docs/maintainers/planning/features/[feature]/` |

**Staged planning:** If the feature already uses `planning-stage2/`, `planning-stage3/`, etc., create **sibling** directories — do not silently merge into an old stage without user confirmation.

**Detection:** If `admin/services/` applies in the repo, prefer the dev-infra layout row. Otherwise use the maintainer-docs row. Record the chosen subdirectory in `status-and-next-steps.md` Notes.

Details and `{N}` semantics: `references/structure.yaml` (`planning_roots`).

### Shared Preconditions

1. **Topic / feature name** is known or inferable.
2. **Input mode** is identified (`from_adr` | `from_artifacts` | `from_reflection` | `from_design`) — see child skills.
3. Source paths exist and are readable — or the workflow stops with options.

### Templates and Contract

- **Copy, do not reinvent filenames:** templates live in `assets/` beside this file.
- **Declarative I/O:** `references/structure.yaml` is the authoritative map of Setup vs Expand outputs (`setup_output`, `expand_output`).
- **Frontmatter parity:** `task_count`, `groups[]`, `tasks_files[]`, and body checkboxes must stay consistent across Setup and Expand (Expand never drops the plan root).

### Commit Discipline

Planning artifacts are documentation. Prefer `docs([feature]):` or the host repo’s planner scope; avoid merging unless policy requires it.

## When NOT to Use This Family

| Situation | Use instead |
|-----------|-------------|
| No agreed source material | Gather ADRs / design first (**decision**, upstream research) |
| Only code churn, no plan files | Implementation task workflows |
| Plan already fully expanded | Execute tasks — do not rescaffold |

## Related

- **decision** — upstream ADRs.
- **plan-review** — validate plan consistency before execution.
- **research / explore** — earlier pipeline stages feeding planning inputs.

**Canonical shapes:** `references/structure.yaml`  
**Templates:** `assets/implementation-plan.md`, `assets/status-and-next-steps.md`, `assets/task-group-skeleton.md`
