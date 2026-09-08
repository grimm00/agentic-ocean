# Commit Command

Commit staged changes using the draft commit message from a `/review` session, then clean up the review folder. Designed as the second half of the review-then-commit workflow.

---

## Configuration

**Review Artifacts Path:**

This command looks for review artifacts in the same locations as `/review`:

1. **Dev-Infra Structure:** `admin/tmp/reviews/`
2. **Template Structure:** `tmp/reviews/`
3. **Lightweight Structure:** `tests/tmp/reviews/`

**Auto-detection:** Searches all three locations for `review-*/` folders.

---

## Usage

**Command:** `/commit [review-folder] [options]`

**Examples:**

- `/commit` - Auto-detect the most recent review folder
- `/commit review-auth-token-refresh-2026-02-13` - Use a specific review folder
- `/commit --no-delete` - Commit but keep the review folder for reference
- `/commit --message "feat(auth): add token refresh"` - Override the draft commit message

**Options:**

- `[review-folder]` - Name of the review folder (auto-detected if omitted)
- `--no-delete` - Keep the review folder after committing
- `--message [msg]` - Override the draft commit message from the review

---

## Process

### 1. Find the Review Context

There are three ways to locate the review context, in priority order:

**a) Same-session context:** If `/review` was run earlier in this conversation, the draft commit message, staged files, and review folder path are already in context. Use them directly -- no need to re-read files.

**b) Explicit folder name:** If the user provided a folder name, look for it in the review directories. Match by exact name or partial match.

```bash
# Search all possible review locations
ls -dt admin/tmp/reviews/review-*/ tmp/reviews/review-*/ tests/tmp/reviews/review-*/ 2>/dev/null
```

**c) Auto-detect:** Find the most recently modified `review-*` folder across all review locations:

```bash
ls -dt admin/tmp/reviews/review-*/ tmp/reviews/review-*/ tests/tmp/reviews/review-*/ 2>/dev/null | head -1
```

If multiple review folders exist and there's no same-session context, show them and ask which one to use.

**If no review folder found:** Warn the user that no review context was found. Suggest running `/review` first, or offer to proceed with a manual commit workflow.

**Checklist:**

- [ ] Review context located (session, explicit, or auto-detect)
- [ ] Review folder path confirmed

---

### 2. Read the Review Summary (if not already in context)

Read `summary.md` from the review folder. Extract:

- The **draft commit message** from the `## Draft Commit Message` section
- The **files changed** list for confirmation

Skip this step if the commit message and file list are already known from the current conversation (same-session context).

**If `--message` provided:** Use the provided message instead of the draft.

**Checklist:**

- [ ] Commit message extracted (from session, summary.md, or --message)

---

### 3. Verify Staged Files

```bash
git diff --staged --stat
```

Confirm that files are still staged from the `/review` step.

**If nothing is staged:**
- Warn the user -- the review may be stale
- Offer to re-stage the files listed in the review summary
- Do NOT commit with nothing staged

**Checklist:**

- [ ] Staged files verified
- [ ] Staged files match review expectations

---

### 4. Confirm and Commit

Show the user:
1. **The commit message** (from summary.md, session context, or `--message`)
2. **The staged file stats** (`git diff --staged --stat`)
3. **Ask for confirmation** or message edits

Then commit:

```bash
git commit -m "$(cat <<'EOF'
[commit message here]
EOF
)"
```

**If the user wants to change the message:** Use their updated version. Always respect user edits.

**Checklist:**

- [ ] Commit message confirmed with user
- [ ] Commit executed successfully

---

### 5. Clean Up the Review Folder

**Unless `--no-delete` was specified**, delete the review folder:

```bash
rm -rf [review-folder-path]
```

Confirm deletion to the user.

**If `--no-delete` was used:** Inform the user the review folder was kept for reference and remind them of the path.

**Checklist:**

- [ ] Review folder cleaned up (or kept with `--no-delete`)

---

### 6. Show Result

```bash
git log -1 --oneline
git status --short
```

Display the commit hash and any remaining uncommitted changes.

---

## Integration

```
/review [description]     ← Stage, capture diff, draft message, STOP
    ↓ human review        ← Review diff, summary, message
/commit                   ← This command: commit, clean up (YOU ARE HERE)
    ↓
[done]                    ← Changes committed, review artifacts cleaned up
```

### Same-Session Flow (Optimal)

When `/review` and `/commit` happen in the same conversation:
1. `/review` runs, captures everything in session context
2. User reviews, approves
3. `/commit` uses session context directly (no file reads needed)
4. Fast, frictionless flow

### Cross-Session Flow

When `/commit` runs in a different conversation than `/review`:
1. `/commit` auto-detects the most recent review folder
2. Reads `summary.md` for the draft commit message
3. Verifies staged files match
4. Same commit + cleanup flow

---

## Common Scenarios

### Scenario 1: Commit After Same-Session Review

**Situation:** Just ran `/review`, user approved the changes.

**Action:**

```bash
/commit
```

**Result:**
- Uses session context (no file reads)
- Shows commit message for confirmation
- Commits and cleans up review folder

---

### Scenario 2: Commit from Previous Session

**Situation:** Ran `/review` yesterday, coming back to commit today.

**Action:**

```bash
/commit
```

**Result:**
- Auto-detects review folder
- Reads summary.md for draft commit message
- Verifies files are still staged (may need re-staging)
- Commits and cleans up

---

### Scenario 3: Override Commit Message

**Situation:** Draft message needs changing but you don't want to edit it interactively.

**Action:**

```bash
/commit --message "fix(auth): correct token expiry handling"
```

**Result:**
- Uses provided message instead of draft
- Commits with the override message
- Cleans up review folder

---

### Scenario 4: Keep Review Artifacts

**Situation:** Want to commit but keep the review artifacts for reference.

**Action:**

```bash
/commit --no-delete
```

**Result:**
- Commits normally
- Review folder preserved with summary.md and diff.patch
- Useful for audit trail or comparing later changes

---

## Tips

### Best Practices

- **Use same-session flow when possible** -- fastest and most reliable
- **Always confirm the commit message** -- even if it looks good
- **Check `git status` after commit** -- verify no unintended changes remain
- **Use `--no-delete` sparingly** -- review folders accumulate if not cleaned up

### Troubleshooting

| Issue | Solution |
|-------|----------|
| "No review folder found" | Run `/review` first to create review artifacts |
| "Nothing is staged" | Re-stage files from the review summary, or run `/review` again |
| "Multiple review folders" | Specify the folder name explicitly, or clean up old folders |
| "Commit message is wrong" | Edit it before confirming, or use `--message` to override |

---

## Important

- **Always show the commit message and ask for confirmation** before committing
- **If the user wants to change the message**, use their updated version
- **If nothing is staged**, do NOT commit -- help the user figure out what happened
- **Keep commit messages** in conventional commit format: `type(scope): description`
- **The `--no-delete` flag** is useful for keeping review artifacts for reference
- **Never skip confirmation** -- the whole point of this workflow is human oversight

---

## Reference

**Review Artifact Locations:**

- **Dev-Infra:** `admin/tmp/reviews/`
- **Template:** `tmp/reviews/`
- **Lightweight:** `tests/tmp/reviews/`

**Related Commands:**

- `/review` - Stage and review changes (first half of review-then-commit workflow)
- `/task-phase` - Phase implementation (often produces changes to review)
- `/pr` - PR creation (after changes are committed)

---

**Last Updated:** 2026-02-13
**Status:** ✅ Active
**Next:** Use after /review to finalize agentic code changes
