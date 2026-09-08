---
name: write-plan-start
description: >-
  Create a self-sufficient implementation-plan tree from ADRs, requirements,
  artifacts, or design docs. Use when the user invokes /write-plan or
  write-plan-start for a new feature or planning-stageN. Do NOT use to mutate an
  existing plan (write-plan-amend) or to implement tasks (implement).
disable-model-invocation: true
---

# Write-Plan Start

Before proceeding, **`read ../SKILL.md`** for paths, sufficiency bar, and
principles. Also **`read ~/.cursor/principles/documentation-is-ownership.md`**.

Create a **complete-enough** planning tree — not empty scaffolding that requires
expand before any work. The user reviews, then **implement** or **write-plan-amend**.

```
sources → groups + tasks → write plan + status + group files → commit suggestion → stop
```

## When to use

- New feature planning root, or new `planning-stageN/` sibling
- User says `/write-plan`, write-plan-start, or legacy `/transition-plan` (no amend)

## When not to use

- Plan already exists for this root → **write-plan-amend** (or confirm new stage dir)
- User only wants one group deepened → **write-plan-amend**
- Ready to code → **implement**

## Input modes

| Mode | Read |
|------|------|
| **from_adr** | ADRs under decisions/ |
| **from_artifacts** | Checklist, handoff, requirements Final, status |
| **from_reflection** | Reflection actionable section |
| **from_design** | design.md / goals and stages |

## Preconditions

1. Feature / topic name known
2. Input mode chosen; sources readable
3. Target planning root does not already have `implementation-plan.md` — unless
   user confirmed a **new** `planning-stageN/` or `--force`

## Workflow

1. **Load sources** — decisions, FRs, constraints, stage boundaries.
2. **Organize groups** — typically 2–8 tasks each; global task numbers 1…N;
   files `tasks/{NN}-{kebab}.md`.
3. **Author `implementation-plan.md`** from `../assets/implementation-plan.md`:
   - Frontmatter: `task_count`, `groups[]`, `tasks_files[]` (see structure.yaml)
   - Overview, goals, frozen constraints, checkbox index
   - Per group: **Docs** ownership line; DoD includes docs / WIP rules
4. **Author `status-and-next-steps.md`** from `../assets/status-and-next-steps.md`
   with honest empty progress and next step = first group / implement.
5. **Author each group file** from `../assets/task-group-ready.md` (not the old
   skeleton-only template):
   - Status: `✅ Ready` when FRs/authority are enough; else `🟡 Needs authority`
   - Tasks with enough context for implement (FR links, acceptance, gotcha)
   - Optional full seven-field cadence if sources are rich — never pad empty fields
   - Dependencies In/Out; Docs checkbox when needed
6. **Suggest commit** `docs([feature]): create … implementation plan` — do not
   auto-commit unless asked.

## Behavioral contract

- **Self-sufficient:** `/implement next` can start without mandatory expand.
- **No setup theater:** Do not leave `🔴 Scaffolding (needs expansion)` as the
  default end state of start.
- **Delta-only chat:** Point at files; do not dump templates into the reply.
- **Failure-aware:** Ambiguous feature or existing plan → stop with options.

## Related

- **write-plan-amend** — later mutations
- **plan-review** — before a group
- **implement** — execution
