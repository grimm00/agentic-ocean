# Agent: Group Cycle

Runs the standard group cycle for a task group: plan expansion, task execution,
PR creation, and validation. Designed to run in an isolated **git worktree** so
the human's workspace stays clean for other work.

The human re-enters after validation to review, merge, and address any open
questions the agent surfaced during execution.

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `feature` | yes | Feature name (e.g., `agentic-workflow-modernization`) |
| `group` | yes | Group number or name (e.g., `02-discuss-conversion`) |
| `service` | yes | Service path (e.g., `ai-workflow`) |
| `base_branch` | no | Branch to base work on (default: `develop`) |
| `first_group` | no | Set to `true` if this is the first group in a stage (default: `false`) |
| `prior_pr` | no | The **merged** PR that landed the prior group's commits on **`base_branch`**. Prefer `gh pr view <n> --json state,mergedAt` — if `CLOSED` with `mergedAt: null`, that's a superseded/aborted sibling (duplicate run, canceled experiment): **do not use it**; use the sibling that actually merged instead. Omit `prior_pr` when Step 0 closeout isn't needed — same posture as **`first_group`**: merges already absorbed, no sweep (see Step 0). |

## Skills & Commands

Read these files **before** the step that needs them. Follow each one exactly.

| Step | Skill / Command | Path |
|------|----------------|------|
| Step 0 — post-PR | post-pr | `~/.cursor/commands/post-pr.md` |
| Step 0 — plan-review (between groups) | plan-review | **Canonical:** `templates/standard-project/.claude/skills/plan-review/SKILL.md` (authoritative semantics + `references/structure.yaml`). **Repo install:** `.claude/skills/plan-review/SKILL.md` when the skill is vendored at repo root — read whichever copy exists in-repo; YAML + assets always align with `templates/standard-project/`. |
| Step 1 — plan expansion | transition-plan | `~/.cursor/commands/transition-plan.md` |
| Step 3 — PR body | update-pr-description | `~/.cursor/skills/update-pr-description/SKILL.md` |
| Step 4 — PR validation | pr-validation | `~/.cursor/commands/pr-validation.md` (reference only — Step 4 sub-steps are self-contained) |

Paths starting with `.` are relative to the repo root (inside the worktree).
Paths starting with `~/` are global (user home directory).

## Worktree Setup

Before starting the pipeline, create an isolated worktree:

1. Branch name: `feat/[feature]-[group]` (e.g., `feat/agentic-workflow-stage2-research-foundation`)
2. Worktree path: `worktrees/feat-[feature]-[group]` (following project convention: branch `feat/foo` → `worktrees/feat-foo`)
3. Create from base branch:
   ```
   git worktree add worktrees/feat-[name] -b feat/[name] [base_branch]
   ```
4. All subsequent work happens inside the worktree directory.

When the pipeline completes (or stops on a blocker), the worktree stays in place
for the human to inspect. The human removes it after merge.

## Pipeline

### Step 0: Prior Group Closeout (skip if `first_group` is true OR `prior_pr` is omitted)

**Skip entirely** when **`first_group` is `true`** *or* **`prior_pr` is omitted**.

When **`prior_pr` is present**, validate it merged into the eventual base lineage (merged state in GitHub — not merely open). Closed-without-merge numbers are mistakes for closeout targets.

Otherwise close out the previous group cycle:

1. **Post-PR:** Read `~/.cursor/commands/post-pr.md` and follow it for the prior
   group's merged PR (`prior_pr`). Key outputs: status document updates,
   implementation plan checkboxes, deferred Sourcery issue check.

2. **Plan review (between group cycles):** Read the **`plan-review`** Claude skill:
   **`templates/standard-project/.claude/skills/plan-review/SKILL.md`** (preferred
   source of truth), **or** **`.claude/skills/plan-review/SKILL.md`** when skills are
   installed at repo root. If **neither** path is present in the checked-out tree, read
   **from the template directory anyway** (or copy `templates/standard-project/.claude/skills/plan-review/`
   to repo-root **`.claude/skills/plan-review/`**) — do **not** treat missing repo-root
   install as a signal to use deprecated slash-command stubs. Follow that skill exactly — instantiate the checklist from
   **`assets/review-checklist.md`** and write **`plan-review-YYYY-MM-DD.md`** beside
   `implementation-plan.md` for the chosen planning subtree (same dated artifact semantics
   as standalone runs). Narrow scope with `--group N` when validating only the next
   dispatch footprint. Deprecated slash-command stubs under **`~/.cursor/commands/pre-phase-review.md`**
   are thin redirects; do **not** use them as the execution primitive. Produce or refresh
   the review artifact **after** the prior group's merged PR is reflected in docs and **before**
   **Step 1** expands or executes the next group's plan.

Both of these happen on the worktree branch before plan expansion begins.

### Step 1: Plan Expansion

Read `~/.cursor/commands/transition-plan.md` and follow its expand semantics. If
the group's task file has tasks without detailed specs (steps, acceptance
criteria, files), expand them.

If Step 0 surfaced adjustments from the prior group, incorporate them during
expansion.

Skip if all tasks already have detailed specs.

### Step 2: Execute Tasks

For each uncompleted task in the group (in order):

1. Read the task spec
2. Implement the task following the steps and acceptance criteria
3. Verify acceptance criteria are met
4. Mark the task `[x]` in the group file
5. Commit with message: `feat([feature]): complete Task N — [brief description]`

**On failure:** If a task fails (test error, missing dependency, unclear spec)
and 3 attempts don't resolve it, STOP. Report:
- Which task failed
- What was attempted (3 tries)
- The error or blocker
- Suggested resolution for the human

Do NOT skip tasks or reorder them. Do NOT continue past a blocker.

### Step 3: Create PR

Once all tasks in the group are complete:

1. Push the branch
2. Create PR to `develop` using `gh pr create` with a placeholder body
3. Title: `feat([feature]): [Group name] (Group N)`
4. **Generate the PR body (mandatory).** Read `~/.cursor/skills/update-pr-description/SKILL.md`
   and execute every step — gather context, generate four sections (Summary, Why,
   After Merge, Follow-ups), and write back via `gh pr edit --body-file`. After
   the write, verify the body was updated: `gh pr view --json body -q .body`
   must contain `## Summary`. If it still shows the placeholder, re-run. Do not
   leave a placeholder body on the PR.

### Step 4: PR Validation

#### 4a. CI Status

```bash
gh pr checks [pr-number]
```

Record **current** CI status (passing, failing, or pending). Do not wait for
pending checks to resolve — Sourcery landing is the only gate for Step 4.
If checks are still running, note them as pending and continue.

If a check has already **failed**, check the known issues registry at
`admin/planning/ci/multi-environment-testing/known-issues.md`. Known issues
don't block; new failures get 3 retry attempts before stopping.

#### 4b. Sourcery Review (dt-review)

Poll for Sourcery's review using `dt-review` directly — it knows how to find
and extract Sourcery review content (inline comments + overall summary).

```bash
mkdir -p admin/feedback/sourcery
dt-review [pr-number] admin/feedback/sourcery/pr[number].md
```

If `dt-review` is not available (`which dt-review` returns nothing), skip this
sub-step and note it in the report. Do not block on a missing tool.

**Polling:** Wait 15 seconds before the first attempt, then run `dt-review`.
If the output has no substantive content, wait another 15 seconds and retry —
up to 4 attempts total (60s of waiting). After each run, check whether the
output file contains substantive content (individual comments or overall
comments — not just headers/empty template). If content appears, Sourcery has
landed — proceed immediately. If all 4 polls produce empty output, proceed
anyway and note that Sourcery did not land within the polling window.

#### 4c. Priority Matrix

For every comment in the review file, fill out the priority matrix table using
the prescribed tiers:

| Priority | Meaning |
|----------|---------|
| CRITICAL | Security vulnerabilities, data loss, breaking changes, test failures |
| HIGH | Performance issues, missing error handling, maintainability concerns |
| MEDIUM | Style improvements, refactoring opportunities, documentation gaps |
| LOW | Naming suggestions, style preferences, optional enhancements |

Each row gets: **Priority**, **Impact**, **Effort**, **Action**.

#### 4d. Act on Findings

**Always fix inline:**
- Priority is CRITICAL or HIGH (any effort)
- Effort is LOW regardless of priority (typos, grammar, one-line fixes — if it
  takes under 5 minutes, just do it)

**Use judgment — weigh and fix inline when it makes sense:**
- HIGH impact + LOW effort, even at MEDIUM or LOW priority — high-leverage
  quick wins are worth doing now, but assess whether the change is safe

**Defer everything else:**
- MEDIUM or LOW priority items at MEDIUM or higher effort — add to
  `admin/feedback/deferred-tasks.md` if the file exists, and note in the PR
  body's Follow-ups section

Commit fixes with: `docs([feature]): address Sourcery feedback — [brief description]`.
If a fix fails after 3 attempts, stop and report (three-strikes rule).

#### 4e. Commit Review Artifacts

Commit the Sourcery review file (with filled matrix) and any deferred-tasks
updates to the PR branch.

### Step 5: Open Questions File

If any open questions were surfaced during execution, write them to:

```
admin/services/[service]/features/[feature]/planning/open-questions.md
```

Format:

```markdown
# Open Questions — [Group Name]

**Generated by:** group-cycle agent
**Date:** YYYY-MM-DD
**PR:** #[number]

---

## Questions

### Q1: [Brief title]

**Context:** [What was happening when this came up]
**Why it matters:** [Impact on current or future work]
**Suggested next step:** [discuss / explore / research / decision]

---

[Repeat for each question]
```

This file is committed to the branch and included in the PR. The human reviews
it alongside the code changes. Questions that get resolved during review can be
deleted; questions that need deeper work get promoted to the appropriate workflow
(explore, research, decision) by the human.

If no open questions surfaced, skip this step entirely — do not create
the file. Questions must come from genuine uncertainty encountered during
task execution (unclear spec, conflicting patterns, design forks). Do NOT
fabricate questions to fill the template.

### Step 6: Report

Present a summary to the human:

```
## Group Cycle Complete: [Group Name]

**Worktree:** worktrees/[name]
**Tasks:** N/N complete
**PR:** #[number] — [title]
**CI:** [passing/failing]
**Review:** [N comments, N fixed inline, N deferred]

### Open Questions
- [N] questions in planning/open-questions.md, or "None — no genuine uncertainties encountered"

### Discoveries
- [Anything unexpected encountered during execution]

### Needs Human Attention
- [ ] Review PR and open questions
- [ ] Merge when satisfied
- [ ] Remove worktree: `git worktree remove worktrees/[name]`
- [ ] [Any other items requiring judgment]
```

## Behavioral Boundaries

- **Natural discovery is expected.** If a task reveals something unexpected
  (a better approach, a missing prerequisite, a design question), note it
  in the PR description and commit message. Don't suppress it. If it needs
  human judgment, add it to the open questions file.
- **Ceremony is the agent's job.** Git operations, PR creation, validation
  scaffolding, status updates — these are mechanical. Do them without asking.
- **Judgment is the human's job.** Design decisions, scope changes, "should
  we do this differently?" — write these as open questions, don't resolve them.
- **Three strikes on errors.** Technical failures (test failures, CI errors,
  command errors) get 3 retry attempts. After that, stop and report.
- **Stay in the worktree.** All file operations happen inside the worktree.
  Do not modify the main workspace.
- **Authoritative PR for Step 0:** `prior_pr` must be merged into the base lineage.
  Do not chase closed-but-not-merge duplicates competing for the same cutover —
  ask the human if numbers disagree with `gh pr view`.
