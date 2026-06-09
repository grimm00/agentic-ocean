# Task Improvement Command

Use this command to implement CI/CD improvement phase tasks step-by-step, following process/documentation workflow. Focuses on documentation updates, process improvements, and workflow integration rather than code implementation.

---

## Configuration

**Phase Path Detection:**

This command supports CI/CD improvement phase organization:

- **CI/CD Improvement Phases:**
  - Path: `docs/maintainers/planning/ci/[improvement-name]/phase-N.md`
  - Improvement name auto-detected from context or configuration
  - Example: `docs/maintainers/planning/ci/status-tracking-automation/phase-1.md`
  - Use `--improvement [name]` option to specify improvement name

**Note:** This command is for CI/CD improvements only (under `planning/ci/`). For feature implementation, use `/task` which reads the uniform planning structure (`implementation-plan.md` + `tasks/`). See [Migration Guide](../../docs/MIGRATION-v0.10.md).

**Improvement Detection:**

- Use `--improvement` option if provided
- Otherwise, auto-detect:
  - Check if `docs/maintainers/planning/ci/` exists
  - If multiple improvements exist, search for phase documents in each
  - If single improvement exists, use that improvement name
  - If no improvements exist, prompt user or error

**Phase Structure Support:**

- Numbered phases: `phase-1.md`, `phase-2.md` (default)
- Named phases: `phase-[name].md` (if configured)

**Branch Naming:**

- Default format: `ci/[improvement-name]-phase-N-[description]`
- Examples: `ci/status-tracking-automation-phase-1`, `ci/documentation-validation-phase-2`

**Task Grouping:**

- Default: Related tasks grouped together
- Process/documentation tasks typically standalone
- Group related documentation updates together

---

## Workflow Overview

**Pattern:**
1. Phase has multiple tasks (process/documentation focused)
2. **Task Grouping:** Related tasks grouped together (e.g., all documentation updates for a section)
3. Implement the task group completely
4. Commit the work
5. Stop and wait for user to invoke command again for next task group
6. Create PR only after completing ALL tasks in phase (use `/pr --ci-improvement [name] --phase [N]` command)

**Task Grouping Rules:**

- **Group together:** Related documentation updates (e.g., all updates to one command)
- **Group together:** Related process steps (e.g., all workflow integration steps)
- **Separate:** Different components (e.g., documentation vs. process integration)
- **Separate:** Large/complex tasks that benefit from review

**Examples:**

- Task 1 (Update Command A Documentation) + Task 2 (Update Command B Documentation) = **One invocation** (if related)
- Task 3 (Create Process Guide) = **Separate invocation** (different component)
- Task 4 (Integrate with Workflow) = **Separate invocation** (different component)

**When to create PR:**

- After completing the LAST task in the phase
- Use `/pr --ci-improvement [name] --phase [N]` command for complete PR workflow
- Before marking phase as complete
- After manual verification (if applicable)

**Key Principle:** Group related process/documentation tasks, but separate different components. Complete the task group, commit it, then stop. User will invoke command again for the next task group.

---

## Usage

**Command:** `/task-improvement [phase-number] [task-number] [options]`

**Examples:**

- `/task-improvement 1 1` - Implement Phase 1, Tasks 1-2 (related documentation updates)
- `/task-improvement 1 3` - Implement Phase 1, Task 3 (process guide creation)
- `/task-improvement 2 1 --improvement status-tracking-automation` - Specify improvement name
- `/task-improvement 1 1 --improvement documentation-validation` - Different improvement

**Task Grouping:**

- When you specify a task, check if next tasks are related
- Different task types (documentation vs. process) are separate invocations
- Check phase document to identify natural groupings

**Options:**

- `--improvement [name]` - Specify improvement name (overrides auto-detection)

**Important:** 
- This command handles **one task group at a time** (typically related process/documentation tasks)
- After completing a task group, stop and wait for user to invoke again for next group
- Do NOT continue to next task group automatically
- Use `/pr --ci-improvement [name] --phase [N]` command when all tasks are complete to create PR

---

## Step-by-Step Process

### 1. Start a Phase Task

**What to do:**

1. **Detect improvement structure:**
   - Use `--improvement` option if provided
   - Otherwise, auto-detect:
     - Check if `docs/maintainers/planning/ci/` exists
     - If multiple improvements exist, search for phase documents in each
     - If single improvement exists, use that improvement name
     - If no improvements exist, prompt user or error

2. **Read the phase document:**
   - CI/CD improvement: `docs/maintainers/planning/ci/[improvement-name]/phase-N.md`
   - Support alternative structures: `milestone-N.md`, `sprint-N.md` (if configured)

3. **Identify the current task** (numbered in the document)

4. **Check prerequisites** (previous tasks, phase status)

5. **Create improvement branch if starting phase:**
   - Default: `ci/[improvement-name]-phase-N-[description]`
   - Configurable via project configuration

**Branch naming:**

- First task: `ci/[improvement-name]-phase-N-[description]` (e.g., `ci/status-tracking-automation-phase-1`)
- Subsequent tasks: Use same branch

**Checklist:**

- [ ] Improvement structure detected
- [ ] Phase document read and understood
- [ ] Prerequisites met (previous phase complete)
- [ ] Improvement branch created (if first task)
- [ ] Current task identified and understood

---

### 2. Implement Task Group Following Process/Documentation Workflow

**Process/Documentation Pattern (not TDD):**

**For documentation updates:**

- [ ] Read existing documentation
- [ ] Identify what needs updating
- [ ] Make documentation updates
- [ ] Review for clarity and completeness
- [ ] Commit: `docs(ci/[improvement-name]): update [documentation description]`

**For process improvements:**

- [ ] Review current process
- [ ] Identify improvement needed
- [ ] Document new process
- [ ] Update workflow documentation
- [ ] Test process (if applicable)
- [ ] Commit: `feat(ci/[improvement-name]): improve [process description]`

**For workflow integration:**

- [ ] Review workflow documentation
- [ ] Identify integration points
- [ ] Update workflow documentation
- [ ] Update command documentation (if applicable)
- [ ] Test integration (if applicable)
- [ ] Commit: `feat(ci/[improvement-name]): integrate [workflow description]`

**Task-specific patterns:**

**Documentation Updates:**

1. Read existing documentation
2. Identify sections to update
3. Make updates following project style
4. Review for clarity and completeness
5. Verify links work
6. Commit

**Process Documentation:**

1. Review current process
2. Document new/improved process
3. Add examples and best practices
4. Update related documentation
5. Review for completeness
6. Commit

**Workflow Integration:**

1. Review workflow documentation
2. Identify integration points
3. Update workflow steps
4. Update command documentation
5. Add validation steps
6. Commit

---

### 3. Commit Strategy

**IMPORTANT:** Always commit work before stopping or moving to next task group.

**Reference:** [Commit Workflow](../../docs/COMMIT-WORKFLOW.md) - Central commit workflow documentation

**For code/workflow changes (scripts, integrations, automation):**

Use `/review` to review changes before committing. This forces a deliberate pause to verify agentic changes.

```
[AI implements improvement]
    ↓
/review [task-description]   ← Review in a separate prompt
    ↓ human review
/commit                      ← Commit reviewed changes
```

**For documentation-only changes (process docs, checklists, templates):**

Direct commit is fine -- no review pause needed.

```bash
git commit -m "docs(ci/status-tracking-automation): add status update reminders to task-phase command"
```

**Commit Message Format:**
- Follow standard format: `type(scope): brief description`
- Include "Related:" line for context
- See [Commit Workflow](../../docs/COMMIT-WORKFLOW.md#commit-message-format) for complete format

**Examples:**
```bash
# Code/workflow changes -- use /review + /commit
# feat(ci/status-tracking-automation): integrate status checks into PR workflow

# Doc changes -- direct commit is fine
git commit -m "docs(ci/documentation-validation): create validation checklist template"
```

**Before Stopping:**
- [ ] Check `git status` for uncommitted changes
- [ ] Use `/review` for code/workflow changes, direct commit for docs-only
- [ ] Push to remote if on feature branch
- [ ] Verify no uncommitted changes remain

---

### 4. Check Task Completion

**After implementing a task:**

- [ ] All tasks for this group complete
- [ ] Documentation follows project patterns
- [ ] Links verified (if documentation)
- [ ] Process documented clearly
- [ ] Manual verification done (if applicable)
- [ ] Task checklist items completed
- [ ] Committed to improvement branch

**Update improvement plan:**

- Mark phase status in `improvement-plan.md` if phase complete
- Don't commit improvement plan changes until phase complete

**Improvement plan location:**

- `docs/maintainers/planning/ci/[improvement-name]/improvement-plan.md`

---

### 5. Stop After Task Group Completion

**After completing a task group:**

- [ ] Task group fully implemented
- [ ] All commits made to improvement branch
- [ ] Documentation/process verified
- [ ] **STOP - Do NOT proceed to next task group**
- [ ] Present completion summary to user
- [ ] Indicate which tasks were completed (e.g., "Tasks 1-2 complete: Documentation updates")
- [ ] Remind user: "Use `/review` to review code/workflow changes before committing"
- [ ] Wait for user to invoke command again for next task group

**Important:** This command handles ONE task group at a time (typically related process/documentation tasks). The user will invoke the command again with the next task number when ready to continue.

---

### 6. Complete All Tasks - Create PR

**When ALL tasks in phase are done:**

**Pre-PR Checklist:**

- [ ] All tasks completed
- [ ] Documentation reviewed
- [ ] Links verified (if documentation)
- [ ] Process documented clearly
- [ ] Manual verification complete (if applicable)
- [ ] Phase document updated (all tasks marked complete)
- [ ] Improvement plan updated (phase status)
- [ ] No linter errors (if applicable)

**Create PR:**

1. Push final commits to improvement branch
2. Run Sourcery review: `dt-review` from dev-toolkit (if available)
3. Fill out priority matrix in `docs/maintainers/feedback/sourcery/pr##.md` (if review available)
4. Address any CRITICAL/HIGH issues before PR
5. Create PR with comprehensive description

**PR Title Format:**

```
ci: [Phase N Description] ([Improvement Name] - Phase N)
```

**PR Description Template:**

```markdown
## CI/CD Improvement: [Improvement Name] - Phase N

[Brief description of what was implemented]

---

## What's Included

### [Component 1]
- Process/change description
- Documentation updates
- Files modified

### [Component 2]
- Process/change description
- Documentation updates
- Files modified

---

## Testing

- [ ] Documentation reviewed
- [ ] Links verified (if applicable)
- [ ] Process documented clearly
- [ ] Manual verification complete (if applicable)
- [ ] Sourcery review completed (if applicable)

---

## Related

- **Phase Plan:** `docs/maintainers/planning/ci/[improvement-name]/phase-N.md`
- **Improvement Plan:** `docs/maintainers/planning/ci/[improvement-name]/improvement-plan.md`
```

**After PR Created:**

- [ ] Present PR link to user (DO NOT auto-merge)
- [ ] Wait for external review (dt-review, if available)
- [ ] Address CRITICAL/HIGH issues
- [ ] Get user approval before merge

---

## Task Detection Logic

**How to identify tasks:**

Tasks are typically numbered in phase documents:

- `#### 1. Update Command Documentation`
- `#### 2. Create Process Guide`
- `#### 3. Integrate with Workflow`
- etc.

**Task boundaries:**

- Each numbered section is a task
- Tasks may have sub-items (checkboxes)
- Complete all sub-items before moving to next task

**Last task detection:**

- Check if there are more numbered tasks after current
- Look for "Completion Criteria" section (comes after all tasks)
- If no more tasks, it's time to create PR

---

## Common Patterns

### Pattern 1: Documentation Update Task

**Task:** "Update Command Documentation"

**Steps:**

1. Read existing command documentation
2. Identify sections to update
3. Make updates following project style
4. Review for clarity
5. Verify links work
6. Commit

**Files typically modified:**

- `.cursor/commands/[command-name].md` (command documentation)
- `docs/[guide-name].md` (user guides)
- `README.md` files (hub files)

### Pattern 2: Process Documentation Task

**Task:** "Create Process Guide"

**Steps:**

1. Review current process (if exists)
2. Document new/improved process
3. Add examples and best practices
4. Update related documentation
5. Review for completeness
6. Commit

**Files typically created/modified:**

- `docs/[process-guide].md` (new process guide)
- `docs/[workflow-guide].md` (workflow documentation)
- Related README.md files

### Pattern 3: Workflow Integration Task

**Task:** "Integrate with PR Workflow"

**Steps:**

1. Review workflow documentation
2. Identify integration points
3. Update workflow steps
4. Update command documentation
5. Add validation steps
6. Test integration (if applicable)
7. Commit

**Files typically modified:**

- `.cursor/commands/[command-name].md` (command documentation)
- `docs/[workflow-guide].md` (workflow documentation)
- Workflow configuration files (if applicable)

---

## Error Handling

**If documentation unclear:**

- Review existing documentation patterns
- Check project style guide
- Ask for clarification if needed
- Don't proceed until clear

**If process unclear:**

- Review existing processes
- Check improvement plan for context
- Document assumptions
- Review with user if needed

**If phase document not found:**

- Check improvement detection logic
- Verify phase structure (numbered vs named)
- Use `--improvement` option to specify improvement name
- Verify improvement exists

---

## Phase Completion Checklist

**Before marking phase complete:**

- [ ] All tasks completed
- [ ] Documentation reviewed
- [ ] Links verified (if applicable)
- [ ] Process documented clearly
- [ ] Manual verification done (if applicable)
- [ ] PR created and reviewed
- [ ] Sourcery review completed (if available)
- [ ] CRITICAL/HIGH issues addressed
- [ ] PR merged to develop
- [ ] Phase document status updated to "✅ Complete"
- [ ] Improvement plan status updated (if needed)

---

## Tips

**While implementing:**

- Focus on ONE task group (typically related process/documentation tasks)
- Keep phase document open for reference
- Check off items as you complete them
- Review documentation for clarity
- Verify links work (if documentation)
- Commit frequently (small commits)
- Push to branch regularly

**Task grouping:**

- Related documentation updates naturally belong together
- Complete the full task group before stopping
- Different components (documentation vs. process) are separate

**After completing task group:**

- **STOP - Do NOT continue to next task group**
- Present summary of what was accomplished
- Indicate which tasks were completed (e.g., "Tasks 1-2 complete")
- Wait for user to invoke command again

**Important reminders:**

- One task group per invocation (typically related process/documentation tasks)
- Complete task group fully before stopping
- Don't proceed to next task group automatically
- Use `/pr --ci-improvement [name] --phase [N]` when all tasks done

---

## Reference

**Phase Documents:**

- CI/CD improvement: `docs/maintainers/planning/ci/[improvement-name]/phase-N.md`

**Improvement Planning:**

- `docs/maintainers/planning/ci/[improvement-name]/improvement-plan.md`
- `docs/maintainers/planning/ci/[improvement-name]/README.md`

**Workflow:**

- Git Flow: See workflow rules
- PR Review: See workflow rules (Pull Request Review Workflow section)

**Related Commands:**

- `/pr --ci-improvement [name] --phase [N]` - Create PR for completed phase
- `/transition-plan --type ci-cd [improvement-name]` - Create transition plan from improvement plan
- `/reflect` - Reflect on improvement progress (if available)

---

**Last Updated:** 2025-12-07  
**Status:** ✅ Active  
**Next:** Use to implement CI/CD improvement phase tasks following process/documentation workflow

