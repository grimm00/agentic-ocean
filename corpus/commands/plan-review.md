# Plan Review Command

Reviews implementation plans before work begins. Ensures the plan is complete, dependencies are satisfiable, and task groups are ready for implementation.

---

## Configuration

**Plan Path Detection:**

This command reads the uniform planning structure (`implementation-plan.md` + `tasks/`):

1. **Dev-Infra Structure:**
   - Plan: `admin/planning/features/[feature-name]/implementation-plan.md`
   - Tasks: `admin/planning/features/[feature-name]/tasks/`
   - Status: `admin/planning/features/[feature-name]/status-and-next-steps.md`

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
   Use `/pre-phase-review` for phase-based plans, or migrate first.
   See docs/MIGRATION-v0.10.md
```

---

## Workflow Overview

**When to use:**

- Before starting implementation of a new group
- After plan generation (`/transition-plan`) is complete
- To validate plan readiness
- To identify missing dependencies or gaps
- To check consistency between plan, task files, and status

**Key principle:** Review planning documents to ensure implementation readiness before beginning work. Catches issues that are cheaper to fix in planning than in code.

---

## Usage

**Command:** `/plan-review [feature] [options]`

**Examples:**

- `/plan-review workflow-simplification` — Review entire plan
- `/plan-review workflow-simplification --group 2` — Review only Group 2
- `/plan-review --feature my-feature --check-deps` — Focus on dependencies
- `/plan-review --dry-run` — Show review without creating files

**Options:**

- `--feature [name]` — Specify feature name (overrides auto-detection)
- `--group [N]` — Review only group N (by index in the groups array, 1-based)
- `--check-deps` — Focus on dependency validation
- `--check-tests` — Focus on test plan validation
- `--dry-run` — Show review without creating files

---

## Step-by-Step Process

### 1. Load and Parse Implementation Plan

**What to do:**

1. Locate `implementation-plan.md` using path detection rules above.

2. Parse YAML frontmatter:
   - `task_count` — total number of tasks
   - `groups[]` — array of group objects (name, file, tasks)
   - `tasks_files[]` — list of task group file paths

3. Verify frontmatter integrity:
   - [ ] `task_count` matches the total number of tasks across all groups
   - [ ] Every task number 1 to `task_count` appears exactly once in `groups[].tasks[]`
   - [ ] All files in `tasks_files[]` exist on disk
   - [ ] `groups[].file` paths match `tasks_files[]`

4. Read the checkbox list in the Implementation Plan section:
   - [ ] Count `- [ ]` (incomplete) and `- [x]` (complete) entries
   - [ ] Verify checkbox count matches `task_count`

**If `--group N` specified:** Only load the Nth group file for detailed review.

**Checklist:**

- [ ] Implementation plan found and readable
- [ ] YAML frontmatter parses correctly
- [ ] Frontmatter is internally consistent
- [ ] All referenced task files exist
- [ ] Checkbox counts match task_count

---

### 2. Review Task Group Files

**For each group file (or the specified `--group`):**

1. **Structure check:**
   - [ ] File has proper header (Feature, Group, Status, Last Updated)
   - [ ] `## 📝 Tasks` section exists
   - [ ] Tasks are listed with descriptions
   - [ ] `## 🔗 Dependencies` section exists (can be empty)

2. **Task descriptions:**
   - [ ] Each task has a clear description (not just a title)
   - [ ] Tasks have enough detail for implementation
   - [ ] Goals or acceptance criteria are identifiable

3. **Group sizing:**
   - Flag if a group has >8 tasks (may be too large; consider splitting)
   - Flag if a group has <2 tasks (may be too granular; consider merging)
   - Note: these are warnings, not blockers

4. **Task numbering:**
   - [ ] Task numbers in the group file match the frontmatter `tasks[]` array
   - [ ] No duplicate task numbers
   - [ ] No gaps in numbering

**Checklist:**

- [ ] All group files have required structure
- [ ] Task descriptions are adequate
- [ ] Group sizes are reasonable
- [ ] Task numbering is consistent

---

### 3. Validate Dependencies

**Check inter-task dependencies:**

1. **Within groups:**
   - Are tasks within a group ordered logically?
   - Are internal dependencies satisfiable (earlier task before later)?

2. **Across groups:**
   - Do cross-group dependencies point to tasks in earlier groups?
   - Flag any circular dependencies.
   - Flag any dependency on a task in a later group (potential ordering issue).

3. **External dependencies:**
   - Are there references to external tools, libraries, or configurations?
   - Are those dependencies available or documented?

4. **Prerequisite completion:**
   - For groups with `🟠 In Progress` or `🔴 Not Started` status, are all prerequisite groups complete?

**Checklist:**

- [ ] No circular dependencies
- [ ] Cross-group dependencies are forward-only (earlier groups first)
- [ ] External dependencies documented
- [ ] Prerequisites satisfiable

---

### 4. Check Consistency

**Cross-document consistency:**

1. **Plan vs. Status:**
   - [ ] Checkbox counts in `implementation-plan.md` match progress in `status-and-next-steps.md`
   - [ ] Group statuses in status file reflect actual task completion
   - [ ] Overall progress count is accurate

2. **Plan vs. Task Files:**
   - [ ] Task titles in plan match task descriptions in group files
   - [ ] No orphan tasks (in group file but not in plan)
   - [ ] No phantom tasks (in plan but not in any group file)

3. **Frontmatter vs. Content:**
   - [ ] `task_count` matches actual checkbox count
   - [ ] Group task ranges are contiguous and cover all tasks

**Checklist:**

- [ ] Plan and status are in sync
- [ ] Plan and task files are in sync
- [ ] Frontmatter matches content

---

### 5. Identify Issues and Gaps

**Categories:**

1. **Blockers (must fix before implementation):**
   - Missing task files
   - Broken task numbering
   - Circular dependencies
   - Inconsistent task counts

2. **Warnings (should fix, not blocking):**
   - Oversized groups (>8 tasks)
   - Undersized groups (<2 tasks)
   - Tasks with only a title and no description
   - Stale status indicators
   - Missing dependency sections

3. **Recommendations (optional improvements):**
   - Better task breakdown suggestions
   - TDD pairing opportunities
   - Documentation improvements

---

### 6. Generate Review Report

**Location:**

- **Preferred (local-only):** `.scratch/[feature-or-topic]/plan-review-YYYY-MM-DD.md`
  under the workspace root. Ensure `.scratch/` is in `.gitignore` (do not commit
  plan-reviews into warm scratch or cold repos).
- Dev-infra (legacy / if no `.scratch`): `admin/planning/features/[feature-name]/plan-review-YYYY-MM-DD.md`
- Template project (legacy): `docs/maintainers/planning/features/[feature-name]/plan-review-YYYY-MM-DD.md`

**Report structure:**

```markdown
# Plan Review - [Feature Name]

**Feature:** [Feature Name]
**Status:** 🔴 Not Ready / 🟡 Needs Work / ✅ Ready
**Reviewed:** YYYY-MM-DD
**Scope:** [Full plan / Group N only]

---

## 📋 Plan Structure

- [x] Implementation plan found and parseable
- [x] YAML frontmatter valid
- [x] All [N] task files present
- [x] Task count consistent ([N] tasks)
- [x] Checkbox count matches frontmatter

---

## 📝 Task Group Review

### Group 1: [Name] (Tasks [N-M])
- **Status:** [✅ Complete / 🟠 In Progress / 🔴 Not Started]
- **Task count:** [N] (within recommended range)
- **Descriptions:** [Adequate / Needs detail]
- **Dependencies:** [Validated / Issues found]

### Group 2: [Name] (Tasks [N-M])
...

---

## 🔗 Dependency Validation

- [x] No circular dependencies
- [x] Cross-group dependencies are forward-only
- [x] External dependencies documented
- [x] Prerequisites satisfiable

---

## 🔄 Consistency Check

- [x] Plan ↔ Status in sync
- [x] Plan ↔ Task files in sync
- [x] Frontmatter ↔ Content match

---

## 🔴 Blockers

[None / list of blockers]

## 🟡 Warnings

[None / list of warnings]

## 💡 Recommendations

[None / list of recommendations]

---

## ✅ Readiness Assessment

**Overall:** [Not Ready / Needs Work / Ready]

**Action Items:**
- [ ] [Action 1]
- [ ] [Action 2]

---

**Last Updated:** YYYY-MM-DD
```

If `--dry-run` is specified, display the report in the conversation instead of writing to disk.

**Checklist:**

- [ ] Review document created (or displayed if `--dry-run`)
- [ ] All sections completed
- [ ] Issues categorized (blockers vs warnings vs recommendations)
- [ ] Readiness assessed

---

### 7. Present Summary

**Display to user:**

```
📋 Plan Review Complete — [Feature Name]

   Status: [✅ Ready / 🟡 Needs Work / 🔴 Not Ready]

   Structure:    ✅ Valid
   Task Files:   ✅ [N/N] present
   Dependencies: ✅ No issues
   Consistency:  ✅ In sync

   Blockers:        [0]
   Warnings:        [2]
   Recommendations: [1]

   Review saved: [path/to/plan-review-YYYY-MM-DD.md]

   Next steps:
   - Address warnings (recommended)
   - Run `/task next` to begin implementation
```

If blockers exist, clearly state that implementation should not proceed until they are resolved.

---

## Common Issues

### Issue: Task File Missing

```
❌ BLOCKER: Task file not found: tasks/03-command-logic-updates.md
   Referenced by frontmatter groups[2].file
   Fix: Create the file or update the frontmatter reference.
```

### Issue: Task Count Mismatch

```
❌ BLOCKER: Frontmatter says task_count: 18 but found 16 checkboxes.
   Fix: Update frontmatter or add missing tasks.
```

### Issue: Oversized Group

```
⚠️ WARNING: Group "Template Assets" has 9 tasks (recommended max: 8).
   Consider splitting into two groups for manageability.
```

### Issue: Status Drift

```
⚠️ WARNING: Status file shows 5/18 complete but plan has 3 checked boxes.
   Fix: Sync the status file with the implementation plan.
```

---

## Tips

**Before review:**
- Ensure plan generation is complete (`/transition-plan`)
- Have task group files populated (at least scaffolded)
- Check that status file exists

**During review:**
- Pay special attention to cross-group dependencies
- Verify task descriptions have enough detail for the AI to implement
- Check that TDD tasks are properly paired (RED + GREEN)

**After review:**
- Use `/address-review [path]` to fix identified issues
- Re-run `/plan-review` after addressing blockers
- Proceed to `/task next` when status is ✅ Ready

---

## Related Commands

- `/task` — Implement tasks from the plan
- `/address-review [path]` — Address review gaps
- `/transition-plan` — Generate implementation plans
- `/pre-phase-review` — **Deprecated.** Legacy phase-based review (stub points here)

---

**Last Updated:** 2026-02-19
**Status:** ✅ Active
**Next:** Use before starting implementation to validate plan readiness (uniform structure)
