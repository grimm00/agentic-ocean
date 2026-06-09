# Task Command

Implement tasks from an implementation plan, following TDD workflow with review-then-commit discipline. Supports sequential flow, explicit selection, and status views.

---

## Configuration

**Plan Path Detection:**

This command reads the uniform planning structure (`implementation-plan.md` + `tasks/`):

1. **Dev-Infra Structure:**
   - Plan: `admin/services/[service]/features/[feature-name]/planning/implementation-plan.md`
   - Tasks: `admin/services/[service]/features/[feature-name]/planning/tasks/`
   - Status: `admin/services/[service]/features/[feature-name]/planning/status-and-next-steps.md`

2. **Template Project Structure (generated projects):**
   - Plan: `docs/maintainers/planning/features/[feature-name]/implementation-plan.md`
   - Tasks: `docs/maintainers/planning/features/[feature-name]/tasks/`
   - Status: `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`

**Feature Detection:**

- Use `--feature` option if provided
- Otherwise, auto-detect:
  - Check if planning features directory exists (dev-infra or template project)
  - If single feature exists, use that feature name
  - If multiple features exist, prompt user to select
  - If no features exist, report error

**Legacy Fallback:**

If `implementation-plan.md` is not found but `feature-plan.md` + `phase-*.md` exist:

```
⚠️ Legacy phase structure detected for feature '[name]'.
   This feature uses the old phase-based planning layout.

   Options:
   1. Use `/task-phase` to work with the existing phase structure
   2. Migrate to the uniform structure: See docs/MIGRATION-v0.10.md
```

---

## Pre-Task Branch Validation (BLOCKING)

**CRITICAL:** This validation MUST pass before any work begins. Do NOT proceed if validation fails.

### Validation Steps

1. **Check Current Branch:**
   ```bash
   git branch --show-current
   ```

2. **Expected Pattern:** `feat/*` (any feature branch)

3. **Validation Logic:**
   - If on `develop` or `main` → **ERROR: Wrong branch**
   - If branch is checked out in another worktree → **ERROR: Worktree conflict**

### Error Handling

**Wrong Branch Error:**
```
❌ BLOCKING: Currently on 'develop', expected a feature branch (feat/*)

   Resolution:
   1. Check out the correct feature branch: git checkout feat/[feature]-[desc]
   2. If branch exists in worktree, work from that worktree instead
   3. If starting new work, create branch: git checkout -b feat/[feature]-[desc]
```

**Worktree Conflict Error:**
```
❌ BLOCKING: Branch 'feat/...' is checked out in worktree at '/path/to/worktree'

   Resolution:
   1. Work from the worktree: cd /path/to/worktree
   2. Or delete the worktree: git worktree remove /path/to/worktree
```

### Enforcement

- This check runs at the START of every `/task` invocation (except bare mode / status view)
- If validation fails, the command STOPS immediately
- No code changes should be made until validation passes

---

## Workflow Overview

**Pattern:**

1. Implementation plan has multiple tasks organized in groups
2. **Task Grouping:** RED + GREEN TDD tasks are grouped together (tightly coupled TDD cycle)
3. Implement the task group completely (RED → GREEN → REFACTOR)
4. Use `/review` to review changes, then `/commit` to finalize
5. Stop and wait for user to invoke command again for next task
6. Create PR only after completing ALL tasks in the feature (or docs-only tasks merge directly)

**Task Grouping Rules:**

- **Group together:** RED test task + GREEN implementation task (e.g., Task 1 + Task 2)
- **Separate:** Different task types (e.g., API tasks vs CLI tasks)
- **Separate:** Large/complex tasks that benefit from individual review

**Key Principle:** Group related TDD cycles (RED+GREEN), but separate different components. Complete the task group, use `/review` + `/commit`, then stop. User invokes the command again for the next task.

---

## Usage

**Command:** `/task [mode] [options]`

### Three Modes

**1. Sequential — `/task next`**

Find the first unchecked task in `implementation-plan.md` and execute it:

```
/task next                        — Execute next incomplete task
/task next --feature my-feature   — Specify feature explicitly
```

**2. Explicit — `/task N`**

Execute a specific task by its global number:

```
/task 5                           — Execute Task 5
/task 12 --feature my-feature     — Execute Task 12 for a specific feature
```

**3. Status — `/task` (bare)**

Show the implementation plan status without executing anything:

```
/task                             — Show progress summary and task list
/task --feature my-feature        — Show progress for specific feature
```

**Output format for bare mode:**

```
📋 Workflow Simplification — 3/18 tasks complete

  Foundation & Specs           ✅ 3/3
  ├── [x] Task 1: Create migration guide
  ├── [x] Task 2: Update validation rules
  └── [x] Task 3: Add planning structure specification

  Command Infrastructure       🔴 0/4
  ├── [ ] Task 4: Create /task command
  ├── [ ] Task 5: Create /plan-review command
  ├── [ ] Task 6: Create deprecation stubs
  └── [ ] Task 7: Update template-sync-manifest.txt

  ... (remaining groups)

  Next: Task 4 — Create /task command (Group: Command Infrastructure)
```

### Options

- `--feature [name]` — Specify feature name (overrides auto-detection)
- `--force-pr` — Force PR creation even for docs-only tasks (overrides auto-detection)
- `--dry-run` — Show what would be executed without doing it

---

## Plan Review Workflow

**Before starting implementation** of a new group, consider reviewing the plan:

1. **Run `/plan-review [feature]`** to identify gaps (optional but recommended)
2. **Run `/address-review [review-path]`** to address gaps (if any found)
3. **Run `/task next`** or **`/task N`** to start implementation (this command)

**Separation of Concerns:**

- **`/plan-review`** — Identifies issues (creates review document)
- **`/address-review`** — Addresses issues (updates plan documents)
- **`/task`** — Implements work (writes code/tests)

---

## Step-by-Step Process

### 1. Resolve the Task

**What to do:**

1. **Detect feature and read implementation plan:**

   - Locate `implementation-plan.md` using path detection rules above
   - Parse YAML frontmatter to get `task_count`, `groups[]`, and `tasks_files[]`
   - Read the checkbox list in the `## 📝 Implementation Plan` section

2. **Determine the target task:**

   - **`/task next`:** Scan checkboxes for the first `- [ ]` entry. Extract the task number from the text (e.g., `- [ ] Task 4: ...` → task number 4).
   - **`/task N`:** Locate `Task N` in the checkbox list. Error if N > task_count or task is already checked.
   - **`/task` (bare):** Display status and exit (no further steps).

3. **Resolve the group file:**

   - From YAML frontmatter, find which `groups[]` entry contains the task number in its `tasks[]` array.
   - Read the group file from `tasks/` directory (e.g., `tasks/02-command-infrastructure.md`).
   - Extract the detailed task description from the group file.

4. **Check prerequisites:**
   - Are all dependency tasks (listed in the group file's Dependencies section) complete?
   - If not, warn: `⚠️ Task N depends on Task M which is not yet complete.`

5. **Check for TDD pairing:**
   - Read the task description for RED/GREEN indicators.
   - If this task is a RED task and the next task is its GREEN pair, automatically include both.
   - If the task description explicitly mentions pairing, follow that grouping.

**Checklist:**

- [ ] Implementation plan located and parsed
- [ ] Target task identified (next or explicit)
- [ ] Group file read for task details
- [ ] Prerequisites verified
- [ ] TDD pairing checked

---

### 2. Auto-Update Status (Start of Group)

When starting the **first task** in a group (i.e., the group was previously `🔴 Not Started`):

1. **Update group file header:**

   - Change `**Status:** 🔴 Not Started` to `**Status:** 🟠 In Progress`
   - Update `**Last Updated:**` to today's date

2. **Update `status-and-next-steps.md`:**

   - Change the group's row from `🔴 Not Started` to `🟠 In Progress`
   - Update `**Last Updated:**` in the document header

3. **Commit status updates immediately:**

   ```bash
   git add [group-file] [status-file]
   git commit -m "docs([feature]): start [group-name] group"
   ```

**Note:** Status updates are committed before implementation begins to ensure tracking is current from the start.

---

### 3. Implement the Task Following TDD

**TDD Pattern (RED → GREEN → REFACTOR):**

**If task group includes RED + GREEN:**

#### RED Phase (Write Tests First)

- [ ] Write failing tests for the task
- [ ] Run tests to confirm they fail
- [ ] Commit: `test([feature]): add tests for [task description]`

#### GREEN Phase (Implement to Pass)

- [ ] Implement minimum code to pass tests
- [ ] Run tests to confirm they pass
- [ ] Commit: `feat([feature]): implement [task description]`

#### REFACTOR Phase (Improve Code)

- [ ] Refactor if needed (with tests still passing)
- [ ] Commit: `refactor([feature]): improve [task description]` (if needed)

**If task is standalone (no TDD pair):**

- [ ] Implement the task completely
- [ ] Test manually or run existing test suite
- [ ] Commit: `feat([feature]): implement [task description]`

---

### 4. Commit Strategy

**IMPORTANT:** Always commit work before stopping or moving to next task.

**Reference:** [Commit Workflow](../../docs/COMMIT-WORKFLOW.md)

**For code changes (tests, implementation, refactoring):**

Use `/review` to review changes before committing. This forces a deliberate pause to verify agentic code changes.

```
[AI implements task]
    ↓
/review [task-description]   ← Review in a separate prompt
    ↓ human review
/commit                      ← Commit reviewed changes
```

**For documentation-only changes (status updates, checkbox markers):**

Direct commit is fine — no review pause needed.

```bash
git commit -m "docs([feature]): mark Task N complete"
```

**Commit Message Format:**

- Follow: `type(scope): brief description`
- Scope is feature name or group name — NOT phase number
- Examples:
  - `test(workflow-simplification): add /task command tests`
  - `feat(workflow-simplification): implement /task command`
  - `docs(workflow-simplification): mark Task 4 complete`

---

### 5. Mark Task Complete

**After implementing a task:**

- [ ] All tests for this task pass
- [ ] Code follows project patterns
- [ ] No linter errors
- [ ] Manual testing done (if applicable)

**Update implementation plan:**

- Mark the task checkbox as complete: `- [x]` instead of `- [ ]`
- Update the group file: mark the corresponding task checkbox as `- [x]`
- Update `**Last Updated:**` in the group file

**Update progress tracking:**

- Update `status-and-next-steps.md` progress column (e.g., `1/4 tasks` → `2/4 tasks`)
- Update overall count (e.g., `3/18 tasks complete` → `4/18 tasks complete`)

**Commit status updates:**

```bash
git add [implementation-plan] [group-file] [status-file]
git commit -m "docs([feature]): mark Task N complete"
```

---

### 6. Auto-Update Status (Group Completion)

When completing the **last task** in a group:

1. **Update group file header:**

   - Change `**Status:** 🟠 In Progress` to `**Status:** ✅ Complete`
   - Add `**Completed:** YYYY-MM-DD`
   - Update `**Last Updated:**`

2. **Update `status-and-next-steps.md`:**

   - Change the group's row from `🟠 In Progress` to `✅ Complete`
   - Update progress column to show all tasks done (e.g., `4/4 tasks`)
   - Update overall progress count
   - Update `**Next Steps:**` to reflect the next group

3. **Commit group completion:**

   ```bash
   git add [group-file] [status-file] [implementation-plan]
   git commit -m "docs([feature]): complete [group-name] group"
   ```

---

### 7. Stop After Task Completion

**After completing a task (or task group if TDD pair):**

- [ ] Task fully implemented and tested
- [ ] All commits made to feature branch
- [ ] Tests passing

**Then STOP:**

- [ ] **STOP — Do NOT proceed to next task**
- [ ] Present completion summary to user:
  ```
  ✅ Task N complete: [task description]
     Group: [group-name] — [X/Y tasks]
     Overall: [X/18 tasks]
     Next: Task [N+1] — [next task description]
  ```
- [ ] Remind user: "Use `/review` to review code changes if not already committed"
- [ ] Wait for user to invoke command again for next task

**Important:** This command handles ONE task (or RED+GREEN pair) at a time. The user will invoke this command again when ready to continue.

---

### 8. All Tasks Complete — Determine Workflow

**When ALL tasks in the feature are done:**

**Detect change type (docs-only vs code):**

```bash
git diff --name-only develop...HEAD | grep -E '\.(py|js|ts|go|rs|java|cpp|c|h|sh|bash)$'
# If matches found → Code changes (use PR workflow)
# If no matches → Docs-only (use direct merge)
```

**Special cases:**
- Template generation scripts (`.sh` in `scripts/`) → Code changes
- CI/CD workflows (`.yml` in `.github/workflows/`) → Code changes
- Mixed changes (code + docs) → Code changes (use PR workflow)
- User override: `--force-pr` forces PR workflow

### 8a. Docs-Only: Direct Merge Workflow

If all changes are documentation-only (and `--force-pr` not used):

1. Push feature branch
2. Merge directly to develop
3. Run `/post-pr --direct` to update status
4. Clean up branch

### 8b. Code Changes: PR Workflow

If changes include code:

1. Push final commits
2. Use `/pr` command for PR creation
3. Wait for review and approval
4. After merge, run `/post-pr` to update status

---

## Docs-Only Detection

This command automatically detects if a task involves documentation-only changes and adjusts workflow accordingly.

**Docs-only criteria:**

- Only documentation files modified (`.md`, `.txt`, `.yml`, `.yaml`, `.json` config files)
- Only copying existing files (no code modifications)
- Creating new documentation/README files
- Template work that involves copying files and creating documentation

**Requires PR:**

- Any code files modified (`.py`, `.js`, `.ts`, `.go`, `.rs`, `.java`, `.cpp`, `.c`, `.h`, `.sh`, `.bash`, etc.)
- Scripts modified (even if they generate docs)
- CI/CD workflows modified (`.yml` in `.github/workflows/`)
- Mixed changes (code + docs) → Use PR workflow

**Workflow adjustment:**

- **Docs-Only Task:** Feature branch → Commit → Merge directly to develop → Update status docs
- **Code Task:** Feature branch → Commit → Create PR → Review → Merge → Update status docs

---

## Task Detection Logic

**How to identify tasks in the plan:**

Tasks are listed as GFM checkboxes in `implementation-plan.md`:

```markdown
### Group Name
- [ ] Task N: Description
- [x] Task M: Already completed
```

**Global numbering:** Tasks are numbered 1 to N across ALL groups. Task numbers never restart per group.

**Task boundaries in group files:**

- Each task is a heading or list item in the group file
- Tasks may have sub-items (checkboxes, bullet points)
- Complete all sub-items before marking the task complete

---

## Error Handling

**Task not found:**
```
❌ Task N does not exist. This plan has [task_count] tasks (1-[task_count]).
```

**Task already complete:**
```
⚠️ Task N is already complete (marked [x] in implementation plan).
   Use `/task next` to find the next incomplete task.
```

**All tasks complete:**
```
✅ All [task_count] tasks are complete!
   Run `/pr` to create a pull request, or merge directly if docs-only.
```

**Prerequisites not met:**
```
⚠️ Task N depends on Task M which is not yet complete.
   Consider completing Task M first, or proceed with caution.
```

**Plan file not found:**
```
❌ No implementation-plan.md found for feature '[name]'.

   Searched:
   - admin/services/[service]/features/[name]/implementation-plan.md
   - docs/maintainers/planning/features/[name]/implementation-plan.md

   If using legacy phase structure, use `/task-phase` instead.
   To migrate: See docs/MIGRATION-v0.10.md
```

**Tests fail:**

- Debug the failure
- Fix the issue
- Re-run tests
- Don't move to next task until tests pass

**Linter errors:**

- Fix linter issues
- Re-run linter
- Don't commit until clean

---

## Feature Completion Checklist

**Before marking feature complete:**

- [ ] All tasks completed (all checkboxes marked `[x]`)
- [ ] All tests passing
- [ ] Coverage maintained/improved (if applicable)
- [ ] Manual testing complete (if applicable)
- [ ] Documentation updated
- [ ] All group statuses show ✅ Complete
- [ ] `status-and-next-steps.md` shows full progress
- [ ] Change type detected (docs-only vs code)
- [ ] PR created and reviewed (if code changes)
- [ ] Post-merge status updates handled

---

## Tips

**While implementing:**

- Focus on ONE task (or RED+GREEN pair)
- Keep `implementation-plan.md` open for reference
- Read the detailed description from the group file
- Don't skip tests (TDD discipline)
- Commit frequently (small commits)
- Push to branch regularly

**Task grouping:**

- RED + GREEN tasks naturally belong together
- Complete the full TDD cycle before stopping
- Different components (API vs CLI) are separate tasks

**After completing a task:**

- **STOP — Do NOT continue to next task**
- Present summary of what was accomplished
- Wait for user to invoke command again

---

## Related Commands

- `/plan-review [feature]` — Review implementation plan before starting
- `/address-review [path]` — Address review gaps
- `/pr` — Create PR for completed work
- `/post-pr` — Update documentation after merge
- `/review` — Review agentic changes before committing
- `/commit` — Commit from review context
- `/task-phase` — **Deprecated.** Legacy phase-based task command (stub points here)

---

**Last Updated:** 2026-02-19
**Status:** ✅ Active
**Next:** Use to implement tasks from implementation plans (uniform structure)
