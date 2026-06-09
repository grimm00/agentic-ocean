# Task Release Command

Implements release tasks following TDD workflow. Similar to `/task-phase` but focused on release preparation tasks. Ensures release tasks are implemented with proper testing and documentation.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Release-Specific Structure (default):**
   - Release transition plan: `docs/maintainers/planning/releases/[version]/transition-plan.md`
   - Release checklist: `docs/maintainers/planning/releases/[version]/checklist.md`
   - Release notes: `docs/maintainers/planning/releases/[version]/release-notes.md`

2. **Project-Wide Structure:**
   - Release planning: `docs/maintainers/planning/releases/[version]/` (if exists)

**Version Detection:**

- Extract version from current branch (e.g., `release/v0.1.0`)
- Or use `--version` option to specify version
- Or auto-detect from release directory structure

---

## Workflow Overview

**When to use:**

- When implementing release preparation tasks from a `transition-plan.md`
- After transition plan is created with specific implementation tasks
- To implement release checklist items that require code/scripts/tests
- Following TDD workflow for release tasks

**When NOT to use (skip to `/release-finalize`):**

- All features already merged to develop via PRs
- Release is bundling accumulated changes (no new implementation)
- `transition-plan.md` doesn't exist or has no implementation tasks
- Example: v0.6.0 (all work done in PRs #47-52)

**Key principle:** Implement release tasks with TDD discipline, ensuring each task is tested and documented before moving to the next. **Always run readiness check before starting tasks.**

**Decision guide:** If your release just needs CHANGELOG and release notes merged, skip this command and go directly to `/release-finalize`. Use this command only when you have actual implementation work (scripts, tests, features) to build during release prep.

---

## Usage

**Command:** `/task-release [task-number] [options]`

**Examples:**

- `/task-release 1` - Implement release task 1
- `/task-release 2 --version v0.1.0` - Implement task 2 for specific version
- `/task-release 3 --checklist-only` - Only update checklist, don't implement
- `/task-release 1 --dry-run` - Show what would be done without implementing

**Options:**

- `--task NUMBER` - Task number to implement (required)
- `--version VERSION` - Specify version (e.g., v0.1.0)
- `--checklist-only` - Only update checklist, don't implement
- `--dry-run` - Show implementation plan without executing

---

## Step-by-Step Process

### 1. Identify Release Information

**Detect version:**

- Extract from current branch: `release/v0.1.0` → `v0.1.0`
- Or use `--version` option
- Or find latest release directory: `docs/maintainers/planning/releases/v*/`

**Load release documents:**

- Transition plan: `docs/maintainers/planning/releases/[version]/transition-plan.md`
- Checklist: `docs/maintainers/planning/releases/[version]/checklist.md`
- Release notes: `docs/maintainers/planning/releases/[version]/release-notes.md`

**Verify documents exist:**

```bash
# Check transition plan
ls docs/maintainers/planning/releases/[version]/transition-plan.md

# Check checklist
ls docs/maintainers/planning/releases/[version]/checklist.md
```

**Checklist:**

- [ ] Version identified
- [ ] Release documents found
- [ ] Documents are readable
- [ ] Current branch is release branch (if applicable)

---

### 1a. Run Readiness Check (NEW)

**Purpose:** Validate release readiness before implementing tasks. Ensures critical criteria are met and provides visibility into release status.

**Run readiness check:**

```bash
# Run the readiness check script
./scripts/check-release-readiness.sh [version]

# Example:
./scripts/check-release-readiness.sh v0.4.0
```

**Review output:**

The script will report:
- ✅ Passed checks (release branch, version format, etc.)
- ❌ Failed checks (blocking criteria)
- ⚠️ Warnings (non-blocking issues)
- 📊 Data gathered (recent PRs, open issues)

**If critical checks fail:**

- ⚠️ **Warning:** Release readiness has blocking failures
- Review the failures before proceeding
- Some tasks may address the failures (e.g., creating release notes)
- Document any known issues that will be addressed during release

**If all checks pass:**

- ✅ Release is ready for task implementation
- Proceed to load and implement tasks

**Generate assessment (optional):**

```bash
# Generate full assessment document
./scripts/check-release-readiness.sh [version] --generate > admin/planning/releases/[version]/RELEASE-READINESS.md
```

**Checklist:**

- [ ] Readiness check executed
- [ ] Output reviewed
- [ ] Blocking failures identified (if any)
- [ ] Decision made to proceed or address failures first

---

### 2. Load Release Task

**Parse transition plan:**

- Extract task from transition plan
- Identify task number
- Read task description
- Identify task dependencies
- Check task status

**Task format in transition plan:**

```markdown
## Transition Steps

1. **Step 1: [Task Name]**
   - [ ] Task 1
   - [ ] Task 2
   - Estimated: [X] hours
```

**Checklist:**

- [ ] Task identified
- [ ] Task description clear
- [ ] Dependencies checked
- [ ] Task is ready to implement

---

### 3. Implement Task (TDD Workflow)

**Follow TDD discipline:**

1. **RED:** Write failing test
   - Create test for task functionality
   - Ensure test fails (RED)
   - Commit test

2. **GREEN:** Implement minimum code
   - Implement just enough to pass test
   - Ensure test passes (GREEN)
   - Commit implementation

3. **REFACTOR:** Improve code
   - Refactor if needed
   - Ensure tests still pass
   - Commit refactoring

**For release tasks, tests may include:**

- Version validation tests
- Release checklist validation
- Release notes format validation
- Tag validation
- Distribution validation

**Checklist:**

- [ ] Test written (RED)
- [ ] Test fails as expected
- [ ] Implementation complete (GREEN)
- [ ] Test passes
- [ ] Code refactored (if needed)
- [ ] All tests passing

---

### 4. Update Release Checklist

**Mark task complete:**

- Update checklist: `- [x]` instead of `- [ ]`
- Add completion notes if needed
- Document any issues encountered

**Checklist location:**

- `docs/maintainers/planning/releases/[version]/checklist.md`

**Update format:**

```markdown
## Release Preparation

- [x] Task 1: [Description] ✅ Completed YYYY-MM-DD
- [ ] Task 2: [Description]
```

**Checklist:**

- [ ] Checklist updated
- [ ] Task marked complete
- [ ] Completion date added
- [ ] Notes added (if needed)

---

### 5. Update Release Notes (if applicable)

**If task affects release notes:**

- Update release notes with task completion
- Add relevant information
- Update version information

**Release notes location:**

- `docs/maintainers/planning/releases/[version]/release-notes.md`

**Checklist:**

- [ ] Release notes updated (if applicable)
- [ ] Information added
- [ ] Version information current

---

### 6. Commit Changes

**IMPORTANT:** Always commit work before stopping or moving to next task.

**Reference:** [Commit Workflow](../../docs/COMMIT-WORKFLOW.md) - Central commit workflow documentation

**For code changes (tests, implementation, scripts):**

Use `/review` to review changes before committing. This forces a deliberate pause to verify agentic code changes.

```
[AI implements release task]
    ↓
/review [task-description]   ← Review in a separate prompt
    ↓ human review
/commit                      ← Commit reviewed changes
```

**For documentation-only changes (checklist updates, release notes):**

Direct commit is fine -- no review pause needed.

```bash
git commit -m "docs(release): update checklist for [task description]"
```

**Commit message examples:**

- Code: `test(release): add test for [task description]` (via `/review` + `/commit`)
- Code: `feat(release): implement [task description]` (via `/review` + `/commit`)
- Docs: `docs(release): update checklist for [task description]` (direct commit)

**Branch:**

- Work on release branch: `release/[version]`
- Or feature branch if needed: `feat/release-[version]-[task]`

**Before Stopping:**
- [ ] Check `git status` for uncommitted changes
- [ ] Use `/review` for code changes, direct commit for docs-only
- [ ] Push to remote
- [ ] Verify no uncommitted changes remain

**Checklist:**

- [ ] Code changes reviewed with `/review`
- [ ] Commit messages descriptive
- [ ] Commits follow project conventions
- [ ] Branch is correct

---

### 7. Stop After Task Completion

**After completing a task:**

- [ ] Task fully implemented and tested
- [ ] All commits made to release branch
- [ ] Tests passing
- [ ] Checklist updated
- [ ] **STOP - Do NOT proceed to next task**
- [ ] Present completion summary to user
- [ ] Indicate which task was completed
- [ ] Remind user: "Use `/review` to review code changes before committing"
- [ ] Wait for user to invoke command again for next task

**Important:** This command handles ONE task at a time. The user will invoke `/review` to review and commit code changes, then invoke this command again with the next task number when ready to continue.

---

### 8. Complete All Tasks - Finalize Release

**When ALL release tasks are done:**

**Pre-Release Checklist:**

- [ ] All tasks completed
- [ ] All tests passing
- [ ] Release checklist complete
- [ ] Release notes finalized
- [ ] Version tagged
- [ ] Documentation updated
- [ ] No linter errors

**Create Release PR:**

1. Push final commits to release branch
2. Run Sourcery review: `dt-review` from dev-toolkit (if available)
3. Fill out priority matrix in `docs/maintainers/feedback/sourcery/pr##.md` (if review available)
4. Address any CRITICAL/HIGH issues before PR
5. Create PR with comprehensive description

**PR Title Format:**

```
chore: Release [version]
```

**PR Description Template:**

```markdown
## Release [version]

[Brief description of release]

---

## Release Preparation Complete

### Checklist Items Completed
- [x] Task 1: [Description]
- [x] Task 2: [Description]
- [x] Task 3: [Description]

### Release Notes
- Release notes finalized
- Version information updated
- Documentation updated

### Verification
- All tests passing ([N] tests)
- Release checklist complete
- Release notes finalized
- Version tagged: [version]

### Next Steps
1. Review PR
2. Merge to main
3. Create GitHub release
4. Distribute release
```

**Checklist:**

- [ ] All tasks complete
- [ ] Release PR created
- [ ] PR description comprehensive
- [ ] Ready for review

---

## Common Issues

### Issue: Release Documents Missing

**Solution:**

- Create release directory structure
- Use `/transition-plan` to create transition plan first
- Create checklist template
- Create release notes template

### Issue: Task Not Found

**Solution:**

- Check task number
- Verify transition plan exists
- Check task format in transition plan
- Ensure task is not already complete

### Issue: Tests Failing

**Solution:**

- Review test implementation
- Check test data
- Verify test environment
- Fix implementation to pass tests

---

## Tips

### Before Starting

- Ensure transition plan exists
- **Run readiness check:** `./scripts/check-release-readiness.sh [version]`
- Review release checklist
- Understand task requirements
- Check dependencies

### During Implementation

- Follow TDD workflow strictly
- Write tests first
- Implement minimum code
- Refactor as needed

### After Completion

- Update checklist immediately
- Document any issues
- Commit changes promptly
- Present summary to user

---

## Reference

**Release Documents:**

- Transition plan: `docs/maintainers/planning/releases/[version]/transition-plan.md`
- Checklist: `docs/maintainers/planning/releases/[version]/checklist.md`
- Release notes: `docs/maintainers/planning/releases/[version]/release-notes.md`

**Related Commands:**

- `/transition-plan` - Create release transition plans
- `/pr` - Create release PRs
- `/task-phase` - Similar workflow for phase tasks

---

## 📊 Log Usage (Final Step)

**After successful command completion, update the usage tracker:**

1. **Update:** `admin/planning/commands/usage-tracker.md`
2. **Add entry to "Recent Usage" table:**
   ```markdown
   | YYYY-MM-DD | `/task-release` | [Context] | ✅ Success | [Evidence] |
   ```
3. **Increment usage count** in summary table
4. **Commit with message:**
   ```
   docs(commands): update usage tracker - /task-release
   ```

**Why:** Tracks command maturity for graduation decisions per [ADR-004](../admin/services/meta/features/dev-infra-identity-and-focus/decisions/adr-001-project-identity.md).

**Note:** This command needs ≥3 uses before graduation consideration. Current uses: 2.

---

**Last Updated:** 2025-12-16  
**Status:** ✅ Active  
**Next:** Use to implement release preparation tasks following TDD workflow (includes readiness check integration)

