# update-pr-description

Generate structured PR descriptions from your branch's diff and commit history.
Analyzes code changes, produces a description with Summary, Why, Action Plan,
and Follow-ups sections, then updates the PR body via `gh`.

## Installation

```bash
/plugin install update-pr-description@drw-up-claude-marketplace
```

## Prerequisites

- `git` — for diff and commit history
- `gh` (GitHub CLI) — authenticated to the remote

## Usage

```
/update-pr-description
```

The skill will:

1. Gather the diff, commit messages, and existing PR body
2. Generate a structured description with four sections
3. Update the PR body, preserving any content you wrote above `## Summary`

### Flags

- `--replace` — discard any existing PR body and use only the generated description
- `--preserve` — prepend the entire existing body above the generated sections

Without flags, the skill uses smart merge: preserves content above `## Summary`
if that heading exists, asks you to choose if the body has content but no
`## Summary`, or writes fresh if the body is empty.

## Generated sections

| Section | Purpose |
|---------|---------|
| **Summary** | What changed and why. Bullet points, 3–8 items. |
| **Why** | Rationale, ticket context, where this fits in the larger effort. |
| **Action Plan** | Post-merge steps inferred from changed files (deploy pipeline, CI-only, docs-only). |
| **Follow-ups** | Remaining work, incomplete migrations, downstream impacts. "None" if nothing applies. |

## How it works

- Detects the base branch dynamically (`gh pr view` → `git symbolic-ref` → fallback)
- Uses `gh pr diff` for PR-scoped changes (avoids noise from merge commits)
- Feeds the full diff to Claude for synthesis (not line-by-line narration)
- Uses `gh pr edit --body-file` for safe markdown write-back
- Includes materiality judgment — won't overwrite a good existing description
- Works best in repos with an `AGENTS.md` or `CLAUDE.md` — the agent picks up
  repo conventions automatically from context

## Author

Cameron Wilson (cdwilson@drwholdings.com)
