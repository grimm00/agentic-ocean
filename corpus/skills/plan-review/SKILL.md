---
name: plan-review
description: >-
  Validate implementation-plan scaffolding before execution: YAML parity,
  task-group quality, dependency ordering, cross-document consistency, and
  prior-stage learning carry-forward for planning-stageN layouts. Mirrors the
  retired /plan-review command. Read references/structure.yaml for dimensions.
disable-model-invocation: true
---

# Plan Review

Ensure **uniform planning trees** are internally consistent before `/task` style
execution. Replaces `.cursor/commands/plan-review.md` with the same behavioral
contract plus **`planning-stage{N}/`** parity with **`write-plan`**.

**Formal absorption of `/pre-phase-review`:** Operator + agent pipelines now standardize
on **plan-review** for the “checkpoint before the next tranche of work” role. Use this
skill **between** dispatched task groups (after the prior group’s work has landed, before
plan expansion / execution of the next group) so blockers surface early. The dated
**`plan-review-YYYY-MM-DD.md`** artifact is identical whether run standalone or as a
pipeline gate — see **`references/structure.yaml`** (`pipeline_integration`). Legacy
**`/pre-phase-review`** stubs remain only as thin redirects to **`/plan-review`** /
this skill.

Heavy checklist prose lives in **`assets/review-checklist.md`** — copy into the dated
review artifact named in **`references/structure.yaml`** (`report_output`).

---

## When to use

- Immediately **before** starting work on a new task group when scaffolding exists.
- **Between task-group dispatches** in long-running agent pipelines (after the prior
  group merges or fully lands, before you expand/execute the next group) — same dated
  artifact output as any other invocation; scope with `--group N` when you only need
  the upcoming group’s footprint reviewed.
- After **`write-plan-setup`** / **`write-plan-expand`** produced or mutated files.
- User invokes `/plan-review`, names this skill, or supplies `--check-deps` /
  `--check-tests` emphasis flags.

## When not to use

- Planning tree absent → run **`write-plan-setup`** first.
- Legacy-only phase markdown (`phase-*.md` without uniform frontmatter) → migrate per
  **`docs/MIGRATION-v0.10.md`** instead of forcing this checklist.

---

## Path resolution

**Authoritative globs, flags, and parity fields** live only in **`references/structure.yaml`**; the table below is a quick human summary (if it ever disagrees with YAML, YAML wins).

Mirror **`write-plan`** parent semantics: choose **one** subtree where `implementation-plan.md` + `tasks/` live (dev-infra row **or** maintainer-docs row).

| Layout | Planning root (summary) |
|--------|-------------------------|
| Dev-infra feature | `admin/services/[service]/features/[feature]/` + `planning/` **or** `planning-stage{N}/` |
| Template maintainer | `docs/maintainers/planning/features/[feature]/` |

If several `planning-stage*` dirs exist, **STOP** after listing candidates unless the operator names the exact subdirectory (`planning_roots` in YAML).

---

## Preconditions

1. **`implementation-plan.md`** readable at chosen root.
2. **`tasks/`** directory exists (may be scaffolding).
3. Feature scope explicit (`--feature`) **when** multiple planning trees match repo detection.

---

## Behavioral contract (five-property rubric)

| Property | Obligation |
|----------|------------|
| Observable | Enumerate blockers vs warnings vs recommendations with file paths + task IDs; readiness label MUST match blocker presence. |
| Bounded | Respect `--group N` narrow scope; otherwise review full frontmatter union — STOP after producing report OR dry-run summary. |
| Outcome-framed | Deliver dated **`plan-review-YYYY-MM-DD.md`** (unless `--dry-run`) filled from **`assets/review-checklist.md`** scaffolding. |
| Delta-only | Do not paste entire planning documents into chat — cite paths + deltas vs expectations from **`references/structure.yaml`**. |
| Failure-aware | Missing files, ambiguous staged roots, or frontmatter/task mismatches escalate as **blockers** with remediation hints — never silently OK. |

---

## Workflow

### 1. Load implementation plan

1. Resolve planning root (§ Path resolution).
2. Validate YAML frontmatter using **`references/structure.yaml`** (`implementation_plan_frontmatter` + parity rules aligned with **`write-plan`**).
3. Verify global task IDs `1…task_count` appear exactly once across `groups[].tasks`.
4. Confirm every `tasks_files[]` entry exists relative to planning root.

### 2. Review task group files

For each group (or **only group `N`** when scoped):

1. Validate markdown scaffolding sections (`Tasks`, `Dependencies`, goals/stats headers).
2. Compare embedded task numbers against owning `groups[].tasks`.
3. Emit sizing warnings when a group owns **below two** or **above eight** tasks (warnings only unless specs contradict frontmatter).

### 3. Validate dependencies

Trace intra-group ordering, cross-group references, and prerequisite completeness — dimensions `dependencies` + `prior_learnings` in **`references/structure.yaml`**.

### 4. Consistency sweep

Cross-check:

1. Checkbox totals vs **`status-and-next-steps.md`** narrative counts.
2. Task titles vs inline checkbox lines inside group markdown.
3. Phantom tasks / orphaned headings vs YAML inventory.

### 5. Prior-stage learning carry-forward

When active root matches **`planning-stage{N}/`** with **`N > 1`**:

1. Locate **`planning-stage{N-1}/`** sibling directory.
2. Read prior **`status-and-next-steps.md`** + **`implementation-plan.md`** surfaces hinted by YAML `prior_stage_carry_forward`.
3. Record explicit gaps: unresolved deferrals, spike follow-ups, PR-linked narratives **missing** from current stage plan → warnings minimum; unresolved contradictions → blockers.

Skip this subsection entirely when no numeric predecessor exists **or** repository uses flat **`planning/`** without staged dirs.

### 6. Issue taxonomy & evidence bucket

Classify findings:

| Severity | Meaning |
|----------|---------|
| Blocker | Structural inconsistency preventing faithful execution |
| Warning | Risk / clarity gap — execution tolerable after acknowledgment |
| Recommendation | Optional improvement |

### 7. Produce review artifact

1. Instantiate **`assets/review-checklist.md`** at planning root → rename pattern **`plan-review-YYYY-MM-DD.md`** (`report_output` in YAML).
2. **`--dry-run`:** Stream identical Markdown sections into assistant reply instead of writing disk file — still include readiness verdict.
3. Finish with concise CLI-style footer listing blocker/warning counts + saved relative path.

---

## Gotchas

- **Staged ambiguity:** Multiple `planning-stage*` dirs without explicit operator choice yields **false confidence** — always confirm directory first.
- **Checkbox drift:** Editors sometimes mutate markdown lists without syncing YAML — treat mismatch as **blocker**, not cosmetic.
- **`task_count` lying:** Never bump YAML without recounting union of group-owned IDs across ALL files.
- **Dry-run ≠ silent OK:** Operators still need categorical counts even when skipping filesystem writes.
- **Prior-stage nostalgia:** Completed milestones prose often hides dependency baggage — skim Notes before endorsing ✅ readiness.
- **Template-only repos:** Maintainer layout lacks `planning-stage*` pattern — skip staged carry-forward quietly after recording rationale in report header.

---

## Related

- **`write-plan`** family — upstream scaffolding producer (`write-plan-setup`, `write-plan-expand`).
- **`decision`** — precedes planning when ADRs justify transition planning.
- `.cursor/commands/pre-phase-review.md` — deprecated redirect shim → use this skill instead.
- Retired `/plan-review` command text (read-only history): `admin/archived/commands/stage3-planner/` — **not** an execution prerequisite.

---

## FR-8 (self-containment)

Core workflow above is executable **without** loading archived Cursor command stubs. Companion **`assets/`** + **`references/`** files provide templates and declarative parity checks — optional depth, not hidden prerequisites.
