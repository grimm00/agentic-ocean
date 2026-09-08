# Handoff Command

Create a handoff document capturing the current state of work for continuity between sessions. Useful for picking up where you left off, passing work to a teammate, or preserving context across conversation resets.

---

## Configuration

**Handoff Artifacts Path:**

This command stores handoff documents in a gitignored temporary directory:

1. **Dev-Infra Structure:**
   - Handoff: `admin/tmp/handoffs/handoff-[topic].md`

2. **Template Structure (for generated projects):**
   - Handoff: `tmp/handoffs/handoff-[topic].md`

3. **Lightweight Structure (no admin/ or established structure):**
   - Handoff: `tests/tmp/handoff-[topic].md`

**Auto-detection:**
- Check if `admin/tmp/` exists (or `admin/` exists) -> use dev-infra structure
- Check if `tmp/` exists at project root -> use template structure
- Otherwise -> use lightweight structure

**Important:** The handoff file MUST be in a gitignored location. These are transient session artifacts, not permanent documentation.

---

## Usage

**Command:** `/handoff [topic] [options]`

**Examples:**

- `/handoff auth-token-refresh` - Create handoff for auth token work
- `/handoff template-sync-fixes` - Create handoff for template sync fixes
- `/handoff` - Auto-detect topic from current branch name
- `/handoff --resume` - Find and read the most recent handoff to resume work

**Options:**

- `[topic]` - Short topic name for the handoff (auto-detected from branch if omitted)
- `--resume` - Find and display the most recent handoff document to restore context

---

## Process

### 1. Gather Context

```bash
# Current branch
git branch --show-current

# Recent commits on this branch
git log main..HEAD --oneline 2>/dev/null || git log develop..HEAD --oneline

# Changed files
git diff main..HEAD --stat 2>/dev/null || git diff develop..HEAD --stat

# Uncommitted changes
git status --short

# Open PRs for this branch
gh pr list --state open --head $(git branch --show-current) 2>/dev/null
```

### 2. Create Handoff Document

Write the handoff document using the template below, populated with gathered context and conversation history.

### 3. Present to User

Display the handoff document contents and confirm the file was saved. Remind the user of the file path for their next session.

---

## Template

```markdown
# [Topic] - Handoff

**Date:** YYYY-MM-DD
**Status:** [In Progress | Findings Documented | Blocked | Ready for PR | Ready for Review]
**Branch:** [current branch]
**Context:** [1-2 sentence summary of the work]

---

## What Was Done

- [Completed item 1]
- [Completed item 2]
- [Completed item 3]

---

## Current State

[Describe where things stand right now. What's working, what's partially done, what files are in what state.]

### Files Changed

- `[file1]` - [what changed and why]
- `[file2]` - [what changed and why]

### Uncommitted Changes

[List any uncommitted changes and their purpose, or "None - all changes committed"]

---

## What's Left

- [ ] [Remaining task 1]
- [ ] [Remaining task 2]
- [ ] [Remaining task 3]

---

## Open Questions

1. [Question that needs answering before proceeding]
2. [Decision that needs to be made]

---

## How to Continue

[Step-by-step instructions for picking this work back up. Include any commands to run, files to read first, or context that would be helpful.]

1. [First thing to do]
2. [Second thing to do]
3. [Third thing to do]
```

---

## Resume Mode (`--resume`)

When starting a new session, use `--resume` to restore context:

```bash
/handoff --resume
```

**Process:**

1. Search handoff locations for `handoff-*.md` files
2. If multiple found, show list and ask which to resume
3. If one found, display its contents
4. Summarize the state: what was done, what's left, how to continue

This gives the AI assistant full context to continue where the previous session left off.

---

## Tips

- **Create a handoff at the end of each session**, not just when you're stuck
- **Be specific about file paths** and what state they're in
- **Include exact commands** someone would need to run to get oriented
- **Note gotchas** or things that aren't obvious from the code
- **If blocked**, clearly state the blocker and potential solutions
- **Use `--resume`** at the start of a new session to restore context quickly

---

## Reference

**Handoff Locations:**

- **Dev-Infra:** `admin/tmp/handoffs/`
- **Template:** `tmp/handoffs/`
- **Lightweight:** `tests/tmp/`

**Related Commands:**

- `/review` - Review changes before committing (often done before handoff)
- `/reflect` - Project reflection (broader than handoff, captures insights)
- `/status` - Project status overview

---

**Last Updated:** 2026-02-13
**Status:** ✅ Active
**Next:** Use at end of every session to preserve continuity
