---
name: implement
description: >-
  Implement planned work after requirements and the planning tree are in place.
  Bare /implement runs through all remaining tasks; /implement next or N does
  one task; --status shows progress only. Show diffs and stop for human
  commit/operator gates — never auto-commit. Do NOT author requirements or
  scaffold plans (write-plan first).
disable-model-invocation: true
---

# Implement

Execute planned work from a uniform planning tree. Preconditions: requirements
agreed, plan exists and is Ready enough for FR-driven work (full seven-field
expand is optional — see write-plan / plan-review).

```
resolve plan → implement task(s) → update checkboxes (working tree)
  → show diff → hand off operator steps if needed → no auto-commit
```

## When to use

- Bare `/implement` — run through **all** remaining incomplete tasks
- `/implement next` / `/implement N` — single task (or RED+GREEN pair)
- `/implement --status` — progress only
- Legacy `/task …` maps here

## When NOT to use

| Situation | Use instead |
|-----------|-------------|
| No plan / no requirements | write-plan, requirements, research |
| Only deepen plan markdown | write-plan-amend |
| Read-only thinking | discuss |
| User asked to commit | commit / explicit “commit that” this turn |

---

## Commit and operator gates (hard rules)

1. **Never auto-commit.** Do not run `git commit` or stage-for-commit unless the
   user explicitly asks in this turn. Default: implement → update plan docs in the
   working tree → **show diff** → suggest commit message(s) → stop for commit
   approval (batch mode still does not commit).
2. **Never auto-push** or open a PR unless asked.
3. **Operator handoff is first-class.** If a task needs CloudShell, Console,
   physical keys, email confirm, or Deck SSH the agent cannot do, write a clear
   **Operator steps** block and **pause the run** — do not pretend apply/SSH
   happened. Resume with bare `/implement` or `/implement next` when they paste
   results.
4. **Batch vs single:** Bare `/implement` continues across tasks until the backlog
   is done, an operator gate, or a blocker. `/implement next` and `/implement N`
   do one task (RED+GREEN pair exception) then stop.

---

## Path detection

Pick one planning root per invocation:

| Layout | Planning root |
|--------|----------------|
| Dev-infra | `admin/services/[service]/features/[feature]/` + `planning/` or `planning-stage{N}/` |
| CatdogServices / scratch feature | `{project}/{feature}/planning/` or `planning-stage{N}/` (e.g. `my-infra/aws-homelab/planning-stage2/`) |
| Template maintainer | `docs/maintainers/planning/features/[feature]/` |

Prefer an in-progress `planning-stageN/` when status says that stage is active.
`--feature` overrides auto-detect when ambiguous.

**Legacy:** `feature-plan.md` + `phase-*.md` only → stop; migrate or use legacy
phase commands — do not invent a parallel tree.

---

## Modes

| Invocation | Behavior |
|------------|----------|
| `/implement` (bare) | **Run all** remaining unchecked tasks in order until done, operator gate, or blocker |
| `/implement next` | First incomplete task only, then stop |
| `/implement N` | Task N only (error if missing or already done), then stop |
| `/implement --status` | Progress table and next task; no code changes |
| `--feature name` | Pin feature / planning root |
| `--dry-run` | Resolve what would run; do not edit |

---

## Branch gate (blocking for code work)

Before changing code/HCL (`--status` exempt):

1. `git branch --show-current` must be `feat/*` (or repo-agreed feature branch).
2. If on `main` / `master` / `develop` → **STOP** with resolution (checkout or create `feat/…`).
3. CatdogServices **planning docs only** may update on `main` when that is the
   established habit — still no auto-commit unless asked.

---

## Workflow

### 1. Resolve scope

1. Locate `implementation-plan.md`; parse frontmatter (`task_count`, `groups`, `tasks_files`).
2. **Bare:** build ordered list of all `- [ ]` tasks. **next / N:** single target.
3. Map each to its group file; read Purpose / Grounding / Steps / Acceptance / Gotcha
   (or thinner FR-linked bullets).
4. Warn if Dependencies In are incomplete; skip or stop only if truly blocked.
5. If a RED task’s next checkbox is its GREEN pair, treat them as one unit.

### 2. Status at group start (working tree only)

When the first incomplete task in a group starts: set group header to
`🟠 In Progress`, bump `Last Updated`, reflect in `status-and-next-steps.md`.
Do not commit.

### 3. Implement (loop in bare mode)

For each task in scope:

| Cohort | Approach |
|--------|----------|
| Code + tests | RED → GREEN → REFACTOR; leave uncommitted |
| Infra / HCL | Design → implement → `fmt`/`validate`/plan when possible; CloudShell apply = **operator** |
| Docs / Mixed | Outline → write durable docs → verify cold-reader bar |
| Scripts | Tests → script → smoke |

Respect `documentation-is-ownership` and `cold-reader-operator` when the task
touches lived docs. Thin HCL comments; narrative in durable docs.

After each agent-completable task: mark checkboxes (working tree), brief one-line
progress. In **bare** mode, continue to the next task unless an operator gate or
blocker fires. In **next/N** mode, go to Diff gate and stop.

### 4. Diff gate

When stopping (end of bare run, end of single task, or operator pause):

1. `git status` and `git diff` (per affected repo)
2. Short summary of intent + file list (group by task if bare ran many)
3. **Suggested** commit message(s) — one per logical chunk is fine; do not run them
4. Explicit: review → ask to commit (or `/commit`) → `/implement` again if backlog remains

### 5. Plan checkboxes (working tree)

Mark finished task(s) `- [x]` in `implementation-plan.md` and the group file; update
progress in `status-and-next-steps.md`. Fold into the diff presentation.

### 6. Group completion (working tree)

On the last task of a group: mark group `✅ Complete`, refresh Next Steps.
Still no auto-commit. In bare mode, continue into the next group if tasks remain.

### 7. Operator steps block (pauses bare run)

```markdown
### Operator steps (human)
1. …
2. …
Paste back: <what the agent needs to continue>
```

Examples: CloudShell `init`/`plan`/`apply`, Console key pair, Deck `ssh`, SNS
confirm, Cursor Remote SSH smoke.

After the human returns results: bare `/implement` resumes from the first
still-unchecked task (do not re-do completed checkboxes).

### 8. Stop summary

**Single task (`next` / `N`):**

```
✅ Task N implemented: …
   Diff: … · Suggested commit: …
   Operator: <none | steps above>
   Next: review → commit if you want → /implement next|bare
```

**Bare (batch) finished or paused:**

```
✅ Implement run: tasks A–B done (working tree)
   Paused: <none | operator gate on Task K | blocker>
   Remaining: <none | list>
   Diff: … · Suggested commit(s): …
   Next: review → commit if you want → /implement (resume) or --status
```

---

## Docs-only vs durable code

When **all** feature tasks are done:

- Docs-only planning in CatdogServices → commit/push `main` if house habit **and**
  the user asked to commit
- Durable HCL/code → feature branch + PR when the user asks
- Do not invent merge/PR flows mid-run

---

## Behavioral contract

| Rule | Why |
|------|-----|
| Plan leads; chat does not invent parallel checklists | Single source of truth |
| FR IDs beat empty expand theater | Macro-learner / Final requirements path |
| Human owns commit and lived apply | Gate agents; control vs data plane |
| Bare runs the backlog; next/N are surgical | Match how operators actually drive work |
| Show diff when stopping | Review before history |

## Related

- **write-plan** / **write-plan-amend** — create or amend the plan
- **plan-review** — readiness before a group
- **commit** / **pre-commit-review** — after human approval
- **handoff** — session state, not task execution
