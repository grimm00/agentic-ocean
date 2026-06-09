# Fix Plan Command

Analyzes Sourcery review for a PR, batches issues by priority and effort, and creates fix plans ready for implementation.

---

## Configuration

**Fix Path Detection:**

This command supports multiple fix organization patterns. It will auto-detect the structure or use configuration:

1. **Feature-Specific Fixes (default):**

   - Path: `docs/maintainers/planning/features/[feature-name]/fix/`
   - Feature name auto-detected from context or configuration
   - Example: `docs/maintainers/planning/features/my-feature/fix/pr##/`

2. **Project-Wide Fixes:**
   - Path: `docs/maintainers/planning/fix/`
   - Used when no feature structure exists
   - Example: `docs/maintainers/planning/fix/pr##/`

**Feature Detection:**

- Check if `docs/maintainers/planning/features/` exists
- If multiple features exist, use configuration or prompt user
- If single feature exists, use that feature name
- If no features exist, use project-wide structure

**Batch Naming:**

- Default format: `pr##-batch-[priority]-[effort]-[batch-number]`
- Configurable via project configuration
- Examples: `pr12-batch-medium-low-01`, `pr12-batch-low-low-01`

**Fix Management:**

- Fix tracking is optional - command will create structure if needed
- Projects without fix management can still use this command
- Structure creation can be disabled via configuration

---

## Workflow Overview

**When to use:**

- After PR is merged and Sourcery review is available
- To organize deferred issues into implementable batches
- Before implementing fixes

**Key principle:** Batch issues intelligently by priority first, then by effort, creating manageable fix plans.

---

## Usage

**Command:** `/fix-plan [pr-number|--from-review-report] [options]`

**Examples:**

- `/fix-plan` - Analyze last merged PR (default)
- `/fix-plan 12` - Analyze PR #12
- `/fix-plan 12 --max-batch-size 3` - Custom batch size
- `/fix-plan 12 --priority MEDIUM` - Only plan MEDIUM priority issues
- `/fix-plan --from-review-report fix-review-report-2025-12-05.md` - Create batches from review report
- `/fix-plan --from-review-report fix-review-report-2025-12-05.md --batch "Quick Wins"` - Create specific batch from report
- `/fix-plan --from-review-report --quick-wins` - Create only Quick Wins batch from latest report
- `/fix-plan --review-old` - Review and plan old deferred issues
- `/fix-plan --archive-completed` - Archive completed fix plans

**Options:**

- `--max-batch-size N` - Maximum issues per batch (default: 5 for MEDIUM/LOW, 3 for HIGH/CRITICAL)
- `--priority LEVEL` - Only plan issues of this priority (CRITICAL, HIGH, MEDIUM, LOW)
- `--min-effort LEVEL` - Only plan issues with at least this effort (LOW, MEDIUM, HIGH)
- `--dry-run` - Show batching plan without creating fix plan files
- `--from-review-report [file]` - Create batches from fix-review report (see "From Review Report" section)
- `--batch NAME` - Create specific batch from report (e.g., "Quick Wins", "Test Quality")
- `--quick-wins` - Create only Quick Wins batch from report
- `--review-old` - Review old deferred issues (see "Reviewing Old Issues" section)
- `--archive-completed` - Archive completed fix plans to `fix/archived/`
- `--known-issues [path]` - Consider known CI/CD issues when planning (NEW)
  - Default: `admin/planning/ci/multi-environment-testing/known-issues.md`
  - Checks if fixes depend on known issues
  - Adds warnings for fixes blocked by known issues
  - Prioritizes fixes that address known issues

---

## Step-by-Step Process

### Mode Selection

**Two modes of operation:**

1. **PR Mode (default):** Analyze single PR's Sourcery review

   - Use: `/fix-plan [pr-number]`
   - Reads: `docs/maintainers/feedback/sourcery/pr##.md`
   - Creates: Batches for that PR's issues

2. **Review Report Mode:** Create batches from fix-review report
   - Use: `/fix-plan --from-review-report [file]`
   - Reads: `docs/maintainers/planning/features/[feature-name]/fix/fix-review-report-*.md` OR `docs/maintainers/planning/fix/fix-review-report-*.md`
   - Creates: Batches for recommended issues across multiple PRs

**If `--from-review-report` is specified, skip to "From Review Report" section below.**

---

### 0. Detect Fix Structure

**Before proceeding, determine fix path structure:**

1. **Check for feature structure:**

   ```bash
   # Check if features directory exists
   ls docs/maintainers/planning/features/ 2>/dev/null

   # If exists, list features
   ls docs/maintainers/planning/features/
   ```

2. **Determine feature name:**

   - If single feature exists → use that feature name
   - If multiple features exist → use configuration or prompt user
   - If no features exist → use project-wide structure

3. **Set fix base path:**

   - Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/`
   - Project-wide: `docs/maintainers/planning/fix/`

4. **Create fix structure if needed (optional):**
   - Check if fix directory exists
   - Create if missing (if fix management enabled)
   - Create main README.md hub if missing

**Checklist:**

- [ ] Fix structure detected or created
- [ ] Fix base path determined
- [ ] Feature name identified (if applicable)

---

### 1. Identify PR and Review File (PR Mode)

**Default behavior:**

- Find last merged PR (check git log or GitHub)
- Locate Sourcery review file: `docs/maintainers/feedback/sourcery/pr##.md`

**Manual specification:**

- Use provided PR number
- Verify review file exists

**Commands:**

```bash
# Find last merged PR
gh pr list --state merged --limit 1 --json number,title,mergedAt

# Check if review file exists
ls docs/maintainers/feedback/sourcery/pr##.md
```

**Checklist:**

- [ ] PR number identified (or using default)
- [ ] Review file exists and is readable
- [ ] Priority matrix is filled out in review file

---

### 2. Parse Sourcery Review

**Extract from review file:**

- All individual comments
- Priority matrix assessments
- Overall comments (if applicable)
- File locations and descriptions

**Parse priority matrix:**

- Extract Priority, Impact, Effort for each comment
- Identify which issues are deferred (MEDIUM/LOW priority)
- Note CRITICAL/HIGH issues that need immediate attention

**Example parsing:**

```markdown
| Comment | Priority  | Impact    | Effort    | Notes                               |
| ------- | --------- | --------- | --------- | ----------------------------------- |
| #1      | 🟡 MEDIUM | 🟡 MEDIUM | 🟢 LOW    | Use click.Choice for CLI validation |
| #2      | 🟡 MEDIUM | 🟢 LOW    | 🟢 LOW    | Tighten test expectations           |
| #3      | 🟡 MEDIUM | 🟢 LOW    | 🟡 MEDIUM | Avoid conditionals in tests         |
```

**Checklist:**

- [ ] All comments parsed
- [ ] Priority/Impact/Effort extracted
- [ ] Deferred issues identified

---

### 3. Check for Already-Fixed Issues

**Check fix tracking:**

- Review fix tracking hub: `docs/maintainers/planning/features/[feature-name]/fix/README.md` OR `docs/maintainers/planning/fix/README.md`
- Check individual fix plan files
- Verify GitHub PRs for fixes

**Mark fixed issues:**

- If issue was fixed in a previous PR, mark as "✅ Complete" in review file
- Update fix tracking to reflect completion
- Archive fix plan if exists

**Archive completed issues:**

- Move fix plan to `fix/archived/` directory (if exists)
- Update fix tracking to remove from active list
- Note completion date and PR number

**Default behavior:**

- Include all deferred issues (MEDIUM/LOW priority)
- Skip CRITICAL/HIGH if already fixed
- Skip issues marked as "✅ Complete" in fix tracking
- Skip issues in archived fix plans

**Checklist:**

- [ ] Fix tracking reviewed for completed issues
- [ ] Already-fixed issues marked/archived
- [ ] Only unfixed issues included in planning

---

### 4. Batch Issues by Priority and Effort

**Batching Strategy:**

1. **Group by Priority** (highest first):

   - 🔴 CRITICAL
   - 🟠 HIGH
   - 🟡 MEDIUM
   - 🟢 LOW

2. **Within each priority, group by Effort** (lowest first):

   - 🟢 LOW effort
   - 🟡 MEDIUM effort
   - 🟠 HIGH effort
   - 🔴 VERY_HIGH effort

3. **Create batches within each priority/effort group:**
   - **CRITICAL/HIGH:** Max 3 issues per batch (urgent, need careful review)
   - **MEDIUM/LOW:** Max 5 issues per batch (can handle more at once)
   - **VERY_HIGH effort:** 1 issue per batch (complex, needs focus)

**Batch Naming:**

- Format: `pr##-batch-[priority]-[effort]-[batch-number]` (default, configurable)
- Examples:
  - `pr12-batch-medium-low-01` - PR #12, MEDIUM priority, LOW effort, batch 1
  - `pr12-batch-low-low-01` - PR #12, LOW priority, LOW effort, batch 1
  - `pr12-batch-critical-low-01` - PR #12, CRITICAL priority, LOW effort, batch 1

**Example Batching:**

**PR #12 Issues:**

- PR12-#1: MEDIUM, LOW effort
- PR12-#2: MEDIUM, LOW effort
- PR12-#3: MEDIUM, MEDIUM effort
- PR12-#4: LOW, LOW effort
- PR12-#5: LOW, LOW effort

**Batches Created:**

- `pr12-batch-medium-low-01`: PR12-#1, PR12-#2 (2 issues)
- `pr12-batch-medium-medium-01`: PR12-#3 (1 issue)
- `pr12-batch-low-low-01`: PR12-#4, PR12-#5 (2 issues)

**Checklist:**

- [ ] Issues grouped by priority
- [ ] Within priority, grouped by effort
- [ ] Batches created with appropriate sizes
- [ ] Batch names follow convention (default or configured)

---

### 5. Create Fix Plan Files

**Location:** `docs/maintainers/planning/features/[feature-name]/fix/pr##/` OR `docs/maintainers/planning/fix/pr##/`

**Directory structure:**

- Create PR directory if it doesn't exist: `pr##/`
- Create README.md hub for PR directory
- Fix plan files go in PR directory

**File naming:**

- Format: `batch-[priority]-[effort]-[batch-number].md` (for batches)
- Format: `issue-[number]-[short-name].md` (for individual issues)
- Example: `pr12/batch-medium-low-01.md`
- Example: `pr02/issue-03-cli-imports.md`

**Fix Plan Template:**

````markdown
# Fix Plan: PR ## Batch [Priority] [Effort] - Batch [Number]

**PR:** ##  
**Batch:** [priority]-[effort]-[batch-number]  
**Priority:** [Priority Level]  
**Effort:** [Effort Level]  
**Status:** 🔴 Not Started  
**Created:** YYYY-MM-DD  
**Issues:** [N] issues

---

## Issues in This Batch

| Issue   | Priority   | Impact   | Effort   | Description   |
| ------- | ---------- | -------- | -------- | ------------- |
| PR##-#N | [Priority] | [Impact] | [Effort] | [Description] |

---

## Overview

This batch contains [N] [priority] priority issues with [effort] effort. These issues are related to [common theme if applicable].

**Estimated Time:** [X] hours  
**Files Affected:** [list of files]

---

## Issues Details

### Issue PR##-#N: [Short Description]

**Location:** `[file]:[line]`  
**Sourcery Comment:** Comment #N  
**Priority:** [Priority] | **Impact:** [Impact] | **Effort:** [Effort]

**Description:**
[Full description from Sourcery review]

**Current Code:**

```[language]
[code snippet]
```

**Proposed Solution:**
[Solution description or code]

---

## Implementation Steps

1. **Issue PR##-#N**

   - [ ] Step 1
   - [ ] Step 2
   - [ ] Step 3

2. **Issue PR##-#M**
   - [ ] Step 1
   - [ ] Step 2

---

## Testing

- [ ] All existing tests pass
- [ ] New tests added (if applicable)
- [ ] Manual testing completed
- [ ] No regressions introduced

---

## Files to Modify

- `[file1]` - [reason]
- `[file2]` - [reason]

---

## Definition of Done

- [ ] All issues in batch fixed
- [ ] Tests passing
- [ ] Code reviewed
- [ ] Documentation updated (if needed)
- [ ] Ready for PR

---

**Batch Rationale:**
These issues are batched together because they:

- Share similar priority and effort levels
- May affect related code areas
- Can be implemented together efficiently
````

**Checklist:**

- [ ] Fix plan file created for each batch
- [ ] All issues documented in batch files
- [ ] Implementation steps outlined
- [ ] Testing requirements specified

---

### 6. Create PR Directory Hub

**File:** `docs/maintainers/planning/features/[feature-name]/fix/pr##/README.md` OR `docs/maintainers/planning/fix/pr##/README.md`

**Create PR hub file:**

```markdown
# PR ## Fix Tracking

**PR:** ## - [PR Title]
**Date:** YYYY-MM-DD
**Status:** 🟡 Planned
**Last Updated:** YYYY-MM-DD

---

## 📋 Quick Links

### Fix Batches

- **[batch-medium-low-01.md](batch-medium-low-01.md)** - [Description] ([Priority], [Effort], [N] issues)
- **[batch-medium-medium-01.md](batch-medium-medium-01.md)** - [Description] ([Priority], [Effort], [N] issues)

---

## 📊 Summary

**Total Issues:** [N]
**Batches:** [M]
**Status:** 🟡 Planned

**Priority Breakdown:**

- 🟡 MEDIUM: [X] issues
- 🟢 LOW: [Y] issues
```

**Checklist:**

- [ ] PR directory created (if needed)
- [ ] PR hub README.md created
- [ ] All batches linked in hub
- [ ] Summary information added

---

### 7. Update Main Fix Tracking

**File:** `docs/maintainers/planning/features/[feature-name]/fix/README.md` OR `docs/maintainers/planning/fix/README.md`

**Add PR to active PRs section:**

```markdown
### Active PRs

- **[PR ##](pr##/README.md)** - [PR Title] ([Status])
```

**Checklist:**

- [ ] Main README updated with PR link
- [ ] PR added to active PRs list
- [ ] Status indicator correct

---

### 8. Summary Report (PR Mode)

**Present to user:**

```markdown
## Fix Plan Complete

**PR:** #N - [PR Title]

### Issues Analyzed

- Total issues: [N]
- Deferred issues: [M]
- Already fixed: [K]

### Batches Created

- [N] batches created
- Priority breakdown:
  - CRITICAL: [X] batches
  - HIGH: [Y] batches
  - MEDIUM: [Z] batches
  - LOW: [W] batches

### Next Steps

1. Review fix plans in `docs/maintainers/planning/features/[feature-name]/fix/` OR `docs/maintainers/planning/fix/`
2. Use `/fix-implement` command to implement batches
3. Start with CRITICAL/HIGH batches first
```

---

## From Review Report Mode

**When to use:**

- After running `/fix-review` and identifying batches to create
- To create batches from accumulated issues across multiple PRs
- To implement recommended batches from review report

**Key principle:** Parse review report recommendations and create fix plans for cross-PR batches.

---

### 1. Load Review Report

**File location:**

- Default: Latest report in `docs/maintainers/planning/features/[feature-name]/fix/fix-review-report-*.md` OR `docs/maintainers/planning/fix/fix-review-report-*.md`
- Manual: `--from-review-report fix-review-report-2025-12-05.md`

**Extract from report:**

- Recommended batches (Quick Wins, Test Quality, etc.)
- Issue IDs for each batch (PR##-#N format)
- Batch descriptions and recommendations
- Priority and effort levels

**Example report sections:**

```markdown
## Quick Wins

| Issue   | Priority | Effort | Age    | Description                |
| ------- | -------- | ------ | ------ | -------------------------- |
| PR01-#5 | 🟢 LOW   | 🟢 LOW | 3 days | Test improvements          |
| PR02-#5 | 🟢 LOW   | 🟢 LOW | 2 days | Test error message content |
```

**Checklist:**

- [ ] Review report file found
- [ ] Report is readable and well-formatted
- [ ] Recommended batches identified
- [ ] Issue IDs extracted

---

### 2. Resolve Issue Details

**For each issue ID (PR##-#N):**

1. **Find source PR:**

   - Extract PR number from issue ID (e.g., PR02-#5 → PR #2)
   - Locate PR hub: `docs/maintainers/planning/features/[feature-name]/fix/pr##/README.md` OR `docs/maintainers/planning/fix/pr##/README.md`
   - Check if archived: `docs/maintainers/planning/features/[feature-name]/fix/archived/pr##/README.md` OR `docs/maintainers/planning/fix/archived/pr##/README.md`

2. **Get issue details:**

   - Read Sourcery review: `docs/maintainers/feedback/sourcery/pr##.md`
   - Extract comment details (location, description, code context)
   - Get priority/impact/effort from priority matrix
   - Check if issue already has fix plan

3. **Verify issue status:**
   - Check if already fixed (marked as "✅ Fixed" in review)
   - Check if fix plan already exists
   - Verify issue is still deferred

**Checklist:**

- [ ] All issue IDs resolved to source PRs
- [ ] Issue details extracted from Sourcery reviews
- [ ] Issue status verified (not already fixed)
- [ ] Missing details noted

---

### 3. Create Cross-PR Batches

**Batch naming for cross-PR batches:**

- Format: `cross-pr-[batch-name]-[priority]-[effort]-[batch-number]` (default, configurable)
- Examples:
  - `cross-pr-quick-wins-low-low-01` - Quick Wins batch, LOW/LOW
  - `cross-pr-test-quality-medium-low-01` - Test Quality batch, MEDIUM/LOW
  - `cross-pr-error-handling-low-low-01` - Error handling batch, LOW/LOW

**Batch location:**

- Create directory: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/` OR `docs/maintainers/planning/fix/cross-pr/`
- Create hub: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/README.md` OR `docs/maintainers/planning/fix/cross-pr/README.md`
- Fix plans: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name].md` OR `docs/maintainers/planning/fix/cross-pr/[batch-name].md`

**Batching logic:**

- Group issues by recommended batch name from report
- Within batch, group by priority and effort
- Create batches following same size guidelines as PR mode

**Example batches from report:**

**Quick Wins Batch:**

- PR01-#5: Test improvements (LOW, LOW)
- PR01-#6: README typo (LOW, LOW)
- PR02-#5: Test error message content (LOW, LOW)
- PR02-#9: Avoid loop in tests (LOW, LOW)
- PR02-#10: Raise from previous error (get) (LOW, LOW)
- PR02-#11: Raise from previous error (list) (LOW, LOW)
- PR12-#5: Raise from previous error (LOW, LOW)

**Test Quality Batch:**

- PR02-#4: Test null path serialization (MEDIUM, LOW)
- PR02-#8: Test updated_at changes (MEDIUM, LOW)
- PR08-#3: Missing test: empty JSON body (MEDIUM, LOW)
- PR13-#1: Strengthen test assertions (MEDIUM, LOW)

**Checklist:**

- [ ] Batches created based on report recommendations
- [ ] Batch names follow cross-PR convention (default or configured)
- [ ] Issues grouped logically
- [ ] Batch sizes appropriate

---

### 4. Create Fix Plan Files (Cross-PR Mode)

**Location:** `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/` OR `docs/maintainers/planning/fix/cross-pr/`

**File naming:**

- Format: `[batch-name]-[priority]-[effort]-[batch-number].md`
- Example: `quick-wins-low-low-01.md`
- Example: `test-quality-medium-low-01.md`

**Fix Plan Template (Cross-PR):**

````markdown
# Fix Plan: Cross-PR Batch [Batch Name] - [Priority] [Effort]

**Batch:** [batch-name]-[priority]-[effort]-[batch-number]  
**Priority:** [Priority Level]  
**Effort:** [Effort Level]  
**Status:** 🔴 Not Started  
**Created:** YYYY-MM-DD  
**Source:** fix-review-report-YYYY-MM-DD.md  
**Issues:** [N] issues from [M] PRs

---

## Issues in This Batch

| Issue   | PR  | Priority   | Impact   | Effort   | Description   |
| ------- | --- | ---------- | -------- | -------- | ------------- |
| PR##-#N | ##  | [Priority] | [Impact] | [Effort] | [Description] |

---

## Overview

This batch contains [N] [priority] priority issues with [effort] effort from [M] PRs. These issues are related to [common theme].

**Estimated Time:** [X] hours  
**Files Affected:** [list of files from all PRs]

**Source PRs:**

- PR ##: [PR Title]
- PR ##: [PR Title]

---

## Issue Details

### Issue PR##-#N: [Short Description]

**Source PR:** ## - [PR Title]  
**Location:** `[file]:[line]`  
**Sourcery Comment:** Comment #N  
**Priority:** [Priority] | **Impact:** [Impact] | **Effort:** [Effort]

**Description:**
[Full description from Sourcery review]

**Current Code:**

```[language]
[code snippet]
```

**Proposed Solution:**
[Solution description or code]

**Related Files:**

- `[file1]` - [reason]
- `[file2]` - [reason]

---

## Implementation Steps

1. **Issue PR##-#N**

   - [ ] Step 1
   - [ ] Step 2
   - [ ] Step 3

2. **Issue PR##-#M**
   - [ ] Step 1
   - [ ] Step 2

---

## Testing

- [ ] All existing tests pass
- [ ] New tests added (if applicable)
- [ ] Manual testing completed
- [ ] No regressions introduced

---

## Files to Modify

- `[file1]` - [reason, PR ##]
- `[file2]` - [reason, PR ##]

---

## Definition of Done

- [ ] All issues in batch fixed
- [ ] Tests passing
- [ ] Code reviewed
- [ ] Documentation updated (if needed)
- [ ] Ready for PR

---

**Batch Rationale:**
This batch was created from fix-review report recommendations. These issues are batched together because they:

- Share similar priority and effort levels
- Address related code quality improvements
- Can be implemented together efficiently
- Were identified as [batch type] in review report
````

**Checklist:**

- [ ] Cross-PR directory created
- [ ] Fix plan file created for each batch
- [ ] All issues documented with source PR references
- [ ] Implementation steps outlined
- [ ] Testing requirements specified

---

### 5. Create Cross-PR Hub

**File:** `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/README.md` OR `docs/maintainers/planning/fix/cross-pr/README.md`

**Create hub file:**

```markdown
# Cross-PR Fix Batches

**Purpose:** Fix batches created from fix-review reports across multiple PRs  
**Status:** ✅ Active  
**Last Updated:** YYYY-MM-DD

---

## 📋 Quick Links

### Active Batches

- **[quick-wins-low-low-01.md](quick-wins-low-low-01.md)** - Quick Wins (🟢 LOW, 🟢 LOW, 7 issues)
- **[test-quality-medium-low-01.md](test-quality-medium-low-01.md)** - Test Quality (🟡 MEDIUM, 🟢 LOW, 4 issues)

---

## 📊 Summary

**Total Batches:** [N]  
**Total Issues:** [M]  
**Source PRs:** [List of PR numbers]

**Priority Breakdown:**

- 🟡 MEDIUM: [X] issues
- 🟢 LOW: [Y] issues

---

## 🟡 Active Batches

### Quick Wins Batch

- **Status:** 🔴 Not Started
- **Issues:** 7 LOW/LOW issues
- **File:** [quick-wins-low-low-01.md](quick-wins-low-low-01.md)
- **Estimated:** 2-3 hours

### Test Quality Batch

- **Status:** 🔴 Not Started
- **Issues:** 4 MEDIUM/LOW issues
- **File:** [test-quality-medium-low-01.md](test-quality-medium-low-01.md)
- **Estimated:** 2-3 hours

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Cross-PR hub created
- [ ] All batches linked in hub
- [ ] Summary information added
- [ ] Source PRs documented

---

### 6. Update Main Fix Tracking (Cross-PR Mode)

**File:** `docs/maintainers/planning/features/[feature-name]/fix/README.md` OR `docs/maintainers/planning/fix/README.md`

**Add cross-PR batches section:**

```markdown
### Cross-PR Batches

- **[Cross-PR Batches](cross-pr/README.md)** - Batches from fix-review reports ([N] batches)
```

**Checklist:**

- [ ] Main README updated with cross-PR link
- [ ] Cross-PR batches section added
- [ ] Status indicator correct

---

### 7. Summary Report (Cross-PR Mode)

**Present to user:**

```markdown
## Fix Plan Complete (From Review Report)

**Report:** fix-review-report-YYYY-MM-DD.md

### Batches Created

- [N] batches created from review report
- Batch breakdown:
  - Quick Wins: [X] issues
  - Test Quality: [Y] issues
  - [Other batches]: [Z] issues

### Source PRs

- PR ##: [X] issues
- PR ##: [Y] issues
- PR ##: [Z] issues

### Next Steps

1. Review fix plans in `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/` OR `docs/maintainers/planning/fix/cross-pr/`
2. Use `/fix-implement` command to implement batches
3. Start with recommended priority order
```

---

## Batching Logic Details

### Batch Size Guidelines

**CRITICAL Priority:**

- Max 1-2 issues per batch (urgent, need careful attention)
- Each issue may need separate PR

**HIGH Priority:**

- Max 2-3 issues per batch
- Can combine related issues

**MEDIUM Priority:**

- Max 3-5 issues per batch
- Group by related functionality if possible

**LOW Priority:**

- Max 5 issues per batch
- Can handle larger batches

**Effort Considerations:**

- VERY_HIGH effort: Always 1 issue per batch
- HIGH effort: Max 2 issues per batch
- MEDIUM effort: Max 3-4 issues per batch
- LOW effort: Can batch up to max size

### Related Issue Grouping

**If issues affect same files:**

- Prefer grouping in same batch
- Reduces file switching overhead

**If issues are similar (e.g., all test improvements):**

- Can batch together even if different files
- Creates cohesive PR

---

## Common Issues

### Issue: No Review File Found

**Solution:**

- Check if PR number is correct
- Verify review was run (`dt-review` command)
- May need to run review first

### Issue: Priority Matrix Not Filled

**Solution:**

- Fill priority matrix in review file first
- Use `/pr-validation` command to ensure matrix is complete

### Issue: All Issues Already Fixed

**Solution:**

- Check fix tracking document
- Update review file status if needed
- No batches needed

### Issue: Too Many Issues in One Batch

**Solution:**

- Reduce `--max-batch-size` parameter
- Manually split batches if needed
- Consider creating separate batches for different file areas

### Issue: Fix Structure Not Found

**Solution:**

- Command will auto-create structure if fix management enabled
- Or manually create fix directory structure
- Check configuration for fix management settings

---

## Tips

### Before Running

- Ensure Sourcery review is complete
- Verify priority matrix is filled out
- Check if any issues were already fixed
- Verify fix structure exists or will be created

### During Planning

- Review batching logic makes sense
- Consider related issues grouping
- Adjust batch sizes if needed

### After Planning

- Review fix plan files for accuracy
- Verify batch sizes are manageable
- Consider implementation order (CRITICAL first)

---

## Reference

**Review Files:**

- `docs/maintainers/feedback/sourcery/pr##.md`

**Fix Plans:**

- `docs/maintainers/planning/features/[feature-name]/fix/pr##/batch-*.md` OR `docs/maintainers/planning/fix/pr##/batch-*.md` (batches)
- `docs/maintainers/planning/features/[feature-name]/fix/pr##/issue-*.md` OR `docs/maintainers/planning/fix/pr##/issue-*.md` (individual issues)

**Fix Tracking:**

- `docs/maintainers/planning/features/[feature-name]/fix/README.md` OR `docs/maintainers/planning/fix/README.md` (main hub)
- `docs/maintainers/planning/features/[feature-name]/fix/pr##/README.md` OR `docs/maintainers/planning/fix/pr##/README.md` (PR hub)

**Related Commands:**

- `/fix-implement` - Implement fixes from a batch
- `/fix-review` - Review old deferred issues and generate report
- `/fix-plan --from-review-report` - Create batches from fix-review report (this command)
- `/pr-validation` - Run Sourcery review and fill priority matrix

---

**Last Updated:** 2025-12-07  
**Status:** ✅ Active  
**Next:** Use `/fix-implement` to implement batches, `/fix-review` to review old issues, or `--from-review-report` to create batches from review reports
