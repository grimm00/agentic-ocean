---
name: write-plan-amend
description: >-
  Amend an existing implementation plan: add a group, deepen tasks, fix DoD or
  status, or attach FR-driven readiness notes. Use when the user invokes
  /write-plan --amend or write-plan-amend. Do NOT create a new planning tree
  (write-plan-start) or implement code (implement).
disable-model-invocation: true
---

# Write-Plan Amend

Before proceeding, **`read ../SKILL.md`**. Mutations touch **user-reviewed** plan
files — append or edit surgically; do not rescaffold the tree.

```
locate plan → validate → apply amendment → update frontmatter/status parity → stop
```

## When to use

- Add a task group or tasks
- Deepen one group (optional seven-field cadence)
- Fix DoD, frozen notes, or status drift
- Record plan-review / Ready notes on a group (as with Stage 2 Group 4)
- Legacy `/transition-plan --expand` → deepen amendment here

## When not to use

- No plan yet → **write-plan-start**
- Execute work → **implement**
- Overwrite entire plan without `--force` / explicit replace request

## Amendment kinds

| Kind | Flag / cue | Behavior |
|------|------------|----------|
| **Add group** | `--add-group`, “add group …” | New `tasks/NN-….md`, extend frontmatter + checkboxes + status row |
| **Deepen** | `--deepen --group N`, legacy expand | Enrich one group; may apply seven-field cadence from `../assets/task-group-expanded-template.md` |
| **Fix / sync** | “fix DoD”, “sync status” | Parity repairs only |
| **Readiness** | After plan-review | Amend group Status + review section in-file (prefer no separate review file unless asked) |

Preserve existing task numbers unless the user authorizes renumbering.

## Workflow

1. **Locate** planning root; read `implementation-plan.md` + target group file(s).
2. **Confirm kind** of amendment from the user invocation.
3. **Apply edits** — prefer in-place section updates; for deepen, do not delete
   lived Acceptance/Gotcha that still apply.
4. **Parity:** `task_count`, `groups[].tasks`, `tasks_files[]`, and body checkboxes
   stay consistent (structure.yaml).
5. **Status:** bump `Last Updated`; adjust group Status (Ready / In Progress / etc.).
6. **Suggest commit** `docs([feature]): amend …` — no auto-commit unless asked.

## Deepen notes

Seven-field cadence (Purpose, Grounding, Relevance, Steps, Files, Acceptance,
Gotcha) is **optional**. Use when Grounding is thin or the operator wants that
shape. Prefer short Steps prose (write-plan family bar) over identifier stew.

If requirements are Final and the group is already Ready for FR-driven
**implement**, prefer readiness notes over manufacturing empty expand fields.

## Behavioral contract

- **Append/amend, don’t reset** — same spirit as explore-amend
- **No silent `--force` rescaffold** of implementation-plan.md
- **Docs ownership** lines stay when lived docs are in play

## Related

- **write-plan-start** — new tree
- **plan-review** — find gaps this skill may amend
- **implement** — after Ready
