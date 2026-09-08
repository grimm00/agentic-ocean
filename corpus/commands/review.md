# Review Command

Stage changes, capture a diff for review, and draft a commit message -- without committing. Designed for reviewing agentic code changes before they become permanent.

---

## Configuration

**Review Artifacts Path:**

This command stores review artifacts in a gitignored temporary directory:

1. **Dev-Infra Structure:**
   - Review folder: `admin/tmp/reviews/review-[description]-YYYY-MM-DD/`

2. **Template Structure (for generated projects):**
   - Review folder: `tmp/reviews/review-[description]-YYYY-MM-DD/`

3. **Lightweight Structure (no admin/ or established structure):**
   - Review folder: `tests/tmp/reviews/review-[description]-YYYY-MM-DD/`

**Auto-detection:**
- Check if `admin/tmp/` exists (or `admin/` exists) -> use dev-infra structure
- Check if `tmp/` exists at project root -> use template structure
- Otherwise -> use lightweight structure

**Important:** The review folder MUST be in a gitignored location. Verify `.gitignore` covers the chosen path. If not, warn the user.

---

## Usage

**Command:** `/review [description] [options]`

**Examples:**

- `/review auth-token-refresh` - Review changes related to auth token refresh
- `/review template-sync-fixes` - Review template sync fixes
- `/review` - Auto-generate description from branch name or changed files

**Options:**

- `[description]` - Short description for the review folder name (auto-generated if omitted)
- `--scope [path]` - Only include files under this path
- `--all` - Include all changed files without confirmation

---

## Why This Exists

With agentic coding (AI making changes), it's too easy to commit code you haven't actually reviewed. The standard `git add && git commit` flow moves too fast.

**The review-then-commit split forces a pause** between "AI wrote code" and "code is committed." This is the single most impactful workflow pattern for AI-assisted development.

**Benefits:**
- Forces human review of agentic changes before they become permanent
- The summary.md artifact provides a human-readable description alongside the raw diff
- Draft commit message can be refined before committing
- Catches real issues in agentic output that would have been committed blindly

---

## Process

### 1. Identify Changed Files

```bash
git status --short
```

Show the user what's changed (staged, unstaged, untracked) and confirm which files to include.

**If `--scope` provided:** Filter to files under the specified path.
**If `--all` provided:** Include all changed files without confirmation.
**Otherwise:** Show the file list and ask the user to confirm which files to include.

**Do NOT include:**
- Files the user didn't intend to include
- Scratch files in temp directories
- Files with secrets or credentials

**Checklist:**

- [ ] Changed files identified
- [ ] User confirmed file selection (or `--all` used)

---

### 2. Stage Files

Stage the agreed-upon files:

```bash
git add [files]
```

Do NOT stage files the user didn't approve. If files were already staged, confirm they should remain staged.

**Checklist:**

- [ ] Correct files staged
- [ ] No unintended files included

---

### 3. Capture Review Artifacts

Create a review folder in the detected temp directory:

```
[review-path]/review-[description]-YYYY-MM-DD/
  summary.md      - Human-readable summary of changes
  diff.patch      - Full diff of staged changes
```

**summary.md template:**

```markdown
# Review: [description]

**Date:** YYYY-MM-DD
**Branch:** [current branch]
**Review Folder:** [path to review folder]

---

## Files Changed

- `[file1]` - [brief description of change]
- `[file2]` - [brief description of change]

---

## Summary

[2-5 sentence description of what these changes do and why]

---

## Draft Commit Message

```
type(scope): description

[body if needed]
```

---

## Stats

[output of git diff --staged --stat]
```

**diff.patch:**

```bash
git diff --staged > [review-folder]/diff.patch
```

**Checklist:**

- [ ] Review folder created
- [ ] summary.md written with all sections
- [ ] diff.patch captured
- [ ] Draft commit message follows conventional commit format

---

### 4. Present for Review

Display to the user:

1. **The summary** - What changed and why
2. **The draft commit message** - In conventional commit format
3. **File count and line stats** - `git diff --staged --stat`
4. **Review folder location** - Where artifacts are stored
5. **Reminder** - "Review the diff.patch file for full details if needed"

---

### 5. STOP and Wait

**CRITICAL: Do NOT commit.** This command is specifically for pausing to review.

The user will:
- Review the diff and summary
- Ask for adjustments if needed (unstage files, modify commit message)
- Explicitly say "commit", "looks good", or similar when ready
- May modify the commit message

**When the user approves**, they can:
- Use `/commit` to finalize (reads the draft commit message, commits, cleans up)
- Or manually commit with their preferred workflow

---

## Integration

```
[AI makes changes]
    ↓
/review [description]     ← Stage, capture diff, draft message, STOP
    ↓ human review        ← KEY PAUSE: review diff, summary, message
    ↓ adjustments         ← Unstage files, refine message (if needed)
/commit                   ← Commit with draft message, clean up review folder
```

**The pause between `/review` and `/commit` is the entire point.** Don't rush it.

### With Other Commands

```
/task-phase 1 1           ← AI implements a task
    ↓
/review task-1-changes    ← Pause to review what AI wrote
    ↓ human review
/commit                   ← Commit reviewed changes

/spike auth-approach      ← Run a spike
    ↓
/review spike-learnings   ← Review spike documentation
    ↓ human review
/commit                   ← Commit spike learnings
```

---

## Common Scenarios

### Scenario 1: Review After AI Implementation

**Situation:** AI just implemented a feature, you want to review before committing.

**Action:**

```bash
/review add-user-validation
```

**Result:**
- Shows changed files, asks for confirmation
- Stages approved files
- Creates summary.md with description and draft commit message
- Presents for review
- Waits for user approval

---

### Scenario 2: Scoped Review

**Situation:** AI changed many files but you only want to commit the backend changes.

**Action:**

```bash
/review backend-api-update --scope backend/
```

**Result:**
- Only shows files under `backend/`
- Stages only those files
- Creates review artifacts for the scoped changes

---

### Scenario 3: Quick Review (All Files)

**Situation:** Small change, you trust the scope but want the review pause.

**Action:**

```bash
/review minor-fix --all
```

**Result:**
- Stages all changed files without confirmation prompt
- Still creates summary and diff for review
- Still waits for approval before committing

---

## Tips

### Best Practices

- **Always review the diff** -- even if the summary looks good
- **Check for unintended changes** -- AI sometimes modifies files it shouldn't
- **Refine the commit message** -- AI drafts are a starting point
- **Use `--scope`** when AI touched many files but you want incremental commits
- **Keep review artifacts** with `/commit --no-delete` if you want a record

### What to Look For During Review

- Unintended file modifications
- Hardcoded values that should be configurable
- Missing error handling
- Test coverage gaps
- Style inconsistencies
- Security concerns (exposed secrets, unsafe patterns)

---

## Important

- **NEVER commit automatically** -- this command is specifically for pausing to review
- **Always show what will be staged** before staging it
- **Keep the draft commit message** in conventional commit format: `type(scope): description`
- **Review folder is gitignored** -- it won't pollute the repo
- **If the user wants to unstage** something after review, help them do that before committing

---

## Reference

**Review Artifacts:**

- **Dev-Infra:** `admin/tmp/reviews/review-[description]-YYYY-MM-DD/`
- **Template:** `tmp/reviews/review-[description]-YYYY-MM-DD/`
- **Lightweight:** `tests/tmp/reviews/review-[description]-YYYY-MM-DD/`

**Related Commands:**

- `/commit` - Commit from review context (second half of review-then-commit workflow)
- `/task-phase` - Phase implementation (often followed by `/review`)
- `/spike` - Spike experiments (review spike learnings before committing)

---

**Last Updated:** 2026-02-13
**Status:** ✅ Active
**Next:** Use before every commit of agentic code changes
