# Agent Dispatch — Pre-flight Checklist

Pre-flight before dispatching `.agents/group-cycle.agent.md` as a subagent.
Ensures the workspace is clean and builds the input block.

---

## Usage

`/agent-dispatch [feature] [group]`

**Examples:**

- `/agent-dispatch agentic-workflow-modernization 02-research-child-skills`
- `/agent-dispatch agentic-workflow-modernization 01-research-family-foundation`

---

## Step 1: Pull Latest

```bash
git fetch origin
git pull origin develop
```

If there are local uncommitted changes on develop, warn and ask whether to
stash or abort.

---

## Step 2: Worktree Cleanup

```bash
git worktree list
```

Check for stale worktrees from prior group cycles (naming pattern:
`worktrees/feat-*`). For each stale worktree:

1. Check if its PR was merged: `gh pr list --head [branch] --state merged`
2. If merged and worktree still exists, ask the user:
   - Remove it? `git worktree remove worktrees/[name]`
   - Delete the remote branch? `git push origin --delete [branch]`
3. If PR is still open, note it and move on — don't remove active worktrees.

Present a summary of what was cleaned vs. what remains.

---

## Step 3: Prior Group Status

Detect the implementation plan for the feature:

```
admin/services/[service]/features/[feature]/planning-stage*/implementation-plan.md
```

Read it to determine:

- Which groups are complete (all tasks `[x]`)
- Which group is next
- Whether the last completed group's PR has been merged

If the user-provided `[group]` doesn't match the next expected group, warn
and confirm intent.

---

### Duplicate / superseded PRs (merged vs closed)

Parallel PRs occasionally target the same base (experiment, model rerun, aborted
duplicate). **Authoritative lineage uses the merged PR only** — verify with GitHub (`state: MERGED`). **Ignore** superseded siblings that **`CLOSED` without `mergedAt`** (e.g., cancel the duplicate once the real merge ships). Populate **`prior_pr` in Dispatch Inputs only from merged PR numbers**.

---


## Step 4: Build Inputs

From the gathered context, assemble the agent input block:

```markdown
## Dispatch Inputs

| Input | Value |
|-------|-------|
| `feature` | [detected or user-provided] |
| `group` | [detected or user-provided] |
| `service` | [detected from plan path] |
| `base_branch` | `develop` |
| `first_group` | `true` / `false` (based on whether prior groups exist) |
| `prior_pr` | #[merged PR] from the cutover actually merged into `develop` — **omit** closed-without-merge duplicates (`gh pr view <n> --json state,mergedAt`). Omit entirely when Step 0 isn’t needed. |
```

---

## Step 5: Confirm and Dispatch

Present the input block to the user. On confirmation, dispatch the subagent
using the Task tool with `.agents/group-cycle.agent.md` as the prompt, passing
the input block and the full agent definition.

Recommend `composer-2-fast` model for implementation-heavy groups. Note this
in the confirmation prompt.

---

## Quick Reference

| Check | Pass | Fail |
|-------|------|------|
| develop is up to date | Continue | Pull first |
| No stale worktrees | Continue | Offer cleanup |
| `prior_pr` is merged (not superseded sibling) | Continue | Warn — wrong PR#, closed dup, merge first |
| Group matches next expected | Continue | Warn — confirm intent |
| All inputs resolved | Dispatch | Ask user for missing values |
