# PR Validation & Review Command

Use this command when a PR is already open to run manual testing, update documentation, and perform code review in one workflow.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns, matching `/pr` and `/post-pr`:

1. **Feature-Specific Structure (default):**

   - Manual testing: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
   - Phase documents: `docs/maintainers/planning/features/[feature-name]/phase-N.md`
   - Sourcery reviews: `docs/maintainers/feedback/sourcery/pr##.md` (for generated projects)

2. **Project-Wide Structure:**
   - Manual testing: `docs/maintainers/planning/manual-testing.md` (if exists)
   - Phase documents: `docs/maintainers/planning/phases/phase-N.md`
   - Sourcery reviews: `docs/maintainers/feedback/sourcery/pr##.md` (for generated projects)

**Note:** For dev-infra project, feedback docs are currently in `admin/feedback/sourcery/pr##.md`. This will be moved to `docs/maintainers/feedback/sourcery/pr##.md` as part of the admin docs migration to `docs/maintainers/`.

**Feature Detection:**

- Auto-detect from PR branch name or phase number
- Use `--feature` option if provided
- Otherwise, detect using same logic as other commands:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for phase/manual testing structure
  - If no features exist, use project-wide structure

**Sourcery Review:**

- Review tool: `dt-review` (REQUIRED - always run this tool)
- Review output:
  - Dev-infra project: `admin/feedback/sourcery/pr##.md` (current location)
  - Generated projects: `docs/maintainers/feedback/sourcery/pr##.md` (template structure)
- **IMPORTANT:** Always run `dt-review` explicitly - do NOT assume GitHub's Sourcery integration check is sufficient
- **Note:** Dev-infra will migrate admin docs to `docs/maintainers/` structure (see admin docs migration note)

---

## Workflow Overview

**When to use:**

- PR is already created and open
- Need to validate features with manual testing
- Need to run Sourcery review (dt-review, if available)
- Want to update manual testing guide with scenarios

**Key principle:** Combines manual testing execution, documentation updates, and code review into a single workflow.

---

## Usage

**Command:** `/pr-validation [pr-number] [phase-number] [options]`

**Examples:**

- `/pr-validation 12 4` - Validate PR #12 for Phase 4
- `/pr-validation 10 3` - Validate PR #10 for Phase 3
- `/pr-validation 12 4 --feature my-feature` - Specify feature name

**Options:**

- `--feature [name]` - Specify feature name (overrides auto-detection)
- `--skip-manual-testing` - Skip manual testing (auto-detected for non-feature PRs)
- `--force-manual-testing` - Force manual testing even for non-feature PRs

**Note:** There is no `--skip-review` option. Sourcery review via `dt-review` is REQUIRED.

---

## Step-by-Step Process

### 1. Verify PR Status

**Check PR exists and is open:**

```bash
gh pr view [pr-number] --json state,title,headRefName
```

**Expected:**

- PR state: `OPEN`
- PR title matches phase/fix/release
- Head branch exists

**Checklist:**

- [ ] PR exists and is open
- [ ] PR number is valid
- [ ] Head branch accessible

---

### 1a. Restore Unrelated Files (Cursor IDE Bug Fix)

**Issue:** Cursor IDE may modify unrelated files when opening them. These should be restored before proceeding.

**Process:**

1. **Check modified files:**

   ```bash
   git status --short
   ```

2. **Identify phase/fix-related files:**

   - Review what files should actually be modified for this PR
   - Keep only files that are part of the implementation

3. **Restore unrelated files:**

   ```bash
   # Restore all unrelated files (adjust paths as needed)
   git restore [unrelated-file-1] [unrelated-file-2] ...

   # Or restore all modified files except phase-specific ones
   git restore $(git diff --name-only | grep -v "phase-[N]\.md\|[relevant-files]")
   ```

4. **Verify only relevant files remain:**
   ```bash
   git status --short
   ```

**Common unrelated files to restore:**

- `__init__.py` files (often just whitespace changes)
- Documentation files unrelated to the PR
- Frontend files (if backend PR)
- Config files (`.gitignore`, `pytest.ini`, `requirements.txt`) unless actually changed

**After restoration:**

- [ ] Only PR-related files remain modified
- [ ] No accidental changes to unrelated code
- [ ] Ready to proceed with validation

---

### 1b. Status Validation (NEW)

**Purpose:** Verify that phase and feature status documents are current before proceeding with PR validation. This ensures status updates happen during work, not just at PR creation time.

**When to check:**

- Before proceeding with manual testing
- After PR is verified to be open
- As part of PR validation workflow

**Status Check Process:**

1. **Detect feature name:**

   - Use `--feature` option if provided
   - Otherwise, auto-detect from PR branch name or phase number:
     - Check if `docs/maintainers/planning/features/` exists
     - If single feature exists, use that feature name
     - If multiple features exist, search for phase documents
     - If no features exist, use project-wide structure

2. **Read phase document:**

   - Feature-specific: `docs/maintainers/planning/features/[feature-name]/phase-N.md`
   - Project-wide: `docs/maintainers/planning/phases/phase-N.md`
   - Check status field at top of document
   - Verify all task checkboxes are marked complete
   - Verify status matches actual work completed

3. **Read feature status document (if applicable):**

   - Feature-specific: `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`
   - Project-wide: `docs/maintainers/planning/status-and-next-steps.md` (if exists)
   - Check phase completion status
   - Verify progress tracking is current
   - Verify next steps are accurate

4. **Validate consistency:**
   - Phase document status matches feature status
   - Progress percentages are accurate
   - No discrepancies between documents

**Status Validation Checklist:**

- [ ] Phase document status is current
  - Location: `docs/maintainers/planning/features/[feature-name]/phase-N.md` or `docs/maintainers/planning/phases/phase-N.md`
  - Verify: Status reflects actual completion state
  - Expected: `**Status:** ✅ Complete` (if phase is complete) or `**Status:** 🟠 In Progress` (if still in progress)
- [ ] Feature status document is current (if applicable)
  - Location: `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`
  - Verify: Phase marked appropriately, progress updated
  - Expected: Phase status matches phase document
- [ ] Progress tracking is accurate
  - Verify: Progress percentages reflect actual completion
  - Verify: Task checkboxes match completed work
  - Verify: No outdated status indicators

**Status Check Examples:**

**Phase Document:**

```markdown
**Status:** ✅ Complete # Should match actual completion state
```

**Feature Status Document:**

```markdown
**Phase 3: Documentation & Examples**

- [x] Dependency sections added ✅ (2025-12-07)
- [x] Dependency documentation created ✅ (2025-12-07)
- Status: ✅ Complete
```

**If status is not current:**

**Warning (Lenient Approach):**

- ⚠️ **Warning:** Status documents may be outdated
- ⚠️ **Recommendation:** Update status documents before proceeding
- ⚠️ **Note:** This is a warning, not a blocker - validation can continue
- Document the warning in the summary report
- Suggest updating status documents

**Action Items (if status outdated):**

- [ ] Update phase document status if needed
- [ ] Update feature status document if needed
- [ ] Commit status updates if made
- [ ] Note status update in PR description

**Note:** This validation uses a **lenient approach** (warnings, not blockers) to start. Validation strictness can be tightened based on feedback from real PR usage.

**Checklist:**

- [ ] Feature name detected or specified
- [ ] Phase document found and read
- [ ] Feature status document found and read (if applicable)
- [ ] Status documents validated
- [ ] Warnings documented if status outdated
- [ ] Ready to proceed with validation

---

### 1c. Check GitHub Actions/CI-CD Status (NEW)

**Purpose:** Verify that all GitHub Actions workflows and CI/CD jobs are passing before proceeding with PR validation. Failed CI/CD jobs should be addressed before merge.

**When to check:**

- After verifying PR is open
- Before proceeding with manual testing
- As part of PR validation workflow

**Process:**

1. **Check GitHub Actions status for PR:**

   ```bash
   gh pr checks [pr-number]
   ```

   **Expected output shows:**

   - All checks passing (✅)
   - Or any failing checks (❌)
   - Check names and status

2. **Get detailed check information:**

   ```bash
   gh pr checks [pr-number] --json name,state,url
   ```

   **Expected JSON structure:**

   ```json
   [
     {
       "name": "CI / Test",
       "state": "SUCCESS",
       "url": "https://github.com/..."
     },
     {
       "name": "CI / Lint",
       "state": "FAILURE",
       "url": "https://github.com/..."
     }
   ]
   ```

   **Note:** The `state` field can be: `SUCCESS`, `FAILURE`, `PENDING`, `ERROR`, etc.

3. **Identify failed checks:**

   - Filter for `"state": "FAILURE"` or `"state": "ERROR"`
   - Note check names and URLs
   - Check if checks are required for merge

4. **Check required checks:**

   ```bash
   gh pr view [pr-number] --json mergeable,mergeStateStatus
   ```

   **Expected:**

   - `mergeable`: `true` (if all required checks pass)
   - `mergeStateStatus`: `CLEAN` (if all checks pass)

**CI/CD Status Validation:**

- [ ] All GitHub Actions checks passing
  - Verify: `gh pr checks [pr-number]` shows all ✅
  - Expected: No ❌ checks
- [ ] No failed CI/CD jobs
  - Verify: All workflow runs completed successfully
  - Expected: No failed workflows
- [ ] Required checks passing
  - Verify: `mergeable: true` and `mergeStateStatus: CLEAN`
  - Expected: PR is mergeable

**If checks are failing:**

**Warning (Lenient Approach):**

- ⚠️ **Warning:** Some CI/CD checks are failing
- ⚠️ **Recommendation:** Address failing checks before merge
- ⚠️ **Note:** This is a warning, not a blocker - validation can continue
- Document the warning in the summary report
- List failed checks and their URLs
- Suggest investigating and fixing failures

**Action Items (if checks failing):**

- [ ] Review failed check logs (use URLs from check output)
- [ ] Identify root cause of failures
- [ ] Fix issues causing failures
- [ ] Push fixes to PR branch
- [ ] Wait for checks to re-run
- [ ] Verify checks pass before merge

**Common CI/CD Check Types:**

- **Test Suite:** Unit tests, integration tests, test coverage
- **Linting:** Code style, formatting, static analysis
- **Build:** Compilation, build verification
- **Security:** Security scanning, dependency checks
- **Documentation:** Documentation validation, link checking

**Checklist:**

- [ ] GitHub Actions status checked
- [ ] All checks passing (or warnings documented)
- [ ] Failed checks identified (if any)
- [ ] Check URLs documented (if failures)
- [ ] Ready to proceed with validation (or blocked by failures)

---

### 1d. Check Known Issues Registry (NEW)

**Purpose:** Identify if failures match known issues with fixes pending. This prevents blocking PR validation for issues that are already documented and have fixes planned.

**When to check:**

- After identifying failed checks
- Before blocking PR validation
- To avoid duplicate failure documentation

**Process:**

1. **Read known issues registry:**

   - Location: `admin/planning/ci/multi-environment-testing/known-issues.md`
   - Check if failed job matches any active known issue
   - Compare job names and error patterns

2. **Match failure to known issue:**

   - Compare job name (e.g., `full-tests-ubuntu`, `full-tests-macos`)
   - Compare error patterns (if error messages available)
   - Check if symptoms match known issue description

3. **If match found:**

   - Note: "Failure matches Known Issue #[number]"
   - Reference known issue in summary
   - Link to fix tracking
   - **Action:** Document failure but don't block PR validation
   - Add PR number to "PRs Affected" list in known issues registry
   - Update failure document to reference known issue

4. **If no match:**

   - This is a new issue
   - Document as new failure
   - Create new known issue entry if fix is pending
   - Block PR validation if critical (CRITICAL/HIGH priority)
   - Allow PR validation to proceed if MEDIUM/LOW priority (with warning)

**Known Issue Match Example:**

```markdown
### CI/CD Status

- GitHub Actions checks: Some checks failing
  - `full-tests-ubuntu`: FAIL ❌
  - **Known Issue:** Matches Known Issue #1 (full-tests-ubuntu intermittent failures)
  - **Status:** Fix pending in multi-environment-testing topic
  - **Reference:** `admin/planning/ci/multi-environment-testing/known-issues.md`
  - **Action:** Documented, not blocking PR validation (local tests passing)
```

**Update Known Issues Registry:**

**File:** `admin/planning/ci/multi-environment-testing/known-issues.md`

**Add PR to "PRs Affected" list:**

```markdown
**PRs Affected:**

- PR #30: Documented failure (2025-12-08)
- PR #[number]: Documented failure (YYYY-MM-DD)
```

**Checklist:**

- [ ] Known issues registry checked
- [ ] Failure matched to known issue (if applicable)
- [ ] Known issue updated with PR number (if match found)
- [ ] PR validation proceeds (if known issue)
- [ ] New issue documented (if no match)
- [ ] Failure document created/updated

---

### 1e. Determine Manual Testing Applicability (NEW)

**Purpose:** Automatically determine if this PR requires manual testing based on PR type, branch name, and file changes. Not all PRs need manual testing scenarios.

**When manual testing IS required:**

| PR Type | Branch Pattern | Requires Manual Testing |
|---------|----------------|------------------------|
| Feature (new functionality) | `feat/*` | ✅ Yes - new user-facing features need scenarios |
| Feature (phase work) | `feat/*-phase-*` | ✅ Yes - phase work adds functionality |
| Fix (user-facing) | `fix/*` with UI/API changes | ✅ Yes - need regression scenarios |
| Script/Command changes | Any with `scripts/` or `.cursor/commands/` changes | ✅ Yes - CLI functionality needs testing |

**When manual testing is NOT required:**

| PR Type | Branch Pattern | Requires Manual Testing |
|---------|----------------|------------------------|
| Documentation only | `docs/*` | ❌ No - no user-facing changes |
| Chore/maintenance | `chore/*` | ❌ No - internal changes only |
| CI/CD changes | `ci/*` | ❌ No - infrastructure only |
| Fix (internal only) | `fix/*` with no UI/API changes | ❌ No - covered by unit tests |
| Refactoring | `refactor/*` | ❌ No - no new functionality |
| Template-only changes | Changes only to `templates/` docs | ⚠️ Maybe - depends on scope |

**Detection Process:**

1. **Extract branch type from PR head branch:**
   ```bash
   gh pr view [pr-number] --json headRefName --jq '.headRefName'
   ```
   
2. **Identify branch type:**
   - `feat/*` → Feature PR
   - `fix/*` → Fix PR
   - `docs/*` → Documentation PR
   - `chore/*` → Chore PR
   - `ci/*` → CI/CD PR
   - `refactor/*` → Refactoring PR

3. **For feature/fix PRs, analyze file changes:**
   ```bash
   gh pr diff [pr-number] --name-only
   ```
   
   - Check if changes include: `scripts/`, `.cursor/commands/`, API files, UI files
   - If only docs/templates changed → May skip manual testing

4. **Make determination:**
   - **Requires manual testing:** Proceed to Step 2
   - **Does NOT require manual testing:** Skip to Step 4 (Sourcery Review)
   - **Uncertain:** Ask user or default to requiring manual testing

**Output:**

```markdown
### Manual Testing Applicability

**PR Type:** [feat/fix/docs/chore/ci/refactor]
**Branch:** [branch-name]
**File Changes:** [summary of changed files]

**Determination:** [✅ Required / ❌ Not Required / ⚠️ Uncertain]
**Reason:** [explanation]

[If not required]
**Skipping manual testing:** No new user-facing functionality detected.
**To override:** Use `--force-manual-testing` flag.
```

**Checklist:**

- [ ] Branch type identified
- [ ] File changes analyzed (if feat/fix)
- [ ] Manual testing determination made
- [ ] User informed of determination
- [ ] Override option noted (if skipping)

---

### 2. Update Manual Testing Guide (CONDITIONAL)

**Applicability:** This step is **conditional** based on Step 1e determination.

- **If manual testing required:** Proceed with this step
- **If manual testing NOT required:** Skip to Step 4 (Sourcery Review)
- **If `--force-manual-testing` provided:** Proceed with this step regardless of determination
- **If `--skip-manual-testing` provided:** Skip to Step 4 (Sourcery Review)

---

#### ⚠️ IMPORTANT: Manual Testing Guides Are for HUMAN Users

**Manual testing guides are written for HUMAN team members to follow, NOT for the AI agent to run tests locally.**

**Purpose of manual testing guides:**
- 📖 **Documentation for humans** - Step-by-step instructions any team member can follow
- 🔍 **User verification** - Allows humans to manually verify features work as expected
- 📝 **Reference material** - Persists in the repo as a testing reference for the feature
- 🎓 **Knowledge transfer** - New team members can understand how to test the feature

**Manual testing guides are NOT:**
- ❌ Tests the AI agent runs during PR validation
- ❌ A checklist only the AI uses internally
- ❌ Automated test scripts (those go in `tests/`)

---

#### 2a. Check if Manual Testing Guide Exists

**Detect feature name:**

- Use `--feature` option if provided
- Otherwise, auto-detect from PR branch or phase number:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for manual testing guide
  - If no features exist, use project-wide structure

**File locations:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
- Project-wide: `docs/maintainers/planning/manual-testing.md` (if exists)
- Dev-infra: `admin/services/[service]/features/[feature-name]/planning/manual-testing.md`

**Check if guide exists:**

```bash
# Feature-specific (adjust path for project structure)
ls docs/maintainers/planning/features/[feature-name]/manual-testing.md

# Or for dev-infra
ls admin/services/[service]/features/[feature-name]/planning/manual-testing.md
```

**If guide does NOT exist:**

1. **STOP and create the guide first** - A feature PR with user-facing changes MUST have a manual testing guide
2. **Create the guide using the template below** (Section 2b)
3. **Add scenarios for ALL phases completed so far** (not just current phase)
4. **Commit the guide to the feature branch** before proceeding

**If guide exists:**

- Proceed to Section 2c (Add scenarios for current phase)

---

#### 2b. Create Manual Testing Guide (If Missing)

**When to create:** When manual testing is required (feat/fix PR) but no guide exists.

**Template:**

```markdown
# Manual Testing Guide - [Feature Name]

**Feature:** [Feature Name]  
**Phases Covered:** [List phases, e.g., 1, 2, 3]  
**Last Updated:** [YYYY-MM-DD]  
**Status:** ✅ Active

---

## 📋 Overview

This guide provides step-by-step instructions for manually verifying the [feature name] feature. These tests are designed for **human testers** to validate functionality beyond what automated tests cover.

**Purpose:**
- Verify user-facing functionality works as expected
- Test edge cases and error handling
- Validate documentation and user experience
- [Feature-specific purpose]

**Prerequisites:**
- [List prerequisites: server running, dependencies, etc.]
- [Access requirements]
- [Test data requirements]

---

## 🧪 Phase N: [Phase Name]

### Scenario N.1: [Scenario Name]

**Objective:** [What this test verifies]

**Steps:**

1. [Step 1]
   ```bash
   [Command or action]
   ```

2. [Step 2]

3. [Step 3]

**Expected Result:** ✅ [What success looks like]

---

[Additional scenarios...]

---

## 🧹 Cleanup

After completing manual testing:

```bash
[Cleanup commands]
```

---

## ✅ Acceptance Criteria Checklist

### Phase N: [Phase Name]
- [ ] Scenario N.1 passes
- [ ] Scenario N.2 passes
- [ ] [etc.]

---

## 📝 Notes for Testers

1. [Important note 1]
2. [Important note 2]
3. **Report Issues:** If any scenario fails, document exact steps, expected vs actual results, and error messages.

---

## 🔗 Related Documents

- **Feature Plan:** [link]
- **Phase Documents:** [links]

---

**Last Updated:** [YYYY-MM-DD]
```

**Key principles for the guide:**

1. **Write for humans** - Clear, step-by-step instructions anyone can follow
2. **Include context** - Explain what each scenario verifies and why
3. **Provide cleanup** - Show how to reset after testing
4. **Cover all phases** - Include scenarios for ALL completed phases, not just current
5. **Be specific** - Include exact commands, expected outputs, and success criteria

---

#### 2c. Add Scenarios for Current Phase

**When this step applies:** Only for PRs with new user-facing functionality (determined in Step 1e).

**Process:**

1. **Review PR changes to identify new features:**

   - Check what endpoints/commands were added/modified
   - Identify all user-facing functionality
   - Note any validation or error handling changes

2. **Check if scenarios exist:**

   - Search manual testing guide for relevant scenarios
   - Check if all new features are covered
   - Verify scenarios match current implementation

3. **Add missing scenarios:**

   - If scenarios are missing, add them using the template below
   - For phase PRs: Add scenarios for all new functionality
   - For fix PRs: Add scenarios if validation/error handling changed
   - Use consistent format and numbering

4. **Update header if needed:**

   - Add PR number to header if not already listed
   - Update "Last Updated" date
   - Note which scenarios were added for this PR

5. **Update acceptance criteria:**
   - Add checkboxes for new functionality
   - Ensure all new features are covered

**Scenario Template:**

````markdown
### Scenario N: [Feature Name] - [Test Type]

**Test:** [Brief description]

**Prerequisites:** [Any setup needed]

**[API/CLI] Test:**

```bash
[Command or curl example]
# Expected: [Expected result]
```
````

**Verification:**

```bash
[Verification command]
# Expected: [What to verify]
```

**Expected Result:** ✅ [Success criteria]

````

**Common scenarios to add:**

**For Filtering Features:**
- Filter by each filter type
- Multiple filters combined
- Invalid filter values
- Empty results
- CLI filter flags

**For Search Features:**
- Search by various fields
- Case-insensitive search
- Partial match
- No results found
- Combined with filters
- CLI search flag

**For New Endpoints:**
- Basic functionality (happy path)
- Error cases (404, 400, validation)
- Edge cases
- CLI equivalent (if applicable)

**After updating:**

- [ ] Scenarios added for all new functionality
- [ ] Header updated with PR number
- [ ] Acceptance criteria updated
- [ ] Scenarios committed to PR branch
- [ ] Note which scenarios were added

---

### 3. Run Manual Testing Scenarios (CONDITIONAL)

**Applicability:** This step is **conditional** - only runs if Step 2 was executed (manual testing is required).

- **If manual testing required:** Proceed with this step
- **If manual testing NOT required:** Skip to Step 4 (Sourcery Review)

**Location:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
- Project-wide: `docs/maintainers/planning/manual-testing.md` (if exists)

**Prerequisites:**

- Backend server running (project-specific command)
  - Example: `cd backend && python run.py`
  - Example: `npm start` or project-specific command
- Server accessible (project-specific URL)
  - Example: `http://localhost:5000`
  - Health check: `curl http://localhost:5000/api/health` (or project-specific)

**Process:**

1. **Identify scenarios to test:**
   - Review manual testing guide
   - Find scenarios for this phase/fix
   - Note scenario numbers (e.g., "Scenarios 16-28 for Phase 4")

2. **Run scenarios in order:**
   - Some scenarios depend on previous state
   - Run each scenario completely
   - Document results (✅ pass / ❌ fail)

3. **For each scenario:**

   **API Tests:**
   ```bash
   # Run curl command from scenario
   curl [endpoint] [options]

   # Verify response matches expected
   # Check status code, JSON structure, values
````

**CLI Tests:**

```bash
# Navigate to CLI directory (project-specific)
cd [cli-directory]

# Run CLI command from scenario
[project-cli] [command] [options]

# Verify output matches expected
# Check formatting, values, error messages
```

4. **Document results and check off scenarios:**
   - For each scenario that passes, check off its checkboxes in the manual testing guide
   - Change `- [ ]` to `- [x]` for each verification item that passes
   - Mark "Expected Result:" line with ✅ if all checks pass
   - Note any failures or issues (keep checkboxes unchecked if scenario fails)
   - Update acceptance criteria checklist at the end of the guide

**Common Issues:**

- **Database state:** If scenarios fail due to missing data, check prerequisites
- **Server not running:** Ensure backend is running before testing
- **Port conflicts:** Verify port is available (project-specific)
- **CLI path:** Ensure you're in the correct directory for CLI commands

**After manual testing:**

- [ ] All scenarios passed
- [ ] Checkboxes checked off (`- [ ]` → `- [x]`) for passing scenarios
- [ ] Expected Result lines marked with ✅ for passing scenarios
- [ ] Any failures documented (keep checkboxes unchecked)
- [ ] Acceptance criteria updated
- [ ] Results committed to PR branch

---

### 4. Run Sourcery Review (dt-review) - REQUIRED

**IMPORTANT:** This step is REQUIRED. Always run `dt-review` explicitly.

- Do NOT assume GitHub's Sourcery integration check is sufficient
- The GitHub check only indicates if Sourcery found issues, it does NOT generate the review file
- You MUST run `dt-review` to create the review file and fill out the priority matrix

**Process:**

1. **Navigate to project directory:**

   ```bash
   cd [project-directory]
   ```

2. **Ensure output directory exists:**

   ```bash
   # For dev-infra:
   mkdir -p admin/feedback/sourcery
   
   # For generated projects:
   mkdir -p docs/maintainers/feedback/sourcery
   ```

3. **Run review with custom path (ALWAYS RUN THIS):**

   ```bash
   # For dev-infra:
   dt-review [pr-number] admin/feedback/sourcery/pr##.md
   
   # For generated projects:
   dt-review [pr-number] docs/maintainers/feedback/sourcery/pr##.md
   ```

   **Example:**

   ```bash
   dt-review 47 admin/feedback/sourcery/pr47.md
   ```

   **Note:** The `dt-review` command should be available in PATH. If not found, check if dev-toolkit is installed.

4. **Review will be saved directly to:**
   - Dev-infra: `admin/feedback/sourcery/pr##.md`
   - Generated projects: `docs/maintainers/feedback/sourcery/pr##.md`

**Expected:**

- Review file created/updated
- Contains Sourcery comments and suggestions
- Organized by file/line number
- Ready for priority matrix assessment

**If `dt-review` fails:**

- Check if dev-toolkit is installed: `which dt-review`
- Verify PR number is correct
- Check network connectivity
- Document the failure and investigate before proceeding

**Checklist:**

- [ ] `dt-review` command executed (REQUIRED)
- [ ] Review file created
- [ ] Review file committed to PR branch (if on PR branch) or noted for later

---

### 5. Fill Out Priority Matrix - REQUIRED

**File:**

- Dev-infra: `admin/feedback/sourcery/pr##.md` (current location)
- Generated projects: `docs/maintainers/feedback/sourcery/pr##.md` (template structure)

**IMPORTANT:** This step is REQUIRED after running `dt-review`. Fill out the priority matrix for all comments.

**For each Sourcery comment:**

Add priority assessment after the comment:

```markdown
**Priority:** CRITICAL 🔴 / HIGH 🟠 / MEDIUM 🟡 / LOW 🟢
**Impact:** CRITICAL 🔴 / HIGH 🟠 / MEDIUM 🟡 / LOW 🟢
**Effort:** LOW 🟢 / MEDIUM 🟡 / HIGH 🟠 / VERY_HIGH 🔴
**Action:** Fix now / Defer to next PR / Document for future
```

**Priority Guidelines:**

**CRITICAL 🔴:**

- Security vulnerabilities
- Data loss risks
- Breaking API changes
- Test failures

**HIGH 🟠:**

- Performance issues
- Code quality problems
- Maintainability concerns
- Missing error handling

**MEDIUM 🟡:**

- Code style improvements
- Refactoring opportunities
- Documentation gaps
- Minor optimizations

**LOW 🟢:**

- Naming suggestions
- Style preferences
- Minor readability improvements
- Optional enhancements

**After priority matrix:**

- [ ] All comments assessed
- [ ] CRITICAL/HIGH items identified
- [ ] Action plan documented
- [ ] Matrix committed to PR branch

---

### 5a. Update Deferred Tasks Collection (NEW)

**Purpose:** Centralize all deferred issues (MEDIUM/LOW priority) in one location for easy tracking and future review.

**When to update:**

- After filling out priority matrix
- Only for MEDIUM/LOW priority issues that are deferred
- CRITICAL/HIGH issues should be addressed, not deferred

**Process:**

1. **Read deferred tasks file:**

   - Location: `admin/feedback/deferred-tasks.md`
   - Parse existing tasks to avoid duplicates
   - Check if file exists, create if needed

2. **For each deferred issue (MEDIUM/LOW priority):**

   - Extract issue details from priority matrix:
     - Issue ID (PR##-#N or PR##-Overall-#N)
     - Priority, Impact, Effort
     - Description
     - File location (if available)
     - Source PR number
   - Check if already exists (by PR number and description)
   - If new: Add to appropriate section
   - If exists: Update status/age (if needed)

3. **Organize by Priority/Effort combination:**

   - **MEDIUM/HIGH:** High effort, medium priority (requires significant work)
   - **MEDIUM/MEDIUM:** Medium effort, medium priority
   - **MEDIUM/LOW:** Low effort, medium priority
   - **LOW/LOW:** Low effort, low priority (quick wins)

4. **Add to appropriate section:**

   ```markdown
   ## 🟡 Medium Priority Tasks

   ### Code Quality & Maintainability

   #### Task [N]: [Description]

   - **Source:** PR #[number] - Sourcery Comment #[N] (or Overall Comment #[N])
   - **Location:** [file-path]:[line-range] - [function/area]
   - **Priority:** 🟡 MEDIUM
   - **Impact:** 🟡 MEDIUM / 🟢 LOW
   - **Effort:** 🟠 HIGH / 🟡 MEDIUM / 🟢 LOW
   - **Description:** [Full description from review]
   - **Status:** ⏸️ Deferred
   ```

5. **Update summary:**

   - Total tasks count
   - Breakdown by priority/effort
   - Last updated date
   - Add PR number to "PR #[number] Additions" section

**File Format:**

**Location:** `admin/feedback/deferred-tasks.md`

**Add new section at end:**

```markdown
## PR #[number] Additions

**Date:** YYYY-MM-DD  
**Status:** ✅ Deferred issues added to backlog

### Deferred from PR #[number]

- Task [N]: [Description] (MEDIUM priority, HIGH/MEDIUM/LOW effort)
- Task [N+1]: [Description] (LOW priority, LOW effort)
```

**Checklist:**

- [ ] Deferred tasks file read/created
- [ ] All MEDIUM/LOW deferred issues extracted
- [ ] Duplicates checked (by PR number and description)
- [ ] New tasks added to appropriate sections
- [ ] Summary updated (total count, breakdown)
- [ ] PR additions section created/updated
- [ ] File saved

**Note:** This step ensures all deferred issues are tracked centrally, making it easier for `/fix-review` to identify candidates for addressing.

---

### 6. Address Critical Issues (If Any)

**If CRITICAL 🔴 or HIGH 🟠 issues found:**

1. **Create fix branch (if not already on PR branch):**

   ```bash
   git checkout [pr-branch-name]
   ```

2. **Implement fixes:**

   - Follow fix plans (if available)
   - Write tests for fixes
   - Run full test suite
   - Commit fixes

3. **Update PR:**
   - Push fixes to PR branch
   - Update PR description with fixes
   - Re-run manual testing if needed

**If only LOW/MEDIUM issues:**

- Document in fix tracking
- Can be deferred to future PR
- Proceed with merge approval

---

### 7. Update PR Description (If Needed)

**If manual testing or review revealed issues:**

Update PR description to include:

- Manual testing results
- Sourcery review summary (if available)
- Critical issues addressed
- Deferred issues documented

**PR Description Updates:**

```markdown
## Testing

- [x] All automated tests passing ([N] tests)
- [x] Coverage: [X]% (maintained/improved)
- [x] Manual testing complete ([N] scenarios)
- [x] Sourcery review complete ([N] comments) (if available)

## Review Summary

**Sourcery Review:** (if available)

- Total comments: [N]
- CRITICAL: [N] (all addressed)
- HIGH: [N] (all addressed)
- MEDIUM: [N] (deferred to next PR)
- LOW: [N] (documented for future)

**Manual Testing:**

- Scenarios tested: [N]
- All scenarios passed: ✅
- Checkboxes checked off: ✅ (all passing scenarios marked)
- Expected Result lines marked: ✅ (all passing scenarios)
- Issues found: [None / List issues]
```

---

### 8. Summary Report

**Present to user:**

```markdown
## PR Validation Complete

**PR:** #[pr-number] - [PR Title]
**PR Type:** [feat/fix/docs/chore/ci]
**Branch:** [branch-name]

### Manual Testing

[If manual testing was required:]
- ✅ Scenarios tested: [N]
- ✅ All scenarios passed
- ✅ Checkboxes checked off for passing scenarios
- ✅ Expected Result lines marked with ✅
- ⚠️ Issues found: [None / List]

[If manual testing was NOT required:]
- ⏭️ Skipped - No new user-facing functionality
- **PR Type:** [docs/chore/ci/refactor]
- **Reason:** [explanation from Step 1e]
- **To test manually:** Re-run with `--force-manual-testing`

### Code Review (Sourcery - REQUIRED)

- ✅ `dt-review` executed
- ✅ Review file created: `admin/feedback/sourcery/pr##.md`
- ✅ Priority matrix filled out
- ⚠️ Critical/High issues: [N] (all addressed)
- ⚠️ Deferred issues (Medium/Low): [N]

### Status Validation

- ✅ Status documents validated (or ⚠️ Status warnings documented)
- ✅ Phase status current (or ⚠️ Status update recommended)
- ✅ Feature status current (or ⚠️ Status update recommended)

### Next Steps

- [ ] User review PR changes
- [ ] User approve merge (if ready)
- [ ] Merge PR
- [ ] Run `/post-pr` command for documentation updates
```

---

## Common Issues

### Issue: Manual Testing Scenarios Missing

**Solution:**

- Review PR changes to identify features
- Add scenarios using template from this command
- Ensure scenarios cover all new functionality
- Test at least one scenario to verify format

### Issue: Backend Server Not Running

**Solution:**

```bash
# Project-specific command to start server
# Example: cd backend && python run.py
# Example: npm start
```

Verify with health check (project-specific):

```bash
# Example: curl http://localhost:5000/api/health
```

### Issue: dt-review Not Found

**Solution:**

- The `dt-review` command should be available in PATH
- Try calling it directly: `dt-review [pr-number] [output-path]`
- Verify it's in PATH: `which dt-review`
- If not found, check if dev-toolkit is installed
- **Note:** Missing review is acceptable - workflow continues

### Issue: Sourcery Review File Not Created

**Solution:**

- **This is acceptable** - some PRs may not have reviews available
- Check if review completed successfully
- Verify PR number is correct
- Ensure output directory exists: `mkdir -p docs/maintainers/feedback/sourcery`
- Verify the path parameter is correct: `docs/maintainers/feedback/sourcery/pr##.md`
- Check that you're running from the project directory
- **If review is not available:** Continue without review - this is acceptable for the workflow

### Issue: Manual Testing Fails

**Solution:**

- Check database state (may need to reset, project-specific)
- Verify prerequisites for scenarios
- Check server logs for errors
- Ensure all dependencies installed
- Document failures and fix before proceeding

### Issue: GitHub Actions Checks Failing

**Solution:**

- Review failed check logs using URLs from `gh pr checks` output
- Check known issues registry for matching failures
- If matches known issue: Document and proceed (don't block)
- If new issue: Identify root cause (test failures, lint errors, build issues)
- Fix issues locally and verify
- Push fixes to PR branch
- Wait for checks to re-run
- Verify all checks pass before merge
- **Note:** Some checks may be flaky - re-run if needed
- **Note:** Known issues with fixes pending don't block PR validation

---

## Checklist Summary

**Before running command:**

- [ ] PR is open and accessible
- [ ] GitHub Actions checks reviewed (NEW)
- [ ] Known issues registry checked (NEW)
- [ ] Backend server is running (if applicable, for feat/fix PRs)
- [ ] dev-toolkit is available (REQUIRED for Sourcery review - `which dt-review`)
- [ ] Status documents are current (checked during validation)

**During execution:**

- [ ] GitHub Actions/CI-CD status checked (NEW)
- [ ] Failed checks identified and documented (if any)
- [ ] Known issues registry checked (NEW)
- [ ] Failures matched to known issues (if applicable)
- [ ] Known issues updated with PR number (if match found)
- [ ] Status documents validated (NEW)
- [ ] Status warnings documented (if status outdated)
- [ ] **Manual testing applicability determined (NEW)**
  - [ ] Branch type identified (feat/fix/docs/chore/ci)
  - [ ] File changes analyzed
  - [ ] Determination: Required / Not Required / Skipped
- [ ] Manual testing guide updated with scenarios (IF REQUIRED)
- [ ] All scenarios tested and passed (IF REQUIRED)
- [ ] Checkboxes checked off (`- [ ]` → `- [x]`) for passing scenarios (IF REQUIRED)
- [ ] Expected Result lines marked with ✅ for passing scenarios (IF REQUIRED)
- [ ] `dt-review` executed (REQUIRED)
- [ ] Priority matrix filled out (REQUIRED)
- [ ] Deferred tasks collection updated (NEW)
- [ ] Critical issues addressed (if any)

**After execution:**

- [ ] Results documented
- [ ] PR description updated (if needed)
- [ ] Summary presented to user
- [ ] Ready for user review/approval

---

## Tips

**Manual Testing:**

- Run scenarios in order (some depend on previous state)
- Document results immediately
- Take screenshots if helpful
- Note any unexpected behavior

**Code Review (Sourcery - REQUIRED):**

- ALWAYS run `dt-review` - do NOT assume GitHub's Sourcery check is sufficient
- Be thorough with priority assessment for all comments
- Don't skip LOW priority items (document them)
- Address CRITICAL items before merge
- Document deferred items clearly

**Workflow:**

- This command combines multiple steps for efficiency
- Can be run multiple times if PR is updated
- Always verify results before proceeding
- Present clear summary to user

---

## Reference

**Manual Testing:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
- Project-wide: `docs/maintainers/planning/manual-testing.md` (if exists)

**Code Review:**

- `docs/maintainers/feedback/sourcery/pr##.md`

**Deferred Tasks:**

- `admin/feedback/deferred-tasks.md` (centralized deferred tasks collection)

**Known Issues:**

- `admin/planning/ci/multi-environment-testing/known-issues.md` (known issues registry)
- `admin/planning/ci/multi-environment-testing/fix/pr##-failures.md` (failure documentation)

**PR Management:**

- GitHub CLI: `gh pr view [number]`
- PR description updates

**Related Commands:**

- `/pr --phase [N]` - Create PR and initial validation
- `/post-pr` - Post-merge documentation updates
- `/int-opp` - Document phase learnings

---

**Last Updated:** 2025-12-15  
**Status:** ✅ Active  
**Next:** Use when PR is open to validate features, run reviews, and update documentation (supports feature-specific and project-wide structures, includes known issues checking, conditional manual testing based on PR type, enforces manual testing guide creation for human users)
