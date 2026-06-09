# PR Command

Centralized command for creating pull requests for phases, fix batches, and draft PRs. Provides consistent PR creation workflow with appropriate templates and validation. Also supports draft PR workflow for continuous feedback during feature development.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns, matching `/task` and `/fix-implement`:

### Dual-Path Detection (v0.10.0+)

**Always check for the uniform structure first, then fall back to legacy phases.**

1. **Uniform Structure (preferred — v0.10.0+):**
   - Plan: `docs/maintainers/planning/features/[feature-name]/implementation-plan.md`
   - Tasks: `docs/maintainers/planning/features/[feature-name]/tasks/`
   - Status: `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`
   - Dev-infra: Same paths under `admin/services/[service]/features/`

2. **Legacy Phase Structure (fallback):**
   - Phase paths: `docs/maintainers/planning/features/[feature-name]/phase-N.md`
   - Feature plan: `docs/maintainers/planning/features/[feature-name]/feature-plan.md`

3. **Fix Structure (unchanged):**
   - Fix paths: `docs/maintainers/planning/features/[feature-name]/fix/pr##/`

4. **Project-Wide Structure (legacy):**
   - Phase paths: `docs/maintainers/planning/phases/phase-N.md`
   - Fix paths: `docs/maintainers/planning/fix/pr##/`

**Detection logic:**

```
IF implementation-plan.md exists → Use uniform structure
  - Read YAML frontmatter for task groups
  - PR description uses task/group language
  - Status references implementation-plan.md
ELSE IF feature-plan.md or phase-*.md exists → Use legacy phase structure
  - Existing phase PR workflow applies unchanged
ELSE → Error: no planning structure found
```

**Feature Detection:**

- Use `--feature` option if provided
- Otherwise, auto-detect using same logic as other commands:
  - Check if planning features directory exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for planning structure in each
  - If no features exist, use project-wide structure

### Uniform Structure PR Behavior

When `implementation-plan.md` is detected, `/pr --phase N` is **not applicable**. Instead:

- **`/pr`** (bare) — Create PR for all committed work on the feature branch. PR description includes task progress from `implementation-plan.md` checkboxes.
- **`/pr --draft`** — Create draft PR (unchanged behavior).
- **`/pr --ready`** — Mark draft ready for review (unchanged behavior).
- **`/pr --review`** — Request Sourcery review (unchanged behavior).
- **`/pr --fix`** — Fix batch PRs (unchanged behavior).
- **`/pr --release`** — Release PRs (unchanged behavior).

**PR Description for Uniform Structure:**

```markdown
## [Feature Name]

[Summary from implementation-plan.md overview]

---

## What's Included

### [Group 1 Name]
- [x] Task 1: [description]
- [x] Task 2: [description]

### [Group 2 Name]
- [x] Task 3: [description]
- [ ] Task 4: [description] (not in this PR)

---

## Progress

[X/N] tasks complete

---

## Related

- **Implementation Plan:** `[path]/implementation-plan.md`
- **Status:** `[path]/status-and-next-steps.md`
```

**Release Paths:**

- Release planning: `docs/maintainers/planning/releases/[version]/`
- Transition plan: `docs/maintainers/planning/releases/[version]/transition-plan.md`
- Release notes: `docs/maintainers/planning/releases/[version]/release-notes.md`

---

## Workflow Overview

**When to use:**

- After completing a phase (use `--phase`)
- After implementing a fix batch (use `--fix`)
- After completing release transition steps (use `--release`)
- To start a feature with early feedback (use `--draft`)
- To mark a draft PR ready for review (use `--ready`)
- To request Sourcery review on a draft PR (use `--review`)
- To create PRs with consistent formatting and validation

**Key principle:** Single command for all PR creation, with context-specific templates and workflows.

---

## Usage

**Command:** `/pr [--phase|--fix|--release] [identifier] [options]`

**Modes:**

1. **Phase PR:** `/pr --phase [phase-number]`
   - Example: `/pr --phase 4`
   - Example: `/pr --phase 4 --feature my-feature`
   - Creates PR for completed phase
   - Uses phase-specific template

2. **Fix PR:** `/pr --fix [batch-name]`
   - Example: `/pr --fix pr12-batch-medium-low-01`
   - Example: `/pr --fix quick-wins-low-low-01` (cross-PR batch)
   - Example: `/pr --fix pr12-batch-medium-low-01 --feature my-feature`
   - Creates PR for fix batch
   - Uses fix-specific template

3. **Release PR:** `/pr --release [version]`
   - Example: `/pr --release v0.1.0`
   - Creates PR for release transition
   - Uses release-specific template

4. **Draft PR:** `/pr --draft [--feature feature-name]`
   - Example: `/pr --draft`
   - Example: `/pr --draft --feature my-feature`
   - Creates draft PR for early feedback
   - Use at start of feature for continuous Sourcery review

**Options:**

- `--feature [name]` - Specify feature name (overrides auto-detection)
- `--dry-run` - Show PR description without creating PR
- `--no-push` - Create PR description but don't push branch or create PR
- `--body-file [path]` - Use custom body file instead of generating
- `--title [title]` - Override default PR title
- `--force` - (Release mode only) Override blocking readiness checks with justification

**Draft PR Options:**

- `--draft` - Create draft PR for early feedback (use at start of feature)
- `--ready` - Mark draft PR as ready for review (convert from draft to ready)
- `--review` - Request Sourcery review on draft PR (triggers `@sourcery-ai review`)

---

## Step-by-Step Process

### Pre-Command Branch Validation (BLOCKING)

**CRITICAL:** This validation MUST pass before any PR work begins.

#### 1. Detect Expected Branch

**For Phase PRs (`--phase N`):**
- Expected pattern: `feat/[feature-name]-phase-N-*` or `feat/phase-N-*`
- Example: `feat/release-readiness-phase-3-assessment-structure`

**For Fix PRs (`--fix [batch-name]`):**
- Expected pattern: `fix/[batch-name]`
- Example: `fix/pr32-batch-high-low-01`

**For Release PRs (`--release [version]`):**
- Expected pattern: `release/[version]`
- Example: `release/v0.4.0`

#### 2. Check Current Branch

```bash
git branch --show-current
```

#### 3. Branch Mismatch Handling

**If on wrong branch (e.g., `develop`, `main`, or different feature):**

1. **Check for worktree with correct branch:**
   ```bash
   git worktree list | grep [expected-branch-pattern]
   ```

2. **If worktree exists:**
   ```
   ⚠️ BRANCH MISMATCH: Currently on 'develop', expected 'feat/[feature]-phase-N-*'
   
   Found worktree with expected branch:
   → /path/to/worktree [feat/feature-phase-3-name]
   
   Resolution:
   1. Switch to worktree: cd /path/to/worktree
   2. Then re-run: /pr --phase N --feature [feature]
   ```

3. **If no worktree but branch exists:**
   ```bash
   git checkout [expected-branch]
   ```

4. **If branch doesn't exist:**
   ```
   ❌ BLOCKING: Expected branch not found
   
   Resolution:
   1. Create branch from develop: git checkout -b feat/[feature]-phase-N-[desc]
   2. Ensure phase work is committed to this branch
   3. Then re-run: /pr --phase N
   ```

#### 4. Auto-Detection Logic

**Branch pattern matching:**
- Phase PRs: Search for `feat/*phase-N*` or `feat/*[feature]*phase-N*`
- Fix PRs: Search for `fix/[batch-name]`
- Release PRs: Search for `release/[version]`

**Worktree awareness:**
- Check `git worktree list` for active worktrees
- If correct branch is in a worktree, direct user to that worktree
- Do NOT checkout branch that's in use by another worktree

---

### Mode Selection

**Determine mode:**

- `--phase` flag → Phase PR mode
- `--fix` flag → Fix PR mode
- `--release` flag → Release PR mode
- Neither flag → Show usage/help

**Checklist:**

- [ ] Mode determined
- [ ] Identifier provided (phase number, batch name, or version)
- [ ] Current branch matches expected (phase branch, fix branch, or release branch)

---

## Phase PR Mode (`--phase`)

### 1. Pre-PR Validation Checklist

**Run these checks before proceeding:**

#### Automated Testing

- [ ] Run full test suite (project-specific command)
  - Example: `pytest tests/ -v` or `npm test` or project-specific command
- [ ] All tests passing (no failures)
- [ ] Coverage maintained or improved
- [ ] Check coverage report (project-specific command)
- [ ] No test warnings (except known deprecations)

#### Code Quality

- [ ] Run linter (project-specific command)
  - Example: `pylint backend/` or `flake8 backend/` or `eslint` or project-specific
- [ ] No linter errors
- [ ] Code follows project patterns
- [ ] No TODO/FIXME comments left behind

#### Manual Testing

- [ ] Check if manual testing guide exists:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
  - Project-wide: `docs/maintainers/planning/manual-testing.md`
- [ ] **REQUIRED:** Add new scenarios for phase features (see step 1a)
- [ ] If guide exists, run ALL scenarios in order
- [ ] Document any issues found during manual testing
- [ ] Fix any bugs found before proceeding
- [ ] Update manual testing guide if scenarios need adjustment

**Manual Testing Location:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
- Project-wide: `docs/maintainers/planning/manual-testing.md`
- Run scenarios in order (some may depend on previous state)
- Note database state requirements (if applicable)

#### Documentation

- [ ] Phase document updated (all tasks marked complete: `- [x]`)
- [ ] README files updated (API docs, CLI docs, project-specific docs)
- [ ] No broken links in documentation
- [ ] Code comments added where needed

#### Status Validation

**Note:** For authoritative status update requirements, see [PR Status Update Requirements](../../docs/PR-STATUS-UPDATE-REQUIREMENTS.md). Examples below use placeholder dates (e.g., `2025-12-07`) and phase numbers (e.g., `Phase 3`) for illustration.

**Before PR creation, verify status documents are current:**

- [ ] Phase document status updated to "✅ Complete"
  - Location: `docs/maintainers/planning/features/[feature-name]/phase-N.md`
  - Verify: Status matches actual completion state
  - Example: `**Status:** ✅ Complete`
- [ ] Feature status document updated with phase completion
  - Location: `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`
  - Verify: Phase marked complete, progress updated
  - Example: `**Phase 3:** ✅ Complete (2025-12-07)`
- [ ] Progress tracking accurate
  - Verify: Progress percentages reflect actual completion
  - Verify: Task checkboxes match completed work
  - Verify: No outdated status indicators

**Status Check Process:**

1. **Read phase document:**
   - Check status field at top of document
   - Verify all task checkboxes are marked complete
   - Verify status matches actual work completed

2. **Read feature status document:**
   - Check phase completion status
   - Verify progress tracking is current
   - Verify next steps are accurate

3. **Validate consistency:**
   - Phase document status matches feature status
   - Progress percentages are accurate
   - No discrepancies between documents

**Status Update Examples:**

**Phase Document:**
```markdown
**Status:** ✅ Complete  # Must be "Complete" before PR
```

**Feature Status Document:**
```markdown
**Phase 3: Documentation & Examples**
- [x] Dependency sections added ✅ (2025-12-07)
- [x] Dependency documentation created ✅ (2025-12-07)
```

**If status is not current:**
- Update phase document status to "✅ Complete"
- Update feature status document with phase completion
- Commit status updates before creating PR
- Note: Status updates should happen during work (per `/task-phase` workflow), but verify before PR

**Status Update Requirements for PR Approval:**

- **Mandatory:** Status updates are required for PR approval
- **Lenient Approach:** Validation uses warnings, not blockers (to start)
- **During Work:** Status should be updated during work (per `/task-phase` workflow)
- **Before PR:** Status must be current before PR creation (validated by this command)
- **After Merge:** Status automatically updated by `/post-pr` command

**See Also:**
- [Status Update Workflow](../../docs/STATUS-UPDATE-WORKFLOW.md) - Complete status update guide
- [Status Update Checklist](../../docs/STATUS-UPDATE-CHECKLIST.md) - Checklist for status updates
- [Status Update Timing](../../docs/STATUS-UPDATE-TIMING.md) - Timing and frequency guide

#### Git State

- [ ] All changes committed to feature branch
- [ ] Feature branch is up-to-date with `develop`
- [ ] No uncommitted changes
- [ ] Commit messages follow conventional format

---

### 1a. Add Manual Testing Scenarios

**File:** 
- Feature-specific: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
- Project-wide: `docs/maintainers/planning/manual-testing.md`

**When to add scenarios:**

- New API endpoints added
- New CLI commands added
- New features that need user verification
- Filtering/search capabilities
- Any user-facing functionality

**Checklist:**

- [ ] Review phase features and identify what needs manual testing
- [ ] Check current scenario count (last scenario number)
- [ ] Add scenarios for each new feature
- [ ] Number scenarios sequentially (continue from last number)
- [ ] Include both API and CLI examples (if applicable)
- [ ] Add verification steps
- [ ] Note any prerequisites or dependencies
- [ ] Update "Phases" field in document header if needed

**Scenario Template:**

```markdown
### Scenario N: [Feature Name] - [Method]

**Test:** [What this scenario tests]

**Prerequisites:** [Any required setup or previous scenarios]

**API Test (if applicable):**
```bash
# API command (curl, httpie, etc.)
curl [endpoint] [options]
# Expected: [expected response]
```

**CLI Test (if applicable):**
```bash
# CLI command
[project-cli] [command] [options]
# Expected Output:
# [example output]
```

**Verification:**
```bash
# Commands to verify the result
# Expected: [expected result]
```

**Expected Result:** ✅ [Success criteria]
```

**Common Scenario Types:**

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

**After adding scenarios:**

- [ ] Update scenario count in document header if needed
- [ ] Verify scenarios are numbered sequentially
- [ ] Check that prerequisites are clear
- [ ] Ensure scenarios can be run in order (or note dependencies)
- [ ] Test at least one scenario manually to verify format

---

### 2. Load Phase Information

**Detect feature name:**

- Use `--feature` option if provided
- Otherwise, auto-detect using same logic as `/task-phase`:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for phase documents in each
  - If no features exist, use project-wide structure

**Parse phase number:**

- Extract phase number (e.g., `--phase 4` → Phase 4)
- Load phase document:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/phase-N.md`
  - Project-wide: `docs/maintainers/planning/phases/phase-N.md`
- Verify phase is complete (status: ✅ Complete)

**Extract information:**

- Phase number and name
- Completion date
- Tasks completed
- Deliverables
- Related PRs (if any)

**Verify:**

- Phase document exists
- Phase marked as complete
- All tasks completed
- Branch name matches phase (e.g., `feat/phase-[N]-...` or `feat/[feature-name]-phase-[N]-...`)

**Checklist:**

- [ ] Feature name detected or specified
- [ ] Phase document found
- [ ] Phase marked complete
- [ ] Current branch is phase branch
- [ ] Pre-PR validation checklist complete

---

### 3. Generate PR Description (Phase)

**Template:**

```markdown
## Phase [N]: [Phase Name]

**Status:** ✅ Complete  
**Completed:** YYYY-MM-DD

---

## Summary

[Brief description of what was accomplished in this phase]

---

## Tasks Completed

- [x] Task 1
- [x] Task 2
- [x] Task 3

---

## Changes

### [Category 1]

**Files Modified:**
- `[file1]` - [description]
- `[file2]` - [description]

**Key Changes:**
- [Change description]
- [Change description]

### [Category 2]

[Similar format]

---

## Testing

- [x] All tests passing ([N] tests)
- [x] Coverage maintained/improved ([X]%)
- [x] Manual testing completed
- [x] No regressions introduced

---

## Deliverables

- [Deliverable 1]
- [Deliverable 2]

---

## Related

- **Phase Plan:** `docs/maintainers/planning/features/[feature-name]/phase-N.md`
- **Feature Status:** `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`
- **Manual Testing:** `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
```

**Checklist:**

- [ ] PR description generated
- [ ] All tasks listed
- [ ] Changes documented
- [ ] Testing status included
- [ ] Related docs linked

---

### 4. Update Feature Documentation

**Files to check:**

**API Documentation:**
- Project-specific API docs (e.g., `backend/README.md`, `api/README.md`)
- Update endpoint list
- Add request/response examples

**CLI Documentation:**
- Project-specific CLI docs (e.g., `scripts/project_cli/README.md`, `cli/README.md`)
- Update command examples
- Add usage notes

**Manual Testing Guide:**
- Feature-specific: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
- Project-wide: `docs/maintainers/planning/manual-testing.md`
- **REQUIRED:** Add new scenarios for phase features (see step 1a)
- Update scenario numbering
- Add prerequisites/notes

---

### 5. Final Test Run

**Before creating PR, run:**

```bash
# Full test suite (project-specific command)
# Example: pytest tests/ -v
# Example: npm test
# Example: [project-specific test command]

# Coverage check (project-specific command)
# Example: pytest --cov --cov-report=term-missing
# Example: npm run test:coverage

# Linter check (project-specific command)
# Example: pylint backend/ || flake8 backend/
# Example: eslint .
```

**Expected:**

- All tests pass
- Coverage maintained/improved
- No linter errors

---

### 6. Create Phase PR

**PR Title:**

```
feat: [Phase N Description] (Phase N)
```

**Examples:**

- `feat: Delete & Archive Projects (Phase 3)`
- `feat: Create & Update Projects (Phase 2)`

**Steps:**

```bash
# Verify branch
git branch --show-current

# Push branch (if not already pushed)
git push origin feat/phase-[N]-[name]
# OR: git push origin feat/[feature-name]-phase-[N]-[name]

# Create PR using GitHub CLI
# Option A: Use temporary file (auto-cleaned)
cat > /tmp/pr-description-phase[N].md << 'EOF'
[paste PR description content]
EOF

gh pr create --title "feat: [Phase N Description] (Phase N)" \
             --body-file /tmp/pr-description-phase[N].md \
             --base develop \
             --head feat/phase-[N]-[name]

# Clean up
rm /tmp/pr-description-phase[N].md
```

**Note:** PR description files are gitignored (`pr-description*.md`) to prevent accidental commits.

**After PR creation:**

1. **Get PR number from output** (e.g., `#12`)
2. **STOP HERE - Present PR link to user**
   - DO NOT auto-merge
   - DO NOT proceed to Sourcery review yet
   - Wait for user acknowledgment

**Checklist:**

- [ ] Branch pushed
- [ ] PR created
- [ ] Description includes all tasks
- [ ] Related docs linked
- [ ] PR link presented to user
- [ ] User acknowledges PR creation

---

### 7. Present PR to User

**After PR is created:**

1. **Display PR information:**
   - PR number and URL
   - PR title
   - Branch information

2. **Next steps:**
   - Use `/pr-validation` command to run manual testing, Sourcery review, and update documentation (if available)
   - Or proceed with manual review and testing

**Note:** Sourcery review (`dt-review`) is handled by the `/pr-validation` command (if available), not during PR creation.

---

### 8. Address Critical Issues (If Any)

**If CRITICAL/HIGH issues found:**

1. **Create fix branch:**
   ```bash
   git checkout -b fix/pr##-critical-issues
   ```

2. **Implement fixes:**
   - Use `/fix-implement` command with fix batch name
   - Follow fix plans
   - Write tests for fixes
   - Run full test suite
   - Commit fixes

3. **Update PR:**
   - Push fix branch
   - Update PR description with fixes
   - Re-run `/pr-validation` if needed (includes Sourcery review)

**If only LOW/MEDIUM issues:**

- Document in fix tracking
- Can be deferred to future PR
- Proceed with merge approval

---

### 9. Get User Approval

**Before merging:**

- [ ] PR created and link presented to user
- [ ] `/pr-validation` command run (if available, includes manual testing and Sourcery review)
- [ ] Manual testing completed
- [ ] CRITICAL/HIGH issues addressed (if any)
- [ ] User explicitly approves merge

**DO NOT auto-merge** - Always wait for explicit user approval.

**After merge:**

- Use `/post-pr` command to update documentation (if available)

---

## Fix PR Mode (`--fix`)

### 1. Load Fix Batch Information

**Detect feature name:**

- Use `--feature` option if provided
- Otherwise, auto-detect using same logic as `/fix-implement`:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for fix structure in each
  - If no features exist, use project-wide structure

**Parse batch name:**

- Extract batch name (e.g., `quick-wins-low-low-01`)
- Determine batch type:
  - PR-Specific: Starts with `pr##-batch-`
  - Cross-PR: Does NOT start with `pr##-batch-`

**Load fix plan:**

- PR-Specific: `docs/maintainers/planning/features/[feature-name]/fix/pr##/[batch-name].md`
  - OR: `docs/maintainers/planning/fix/pr##/[batch-name].md` (project-wide)
- Cross-PR: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name].md`
  - OR: `docs/maintainers/planning/fix/cross-pr/[batch-name].md` (project-wide)

**Extract information:**

- Batch name and type
- Issues fixed
- Source PR(s)
- Files modified
- Testing status
- Completion date

**Verify:**

- Fix plan exists
- Batch marked as complete
- All issues fixed
- Tests passing
- Current branch is fix branch (e.g., `fix/[batch-name]`)

**Checklist:**

- [ ] Feature name detected or specified
- [ ] Batch type determined
- [ ] Fix plan found
- [ ] Batch marked complete
- [ ] Current branch is fix branch

---

### 2. Generate PR Description (Fix)

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

- [x] All existing tests passing ([N] tests)
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

- [x] All existing tests passing ([N] tests)
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

**Checklist:**

- [ ] PR description generated
- [ ] All issues listed
- [ ] Changes documented
- [ ] Testing status included
- [ ] Related docs linked
- [ ] Source PRs listed (for cross-PR batches)

---

### 3. Create Fix PR

**PR Title:**

**For PR-Specific Batches:**

```
fix: [Batch Description] ([batch-name])
```

**For Cross-PR Batches:**

```
fix: [Batch Description] ([batch-name], cross-PR batch)
```

**Steps:**

```bash
# Verify branch
git branch --show-current

# Push branch (if not already pushed)
git push origin fix/[batch-name]

# Create PR
gh pr create --title "fix: [Batch Description] ([batch-name])" \
             --body-file /tmp/pr-description-fix-[batch-name].md \
             --base develop \
             --head fix/[batch-name]
```

**Checklist:**

- [ ] Branch pushed
- [ ] PR created
- [ ] Description includes all issues
- [ ] Fix plan linked
- [ ] Tests documented
- [ ] PR link presented to user

---

## Draft PR Mode (`--draft`)

### When to Use

Use draft PRs when:
- Starting a new feature branch
- Want early Sourcery feedback during development
- Following self-contained feature branch workflow
- Not ready for merge but want continuous review

### Workflow

1. Create feature branch from develop
2. Make first meaningful commit
3. Run `/pr --draft` to open draft PR
4. Continue development with regular pushes
5. Request Sourcery reviews at milestones with `/pr --review`
6. When complete, run `/pr --ready` to mark ready for merge

### Create Draft PR

**Command:**

```bash
/pr --draft --feature [feature-name]
```

**Steps:**

1. **Verify branch:**
   ```bash
   git branch --show-current
   # Expected: feat/[feature-name] or similar
   ```

2. **Push branch:**
   ```bash
   git push -u origin [branch-name]
   ```

3. **Create draft PR:**
   ```bash
   gh pr create --draft \
     --title "feat: [Feature Name] (WIP)" \
     --body "[Description - work in progress]" \
     --base develop
   ```

4. **Note PR number** for future reference

### Draft PR Template

```markdown
## [Feature Name] - Work in Progress

**Status:** 🟠 In Progress  
**Branch:** feat/[feature-name]

---

## Overview

[Brief description of the feature being developed]

---

## Current Progress

- [ ] Phase 1: [Description]
- [ ] Phase 2: [Description]
- [ ] Phase N: [Description]

---

## Notes

- This is a draft PR for early feedback
- Sourcery reviews requested at milestones
- Will mark ready when feature complete
```

---

## Mark PR Ready (`--ready`)

### When to Use

Use `--ready` when:
- Feature development is complete
- All phases implemented
- Ready for final review and merge
- Draft PR exists and needs to be converted

### Command

```bash
/pr --ready --feature [feature-name]
```

### Steps

1. **Find PR number:**
   ```bash
   gh pr list --state open --head [branch-name]
   ```

2. **Mark ready:**
   ```bash
   gh pr ready [PR-number]
   ```

3. **Optionally update title (remove WIP):**
   ```bash
   gh pr edit [PR-number] --title "feat: [Feature Name]"
   ```

### Checklist Before Marking Ready

- [ ] All phases complete
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Sourcery issues addressed
- [ ] Ready for final review

---

## Request Sourcery Review (`--review`)

### Important: Sourcery Does NOT Auto-Review Draft PRs

Draft PRs do not trigger automatic Sourcery reviews. You must manually request a review:

```bash
/pr --review --feature [feature-name]
```

### When to Request Review

Request Sourcery review at:
- After completing a phase
- After significant changes
- Before marking PR ready
- At development milestones

### Command

```bash
/pr --review --feature [feature-name]
```

### Steps

1. **Find PR number:**
   ```bash
   gh pr list --state open --head [branch-name]
   ```

2. **Request review:**
   ```bash
   gh pr comment [PR-number] --body "@sourcery-ai review"
   ```

3. **Wait for review** (usually 1-2 minutes)

4. **Save review feedback** (optional):
   - Copy Sourcery comments to `admin/feedback/sourcery/pr[number].md`

### Note on Review Frequency

- Request review at meaningful milestones, not every commit
- Each review provides feedback on current state vs. base branch
- Too frequent reviews may generate noise for incremental changes

---

## Release PR Mode (`--release`)

### 1. Load Release Information

**Parse version:**

- Extract version (e.g., `v0.1.0`)
- Verify version format (should match semantic versioning)

**Load transition plan:**

- `docs/maintainers/planning/releases/[version]/transition-plan.md`

**Extract information:**

- Version number
- Release steps completed
- Release checklist status
- Release notes status
- Tagging status
- Post-release verification status

**Verify:**

- Transition plan exists
- All steps marked complete
- Release checklist complete
- Release notes finalized
- Current branch is release branch (e.g., `release/[version]`)

**Checklist:**

- [ ] Version format valid
- [ ] Transition plan found
- [ ] All steps complete
- [ ] Current branch is release branch

---

### 1a. Validate Release Readiness (NEW)

**Purpose:** Ensure release is ready before creating PR. Critical checks must pass or be explicitly overridden.

**Run readiness check:**

```bash
# Run the readiness check script
./scripts/check-release-readiness.sh [version]

# Example:
./scripts/check-release-readiness.sh v0.4.0
```

**Evaluate results:**

The script reports:
- ✅ Passed checks (release branch exists, version format, etc.)
- ❌ Failed checks (blocking criteria)
- ⚠️ Warnings (non-blocking issues)

**Blocking Criteria:**

If any of these fail, **do NOT create PR** (unless overridden):
- Release branch exists
- CHANGELOG has version entry
- Release notes file exists
- No critical open issues blocking release (if configured)

**Non-Blocking Criteria:**

These generate warnings but don't block PR creation:
- CI status (if temporarily failing)
- Documentation gaps (if minor)

**If blocking criteria fail:**

```
⚠️ RELEASE NOT READY - PR creation blocked

Blocking failures:
- ❌ [Failure 1]
- ❌ [Failure 2]

To proceed anyway, use: /pr --release [version] --force
```

**If all checks pass:**

```
✅ RELEASE READY - Proceeding with PR creation

All blocking criteria passed:
- ✅ Release branch exists
- ✅ CHANGELOG has version entry
- ✅ Release notes file exists
```

**Override option:**

- `--force` flag allows PR creation despite blocking failures
- Use with caution - document why override is acceptable
- Add override justification to PR description

**Generate assessment for PR:**

```bash
# Generate assessment to include in PR
./scripts/check-release-readiness.sh [version] --generate > /tmp/readiness-assessment.md
```

**Checklist:**

- [ ] Readiness check executed
- [ ] Results evaluated
- [ ] Blocking criteria passed (or override justified)
- [ ] Ready to create PR

---

### 2. Generate PR Description (Release)

**PR Title:**

```
chore: Release [version]
```

**PR Description Template:**

```markdown
## Release [version]

[Brief description of release - e.g., "MVP Release" or "First production release"]

---

## What's Included

### Release Preparation
- Release checklist completed
- Release notes finalized
- Pre-release verification complete
- Version tagged: [version]
- Release documentation updated

### Verification
- All tests passing ([N] tests)
- Test coverage: [X]%
- Production readiness verified
- Deployment guide reviewed
- Post-release verification complete (if applicable)

### Release Steps Completed
- [x] Step 1: Finalize Release Documentation
- [x] Step 2: Complete Pre-Release Verification
- [x] Step 3: Version Tagging and Release
- [x] Step 4: Update Release Documentation
- [x] Step 5: Post-Release Verification
- [x] Step 6: Release Communication

---

## Testing

- [x] All automated tests passing ([N] tests)
- [x] Coverage: [X]% (maintained/improved)
- [x] Pre-release verification complete
- [x] Post-release verification complete (if applicable)
- [ ] Sourcery review completed (if code changes)

---

## Release Artifacts

- **Release Checklist:** `docs/maintainers/planning/releases/[version]/checklist.md`
- **Release Notes:** `docs/maintainers/planning/releases/[version]/release-notes.md`
- **Transition Plan:** `docs/maintainers/planning/releases/[version]/transition-plan.md`

---

## Related

- **Transition Plan:** `docs/maintainers/planning/releases/[version]/transition-plan.md`
- **Release Checklist:** `docs/maintainers/planning/releases/[version]/checklist.md`
- **Release Notes:** `docs/maintainers/planning/releases/[version]/release-notes.md`
- **Release Hub:** `docs/maintainers/planning/releases/README.md`
```

---

### 3. Pre-PR Validation (Release)

**Before creating PR:**

- [ ] All release steps completed
- [ ] Release checklist complete
- [ ] Release notes finalized
- [ ] Version tagged (if Step 3 complete)
- [ ] All verification steps passed
- [ ] Release documentation updated
- [ ] Transition plan updated (all steps marked complete)
- [ ] Current branch is release branch
- [ ] All changes committed

**Verification commands:**

```bash
# Verify tag exists
git tag -l [version]

# Verify branch
git branch --show-current

# Verify tests passing (project-specific command)
# Example: pytest backend/ -v
# Example: npm test
```

**Checklist:**

- [ ] On release branch
- [ ] No uncommitted changes
- [ ] All verification steps passed
- [ ] Release documentation complete

---

### 4. Create PR (Release)

**Steps:**

1. **Push release branch:**
   ```bash
   git push origin release/[version]
   ```

2. **Create PR using GitHub CLI:**
   ```bash
   gh pr create --title "chore: Release [version]" \
                --body-file /tmp/pr-description-release-[version].md \
                --base develop \
                --head release/[version]
   ```

3. **Get PR number from output** (e.g., `#36`)

4. **STOP HERE - Present PR link to user**
   - DO NOT auto-merge
   - DO NOT proceed to Sourcery review yet
   - Wait for user acknowledgment

---

### 5. Sourcery Review (Release)

**After PR created and user acknowledges:**

- Run Sourcery review if code changes exist: `dt-review` (if available)
- Review feedback saved to: `docs/maintainers/feedback/sourcery/pr##.md`
- Fill out priority matrix (if review run)
- Address CRITICAL/HIGH issues before merge (if any)

**Note:** Release PRs may have minimal code changes (mostly documentation), so Sourcery review may be optional.

---

### 6. Post-Merge (Release)

**After merge:**

- Use `/post-pr --release [version]` command to update documentation (if available)

---

## Common Workflow Steps

### Status Updates in PR Process

**Status updates are mandatory throughout the PR lifecycle:**

1. **During Work:** Update status as tasks complete (per `/task-phase` workflow)
   - Mark task checkboxes `- [x]` as tasks complete
   - Update progress tracking at milestones
   - Update phase status to "🟠 In Progress" at phase start

2. **Before PR Creation:** Status must be current (validated by this command)
   - Phase document status: "✅ Complete"
   - Feature status document: Updated with phase completion
   - Progress tracking: Accurate percentages
   - See: [Status Validation](#status-validation) section above

3. **During PR Review:** Status updates verified (per PR Review Workflow)
   - Status Check Checklist verifies status updates
   - Warnings if status outdated (not blockers)
   - See: [Status Check Checklist](../../.cursor/rules/workflow.mdc#status-check-checklist)

4. **After PR Merge:** Status automatically updated (per `/post-pr` command)
   - Run `/post-pr [pr-number] --phase [N]` after PR merge
   - Command automatically updates phase and feature status
   - See: [Status Update Behavior](../../.cursor/commands/post-pr.md#status-update-behavior)

**Status Update Requirements:**
- **Mandatory:** Status updates are required for PR approval
- **Lenient Approach:** Validation uses warnings, not blockers (to start)
- **During Work:** Status should be updated during work (per `/task-phase` workflow)
- **Before PR:** Status must be current before PR creation (validated by this command)
- **After Merge:** Status automatically updated by `/post-pr` command

**See Also:**
- [PR Status Update Requirements](../../docs/PR-STATUS-UPDATE-REQUIREMENTS.md) - Complete PR status update guide
- [Status Update Workflow](../../docs/STATUS-UPDATE-WORKFLOW.md) - Complete status update guide
- [Status Update Checklist](../../docs/STATUS-UPDATE-CHECKLIST.md) - Checklist for status updates

---

### Pre-PR Validation

**For all modes:**

1. **Verify branch:**
   ```bash
   git branch --show-current
   ```

2. **Check uncommitted changes:**
   ```bash
   git status --short
   ```

3. **Verify tests pass:**
   ```bash
   # Project-specific test command
   # Example: cd backend && pytest -v
   # Example: npm test
   ```

4. **Check coverage:**
   ```bash
   # Project-specific coverage command
   # Example: pytest --cov --cov-report=term-missing
   # Example: npm run test:coverage
   ```

**Checklist:**

- [ ] On correct branch
- [ ] No uncommitted changes
- [ ] All tests passing
- [ ] Coverage acceptable

---

## Options

### `--dry-run`

**Behavior:**

- Generate PR description
- Display to user
- Do NOT push branch
- Do NOT create PR

**Use case:**

- Preview PR description before creating
- Verify template formatting
- Check for missing information

---

### `--no-push`

**Behavior:**

- Generate PR description
- Save to file
- Do NOT push branch
- Do NOT create PR

**Use case:**

- Generate description for manual PR creation
- Review before pushing
- Custom PR creation workflow

---

### `--body-file [path]`

**Behavior:**

- Use provided file as PR body
- Skip description generation
- Still validate branch and mode

**Use case:**

- Custom PR descriptions
- Pre-written descriptions
- Template variations

---

### `--title [title]`

**Behavior:**

- Override default PR title
- Still use generated body (unless `--body-file` used)

**Use case:**

- Custom titles
- Special formatting
- Consistency requirements

---

## Integration with Other Commands

### Phase Workflow

1. `/task-phase` - Implement phase tasks
2. `/pr --phase [N]` - Create phase PR
3. `/post-pr` - Update documentation after merge (if available)

### Fix Workflow

1. `/fix-plan` - Create fix plans
2. `/fix-implement [batch-name]` - Implement fixes
3. `/pr --fix [batch-name]` - Create fix PR
4. `/post-pr --fix [batch-name]` - Update documentation after merge (if available)

### Release Workflow

1. `/transition-plan` - Create transition plan (if available)
2. `/task-release` - Implement release steps (if available)
3. `/pr --release [version]` - Create release PR
4. `/post-pr --release [version]` - Update documentation after merge (if available)

### Draft PR Workflow (Worktree Feature)

1. Start feature: `git checkout -b feat/[feature-name]`
2. First commit: Make meaningful change, commit
3. Draft PR: `/pr --draft --feature [feature-name]`
4. Develop: Multiple commits, regular pushes
5. Review: `/pr --review` at milestones
6. Complete: `/pr --ready` when done
7. Final review: Address any remaining issues
8. Merge: PR merged to develop

**See:** [ADR-003: Draft PR Review Workflow](../decisions/worktree-feature-workflow/adr-003-draft-pr-review-workflow.md)

---

## Common Issues

### Issue: Branch Name Mismatch

**Solution:**

- Verify current branch matches expected
- For phases: Should be `feat/phase-[N]-...` or `feat/[feature-name]-phase-[N]-...`
- For fixes: Should be `fix/[batch-name]`
- For releases: Should be `release/[version]`
- Create branch if needed

---

### Issue: Phase/Fix Document Not Found

**Solution:**

- Check feature detection logic
- Use `--feature` option to specify feature name
- Verify phase/fix structure exists
- Check for project-wide structure

---

### Issue: Manual Testing Guide Missing

**Solution:**

- Create manual testing guide if needed
- Use template from this command
- Add scenarios for phase features
- Update guide location in configuration

---

## Tips

**Before creating PR:**

- Complete all validation checklist items
- Add manual testing scenarios
- Update documentation
- Verify all tests pass

**PR Description:**

- Be comprehensive but concise
- Include all relevant information
- Link to related documentation
- Document testing status

**After PR creation:**

- Present PR link to user
- Wait for user acknowledgment
- Do NOT auto-merge
- Follow up with `/pr-validation` if available

---

## Reference

**Phase Documents:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/phase-N.md`
- Project-wide: `docs/maintainers/planning/phases/phase-N.md`

**Fix Plans:**

- PR-Specific: `docs/maintainers/planning/features/[feature-name]/fix/pr##/[batch-name].md`
- Cross-PR: `docs/maintainers/planning/features/[feature-name]/fix/cross-pr/[batch-name].md`
- Project-wide: `docs/maintainers/planning/fix/pr##/[batch-name].md` or `docs/maintainers/planning/fix/cross-pr/[batch-name].md`

**Release Planning:**

- `docs/maintainers/planning/releases/[version]/transition-plan.md`
- `docs/maintainers/planning/releases/[version]/release-notes.md`

**Manual Testing:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/manual-testing.md`
- Project-wide: `docs/maintainers/planning/manual-testing.md`

**Related Commands:**

- `/task-phase` - Implement phase tasks
- `/fix-implement` - Implement fixes
- `/post-pr` - Update documentation after merge (if available)
- `/pr-validation` - Run validation and reviews (if available)

---

**Last Updated:** 2025-12-10  
**Status:** ✅ Active  
**Next:** Use to create PRs for phases, fixes, and releases (includes readiness validation for release PRs)

