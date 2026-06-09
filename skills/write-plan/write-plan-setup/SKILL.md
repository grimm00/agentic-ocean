---
name: write-plan-setup
description: >-
  Scaffold an implementation-plan tree (implementation-plan.md,
  status-and-next-steps.md, tasks/ skeletons) from ADRs, artifacts,
  reflection-ready sources, or design docs. Same as Setup mode of retired
  /transition-plan. Read ../SKILL.md first. Do NOT expand group detail here —
  use write-plan-expand.
disable-model-invocation: true
---

# Write-Plan Setup

Before proceeding, **`read ../SKILL.md`** for family path rules, parity contract,
and staged-directory guidance.

---

## When to use

- After upstream decisions/design and the user wants a plan skeleton.
- User invokes **`write-plan-setup`**, **`/transition-plan`** (legacy alias) without expand, says “scaffold implementation plan”, or “setup planning tree”.
- Needs `planning/…` or `planning-stageN/…` under a feature (see structure.yaml).

## When not to use

- No source material identified — refuse until ADR/design/artifact path exists.
- User wants one group deeply specified — delegate to **write-plan-expand**.
- `implementation-plan.md` already exists and user did not authorize new stage /
  `--force` — stop and propose options.

---

## Input modes

| Mode | Read |
|------|------|
| **from_adr** | ADR files under `decisions/…`; optional `research/…/requirements.md` |
| **from_artifacts** | Provided artifact path (checklist, handoff, transition brief) |
| **from_reflection** | Reflection doc; surface dependency if artifacts must generate first |
| **from_design** | `design.md` or excerpts: goals, stages, scoped task groups |

Extract: decisions, constraints, success criteria, and candidate group boundaries.

---

## Preconditions (stop if unmet)

1. **Topic / feature name** known or inferable.
2. **Input mode** chosen from the table above.
3. Source paths exist — or stop with remediation options (`from_artifacts` paths,
   reflection routing, staged dir choice).

---

## Setup workflow

**Goal:** Create `implementation-plan.md`, `status-and-next-steps.md`, and
scaffolding-only `tasks/NN-group-slug.md` files under the resolved planning root.

1. **Load sources** using the declared input mode — extract grouping signals the way a human planner would summarize them (decisions, requirements, constraints, phased scope).
2. **Choose transition type:** feature (default), release when path/content signals
   a release rollout, **CI/CD** if pipeline-only.
3. **Organize groups:** target 2–8 tasks per group; **global** numbering 1…N;
   filenames `tasks/{NN}-{kebab-case}.md`.
4. **Author `implementation-plan.md`** using **`../assets/implementation-plan.md`** as
   boilerplate shape:
   - YAML frontmatter: `task_count`, `groups[]` (each `{ name, file, tasks }` where **`tasks`** is a **YAML list of integers** partitioning global checkbox IDs assigned to that group), `tasks_files[]` aligned with groups order (**`../references/structure.yaml`**).
   - Body: checklist rows matching task_count exactly.
5. **Author `status-and-next-steps.md`** from **`../assets/status-and-next-steps.md`** —
   empty progress counts, next steps referencing expand.
6. **Author group files:** duplicate **`../assets/task-group-skeleton.md`** once per group;
   fill titles + 1-line hints **only**. Header **`Status:** 🔴 Scaffolding (needs expansion)**.
   Keep the scaffolding warning banner referencing expand.
7. **Commit suggestion:** bounded message such as `docs([feature]): create implementation plan scaffolding`;
   list concrete `git add` paths.

---

## Behavioral contract

- **Observable:** Every checkbox ties to exactly one eventual row inside a matching
  group file; filenames match declared `tasks_files`.
- **Bounded:** Cannot silently pick among multiple features — ask once if ambiguous.
- **Outcome-framed:** Deliver skeleton files only — no Tier-2 TDD narratives yet.
- **Delta-only:** Do not flood chat with pasted templates — **copy paths on disk**.
- **Failure-aware:** Conflicting staged dirs, existing plan without policy, unreadable sources
  → halt with branching options (`planning-stageN`, abort, waive).

---

## Gotchas

1. **`tasks_files` parity:** Ordered duplicate of each `groups[i].file` — see `structure.yaml`.
2. **`--all`-style expand is out of scope** here — deliberately skeleton-only outputs.
3. **`from_reflection` may block** pending another generator — refuse silent filler.
4. **Release layouts** reuse filenames; semantics differ inside group titles — still valid.
5. **Staged dev-infra** often uses `planning-stage{N}/`; mirror sibling pattern already in use.

---

## Related

- **write-plan-expand** — detail one group markdown.
- **plan-review** — after several expands.
- Canonical output map: **`../references/structure.yaml`** (`setup_output`).
