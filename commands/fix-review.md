# Fix Review Command

Review old deferred issues to identify candidates for addressing. Helps prioritize which old issues are worth fixing now.

---

## Configuration

**Fix Path Detection:**

This command supports multiple fix organization patterns, matching `/fix-plan` and `/fix-implement`:

1. **Feature-Specific Fixes (default):**

   - Main hub: `docs/maintainers/planning/features/[feature-name]/fix/README.md`
   - PR hubs: `docs/maintainers/planning/features/[feature-name]/fix/pr##/README.md`
   - Fix plans: `docs/maintainers/planning/features/[feature-name]/fix/pr##/batch-*.md` or `pr##/issue-*.md`
   - Archived: `docs/maintainers/planning/features/[feature-name]/fix/archived/pr##/`

2. **Project-Wide Fixes:**
   - Main hub: `docs/maintainers/planning/fix/README.md`
   - PR hubs: `docs/maintainers/planning/fix/pr##/README.md`
   - Fix plans: `docs/maintainers/planning/fix/pr##/batch-*.md` or `pr##/issue-*.md`
   - Archived: `docs/maintainers/planning/fix/archived/pr##/`

**Feature Detection:**

- Use `--feature` option if provided
- Otherwise, auto-detect using same logic as other commands:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for fix structure in each
  - If no features exist, use project-wide structure

**Sourcery Review Paths:**

- `docs/maintainers/feedback/sourcery/pr##.md` (consistent across all projects)

---

## Workflow Overview

**When to use:**

- After several phases/PRs completed
- When looking for quick wins or accumulated issues
- Before starting new feature work
- To clean up technical debt

**Key principle:** Review deferred issues periodically to identify opportunities for improvement and technical debt reduction.

---

## Usage

**Command:** `/fix-review [options]`

**Examples:**

- `/fix-review` - Review all old deferred issues
- `/fix-review --priority MEDIUM` - Review only MEDIUM priority issues
- `/fix-review --min-age 30` - Review issues older than 30 days
- `/fix-review --accumulated` - Find issues that have accumulated (similar issues)
- `/fix-review --quick-wins` - Find LOW effort issues (quick wins)
- `/fix-review --feature my-feature` - Specify feature name

**Options:**

- `--feature [name]` - Specify feature name (overrides auto-detection)
- `--priority LEVEL` - Filter by priority (CRITICAL, HIGH, MEDIUM, LOW)
- `--min-effort LEVEL` - Filter by minimum effort (LOW, MEDIUM, HIGH)
- `--min-age DAYS` - Only review issues older than N days
- `--accumulated` - Find issues that appear multiple times (similar issues)
- `--quick-wins` - Find LOW effort issues that can be fixed quickly
- `--by-pr` - Group issues by PR number
- `--by-file` - Group issues by affected file
- `--known-issues [path]` - Consider known CI/CD issues when reviewing (NEW)
  - Default: `admin/planning/ci/multi-environment-testing/known-issues.md`
  - Checks if fixes depend on known issues
  - Prioritizes fixes that address known issues

---

## Step-by-Step Process

### 1. Scan All Deferred Issues

**Detect feature name:**

- Use `--feature` option if provided
- Otherwise, auto-detect using same logic as `/fix-plan`:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for fix structure in each
  - If no features exist, use project-wide structure

**Sources:**

- Fix tracking document:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/README.md` (main hub)
  - Project-wide: `docs/maintainers/planning/fix/README.md` (main hub)
- PR hub files:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/pr##/README.md`
  - Project-wide: `docs/maintainers/planning/fix/pr##/README.md`
- **Deferred tasks collection (NEW):**
  - `admin/feedback/deferred-tasks.md` (centralized deferred tasks)
- Sourcery review files: `docs/maintainers/feedback/sourcery/pr##.md`
- Individual fix plans:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/pr##/batch-*.md` or `pr##/issue-*.md`
  - Project-wide: `docs/maintainers/planning/fix/pr##/batch-*.md` or `pr##/issue-*.md`
- Archived fixes:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/archived/pr##/`
  - Project-wide: `docs/maintainers/planning/fix/archived/pr##/`

**Extract from fix tracking:**

- Issue ID (PR##-#N)
- Priority, Impact, Effort
- Description
- File location
- Age (days since PR merged)
- Status (deferred, not fixed, etc.)

**Extract from deferred tasks collection:**

- Task number (Task N)
- Source PR and comment number
- Priority, Impact, Effort
- Description
- File location
- Status (Planned, Deferred, etc.)
- Age (if date available)

**Checklist:**

- [ ] Feature name detected or specified
- [ ] All deferred issues identified from fix tracking
- [ ] All deferred issues identified from deferred tasks collection (NEW)
- [ ] Age calculated for each issue
- [ ] Status verified (not already fixed)
- [ ] Duplicates identified (same issue in both sources)

---

### 2. Filter and Group Issues

**Apply filters:**

- Priority filter (if specified)
- Effort filter (if specified)
- Age filter (if specified)
- Accumulation filter (if specified)

**Group by:**

- **By PR:** All issues from same PR together
- **By File:** Issues affecting same file together
- **By Type:** Similar issues (e.g., all test improvements)
- **By Priority:** Highest priority first

**Checklist:**

- [ ] Filters applied
- [ ] Issues grouped logically
- [ ] Duplicates identified

---

### 3. Identify Candidates

**Criteria for addressing:**

1. **Accumulated Issues**

   - Same issue appears multiple times
   - Similar issues that can be batched
   - Example: Multiple "use click.Choice" suggestions

2. **Quick Wins**

   - LOW effort, LOW priority
   - Can be fixed quickly
   - Example: Style improvements, minor refactors

3. **Blocking Issues**

   - Fixing enables other improvements
   - Reduces technical debt
   - Example: Code duplication that blocks refactoring

4. **Old Issues**

   - Been deferred for a while
   - Code may have changed making fix easier
   - Example: Issues from early PRs

5. **Related to Current Work**
   - Fixing while working on related code
   - Reduces context switching
   - Example: CLI improvements while adding CLI features

**Checklist:**

- [ ] Accumulated issues identified
- [ ] Quick wins identified
- [ ] Blocking issues identified
- [ ] Old issues reviewed
- [ ] Related issues noted

---

### 4. Generate Review Report

**Report Location:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/fix-review-report-YYYY-MM-DD.md`
- Project-wide: `docs/maintainers/planning/fix/fix-review-report-YYYY-MM-DD.md`

**Report Format:**

```markdown
# Fix Review Report

**Date:** YYYY-MM-DD  
**Total Deferred Issues:** [N]  
**Candidates for Addressing:** [M]

---

## Summary

- **Accumulated Issues:** [X] (can batch together)
- **Quick Wins:** [Y] (LOW effort, can fix quickly)
- **Blocking Issues:** [Z] (enable other improvements)
- **Old Issues:** [W] (deferred for [N] days)

---

## Accumulated Issues

### Issue Type: [Description]

**Occurrences:** [N] times  
**PRs:** #[N1], #[N2], #[N3]  
**Total Effort:** [Effort Level]

**Issues:**

- PR##-#N: [Description] ([Priority], [Effort])
- PR##-#M: [Description] ([Priority], [Effort])
- PR##-#K: [Description] ([Priority], [Effort])

**Recommendation:** Batch together in single fix plan

---

## Quick Wins

| Issue   | Priority | Effort | Age      | Description   |
| ------- | -------- | ------ | -------- | ------------- |
| PR##-#N | 🟢 LOW   | 🟢 LOW | [N] days | [Description] |

**Recommendation:** Create quick-wins batch

---

## Blocking Issues

| Issue   | Priority  | Effort    | Blocks           | Description   |
| ------- | --------- | --------- | ---------------- | ------------- |
| PR##-#N | 🟡 MEDIUM | 🟡 MEDIUM | [What it blocks] | [Description] |

**Recommendation:** Address before [blocked work]

---

## Old Issues (30+ days)

| Issue   | Priority  | Effort | Age      | Description   |
| ------- | --------- | ------ | -------- | ------------- |
| PR##-#N | 🟡 MEDIUM | 🟢 LOW | [N] days | [Description] |

**Recommendation:** Review if still relevant

---

## Related to Known Issues (NEW - if --known-issues provided)

| Issue   | Priority  | Effort  | Related Known Issue | Relationship | Description                            |
| ------- | --------- | ------- | ------------------- | ------------ | -------------------------------------- |
| PR##-#N | 🟡 MEDIUM | 🟠 HIGH | Known Issue #1      | Depends on   | Fix blocked until known issue resolved |
| PR##-#M | 🟡 MEDIUM | 🟢 LOW  | Known Issue #2      | Addresses    | Fix would resolve known issue          |

**Recommendation:** Prioritize fixes that address known issues. Defer fixes that depend on known issues until known issue is resolved.

---

## Recommendations

1. **Immediate:** [Top recommendation]
2. **Next:** [Second recommendation]
3. **Future:** [Long-term recommendation]
4. **Known Issues:** [Recommendations related to known issues, if applicable]
```

**Checklist:**

- [ ] Report generated
- [ ] Report saved to correct location
- [ ] Candidates identified
- [ ] Recommendations provided
- [ ] Report saved for reference

---

### 5. Create Fix Plans (Optional)

**If issues are worth addressing:**

1. **Use `/fix-plan --from-review-report` command:**

   ```bash
   # Create batches from latest review report
   /fix-plan --from-review-report fix-review-report-YYYY-MM-DD.md

   # Create specific batch from report
   /fix-plan --from-review-report fix-review-report-YYYY-MM-DD.md --batch "Quick Wins"

   # Create only Quick Wins batch
   /fix-plan --from-review-report --quick-wins
   ```

2. **The command will:**

   - Parse review report recommendations
   - Resolve issue details from source PRs
   - Create cross-PR batches
   - Update fix tracking

3. **Or manually create batches:**
   - Group accumulated issues
   - Create quick-wins batch
   - Address blocking issues first

**Checklist:**

- [ ] Review report saved
- [ ] Fix plans created using `/fix-plan --from-review-report` (if addressing)
- [ ] Fix tracking updated
- [ ] Issues marked as planned

---

## Common Scenarios

### Scenario 1: Accumulated Similar Issues

**Situation:** Multiple PRs have similar issues (e.g., "use click.Choice")

**Action:**

- Identify all occurrences
- Create single batch for all
- Fix once, addresses multiple PRs

**Example:**

- PR #10: Use click.Choice for status
- PR #12: Use click.Choice for status
- PR #15: Use click.Choice for classification
  → Batch together: "CLI validation improvements"

---

### Scenario 2: Quick Wins

**Situation:** Many LOW effort, LOW priority issues accumulated

**Action:**

- Create quick-wins batch
- Fix all in single PR
- Clean up technical debt

**Example:**

- 5 LOW/LOW issues from different PRs
  → Batch: "Code quality quick wins"

---

### Scenario 3: Blocking Refactoring

**Situation:** Code duplication issue blocking other improvements

**Action:**

- Prioritize fixing duplication
- Enables cleaner refactoring
- Reduces future technical debt

**Example:**

- PR #8 Overall: Code duplication
  → Fix before major refactoring work

---

## Tips

### When to Review

- **After each phase:** Quick review of new deferred issues
- **Monthly:** Comprehensive review of all deferred issues
- **Before major refactoring:** Check for blocking issues
- **When looking for work:** Find quick wins or accumulated issues

### What to Look For

- **Patterns:** Similar issues across PRs
- **Accumulation:** Many small issues that can batch
- **Dependencies:** Issues that block other work
- **Age:** Old issues that may be easier now

### Prioritization

1. **Blocking issues** (enable other work)
2. **Accumulated issues** (fix once, helps many)
3. **Quick wins** (easy, builds momentum)
4. **Old issues** (if still relevant)

---

## Reference

**Fix Tracking:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/README.md` (main hub)
- Project-wide: `docs/maintainers/planning/fix/README.md` (main hub)
- PR hubs: `docs/maintainers/planning/features/[feature-name]/fix/pr##/README.md` or `docs/maintainers/planning/fix/pr##/README.md`
- Archive hub: `docs/maintainers/planning/features/[feature-name]/fix/archived/README.md` or `docs/maintainers/planning/fix/archived/README.md`

**Sourcery Reviews:**

- `docs/maintainers/feedback/sourcery/pr##.md`

**Review Reports:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/fix/fix-review-report-YYYY-MM-DD.md`
- Project-wide: `docs/maintainers/planning/fix/fix-review-report-YYYY-MM-DD.md`

**Deferred Tasks:**

- `admin/feedback/deferred-tasks.md` (centralized deferred tasks collection)

**Known Issues:**

- `admin/planning/ci/multi-environment-testing/known-issues.md` (known issues registry)

**Related Commands:**

- `/fix-plan` - Create fix plans from review report
- `/fix-implement` - Implement fix batches

---

**Last Updated:** 2025-12-08  
**Status:** ✅ Active  
**Next:** Run periodically to identify fix opportunities (supports feature-specific and project-wide fix structures, reads from deferred tasks collection, supports known issues integration)
