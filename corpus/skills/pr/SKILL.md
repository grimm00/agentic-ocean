---
name: pr
description: >-
  Create or advance a pull request for the current feature branch. Uses the
  branch's review bundle from pre-commit-review (pr-body.md, per-commit summaries,
  queued plan comments) when it exists; otherwise generates the body with the update-pr-description
  contract (or a repo variant) so create and refresh share one format. Posts
  queued infrastructure-as-code plans as PR comments. Use when the user runs /pr,
  asks to open a PR, mark ready, or request review.
disable-model-invocation: true
compatibility: Requires git and gh (GitHub CLI) authenticated to the remote.
---

# PR

Create or advance a GitHub pull request. **PR body format is owned by
`update-pr-description`** — this skill does not invent a parallel template.

```
branch + commits ready → push → body (pr-body.md, or generate) → gh pr create → post queued plan comments
                                      ↑
              /update-pr-description alone refreshes an existing PR
```

**Branch context from pre-commit-review:** each `pre-commit-review` run on the branch adds a
dated summary under `[artifact_base]/review-<branch-slug>/summaries/`, merges its commit into
`pr-body.md` in the same bundle, and queues IaC plans under `plan-comments/`. A PR isn't tied to
one commit; the bundle carries the context across all of them, and `summaries/` keeps it after
conversation context is gone. `[artifact_base]` and `<branch-slug>` follow
`../pre-commit-review/references/structure.yaml` (`artifact_folder`, `branch_artifacts`).

## Hard rules

1. **Read and follow** `~/.cursor/skills/update-pr-description/SKILL.md` for every
   body you write or refresh (Step 2 sections + quality guidelines), or the repo's
   context variant of it when one is installed (`update-pr-description-<context>`). Do not use
   legacy “What's Included / Phase N” bodies as the primary description.
2. **Never auto-merge.** Present the PR URL and stop.
3. **Do not commit** unless the user explicitly asked to commit in this turn.
   If the working tree is dirty, warn and ask before creating the PR.
4. Base branch: prefer repo default (`origin/HEAD`), else `main`, else `master`.
   my-infra / similar labs often use **`main`** (not `develop`).
5. **Load the norms before writing the body.**
   `read ~/.cursor/principles/documentation-is-ownership.md` before asserting Done
   (After Merge / Follow-ups). For Summary/Why that is operator- or platform-facing
   narrative, `read ~/.cursor/registers/cold-reader-operator.md`.

## When to use

| Invocation | Behavior |
|------------|----------|
| `/pr` (bare) | Push feature branch if needed; create ready PR with full body |
| `/pr --draft` | Same, but `--draft` |
| `/pr --ready` | `gh pr ready` on the open PR for this branch |
| `/pr --review` | Comment `@sourcery-ai review` on the open PR |
| `/pr --dry-run` | Generate body only; do not push or create |

**Body refresh only** (PR already exists): prefer `/update-pr-description`.

## When NOT to use

| Situation | Use instead |
|-----------|-------------|
| Only rewrite an existing PR body | `/update-pr-description` |
| Uncommitted work the user has not approved | `/commit` or explicit commit ask first |
| On `main` / `master` / `develop` with no feature branch | Stop; cut `feat/…` first |

---

## Prerequisites

```bash
git branch --show-current    # must be feat/* / fix/* / chore/* (not main/master/develop)
gh auth status
git status --short           # warn if dirty
```

If no feature branch or `gh` is unauthenticated → stop and guide the user.

---

## Workflow — create (`/pr` or `/pr --draft`)

### 1. Resolve base and scope

```bash
BASE=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
# fallback: main, then master
git log $BASE..HEAD --oneline
git diff $BASE...HEAD --stat
```

Optional planning context (uniform tree): if an in-progress
`implementation-plan.md` / `planning-stageN/` exists for this work, skim
checkboxes for **Related** links only — do **not** replace the four managed
sections with a task dump.

### 2. Generate body (mandatory — update-pr-description)

**If `review-<branch-slug>/pr-body.md` exists, start from it.** pre-commit-review wrote it in the
repo's PR-description format. Check it against every file in `summaries/`, `git diff
$BASE...HEAD`, and the commit log: add anything a commit changed that the body misses, drop what
the branch no longer does, and condense if it has grown. Then use it as the body.

**If `pr-body.md` is missing but `summaries/` has files**, rebuild the body from the summaries
plus the branch diff, in the repo's PR-description format. Generate from scratch only when the
branch has no bundle.

**Read** `~/.cursor/skills/update-pr-description/SKILL.md` (or the repo's variant) and produce
its managed sections. For the generic skill, those are:

- `## Summary`
- `## Why`
- `## After Merge`
- `## Follow-ups`

**Create-time gather** (PR does not exist yet — adapt prerequisites):

```bash
git diff $BASE...HEAD          # or --stat if huge
git log $BASE..HEAD --format='%s%n%n%b---'
```

Use the same quality guidelines (what/why not how; After Merge = downstream
consequences, not deploy narration).

**Optional appendix** (after Follow-ups, only if useful):

```markdown
## Related

- Implementation plan / status paths (CatdogServices or in-repo)
- Tracking issue or prior PRs
```

Do not put task checkbox lists above or instead of Summary.

### 3. Push and create

```bash
git push -u origin HEAD

# body: review-<branch-slug>/pr-body.md if it exists, else a temp file
gh pr create --title "<conventional title>" --body-file <body-file> [--draft] --base "$BASE"
```

Then post each queued plan comment, oldest first, and move it to `posted/` so it isn't posted
twice:

```bash
P=[artifact_base]/review-<branch-slug>/plan-comments
for f in $(ls "$P"/*.md 2>/dev/null | sort); do
  gh pr comment --body-file "$f" && mkdir -p "$P/posted" && mv "$f" "$P/posted/"
done
```

For a GitHub Enterprise remote, set `GH_HOST=<host>`.

Title: conventional commit style from the branch purpose (e.g.
`feat(aws-homelab-stage2): host Docker + access runbook`).

### 4. Verify body landed

```bash
gh pr view --json url,body -q .
```

Body **must** contain `## Summary`. If missing, run
`update-pr-description` (or `gh pr edit --body-file`) until it does.

### 5. Stop

Show PR URL + title, and how many plan comments were posted. Do not merge. Suggest
`/update-pr-description` if the branch gains more commits later; `/pr --review` for Sourcery
when desired. Remind the user to remove `review-<branch-slug>/` once the PR merges.

---

## Workflow — refresh after more commits

When the PR exists and the branch has gained commits (each through pre-commit-review):

1. Push the branch.
2. Refresh the body from `review-<branch-slug>/pr-body.md`, checked against `summaries/` and the
   branch diff as in step 2, with `gh pr edit --body-file` (or `/update-pr-description`, which
   merges with the existing body).
3. Post any plan comments still queued in `plan-comments/`, as in step 3.

---

## Workflow — `--ready` / `--review`

```bash
gh pr view --json number,isDraft,url
gh pr ready              # --ready
gh pr comment --body "@sourcery-ai review"   # --review
```

---

## Relationship to update-pr-description

| Skill | Job |
|-------|-----|
| **pr** | Branch gates, push, `gh pr create` / ready / review, posting queued plan comments |
| **update-pr-description** | Authoritative body sections + merge-with-existing rules |
| **pre-commit-review** | Adds a dated summary per commit, builds `review-<branch-slug>/pr-body.md`, queues plan comments |
| **commit** | Commits from `commit-msg.txt`; deletes it and `diff.patch`, keeps summaries and the PR body |

`/pr` **generates the initial body by following update-pr-description Step 2**.
`/update-pr-description` **refreshes** an existing PR (prerequisites: PR must
exist; uses `gh pr diff` + smart merge).

Do not maintain a second body template in this skill or in `commands/pr.md`.

---

## Related

- `~/.cursor/skills/update-pr-description/SKILL.md` — body contract
- `~/.cursor/skills/commit/SKILL.md` — before PR if tree is dirty
- `~/.cursor/skills/pre-commit-review/SKILL.md` — writes the review bundle this skill reads
- `~/.cursor/skills/implement/SKILL.md` — often precedes `/pr`
