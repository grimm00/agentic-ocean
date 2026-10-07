---
name: pr
description: >-
  Create or advance a pull request for the current feature branch. Generates the
  PR body using the update-pr-description contract (Summary, Why, After Merge,
  Follow-ups) so create and refresh share one format. Use when the user runs /pr,
  asks to open a PR, mark ready, or request review.
disable-model-invocation: true
compatibility: Requires git and gh (GitHub CLI) authenticated to the remote.
---

# PR

Create or advance a GitHub pull request. **PR body format is owned by
`update-pr-description`** — this skill does not invent a parallel template.

```
branch + commits ready → push → generate body (update-pr-description) → gh pr create
                                      ↑
              /update-pr-description alone refreshes an existing PR
```

## Hard rules

1. **Read and follow** `~/.cursor/skills/update-pr-description/SKILL.md` for every
   body you write or refresh (Step 2 sections + quality guidelines). Do not use
   legacy “What's Included / Phase N” bodies as the primary description.
2. **Never auto-merge.** Present the PR URL and stop.
3. **Do not commit** unless the user explicitly asked to commit in this turn.
   If the working tree is dirty, warn and ask before creating the PR.
4. Base branch: prefer repo default (`origin/HEAD`), else `main`, else `master`.
   my-infra / similar labs often use **`main`** (not `develop`).

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

**Read** `~/.cursor/skills/update-pr-description/SKILL.md` and produce the same
four managed sections:

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

# write body to a temp file, then:
gh pr create --title "<conventional title>" --body-file <tmpfile> [--draft] --base "$BASE"
```

Title: conventional commit style from the branch purpose (e.g.
`feat(aws-homelab-stage2): host Docker + access runbook`).

### 4. Verify body landed

```bash
gh pr view --json url,body -q .
```

Body **must** contain `## Summary`. If missing, run
`update-pr-description` (or `gh pr edit --body-file`) until it does.

### 5. Stop

Show PR URL + title. Do not merge. Suggest `/update-pr-description` if the
branch gains more commits later; `/pr --review` for Sourcery when desired.

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
| **pr** | Branch gates, push, `gh pr create` / ready / review |
| **update-pr-description** | Authoritative body sections + merge-with-existing rules |

`/pr` **generates the initial body by following update-pr-description Step 2**.
`/update-pr-description` **refreshes** an existing PR (prerequisites: PR must
exist; uses `gh pr diff` + smart merge).

Do not maintain a second body template in this skill or in `commands/pr.md`.

---

## Related

- `~/.cursor/skills/update-pr-description/SKILL.md` — body contract
- `~/.cursor/skills/commit/SKILL.md` — before PR if tree is dirty
- `~/.cursor/skills/implement/SKILL.md` — often precedes `/pr`
