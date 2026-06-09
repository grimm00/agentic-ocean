---
name: update-pr-description
description: >-
  Generate or update a PR description from the current branch's diff and commit
  history. Use when the user asks to write, update, generate, or refresh a PR
  description, or mentions PR descriptions, PR summaries, or PR body content.
disable-model-invocation: true
compatibility: Requires git and gh (GitHub CLI) authenticated to the remote.
---

# Update PR Description

Generate a structured PR description from the current branch's diff against the
base branch, then update the PR body via `gh`.

```
prerequisites ──► gather context ──► generate ──► merge with existing ──► write back
     │                                               │
     ▼                                        ┌──────┴───────┐
  on failure:                                 │ existing PR  │
  stop & guide user                           │ body logic   │
                                              └──────────────┘
```

## Prerequisites

Verify the environment before proceeding:

```bash
git branch --show-current            # must be a feature branch, not main/master
gh auth status                       # must be authenticated
gh pr view --json number,title,body,baseRefName   # PR must exist
```

If any check fails, stop and guide the user (push branch, open PR, or
`gh auth login`). Do not proceed without all three passing.

## Step 1: Gather context

Detect the base branch:

```bash
BASE=$(gh pr view --json baseRefName -q .baseRefName)
```

Fallback chain if the above fails:

```bash
BASE=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
# then try: main
# then try: master
```

Gather the diff and commit history:

```bash
gh pr diff                                     # PR-scoped diff (preferred over git diff for PRs with merge commits)
gh pr diff --name-only                         # changed file list (for After Merge inference)
git log $BASE..HEAD --format='%s%n%n%b---'     # commit messages
gh pr view --json body -q .body                # existing PR body
```

If the diff is extremely large (hundreds of files), use `--stat` as primary
context and note the PR is large. Focus on the most significant changes.

## Step 2: Generate description

Produce four managed sections:

```markdown
## Summary

<What this PR does and why. Bullet points for multiple changes. 3–8 bullets.
Focus on *what* and *why*, not *how* — the diff shows the how.>

## Why

<Rationale and context. What motivated this change? If part of a larger effort
(migration, epic, incident), explain where this PR fits. Reference ticket IDs
if commit messages mention them. If the Summary already covers the "why"
sufficiently, keep this section brief — one or two sentences is fine.>

## After Merge

<Downstream consequences and things to be aware of after this PR merges.
Synthesize from the diff — focus on implications that aren't obvious from
reading the changed files alone:

- Default values that changed (existing consumers using the default will pick
  up the new behavior on next sync/deploy)
- Removed or renamed fields (consumers referencing them will break)
- New resources or CRDs introduced (clusters will gain new objects)
- Shared helpers or templates modified (affects all callers)
- Breaking changes flagged in commit messages (downstream coordination needed)
- Version bumps in dependency manifests (new dependency versions pulled on
  next install/upgrade)
- CI/workflow file changes (take effect on future PRs, not this one)

If the change is test-only or docs-only with no downstream effects, say
"No downstream effects — test/docs-only change."

Do not narrate the deployment pipeline. The audience knows their own release
process. Focus on what this specific change means for things outside the PR.>

## Follow-ups

<Follow-up work, if any. Flag incomplete migrations, missing test coverage,
downstream impacts, TODOs in the diff. "None" if nothing applies.>
```

**Quality guidelines:**

- Focus on *what* and *why*, not *how*. The diff shows the how.
- Do not narrate the diff line by line. Synthesize.
- If the PR title already says what changed, the Summary should say *why*.
- The Why section should connect the change to its broader purpose — tickets,
  migrations, incidents, or team decisions. If there's no broader context,
  keep it brief rather than inventing one.
- After Merge should surface downstream consequences, not narrate the
  deployment pipeline.

**Materiality judgment:**

If the existing PR body already has a `## Summary` that accurately reflects the
current diff, tell the user it looks current and ask whether to regenerate.

## Step 3: Merge with existing PR body

```
existing_body = (from Step 1)
generated     = (from Step 2)

if user passed --replace:
    final_body = generated
    done

if user passed --preserve:
    final_body = existing_body + "\n\n" + generated
    done

# no flag — apply smart merge:
if existing_body is empty:
    final_body = generated

elif existing_body contains "## Summary":
    # preserve everything above ## Summary (JIRA links, deployment notes, etc.)
    above = existing_body[..before "## Summary"]
    final_body = above + generated

elif existing_body has content but no "## Summary":
    # ambiguous — ask the user
    show existing_body
    ask: "Replace entirely, or preserve above generated sections?"
    if replace: final_body = generated
    if preserve: final_body = existing_body + "\n\n" + generated
```

## Step 4: Write back

```bash
# write final_body to a temp file
gh pr edit --body-file <tmpfile>
```

Confirm success and show the user the final description.
