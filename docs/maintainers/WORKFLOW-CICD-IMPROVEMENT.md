# CI/CD Improvement Workflow

**Purpose:** Guide for improving CI/CD processes and workflows  
**Status:** ✅ Active  
**Last Updated:** [Date]

---

## 📋 Quick Links

- **[Workflow Overview](WORKFLOW-OVERVIEW.md)** - All available workflows
- **[CI/CD Planning](planning/ci/README.md)** - CI/CD improvement overview
- **[Feature Development Workflow](WORKFLOW-FEATURE-DEVELOPMENT.md)** - Feature implementation workflow

---

## 🎯 Overview

The CI/CD Improvement workflow guides you through improving CI/CD processes, workflows, and automation. This workflow focuses on process/documentation improvements rather than code implementation, and uses a different structure than feature development.

### Workflow Sequence

```
Improvement Plan → Phase Planning → Implementation → PR → Merge
       ↓                ↓                ↓           ↓      ↓
    Create      /task-improvement  /task-improvement  /pr   /post-pr
```

### When to Use

- **CI/CD process improvements** - When improving CI/CD workflows
- **Automation enhancements** - When adding or improving automation
- **Documentation updates** - When updating CI/CD documentation
- **Workflow integration** - When integrating new workflows

---

## 🚀 Quick Start

### Step 1: Create Improvement Plan

Create an improvement plan document:

**File:** `planning/ci/[improvement-name]/improvement-plan.md`

**Key sections:**
- Improvement overview
- Success criteria
- Implementation phases
- Process changes

### Step 2: Create Phase Documents

Break improvement into phases:

**File:** `planning/ci/[improvement-name]/phase-N.md`

**Each phase includes:**
- Phase goals
- Tasks (process/documentation focused)
- Completion criteria

### Step 3: Implement Phases

Use `/task-improvement` command to implement phases:

```bash
/task-improvement [phase-number] [task-number] --improvement [improvement-name]
```

**Example:**
```bash
/task-improvement 1 1 --improvement status-tracking-automation
```

**Output:**
- Tasks implemented following process/documentation workflow
- Status automatically updated
- Commits made to improvement branch

### Step 4: Create PR

After completing all tasks in a phase:

```bash
/pr --ci-improvement [improvement-name] --phase [phase-number]
```

**Example:**
```bash
/pr --ci-improvement status-tracking-automation --phase 1
```

**Output:**
- PR created with comprehensive description
- Status validation performed
- Ready for review

### Step 5: Post-Merge Updates

After PR is merged:

```bash
/post-pr [pr-number] --ci-improvement [improvement-name] --phase [phase-number]
```

**Example:**
```bash
/post-pr 42 --ci-improvement status-tracking-automation --phase 1
```

**Output:**
- Status documents updated
- Phase marked complete
- Improvement progress updated

---

## 📖 Detailed Workflow

### Phase 1: Improvement Planning

**Purpose:** Plan CI/CD improvement structure, phases, and approach

**Activities:**

1. **Create improvement plan**
   - File: `planning/ci/[improvement-name]/improvement-plan.md`
   - Document improvement overview
   - Define success criteria
   - Break into phases

2. **Create phase documents**
   - File: `planning/ci/[improvement-name]/phase-N.md`
   - Define phase goals
   - List tasks (process/documentation focused)
   - Set completion criteria

**Key principles:**
- Focus on process/documentation improvements
- Break work into manageable phases
- Define clear success criteria
- Plan workflow integration

**Differences from Feature Development:**

- **No status-and-next-steps.md** - CI/CD improvements don't use this file
- **Process/documentation focus** - Less code, more process
- **Different branch naming** - `ci/[improvement-name]-phase-N` format
- **Different command** - Use `/task-improvement` instead of `/task-phase`

**Next step:** Begin implementation with `/task-improvement`

---

### Phase 2: Implementation

**Purpose:** Implement CI/CD improvement phases using process/documentation workflow

**Command:** `/task-improvement [phase-number] [task-number] --improvement [improvement-name]`

**Workflow:**

1. **Start phase**
   ```bash
   /task-improvement 1 1 --improvement status-tracking-automation
   ```
   - Creates improvement branch (if first task)
   - Implements task group (related process/documentation tasks)

2. **Continue with next task group**
   ```bash
   /task-improvement 1 3 --improvement status-tracking-automation
   ```
   - Implements next task group
   - Commits work
   - Updates phase document

3. **Complete phase**
   - All tasks completed
   - Status auto-updated to "Complete"
   - Ready for PR creation

**Task Grouping:**

- **Related tasks** grouped together (e.g., all documentation updates for one command)
- Different components separated (documentation vs. process integration)
- Complete task group before moving to next

**Process/Documentation Focus:**

- **Documentation updates** - Update command docs, guides
- **Process improvements** - Create process guides, workflows
- **Workflow integration** - Integrate with existing workflows
- **Less code** - Focus on process, not implementation

**Status Updates:**

- Status updated automatically at phase start
- Status updated automatically at phase completion
- Phase document updated as tasks complete

**Next step:** Create PR with `/pr --ci-improvement`

---

### Phase 3: Pull Request

**Purpose:** Create PR for completed phase

**Command:** `/pr --ci-improvement [improvement-name] --phase [phase-number]`

**Workflow:**

1. **Create PR**
   ```bash
   /pr --ci-improvement status-tracking-automation --phase 1
   ```
   - Validates status updates
   - Creates PR description
   - Pushes branch and creates PR

2. **Review Process**
   - External review (if available)
   - Address CRITICAL/HIGH issues
   - Get approval

3. **Merge**
   - Merge PR to develop
   - Run `/post-pr` to update status

**PR Description Includes:**

- Improvement summary
- What's included
- Process changes
- Related documents

**Status Validation:**

- Verifies phase status is current
- Checks improvement progress
- Ensures documentation complete

**Next step:** Post-merge updates with `/post-pr`

---

### Phase 4: Post-Merge Updates

**Purpose:** Update status documents after PR merge

**Command:** `/post-pr [pr-number] --ci-improvement [improvement-name] --phase [phase-number]`

**Workflow:**

1. **Update status**
   ```bash
   /post-pr 42 --ci-improvement status-tracking-automation --phase 1
   ```
   - Updates phase document with PR number
   - Updates improvement progress
   - Documents next steps

2. **Continue to next phase**
   - Start next phase with `/task-improvement`
   - Repeat implementation → PR → merge cycle

**Status Updates:**

- Phase marked complete with PR number
- Improvement progress updated
- Next steps documented

**Next step:** Continue with next phase or complete improvement

---

## 🔄 CI/CD vs Feature Structure Differences

### Structure Differences

**Feature Development:**
- Path: `planning/features/[feature-name]/`
- Status file: `status-and-next-steps.md`
- Branch: `feat/phase-N-[description]`
- Command: `/task-phase`

**CI/CD Improvement:**
- Path: `planning/ci/[improvement-name]/`
- No status file (different structure)
- Branch: `ci/[improvement-name]-phase-N`
- Command: `/task-improvement`

### Workflow Differences

**Feature Development:**
- TDD workflow (RED → GREEN → REFACTOR)
- Code implementation focus
- Test-driven development

**CI/CD Improvement:**
- Process/documentation workflow
- Process improvement focus
- Documentation and workflow integration

### Command Differences

**Feature Development:**
```bash
/task-phase 1 1
/pr --phase 1
/post-pr 42 --phase 1
```

**CI/CD Improvement:**
```bash
/task-improvement 1 1 --improvement [name]
/pr --ci-improvement [name] --phase 1
/post-pr 42 --ci-improvement [name] --phase 1
```

---

## 💡 Best Practices

### Improvement Planning

- **Focus on process** - CI/CD improvements are about process, not code
- **Break into phases** - Manageable chunks of work
- **Define success criteria** - Clear goals for each phase
- **Plan workflow integration** - How does this integrate with existing workflows?

### Implementation

- **One task group at a time** - Focus on current work
- **Complete related tasks** - Group related documentation/process updates
- **Commit frequently** - Small, logical commits
- **Update documentation** - Keep documentation current

### Pull Requests

- **Complete phase before PR** - All tasks done
- **Validate status** - Ensure status is current
- **Comprehensive description** - Document process changes
- **Address feedback** - Fix CRITICAL/HIGH issues

### Status Updates

- **Automatic updates** - Commands handle status updates
- **Manual updates** - Update during work if needed
- **Post-merge updates** - Use `/post-pr` after merge
- **Keep current** - Status should reflect reality

---

## 🔄 Workflow Integration

### Integration with Feature Development

CI/CD improvements support feature development:

```
CI/CD Improvement → Feature Development
       ↓                    ↓
  /task-improvement    /task-phase
```

### Integration with Commands

All phases integrate with Cursor commands:

- **`/task-improvement`** - Implements phases with process/documentation workflow
- **`/pr`** - Creates PRs for completed phases
- **`/post-pr`** - Updates status after merge

### Document Organization

Documents follow hub-and-spoke pattern:

- **Hub files** - `README.md` files provide navigation
- **Spoke documents** - Phase documents focus on specific work
- **Status tracking** - Consistent status indicators

---

## 📊 Workflow Diagram

```
┌─────────────────┐
│Improvement Plan │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     /task-improvement
│   Phase 1       │ ────────────────────┐
└────────┬────────┘                     │
         │                               │
         ▼                               │
┌─────────────────┐     /pr             │
│   PR #42        │ ────────────────────┤
└────────┬────────┘                     │
         │                               │
         ▼                               │
┌─────────────────┐     /post-pr        │
│    Merge        │ ────────────────────┤
└────────┬────────┘                     │
         │                               │
         ▼                               │
┌─────────────────┐     /task-improvement
│   Phase 2       │ ────────────────────┤
└────────┬────────┘                     │
         │                               │
         ▼                               │
┌─────────────────┐
│   Complete      │
└─────────────────┘
```

---

## ❓ Common Questions

### How do I start a new CI/CD improvement?

1. Create improvement plan: `planning/ci/[improvement-name]/improvement-plan.md`
2. Create phase documents: `planning/ci/[improvement-name]/phase-N.md`
3. Start implementation: `/task-improvement 1 1 --improvement [name]`

### How is this different from feature development?

- **Structure:** Different paths (`planning/ci/` vs `planning/features/`)
- **Focus:** Process/documentation vs code implementation
- **Command:** `/task-improvement` vs `/task-phase`
- **Branch:** `ci/[name]-phase-N` vs `feat/phase-N`

### How do I group tasks?

- **Group together:** Related documentation/process updates
- **Separate:** Different components (documentation vs. process integration)
- **Complete task group** before moving to next

### When do I create a PR?

- After completing **all tasks** in a phase
- Use `/pr --ci-improvement [name] --phase [N]` command
- Status must be current before PR

### How do I update status?

- **Automatic:** Commands update status automatically
- **Manual:** Update during work if needed
- **Post-merge:** Use `/post-pr` after merge

---

## 🔗 Related Documentation

### Workflow Guides

- [Workflow Overview](WORKFLOW-OVERVIEW.md) - All workflows
- [Feature Development Workflow](WORKFLOW-FEATURE-DEVELOPMENT.md) - Feature implementation
- [Exploration/Research/Decision Workflow](WORKFLOW-EXPLORATION-RESEARCH-DECISION.md) - Discovery workflow

### Command Documentation

- `/task-improvement` - CI/CD improvement implementation command
- `/pr` - PR creation command
- `/post-pr` - Post-merge status updates

---

**Last Updated:** [Date]  
**Status:** ✅ Active  
**Next:** Create improvement plan and start with `/task-improvement 1 1 --improvement [name]`

