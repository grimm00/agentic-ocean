# Fix Implement Command

Implements fixes from a fix plan batch. Handles TDD workflow, testing, and PR creation for fix batches.

---

## Configuration

**Fix Path Detection:**

This command supports multiple fix organization patterns, matching `/fix-plan`:

1. **Feature-Specific Fixes (default):**
   - Path: `docs/maintainers/planning/features/[feature-name]/fix/`
   - Feature name auto-detected from context or configuration
   - Example: `docs/maintainers/planning/features/my-feature/fix/pr##/batch-[name].md`

2. **Project-Wide Fixes:**
   - Path: `docs/maintainers/planning/fix/`
   - Used when no feature structure exists
   - Example: `docs/maintainers/planning/fix/pr##/batch-[name].md`

**Feature Detection:**

- Check if `docs/maintainers/planning/features/` exists
- If multiple features exist, use configuration or prompt user
- If single feature exists, use that feature name
- If no features exist, use project-wide structure

**Batch Naming:**

- Default format: `pr##-batch-[priority]-[effort]-[batch-number]` (PR-specific)
- Cross-PR format: `[batch-name]-[priority]-[effort]-[batch-number]`
- Configurable via project configuration
- Examples: `pr12-batch-medium-low-01`, `quick-wins-low-low-01`

**Branch Naming:**

- Format: `fix/[batch-name]` (keep full batch name)
- Examples: `fix/pr12-batch-medium-low-01`, `fix/quick-wins-low-low-01`

---

## Workflow Overview

**When to use:**

- After fix plans are created with `/fix-plan`
- To implement a specific batch of fixes
- When ready to address deferred issues

**Key principle:** Follow TDD workflow, implement all issues in batch, test thoroughly, create PR.

---

## Usage

**Command:** `/fix-implement [batch-name] [options]`

**Batch Name Formats:**

1. **PR-Specific Batch:**
   - Format: `pr##-batch-[priority]-[effort]-[batch-number]`
   - Example: `pr12-batch-medium-low-01`
   - File path: `docs/maintainers/planning/features/[feature-name]/fix/pr##/batch-[priority]-[effort]-[batch-number].md`
   - OR: `docs/maintainers/planning/fix/pr##/batch-[priority]-[effort]-[batch-number].md` (project-wide)

2. **Cross-PR Batch (from fix-review):**
   - Format: `[batch-name]-[priority]-[effort]-[batch-number]`
   - Example: `quick-wins-low-low-01`
   - File path: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name]-[priority]-[effort]-[batch-number].md`
   - OR: `docs/maintainers/planning/fix/cross-pr/[batch-name]-[priority]-[effort]-[batch-number].md` (project-wide)

**Examples:**

- `/fix-implement pr12-batch-medium-low-01` - Implement PR-specific batch
- `/fix-implement quick-wins-low-low-01` - Implement cross-PR batch
- `/fix-implement pr12-batch-medium-low-01 --skip-tests` - Skip test writing (not recommended)
- `/fix-implement quick-wins-low-low-01 --dry-run` - Show implementation plan without executing

**Options:**

- `--skip-tests` - Skip writing tests (not recommended, use only for trivial fixes)
- `--dry-run` - Show what would be implemented without making changes
- `--no-pr` - Implement fixes but don't create PR (for testing)
- `--feature [name]` - Specify feature name (overrides auto-detection)

---

## Step-by-Step Process

### 1. Load Fix Plan

**Determine batch type:**

- **PR-Specific Batch:** Starts with `pr##-batch-`
  - Example: `pr12-batch-medium-low-01`
  - Extract PR number: `pr12` → PR #12
  - Extract batch file name: `batch-medium-low-01`
  - Location: `docs/maintainers/planning/features/[feature-name]/fix/pr##/batch-[priority]-[effort]-[batch-number].md`
  - OR: `docs/maintainers/planning/fix/pr##/batch-[priority]-[effort]-[batch-number].md` (project-wide)
- **Cross-PR Batch:** Does NOT start with `pr##-batch-`
  - Example: `quick-wins-low-low-01`
  - Location: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name]-[priority]-[effort]-[batch-number].md`
  - OR: `docs/maintainers/planning/fix/cross-pr/[batch-name]-[priority]-[effort]-[batch-number].md` (project-wide)

**Detect feature name:**

- Use `--feature` option if provided
- Otherwise, auto-detect using same logic as `/fix-plan`:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for fix structure in each
  - If no features exist, use project-wide structure

**Parse batch name:**

**For PR-Specific Batches:**

- Extract PR number from batch name (e.g., `pr12-batch-medium-low-01` → PR #12)
- Extract batch file name (remove `pr##-batch-` prefix: `batch-medium-low-01`)
- Construct file path based on feature detection:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/pr##/batch-[priority]-[effort]-[batch-number].md`
  - Project-wide: `docs/maintainers/planning/fix/pr##/batch-[priority]-[effort]-[batch-number].md`

**For Cross-PR Batches:**

- Use batch name as-is (e.g., `quick-wins-low-low-01`)
- Construct file path based on feature detection:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name].md`
  - Project-wide: `docs/maintainers/planning/fix/cross-pr/[batch-name].md`

**Examples:**

- Batch name: `pr12-batch-medium-low-01`
  - Type: PR-Specific
  - PR number: 12
  - Feature: `my-feature` (detected)
  - File path: `docs/maintainers/planning/features/my-feature/fix/pr12/batch-medium-low-01.md`

- Batch name: `quick-wins-low-low-01`
  - Type: Cross-PR
  - Feature: None (project-wide)
  - File path: `docs/maintainers/planning/fix/cross-pr/quick-wins-low-low-01.md`

**Extract information:**

- Batch type (PR-specific or cross-PR)
- Source PR number(s) (single PR for PR-specific, multiple PRs for cross-PR)
- Issues in batch
- Priority and effort levels
- File locations
- Implementation steps
- Testing requirements

**Verify:**

- Fix plan exists and is readable
- All issues are documented
- Implementation steps are clear
- Source PRs identified (for cross-PR batches)

**Checklist:**

- [ ] Batch type determined
- [ ] Feature name detected or specified
- [ ] Fix plan file found
- [ ] All issues identified
- [ ] Source PRs identified (for cross-PR batches)
- [ ] Implementation steps reviewed
- [ ] Testing requirements understood

---

### 1a. Check Source PR Status (NEW - Critical Workflow Fix)

**For PR-Specific Batches Only:**

**Purpose:** Determine if fixes should be pushed to an existing open PR or create a new PR based on PR status and fix priority.

**Critical Issue:** Previously, `/fix-implement` always created new PRs, even when the source PR was still open. This caused workflow fragmentation where HIGH priority fixes that should be included in the original PR were split into separate PRs.

**Correct Workflow:**
- **HIGH/CRITICAL priority + PR OPEN** → Push to existing PR branch (fixes included before merge)
- **MEDIUM/LOW priority OR PR MERGED** → Create new PR (post-merge fixes)

**Determine if source PR is still open:**

1. **Extract source PR number from batch name:**
   - Example: `pr32-batch-high-low-01` → PR #32
   - Skip this step for cross-PR batches (they don't have a single source PR)

2. **Check PR status:**
   ```bash
   gh pr view [pr-number] --json state,headRefName
   ```

3. **Read priority from fix plan:**
   ```bash
   # Extract priority from fix plan file
   PRIORITY=$(grep "^**Priority:**" "$FIX_PLAN_FILE" | sed 's/.*: //' | sed 's/ .*//')
   ```

4. **Determine action based on status and priority:**

   **If PR is OPEN and priority is HIGH/CRITICAL:**
   - **Action:** Push fixes to PR's branch (pre-merge fixes)
   - **Branch:** Use PR's existing branch (from `headRefName`)
   - **No new PR:** Fixes update existing PR
   - **Rationale:** HIGH/CRITICAL issues should be fixed before merge
   - **Example:** PR #32 (OPEN) + HIGH priority → Push to `feat/release-readiness-phase-2` branch

   **If PR is MERGED or priority is MEDIUM/LOW:**
   - **Action:** Create new branch and PR (post-merge fixes)
   - **Branch:** Create new `fix/[batch-name]` branch
   - **New PR:** Separate PR for deferred fixes
   - **Rationale:** MEDIUM/LOW issues can be addressed after merge
   - **Example:** PR #32 (MERGED) OR MEDIUM priority → Create new `fix/pr32-batch-medium-low-01` branch

**Implementation:**

```bash
# Initialize variables
PUSH_TO_EXISTING_PR=false
TARGET_BRANCH=""

# Extract PR number from batch name (PR-specific batches only)
if [[ "$BATCH_NAME" =~ ^pr([0-9]+)-batch- ]]; then
    SOURCE_PR="${BASH_REMATCH[1]}"
    
    echo "Detected PR-specific batch for PR #$SOURCE_PR"
    
    # Check if PR is open
    PR_INFO=$(gh pr view "$SOURCE_PR" --json state,headRefName 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        PR_STATE=$(echo "$PR_INFO" | jq -r '.state')
        PR_BRANCH=$(echo "$PR_INFO" | jq -r '.headRefName')
        
        # Check priority from fix plan
        PRIORITY=$(grep "^**Priority:**" "$FIX_PLAN_FILE" | sed 's/.*: //' | sed 's/ .*//')
        
        echo "PR State: $PR_STATE"
        echo "Priority: $PRIORITY"
        
        if [[ "$PR_STATE" == "OPEN" ]] && [[ "$PRIORITY" =~ (CRITICAL|HIGH) ]]; then
            echo "✅ Source PR #$SOURCE_PR is OPEN and priority is $PRIORITY"
            echo "📋 Action: Push fixes to PR's branch ($PR_BRANCH)"
            echo "⚠️  This ensures HIGH priority fixes are included before merge"
            PUSH_TO_EXISTING_PR=true
            TARGET_BRANCH="$PR_BRANCH"
        else
            echo "ℹ️  Source PR #$SOURCE_PR is $PR_STATE or priority is $PRIORITY"
            echo "📋 Action: Create new branch and PR"
            PUSH_TO_EXISTING_PR=false
            TARGET_BRANCH="fix/$BATCH_NAME"
        fi
    else
        echo "⚠️  Could not check PR status (gh CLI not available or PR not found)"
        echo "📋 Action: Create new branch and PR (default behavior)"
        PUSH_TO_EXISTING_PR=false
        TARGET_BRANCH="fix/$BATCH_NAME"
    fi
else
    # Cross-PR batch - always create new branch
    echo "Detected cross-PR batch"
    PUSH_TO_EXISTING_PR=false
    TARGET_BRANCH="fix/$BATCH_NAME"
fi
```

**Checklist:**

- [ ] Source PR number extracted (if PR-specific batch)
- [ ] PR status checked (OPEN/MERGED/CLOSED)
- [ ] Priority level checked (CRITICAL/HIGH vs MEDIUM/LOW)
- [ ] Action determined (push to existing vs create new)
- [ ] Target branch identified
- [ ] Variables set: `PUSH_TO_EXISTING_PR`, `TARGET_BRANCH`

---

### 2. Checkout Target Branch

**Branch strategy depends on action from Step 1a:**

**If pushing to existing PR (pre-merge fixes):**

```bash
# Ensure develop is up-to-date
git checkout develop
git pull origin develop

# Checkout PR's branch
git checkout $TARGET_BRANCH
git pull origin $TARGET_BRANCH

echo "✅ Checked out existing PR branch: $TARGET_BRANCH"
echo "⚠️  Commits will update the existing PR"
```

**If creating new PR (post-merge fixes):**

```bash
# Ensure develop is up-to-date
git checkout develop
git pull origin develop

# Create new fix branch
git checkout -b $TARGET_BRANCH

echo "✅ Created new branch: $TARGET_BRANCH"
```

**Branch naming (for new branches):**

- Format: `fix/[batch-name]` (keep full batch name)
- PR-Specific Example: `fix/pr12-batch-medium-low-01`
- Cross-PR Example: `fix/quick-wins-low-low-01`

**Checklist:**

- [ ] Correct branch checked out (existing PR branch OR new fix branch)
- [ ] Branch is up-to-date with remote
- [ ] Local develop is up-to-date
- [ ] Ready for implementation

---

### 3. Implement Each Issue (TDD Workflow)

**For each issue in the batch:**

#### 3a. Write Tests First (RED)

**If tests don't exist:**

- Write failing tests that demonstrate the issue
- Test should fail with current implementation
- Document expected behavior

**If tests exist but need updating:**

- Update tests to reflect desired behavior
- Ensure tests fail initially

**Example:**

```python
def test_cli_uses_click_choice_for_status(client):
    """Test that CLI validates status using click.Choice."""
    runner = CliRunner()
    # This should fail with invalid status
    result = runner.invoke(cli, ['list', '--status', 'invalid'])
    assert result.exit_code != 0
    assert 'invalid choice' in result.output.lower()
```

#### 3b. Implement Fix (GREEN)

**Follow implementation steps from fix plan:**

- Make minimal changes to pass tests
- Follow code style and patterns
- Add comments if needed

**Example:**

```python
@click.option(
    '--status', '-s',
    type=click.Choice(['active', 'paused', 'completed', 'cancelled'], case_sensitive=False),
    help='Filter by project status'
)
```

#### 3c. Refactor (If Needed)

**After tests pass:**

- Improve code quality
- Remove duplication
- Improve readability
- Ensure no regressions

#### 3d. Verify Fix

**Run tests:**

```bash
# Run specific test
pytest backend/tests/path/to/test_file.py::test_name -v

# Run all tests
pytest backend/tests/ -v

# Check coverage
pytest --cov --cov-report=term-missing
```

**Manual testing (if applicable):**

- Test the fix manually
- Verify expected behavior
- Check for regressions

**Checklist:**

- [ ] Tests written (RED)
- [ ] Implementation done (GREEN)
- [ ] Tests passing
- [ ] Refactored if needed
- [ ] No regressions

---

### 4. Commit Each Issue

**IMPORTANT:** Always commit work before stopping or moving to next issue.

**Reference:** [Commit Workflow](../../docs/COMMIT-WORKFLOW.md) - Central commit workflow documentation

**For code changes (fixes, test updates):**

Use `/review` to review changes before committing. This forces a deliberate pause to verify the fix is correct.

```
[AI implements fix]
    ↓
/review [issue-description]   ← Review in a separate prompt
    ↓ human review
/commit                       ← Commit reviewed changes
```

**Commit message format:**

**For PR-Specific Batches:**

```
fix(scope): [brief description] (PR##-#N)

[Longer description if needed]

Fixes: PR##-#N
Part of: [batch-name]
```

**For Cross-PR Batches:**

```
fix(scope): [brief description] (PR##-#N)

[Longer description if needed]

Fixes: PR##-#N
Part of: [batch-name] (cross-PR batch)
Source PRs: PR##, PR##, ...
```

**Examples:**

**PR-Specific:**

```bash
git commit -m "fix(cli): use click.Choice for status validation (PR12-#1)

Replace free-form status input with click.Choice to validate
status values at CLI level, improving UX by catching invalid
values early.

Fixes: PR12-#1
Part of: pr12-batch-medium-low-01"
```

**Cross-PR:**

```bash
git commit -m "fix(tests): use response.get_json() instead of json.loads (PR01-#5)

Replace manual JSON parsing with Flask's built-in get_json()
method for better error handling and consistency.

Fixes: PR01-#5
Part of: quick-wins-low-low-01 (cross-PR batch)
Source PRs: PR #1, PR #2, PR #12"
```

**Checklist:**

- [ ] Changes reviewed with `/review` (for code changes)
- [ ] Commit message follows format
- [ ] Issue number referenced
- [ ] Batch name included
- [ ] Source PRs listed (for cross-PR batches)
- [ ] Changes committed (via `/commit` or direct for docs-only)

---

### 5. Complete Batch Implementation

**After all issues in batch are fixed:**

1. **Run full test suite:**

   ```bash
   pytest backend/tests/ -v
   # Or project-specific test command
   ```

2. **Check coverage:**

   ```bash
   pytest --cov --cov-report=html
   ```

3. **Run linter:**

   ```bash
   pylint backend/ || flake8 backend/
   # Or project-specific lint command
   ```

4. **Verify all issues addressed:**
   - Check fix plan checklist
   - Verify all implementation steps completed
   - Ensure all tests pass

**Checklist:**

- [ ] All issues in batch fixed
- [ ] All tests passing
- [ ] Coverage maintained/improved
- [ ] No linter errors
- [ ] Manual testing complete (if applicable)

---

### 6. Update Fix Plan Status

**For PR-Specific Batches:**

**File:** `docs/maintainers/planning/features/[feature-name]/fix/pr##/[batch-name].md`  
**OR:** `docs/maintainers/planning/fix/pr##/[batch-name].md` (project-wide)

**For Cross-PR Batches:**

**File:** `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name].md`  
**OR:** `docs/maintainers/planning/fix/cross-pr/[batch-name].md` (project-wide)

**Update status:**

```markdown
**Status:** ✅ Complete  
**Completed:** YYYY-MM-DD  
**PR:** #[number]
```

**Update Definition of Done:**

- Mark all items complete
- Add completion notes if needed

**Mark individual issues in Sourcery review:**

**For PR-Specific Batches:**

- Update single review file: `docs/maintainers/feedback/sourcery/pr##.md`
- Mark each issue as "✅ Fixed" in priority matrix
- Add PR number reference

**For Cross-PR Batches:**

- Update multiple review files (one per source PR)
- For each issue, find its source PR and update that review file
- Mark each issue as "✅ Fixed" in priority matrix
- Add PR number reference

**Examples:**

**PR-Specific:**

```markdown
| Comment | Priority  | Impact    | Effort | Status   | Notes                                      |
| ------- | --------- | --------- | ------ | -------- | ------------------------------------------ |
| #1      | 🟡 MEDIUM | 🟡 MEDIUM | 🟢 LOW | ✅ Fixed | Fixed in PR #15 (pr12-batch-medium-low-01) |
```

**Cross-PR (PR #1 review file):**

```markdown
| Comment | Priority | Impact | Effort | Status   | Notes                                   |
| ------- | -------- | ------ | ------ | -------- | --------------------------------------- |
| #5      | 🟢 LOW   | 🟢 LOW | 🟢 LOW | ✅ Fixed | Fixed in PR #16 (quick-wins-low-low-01) |
| #6      | 🟢 LOW   | 🟢 LOW | 🟢 LOW | ✅ Fixed | Fixed in PR #16 (quick-wins-low-low-01) |
```

**Checklist:**

- [ ] Fix plan status updated
- [ ] Definition of Done marked complete
- [ ] Completion date added
- [ ] Individual issues marked in Sourcery review(s)
  - [ ] Single review file updated (PR-specific)
  - [ ] Multiple review files updated (cross-PR)
- [ ] PR number referenced

---

### 7. Update Fix Tracking

**For PR-Specific Batches:**

**Update PR Hub:**

**File:** `docs/maintainers/planning/features/[feature-name]/fix/pr##/README.md`  
**OR:** `docs/maintainers/planning/fix/pr##/README.md` (project-wide)

**Update batch status:**

```markdown
| Batch               | Priority  | Effort | Issues | Status      | File                                             |
| ------------------- | --------- | ------ | ------ | ----------- | ------------------------------------------------ |
| batch-medium-low-01 | 🟡 MEDIUM | 🟢 LOW | 2      | ✅ Complete | [batch-medium-low-01.md](batch-medium-low-01.md) |
```

**For Cross-PR Batches:**

**Update Cross-PR Hub:**

**File:** `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/README.md`  
**OR:** `docs/maintainers/planning/fix/cross-pr/README.md` (project-wide)

**Update batch status:**

```markdown
### Quick Wins Batch

- **Status:** ✅ Complete
- **Issues:** 7 LOW/LOW issues
- **File:** [quick-wins-low-low-01.md](quick-wins-low-low-01.md)
- **Completed:** YYYY-MM-DD via PR #[number]
```

**Update main hub:**

**File:** `docs/maintainers/planning/features/[feature-name]/fix/README.md`  
**OR:** `docs/maintainers/planning/fix/README.md` (project-wide)

**For PR-Specific Batches:**

```markdown
**Completed:** YYYY-MM-DD via PR #[number]
```

**For Cross-PR Batches:**

```markdown
**Cross-PR Batches:**

- Quick Wins batch completed via PR #[number]
```

**Checklist:**

- [ ] Hub updated (PR hub for PR-specific, cross-PR hub for cross-PR batches)
- [ ] Batch status updated to "Complete"
- [ ] PR number added
- [ ] Completion date added
- [ ] Main hub updated

---

### 8. Create or Update PR

**Action depends on Step 1a determination:**

**If pushing to existing PR (pre-merge fixes):**

```bash
# Push commits to PR's branch
git push origin $TARGET_BRANCH

echo "✅ Pushed fixes to existing PR branch: $TARGET_BRANCH"
echo "📋 Updating PR description to include fixes..."

# Update PR description
gh pr edit $SOURCE_PR --body "$(cat /tmp/pr-update-description.md)"

echo "✅ PR #$SOURCE_PR updated with fix information"
echo "🔗 PR Link: $(gh pr view $SOURCE_PR --json url --jq '.url')"
```

**PR Description Update (append to existing description):**

```markdown
---

## Fixes Included (from Sourcery Review)

### [batch-name]: [Brief Description]

**Fixes:**
- **PR##-#N:** [Description] ([Priority], [Effort]) - ✅ Fixed
- **PR##-#M:** [Description] ([Priority], [Effort]) - ✅ Fixed

**Status:** ✅ HIGH priority fixes addressed before merge

---
```

**If creating new PR (post-merge fixes):**

```bash
# Push new branch
git push origin $TARGET_BRANCH

echo "✅ Pushed new branch: $TARGET_BRANCH"
echo "📋 Creating PR..."

# Create PR
gh pr create \
  --title "[PR Title]" \
  --body-file /tmp/pr-description.md \
  --base develop \
  --head $TARGET_BRANCH

echo "✅ PR created"
```

**PR Title Format (for new PRs):**

**For PR-Specific Batches:**

```
fix: [Batch Description] ([batch-name])
```

**For Cross-PR Batches:**

```
fix: [Batch Description] ([batch-name], cross-PR batch)
```

**Examples:**

```
fix: CLI validation and test improvements (pr12-batch-medium-low-01)
fix: Quick wins - test improvements and error handling (quick-wins-low-low-01, cross-PR batch)
fix: gh CLI skipped check bug (pr32-batch-high-low-01)
```

**PR Description Template:**

**For PR-Specific Batches:**

```markdown
## Fix Batch: [batch-name]

Fixes [N] issues from PR #[number] Sourcery review.

---

## Issues Fixed

- **PR##-#N:** [Description] ([Priority], [Effort])
- **PR##-#M:** [Description] ([Priority], [Effort])

---

## Changes

### [Issue PR##-#N]

**File:** `[file]`

[Description of changes]

**Tests:**

- [Test file] - [What was tested]

### [Issue PR##-#M]

[Similar format]

---

## Testing

- [x] All existing tests passing
- [x] New tests added for fixes
- [x] Coverage maintained/improved ([X]%)
- [x] Manual testing completed (if applicable)
- [x] No regressions introduced

---

## Related

- **Fix Plan:** `docs/maintainers/planning/features/[feature-name]/fix/pr##/[batch-name].md`
- **Sourcery Review:** `docs/maintainers/feedback/sourcery/pr##.md`
- **Original PR:** #[number]
```

**For Cross-PR Batches:**

```markdown
## Fix Batch: [batch-name] (Cross-PR)

Fixes [N] issues from multiple PRs' Sourcery reviews.

**Source PRs:** PR #[number], PR #[number], ...

---

## Issues Fixed

- **PR##-#N:** [Description] ([Priority], [Effort]) - Source: PR #[number]
- **PR##-#M:** [Description] ([Priority], [Effort]) - Source: PR #[number]

---

## Changes

### [Issue PR##-#N] (from PR #[number])

**File:** `[file]`

[Description of changes]

**Tests:**

- [Test file] - [What was tested]

### [Issue PR##-#M] (from PR #[number])

[Similar format]

---

## Testing

- [x] All existing tests passing
- [x] New tests added for fixes
- [x] Coverage maintained/improved ([X]%)
- [x] Manual testing completed (if applicable)
- [x] No regressions introduced

---

## Related

- **Fix Plan:** `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name].md`
- **Fix Review Report:** `docs/maintainers/planning/features/[feature-name]/fix/fix-review-report-YYYY-MM-DD.md`
- **Source PRs:** PR #[number], PR #[number], ...
- **Sourcery Reviews:**
  - `docs/maintainers/feedback/sourcery/pr##.md`
  - `docs/maintainers/feedback/sourcery/pr##.md`
```

**Create PR:**

```bash
# Push branch
git push origin fix/[batch-name]

# Create PR
gh pr create --title "fix: [Batch Description] ([batch-name])" \
             --body-file /tmp/pr-description.md \
             --base develop \
             --head fix/[batch-name]
```

**Checklist:**

- [ ] PR created
- [ ] Description includes all issues
- [ ] Fix plan linked
- [ ] Tests documented
- [ ] PR link presented to user

---

## TDD Workflow Reminder

**For each issue:**

1. **RED:** Write failing test
   - Test demonstrates the issue
   - Test fails with current code

2. **GREEN:** Implement fix
   - Minimal changes to pass test
   - Test now passes

3. **REFACTOR:** Improve code
   - Clean up implementation
   - Remove duplication
   - Improve readability
   - Ensure tests still pass

---

## Common Issues

### Issue: Tests Fail After Fix

**Solution:**

- Review test expectations
- Check if fix changed behavior
- Update tests if behavior change is correct
- Verify no regressions

### Issue: Multiple Files Affected

**Solution:**

- Implement changes file by file
- Test after each file change
- Commit incrementally if helpful
- Ensure all files updated consistently

### Issue: Fix Conflicts with Recent Changes

**Solution:**

- Rebase on latest develop
- Resolve conflicts
- Re-test after rebase
- Verify fix still works

### Issue: Batch Too Large

**Solution:**

- Can split batch into smaller PRs
- Implement subset of issues
- Create PR for partial batch
- Continue with remaining issues

---

## Tips

### Before Starting

- Review fix plan thoroughly
- Understand all issues in batch
- Check if any dependencies exist
- Ensure test environment ready

### During Implementation

- Follow TDD workflow strictly
- Commit frequently (per issue)
- Test after each change
- Keep commits focused

### After Implementation

- Run full test suite
- Check coverage
- Review code changes
- Update documentation

---

## Reference

**Fix Plans:**

- PR-Specific: `docs/maintainers/planning/features/[feature-name]/fix/pr##/[batch-name].md`
- Cross-PR: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name].md`
- Project-wide: `docs/maintainers/planning/fix/pr##/[batch-name].md` or `docs/maintainers/planning/fix/cross-pr/[batch-name].md`

**Fix Tracking:**

- `docs/maintainers/planning/features/[feature-name]/fix/README.md` (main hub - feature-specific)
- `docs/maintainers/planning/fix/README.md` (main hub - project-wide)
- `docs/maintainers/planning/features/[feature-name]/fix/pr##/README.md` (PR hub - PR-specific batches)
- `docs/maintainers/planning/fix/pr##/README.md` (PR hub - project-wide)
- `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/README.md` (cross-PR hub - feature-specific)
- `docs/maintainers/planning/fix/cross-pr/README.md` (cross-PR hub - project-wide)

**Sourcery Reviews:**

- `docs/maintainers/feedback/sourcery/pr##.md` (one per source PR for cross-PR batches)

**Fix Review Reports:**

- `docs/maintainers/planning/features/[feature-name]/fix/fix-review-report-YYYY-MM-DD.md` (source for cross-PR batches)
- `docs/maintainers/planning/fix/fix-review-report-YYYY-MM-DD.md` (project-wide)

**Related Commands:**

- `/fix-plan` - Create fix plans from PR review or fix-review report
- `/fix-review` - Review old deferred issues and generate report
- `/pr --fix [batch-name]` - Create PR for fix batch (use after implementation)
- `/task-phase` - Phase task implementation (similar workflow)
- `/task-release` - Release transition task implementation (similar workflow)

---

**Last Updated:** 2025-12-07  
**Status:** ✅ Active  
**Next:** Use after `/fix-plan` to implement batches (supports both PR-specific and cross-PR batches, feature-specific and project-wide)

