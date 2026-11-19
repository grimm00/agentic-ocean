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

Before creating the planning tree, **`read ~/.cursor/principles/artifacts-live-with-the-work.md`**.
Before DoD or Acceptance prose, **`read ~/.cursor/principles/documentation-is-ownership.md`**.
For Docs / Mixed operator prose, **`read ~/.cursor/registers/cold-reader-operator.md`**.

### Path Detection

Planning lives **beside the rest of the line of work**, not in a planning-specific
tree: `<thinking_root>/<topic>/planning/`, sibling to `exploration.md`, `research/`,
and `decisions/`.

```
<thinking_root>/<topic>/planning/
  implementation-plan.md
  status-and-next-steps.md
  tasks/
```

Resolve `<thinking_root>` per the artifacts-live-with-the-work principle (config key
`thinking_root`, default `.scratch`) — once per invocation, then use it consistently.

Staged siblings (`planning-stage2/`, …): create a **new** stage directory when
starting a stage — do not overwrite or silently merge into a prior stage without
confirmation. Record the chosen subdirectory in `status-and-next-steps.md` Notes.

**Legacy layouts** — `docs/maintainers/planning/features/<feature>/`,
`admin/services/<service>/features/<feature>/planning/`, and
`<project>/<feature>/planning/` (CatdogServices-style). If a plan already exists at
one of these, work in place; do not migrate silently.

Details and `{N}` semantics: `references/structure.yaml` (`planning_roots`).

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

### Task Numbering — Stable IDs, Elastic Scope

Tasks are **pacing devices**. They break a problem into reviewable units of work;
they carry no inherent logic about the outcome. So a task's *scope* is expected to
move as evidence arrives — its *number* is not.

| Change | Allowed | Why |
|--------|---------|-----|
| Grow or shrink a task's scope | ✅ | The normal result of a plan meeting reality |
| Repoint a task at a better question | ✅ | Keep the old premise visible — a falsified prediction is a finding |
| Mark a task dropped, keeping its slot | ✅ | Holds numbering without pretending the work exists |
| **Append** task N+1 at the end | ✅ | Growth that breaks nothing |
| Insert a task mid-sequence | ❌ | Shifts every ID after it |
| Renumber to close gaps or tidy up | ❌ | Cosmetic gain, silent breakage |

**Why numbers are load-bearing even though tasks are not.** Task IDs get cited from
*outside* the plan — evidence ledgers, status docs, sibling group files, handoffs,
commit messages. Those citations are unidirectional and invisible from the plan
itself, so renumbering breaks references that cannot be seen from where the edit is
made. Repointing a slot preserves every one of them.

Before renumbering ever looks worthwhile, `grep -c 'Task [0-9]'` across the feature
tree. The count is routinely higher than expected, and forward references into groups
that have not been deepened yet are the ones that break most quietly.

### Commit Discipline

Planning artifacts are documentation, so `<thinking_root>` decides whether there is a
commit at all:

- **Tracked** (e.g. `docs/maintainers`) — `docs([topic]): …` or the host planner
  scope. Docs-only may push per repo habit; never force-push.
- **Gitignored** (the `.scratch` default) — the tree is intentionally untracked.
  Skip the commit and stop after writing the files.

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
