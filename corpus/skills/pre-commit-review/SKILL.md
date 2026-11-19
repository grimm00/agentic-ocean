---
name: pre-commit-review
description: >-
  Stage changes, capture a diff for staged-change review, and draft a commit
  message without committing. Preserves the review-then-commit pause — STOP
  after presenting; never auto-commit. Use when the user invokes
  /pre-commit-review or wants a staged diff bundle before /commit. Do NOT use
  for Cursor built-in /review (Bugbot / Security).
disable-model-invocation: true
---

# Pre-Commit Review

Stage changes, capture review artifacts, present a review bundle, **then STOP**.
This workflow exists because agentic edits are easy to commit before a human
actually reads them.

```
detect layout → pick files → stage → write bundle → present → STOP (no commit)
```

Each line of work has one bundle that lives across all its commits: `review-<branch-slug>/` on a
feature branch, `review-<description>/` on the default branch.

| File | Lifetime | Written by | Read by |
|---|---|---|---|
| `commit-msg.txt`, `diff.patch` | One commit | this skill | **commit**, which deletes both after committing (and nothing else) |
| `summaries/YYYY-MM-DD-<desc>.md` | The bundle | this skill, one per commit | this skill and **pr**, to reconcile `pr-body.md` |
| `pr-body.md`, `plan-comments/` | The bundle | this skill | **pr**, at create and refresh |

**Authoritative artifact contract:** read `references/structure.yaml` — paths,
required files, and commit-skill coupling notes live there.

---

## When to use

- After substantive agentic edits and before any commit
- When the user asks for a staged diff / review folder before committing
- When pairing with **commit** — this skill is always the first half

## When not to use

- Cursor built-in `/review` (Bugbot / Security) — different skill; do not confuse
- User already committed and only wants a retrospective — use **narrative** or
  changelog workflows instead
- Pure ideation with no git changes — nothing to stage

---

## Configuration

**Review artifacts path (first match wins):**

1. **Scratch space (default):** `<thinking_root>/reviews/`, when `<thinking_root>` exists. Read
   `thinking_root` from `${XDG_CONFIG_HOME:-$HOME/.config}/cursor-skills/config.yaml`: the
   repo's entry under `repos.<origin-slug>` (the basename of `git remote get-url origin`
   without `.git`), else the global `thinking_root`, else `.scratch`.
2. **Legacy fallbacks**, only for a repo with no scratch space:
   - Dev-Infra: `admin/tmp/reviews/` (if `admin/tmp` **or** `admin/` exists)
   - Template project: `tmp/reviews/` (if `tmp/` exists at repo root)
   - Lightweight: `tests/tmp/reviews/` (otherwise)

A repo that has both `.scratch/` and `tests/tmp/` uses `.scratch/reviews/`.

**Bundle shape:**

```
[artifact_base]/review-[name]/
  commit-msg.txt                      # this commit; commit deletes it
  diff.patch                          # this commit; commit deletes it
  summaries/
    YYYY-MM-DD-[description].md       # one per commit, never overwritten
  pr-body.md                          # rolling PR body, created on the first run
  plan-comments/
    YYYY-MM-DD-[description].md       # one per IaC plan, queued for the PR
    posted/                           # pr moves comments here after posting
  wiki-drafts/                        # written by docs-pass; not read here
```

**`[name]`** depends on the branch:

| Branch | Name | Example |
|---|---|---|
| Feature branch | the branch with `/` replaced by `-` | `feat/vault-prod` → `review-feat-vault-prod` |
| Default branch (`main`, `master`, or `origin/HEAD`) | a kebab-case description of the line of work, from the invocation or the changed files | `review-closed-tickets-to-completed` |

On the default branch, reuse an existing `review-<description>/` when the same line of work
continues, rather than starting a second one.

**`pr-body.md` is always written.** Create it on the first run if the bundle has none, and merge
into it on every later run. It doesn't decide what **commit** deletes: commit only ever removes
`commit-msg.txt` and `diff.patch`.

**`.gitignore`:** Before writing, confirm the resolved base path is ignored. If
not, **warn** the user and do not silently write to a tracked location.

---

## Usage

| Invocation | Behavior |
|------------|----------|
| Review with description | Name this commit's summary `summaries/YYYY-MM-DD-{description}.md` |
| Review without description | Derive a short description from the changed files |
| `--scope PATH` | Restrict candidate files to that path |
| `--all` | Stage all changed files without confirmation |

---

## Workflow

### 1. Identify changed files

```bash
git status --short
```

Show staged, unstaged, and untracked files. **Exclude** items the user did not
intend to ship, scratch/temp files, and anything that may contain secrets.

| Mode | Selection rule |
|------|----------------|
| `--scope` | Only paths under the scope |
| `--all` | All changed files, no confirmation prompt |
| Default | List files; confirm with the user before staging |

**Bounded stop:** If nothing remains after filtering, **STOP** and explain why.

### 2. Stage files

```bash
git add [files]
```

Do not stage files the user rejected. If files were already staged, confirm they
should remain staged.

### 3. Write the per-commit artifacts

**Hard-require:** `read ~/.cursor/registers/plain-informational.md` before drafting
`commit-msg.txt` or the summary's prose. Neither this skill nor its downstream readers
(`commit`, `pr`) specify a register on their own, so without this the draft prose has no sentence
rules at all. If the register file can't be read, stop and say so rather than drafting from
memory.

1. Resolve `artifact_base` per **Configuration** + `references/structure.yaml`, and the bundle
   name from the current branch: `review-[branch-slug]/` on a feature branch,
   `review-[description]/` on the default branch. If the work on the default branch is headed for
   a PR, agree a branch name with the user first and use its slug.
2. Write a new summary at `summaries/YYYY-MM-DD-[description].md` from
   `assets/summary-template.md` (fill it in the file; do not paste the template into chat).
   Populate **Files Changed**, **Summary**, **Draft Commit Message** (Conventional Commits),
   and **Stats** (`git diff --staged --stat`). Never overwrite an earlier summary: if the name
   is taken, add `-2`, `-3`, ….
   - If a summary exists for a commit that hasn't been made yet (the same staged change being
     reviewed again), update that summary in place instead of adding a second one.
3. Write `diff.patch`:

```bash
git diff --staged > [bundle]/diff.patch
```

4. Write **`commit-msg.txt`**: the same draft message as in the summary. The commit skill
   passes it to `git commit -F`, which keeps the body separate from the subject.
   - **Default to the subject line alone**, in conventional form (`type(scope): summary`,
     about 72 characters or fewer). The diff shows what changed, and the PR body carries the
     context.
   - **Add a body only when the change needs one:** a reason the diff can't show, a behavior
     change someone bisecting would want to know about, or a commit that touches several
     unrelated things. Keep it to a few short lines after a blank line, and state the reason
     rather than touring the files.

### 3b. Update the bundle artifacts *(every run)*

1. **`pr-body.md`** — create it if the bundle has none; otherwise merge into it. Read and follow the PR-description skill that applies to the repo
   (`update-pr-description`, or a context variant such as `update-pr-description-<context>`). That skill
   owns the format; this skill does not define one.
   - **Reconcile against every file in `summaries/`**, not only this commit's. The summaries
     are the durable record of the branch, so the body stays correct even when earlier
     commits' context is no longer in the conversation.
   - **First run on the branch:** draft the body from this commit's summary.
   - **Later runs:** merge this commit into the existing body. The body describes the branch as a
     whole, not a list of commits: fold new changes into Summary, extend Why only if the reason
     changed, and keep Testing done cumulative.
   - **Condense as it grows.** Keep the body readable in about 20 seconds. Merge related bullets,
     drop detail the diff already shows, and keep only the latest result of a repeated check.
   - Keep raw plan output out of the body. State the result (e.g. "3 to add, 0 to change") and
     say the plan is in a comment.
2. **`plan-comments/YYYY-MM-DD-[description].md`** — for infrastructure-as-code changes
   (Terraform, OpenTofu) that have a plan. Assemble it from plan output the user pastes or that
   is in the terminal:
   - Lead with the result line in bold, then the full plan inside a `<details>` block.
   - Drop `Refreshing state...` lines; keep the actions and the `Plan:` line.
   - Use text captured with `-no-color`, or `terraform show -no-color <planfile>`. Never attach
     or paste a binary plan file.
   - If the change is already applied, add the follow-up plan ("No changes") and any read-back
     that proves the result.
   - Abbreviate large values that are already in the diff (certificates, policy documents), and
     say where the full value is.

### 4. Present for review

Show the user:

1. Executive **summary** — what changed and why
2. **Draft commit message**
3. Line / file **stats** (`git diff --staged --stat`)
4. **Bundle path** and this commit's summary file
5. Reminder to open `diff.patch` for full detail
6. What changed in `pr-body.md`, and any queued plan comment
7. **Next steps:** `/commit` to commit (it uses `commit-msg.txt`), then `/pr` to open or refresh
   the PR (it uses `pr-body.md` and posts queued plan comments). If still on the default branch,
   create the agreed branch before committing.

### 5. STOP and wait

**CRITICAL: Do NOT `git commit`.** After presentation, **stop** and wait for explicit
human approval. The user continues via **commit**, manual `git commit`, or edit /
unstage cycles.

---

## Behavioral Contract

**Hybrid skill.** Staging paths and artifact names are deterministic; summarizing,
risk spotting, and file-intent judgment require care.

**What “good review” looks like:**

- Explain the intent of the diff, not every line listing
- Call out risky areas (security, unintended edits, missing tests)
- Keep the draft message in conventional form and as short as the change allows: a subject
  alone for most commits, a short body only when the reason isn't visible in the diff

**What to scrutinize:**

- Surprise file touches and broad refactors slipped in by tooling
- Hardcoded secrets, unsafe defaults, or logging of sensitive data
- Tests/docs drift when behavior changed

---

## Integration

```
[changes made]
review  → pause (human reads summary + diff)       writes the bundle: per-commit files + summary + pr-body
commit  → finalize (after approval)                 reads commit-msg.txt, deletes it and diff.patch
  ... repeat review → commit for each commit on the branch; summaries/ accumulates ...
pr      → create or refresh the PR                  reads pr-body.md (rebuilds from summaries/ if needed)
```

**The pause is the entire point.** Do not compress review and commit into one step.

---

## Five-property rubric (self-check)

| Property | Obligation in this skill |
|----------|-------------------------|
| **Observable** | Name the bundle path and this commit's summary file; cite `references/structure.yaml`. |
| **Bounded** | Honor `--scope` / `--all` / confirmation; STOP on empty selection. |
| **Outcome-framed** | Deliver `commit-msg.txt`, `diff.patch`, a dated summary, a `pr-body.md` (created or merged) reconciled against all summaries, and any queued plan comment. |
| **Delta-only** | Long template lives in `assets/summary-template.md`, not repeated in chat. |
| **Failure-aware** | `.gitignore` warnings; secret/scratch exclusions; never commit here. |

---

## Gotchas

**Auto-committing after review.** Never. If the user says “ship it,” route them to
**commit** or a manual commit — do not improvise `git commit` from this skill.

**Skipping confirmation on large diffs.** Unless `--all` is explicit, show the file
list first.

**Pasting the whole diff into chat.** Use `diff.patch` on disk; keep chat to summary
+ stats unless the user asks for an excerpt.

**Wrong layout detection.** The scratch space wins whenever it exists, even when `tests/tmp/`,
`tmp/` or `admin/` is also present. The legacy roots are only for repos with no scratch space.

**Naming a default-branch bundle after the branch.** `review-main/` says nothing about the work
and collides with every other line of work on `main`. On the default branch, name it for the
work.

**Template sprawl in SKILL.** If the summary scaffold changes, edit
`assets/summary-template.md` only.

**A commit body collapsed into the subject.** Passing a multi-line message through `-m "..."`
can flatten it into one long subject line. Use `git commit -F commit-msg.txt`.

**A commit body that retells the diff.** Listing the files and restating each change repeats
what `git show` already prints. Say why the change exists, or leave the body out.

**Plan output in the PR body.** A full plan buries the description. The body states the result;
the plan goes in `plan-comments/`.

**Inventing a PR format.** `pr-body.md` follows the repo's PR-description skill. If none applies,
use `update-pr-description`.

**A PR body that reads as a commit log.** Each run merges into one description of the branch.
Don't append a section per commit.

**Overwriting an earlier commit's summary.** The summaries are the only record of earlier
commits that survives context loss. Add a new dated file per commit; update in place only when
re-reviewing the same uncommitted change.

**Reconciling `pr-body.md` from the current commit alone.** A body updated only from what's in
the conversation drifts once earlier context is gone. Read all of `summaries/` first.

---

## Related

- **commit** — second half of review-then-commit; reads `commit-msg.txt`, deletes it and `diff.patch`
- **update-pr-description** (or a repo variant) — owns the `pr-body.md` format
- **pr** — creates or refreshes the PR from `pr-body.md` and `summaries/`
- `references/structure.yaml` — machine-readable outputs and detection
- `assets/summary-template.md` — summary skeleton

---

**Last Updated:** 2026-11-09
