# Transition Plan Command

Creates transition planning documents from reflection artifacts or directly from reflection documents. Plans the next stage of the project (feature, release, infrastructure) based on reflection insights.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Feature-Specific Structure (default):**

   - Artifacts: `docs/maintainers/planning/features/[feature-name]/feature-plan.md`
   - Transition plans: `docs/maintainers/planning/features/[feature-name]/transition-plan.md`

2. **Project-Wide Structure:**
   - Artifacts: `docs/maintainers/planning/releases/[version]/checklist.md`
   - Transition plans: `docs/maintainers/planning/releases/[version]/transition-plan.md`

**Feature Detection:**

- Use `--feature` option if provided
- Otherwise, auto-detect:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for artifact files in each
  - If no features exist, use project-wide structure

**Artifact Paths:**

- **Release Artifacts:** `docs/maintainers/planning/releases/[version]/checklist.md` or `release-notes.md`
- **Feature Artifacts:** `docs/maintainers/planning/features/[feature-name]/feature-plan.md`
- **CI/CD Artifacts:** `docs/maintainers/planning/ci/[improvement-name]/improvement-plan.md`
- **Infrastructure Artifacts:** `docs/maintainers/planning/infrastructure/[improvement-name]/improvement-plan.md` (if exists)

---

## Workflow Overview

**When to use:**

- After creating reflection artifacts with `/reflection-artifacts`
- After creating ADRs with `/decision` command
- To plan transition to next stage (feature, release, infrastructure)
- When ready to move from reflection to implementation planning

**Workflow:** Setup → Human Review → Expand → Implement

**Key principle:** Transform reflection artifacts into actionable transition plans ready for implementation, following established planning patterns. For feature transitions, also create detailed phase documents (`phase-#.md`) following work-prod's comprehensive phase structure.

**Two Modes:**

### Setup Mode (Default)

Creates scaffolding documents (~60-80 lines per phase) with structure but not detail.

**When to use:**

- First run on a new transition
- After creating ADRs with `/decision`
- To review phase breakdown before adding detail

**Output:**

- `transition-plan.md` - Transition overview
- `phase-N.md` files - Phase scaffolding (goals, criteria, dependencies)

**Status Indicator:** Phase documents show `🔴 Scaffolding (needs expansion)`

```
/transition-plan --from-adr decisions/[topic]/
  → Reads ADR and requirements documents
  → Creates transition-plan.md
  → Creates phase scaffolding documents
  → Outputs: Scaffolding ready for human review
```

### Expand Mode (`--expand`)

Fills scaffolding with detailed TDD tasks, code examples, and implementation notes.

**When to use:**

- After reviewing scaffolding structure
- When ready to add implementation detail
- Before starting `/task-phase` implementation

**Flags:**

- `--phase N` - Expand specific phase only
- `--all` - Expand all phases at once

**Output:**

- Updated `phase-N.md` files (~200-300 lines with TDD detail)

**Status Indicator:** Phase documents show `✅ Expanded`

```
/transition-plan [topic] --expand --phase N
  → Reads existing phase scaffolding
  → Fills in TDD tasks (RED → GREEN → REFACTOR)
  → Adds code examples and implementation notes
  → Updates phase status to Expanded
  → Commits changes
```

---

## Usage

**Command:** `/transition-plan [--from-artifacts|--from-reflection|--from-adr] [options]`

**Setup Mode Examples (default):**

- `/transition-plan --from-adr decisions/auth-system/` - Create scaffolding from ADRs
- `/transition-plan --from-artifacts releases/v0.1.0/checklist.md` - Create scaffolding from artifact
- `/transition-plan --from-reflection reflection-2025-12-07-mvp-complete.md` - Create scaffolding from reflection (auto-generates artifacts first)
- `/transition-plan --dry-run` - Preview scaffolding without creating files
- `/transition-plan --type release` - Force release transition type
- `/transition-plan --type feature` - Force feature transition type
- `/transition-plan --feature my-feature` - Specify feature name

**Expand Mode Examples:**

- `/transition-plan auth-system --expand --phase 1` - Expand specific phase with TDD detail
- `/transition-plan auth-system --expand --phase 2` - Expand phase 2
- `/transition-plan auth-system --expand --all` - Expand all phases at once

**Setup Mode Options:**

- `--from-reflection FILE` - Use reflection file (auto-generates artifacts first, then creates plans)
- `--from-artifacts PATH` - Use specific artifact file (e.g., `releases/v0.1.0/checklist.md`)
- `--from-adr PATH` - Use ADR document (e.g., `decisions/auth-system/adr-001-auth-system.md`)
- `--requirements PATH` - Use requirements document (optional, auto-detected if exists in research directory)
- `--feature [name]` - Specify feature name (overrides auto-detection)
- `--type TYPE` - Force transition type (`feature`, `release`, `ci-cd`, `infrastructure`, `auto`)
- `--dry-run` - Show transition plan without creating files

**Expand Mode Options:**

- `--expand` - Enter expand mode (fill scaffolding with detail)
- `--phase N` - Expand specific phase number (use with `--expand`)
- `--all` - Expand all scaffolding phases (use with `--expand`)

---

## Setup Mode Workflow

Creates scaffolding documents. For detailed expansion, use `--expand` flag (see Expand Mode Workflow).

### Mode Selection

**Input sources (all produce scaffolding in Setup Mode):**

1. **Artifact Mode:** `/transition-plan --from-artifacts [path]`
   - Reads artifact files created by `/reflection-artifacts`
   - Creates scaffolding documents

2. **Reflection Mode:** `/transition-plan --from-reflection [file]`
   - Reads reflection document
   - Internally calls `/reflection-artifacts` first
   - Then creates scaffolding from artifacts

3. **ADR Mode:** `/transition-plan --from-adr [path]`
   - Reads ADR document from `/decision` command
   - Automatically reads requirements if they exist in research directory
   - Creates scaffolding documents

**All modes create scaffolding documents. Use `--expand` to add detail.**

**If `--from-reflection` is specified, skip to "From Reflection Mode" section below.**  
**If `--from-adr` is specified, skip to "From ADR Mode" section below.**

---

### 1. Identify Artifact File (Artifact Mode)

**Detect feature name:**

- Use `--feature` option if provided
- Otherwise, auto-detect:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for artifact files in each
  - If no features exist, use project-wide structure

**Default behavior:**

- If no artifact specified, look for latest artifacts in planning directories
- Check `docs/maintainers/planning/releases/` for latest release
- Check `docs/maintainers/planning/features/[feature-name]/` for latest feature
- Use most recent artifact

**Manual specification:**

- Use provided artifact path
- Verify artifact file exists and is readable

**Commands:**

```bash
# Find latest release artifact
ls -t docs/maintainers/planning/releases/v*/checklist.md | head -1

# Find latest feature artifact (feature-specific)
ls -t docs/maintainers/planning/features/[feature-name]/feature-plan.md | head -1

# Find latest feature artifact (project-wide)
ls -t docs/maintainers/planning/features/*/feature-plan.md | head -1

# Check if artifact exists
ls docs/maintainers/planning/releases/v0.1.0/checklist.md
```

**Checklist:**

- [ ] Feature name detected or specified
- [ ] Artifact file identified (or using default)
- [ ] File exists and is readable
- [ ] Artifact type determined (release, feature, ci-cd, infrastructure)

---

### 2. Determine Transition Type

**Auto-detection logic:**

1. **Release Transition:**

   - Artifact path contains `releases/`
   - Artifact filename is `checklist.md` or `release-notes.md`
   - Artifact content mentions "release", "version", "tag"

2. **Feature Transition:**

   - Artifact path contains `features/`
   - Artifact filename is `feature-plan.md`
   - Artifact content mentions "feature", "implementation", "phases"

3. **CI/CD Transition:**

   - Artifact path contains `ci/`
   - Artifact filename is `improvement-plan.md`
   - Artifact content mentions "ci", "cd", "pipeline", "automation"

4. **Infrastructure Transition:**
   - Artifact path contains `infrastructure/`
   - Artifact filename is `improvement-plan.md`
   - Artifact content mentions "infrastructure", "monitoring", "logging"

**Manual override:**

- Use `--type` option to force specific type
- Useful when auto-detection is ambiguous

**Checklist:**

- [ ] Transition type determined (or forced with `--type`)
- [ ] Type is appropriate for artifact
- [ ] Type matches project needs

---

### 3. Parse Artifact Content

**Extract from artifact:**

- Overview/description
- Success criteria
- Implementation steps
- Next steps
- Priority and effort
- Benefits

**Parse implementation steps:**

- Extract actionable steps
- **Extract ALL phases** from artifact (Phase 1, Phase 2, Phase 3, etc.)
- Organize into logical phases (if feature)
- Preserve phase structure, goals, tasks, deliverables, and effort estimates
- Identify dependencies between phases
- Estimate effort per phase

**Example parsing:**

```markdown
## Implementation Steps

1. Create release directory structure
2. Create release checklist template
3. Create release notes template
4. Document version tagging process
5. Prepare MVP release (v0.1.0)
```

**For Feature Artifacts with Phases:**

- Extract **ALL phases** from artifact (e.g., Phase 1, Phase 2, Phase 3, Phase 4, etc.)
- Preserve phase structure: Goal, Tasks, Deliverables, Estimated Effort
- Include prerequisites between phases
- Maintain phase numbering and naming

**Checklist:**

- [ ] Artifact content parsed
- [ ] **ALL phases extracted** (not just Phase 1 and Phase 2)
- [ ] Implementation steps extracted
- [ ] Phase structure preserved (goals, tasks, deliverables, effort)
- [ ] Dependencies identified
- [ ] Effort estimated

---

### 4. Create Transition Planning Documents

Creates the main `transition-plan.md` file with phase summaries.

**Note:** Phase details are in separate `phase-N.md` scaffolding files. See "5. Create Phase Scaffolding Documents" below.

**For Release Transition:**

**Location:** `docs/maintainers/planning/releases/vX.Y.Z/`

**Documents created:**

- `transition-plan.md` - Detailed transition plan
- Update `checklist.md` - Add transition-specific checklist items

**Transition Plan Template:**

```markdown
# Release Transition Plan - vX.Y.Z

**Version:** vX.Y.Z  
**Status:** 🔴 Not Started  
**Created:** YYYY-MM-DD  
**Source:** [artifact-file]  
**Type:** Release

---

## Overview

[Extracted from artifact overview]

## Transition Goals

[Extracted from artifact success criteria]

## Pre-Transition Checklist

- [ ] All prerequisites met
- [ ] Release artifacts reviewed
- [ ] Release checklist complete
- [ ] Release notes prepared

## Transition Steps

[Extracted from artifact implementation steps, organized chronologically]

**IMPORTANT:** Extract **ALL steps** from the artifact. Do not limit to just 2 steps.

1. **Step 1: [Name]**

   - [ ] Task 1
   - [ ] Task 2
   - Estimated: [X] hours

2. **Step 2: [Name]**

   - [ ] Task 1
   - [ ] Task 2
   - Estimated: [X] hours

3. **Step 3: [Name]**
   - [ ] Task 1
   - [ ] Task 2
   - Estimated: [X] hours

[Continue extracting ALL steps from artifact. Include Step 3, Step 4, Step 5, etc. as they exist in the artifact.]

## Post-Transition

- [ ] Release tagged
- [ ] Release notes published
- [ ] Documentation updated
- [ ] Monitoring active (if applicable)

## Definition of Done

- [ ] All transition steps complete
- [ ] Release successful
- [ ] Post-transition tasks complete
- [ ] Ready for next stage
```

---

**For Feature Transition:**

**Location:** `docs/maintainers/planning/features/[feature-name]/`

**Documents created:**

- `transition-plan.md` - Detailed transition plan
- `phase-1.md`, `phase-2.md`, `phase-3.md`, etc. - Detailed phase documents (one per phase)
- Update `feature-plan.md` - Add transition-specific details

**Transition Plan Template:**

```markdown
# Feature Transition Plan - [Feature Name]

**Feature:** [Feature Name]  
**Status:** 🔴 Not Started  
**Created:** YYYY-MM-DD  
**Source:** [artifact-file]  
**Type:** Feature

---

## Overview

[Extracted from artifact overview]

## Transition Goals

[Extracted from artifact success criteria]

## Pre-Transition Checklist

- [ ] Feature plan reviewed
- [ ] Prerequisites identified
- [ ] Dependencies resolved
- [ ] Resources allocated

## Transition Steps

[Extracted from artifact implementation steps, organized into phases]

**IMPORTANT:** Extract **ALL phases** from the artifact (Phase 1, Phase 2, Phase 3, Phase 4, etc.). Do not stop at Phase 2.

### Phase 1: [Phase Name]

**Goal:** [Extracted from artifact phase goal]

**Estimated Effort:** [X] hours/days

**Prerequisites:**

- [ ] [Prerequisite 1]
- [ ] [Prerequisite 2]

**Tasks:**

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

**Deliverables:**

- [Deliverable 1]
- [Deliverable 2]

**Definition of Done:**

- [ ] All tasks complete
- [ ] Deliverables created
- [ ] Ready for Phase 2

---

### Phase 2: [Phase Name]

**Goal:** [Extracted from artifact phase goal]

**Estimated Effort:** [X] hours/days

**Prerequisites:**

- [ ] Phase 1 complete
- [ ] [Additional prerequisites]

**Tasks:**

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

**Deliverables:**

- [Deliverable 1]
- [Deliverable 2]

**Definition of Done:**

- [ ] All tasks complete
- [ ] Deliverables created
- [ ] Ready for Phase 3 (or post-transition if last phase)

---

### Phase 3: [Phase Name]

[Continue extracting ALL phases from artifact. Include Phase 3, Phase 4, Phase 5, etc. as they exist in the artifact.]

**Goal:** [Extracted from artifact phase goal]

**Estimated Effort:** [X] hours/days

**Prerequisites:**

- [ ] Phase 2 complete
- [ ] [Additional prerequisites]

**Tasks:**

- [ ] Task 1
- [ ] Task 2

**Deliverables:**

- [Deliverable 1]

**Definition of Done:**

- [ ] All tasks complete
- [ ] Deliverables created
- [ ] Ready for post-transition (if last phase)

## Post-Transition

- [ ] Feature complete
- [ ] Documentation updated
- [ ] Tests passing
- [ ] Ready for next feature

## Definition of Done

- [ ] All phases complete
- [ ] Feature implemented
- [ ] Tests passing
- [ ] Documentation updated
```

---

**For CI/CD Transition:**

**Location:** `docs/maintainers/planning/ci/[improvement-name]/`

**Documents created:**

- `transition-plan.md` - Detailed transition plan
- `phase-1.md`, `phase-2.md`, `phase-3.md`, etc. - Detailed phase documents (one per step, treating steps as phases)

**Note:** CI/CD improvements use `/task-improvement` command (not `/task-phase`) because they have different structure and workflow (process/documentation vs. TDD).

**Transition Plan Template:**

```markdown
# CI/CD Transition Plan - [Improvement Name]

**Improvement:** [Improvement Name]  
**Status:** 🔴 Not Started  
**Created:** YYYY-MM-DD  
**Source:** [artifact-file]  
**Type:** CI/CD

---

## Overview

[Extracted from artifact overview]

## Transition Goals

[Extracted from artifact benefits]

## Pre-Transition Checklist

- [ ] Improvement plan reviewed
- [ ] CI/CD infrastructure ready
- [ ] Dependencies identified
- [ ] Rollback plan prepared (if applicable)

## Transition Steps

[Extracted from artifact implementation steps]

**IMPORTANT:** Extract **ALL steps** from the artifact. Do not limit to just 2 steps.

1. **Step 1: [Name]**

   - [ ] Task 1
   - [ ] Task 2
   - Estimated: [X] hours

2. **Step 2: [Name]**

   - [ ] Task 1
   - [ ] Task 2
   - Estimated: [X] hours

3. **Step 3: [Name]**
   - [ ] Task 1
   - [ ] Task 2
   - Estimated: [X] hours

[Continue extracting ALL steps from artifact. Include Step 3, Step 4, Step 5, etc. as they exist in the artifact.]

## Post-Transition

- [ ] Improvement deployed
- [ ] CI/CD pipeline verified
- [ ] Documentation updated
- [ ] Monitoring active (if applicable)

## Definition of Done

- [ ] All steps complete
- [ ] CI/CD improvement active
- [ ] Tests passing
- [ ] Documentation updated
```

---

### 5. Create Phase Scaffolding Documents

**Purpose:** Create minimal phase documents (~60-80 lines) for human review.

**Note:** Detailed TDD tasks, code examples, and implementation notes are added in Expand Mode. See "Expand Mode Workflow (`--expand`)" section.

**When to create:**

- For feature transitions (always)
- For CI/CD transitions (treat steps as phases)

**Process:**

1. **Extract phases from source:**
   - Parse transition-plan.md for phase sections
   - Extract: phase number, name, goal, deliverables, prerequisites, effort

2. **For each phase, create scaffolding `phase-N.md`:**
   - Use scaffolding template (below)
   - Extract content from source (goals, criteria, dependencies)
   - Do NOT add detailed TDD tasks (that's for Expand Mode)
   - Add status indicator and placeholder message

**Scaffolding Template (~60-80 lines):**

```markdown
# [Feature] - Phase [N]: [Name]

**Phase:** [N] - [Name]  
**Duration:** [Estimate]  
**Status:** 🔴 Scaffolding (needs expansion)  
**Prerequisites:** [From source]

---

## 📋 Overview

[1-2 sentences from ADR/source]

**Success Definition:** [From source criteria]

---

## 🎯 Goals

1. **[Goal 1]** - [From source]
2. **[Goal 2]** - [From source]

---

## 📝 Tasks

> ⚠️ **Scaffolding:** Run `/transition-plan [topic] --expand --phase [N]` to add detailed TDD tasks.

### Task Categories

- [ ] **[Category 1]** - [Brief description]
- [ ] **[Category 2]** - [Brief description]

---

## ✅ Completion Criteria

- [ ] [Criterion 1 from source]
- [ ] [Criterion 2 from source]

---

## 📦 Deliverables

- [Deliverable 1 from source]
- [Deliverable 2 from source]

---

## 🔗 Dependencies

### Prerequisites

- [Previous phase or requirement]

### Blocks

- [Next phase]

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase N-1](phase-N-1.md)
- [Next Phase: Phase N+1](phase-N+1.md)

---

**Last Updated:** YYYY-MM-DD  
**Status:** 🔴 Scaffolding  
**Next:** Expand with `/transition-plan [topic] --expand --phase [N]`
```

**Target:** ~60-80 lines per phase document

**File locations:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/phase-N.md`
- Project-wide: `docs/maintainers/planning/phases/phase-N.md`
- CI/CD improvements: `docs/maintainers/planning/ci/[improvement-name]/phase-N.md`

**Checklist:**

- [ ] Phase scaffolding created for each phase
- [ ] Status indicator: `🔴 Scaffolding (needs expansion)`
- [ ] Placeholder message guides to expansion command
- [ ] Goals, criteria, dependencies extracted from source
- [ ] NO detailed TDD tasks (reserved for Expand Mode)

---

### 6. Update Planning Hubs

**Update hub files with scaffolding links:**

1. **Feature Hub:**
   - File: `docs/maintainers/planning/features/[feature-name]/README.md`
   - Add phase scaffolding links with `🔴 Scaffolding` status
   - Add transition plan link

2. **Release Hub:**
   - File: `docs/maintainers/planning/releases/README.md`
   - Update release status
   - Add transition plan link

3. **CI/CD Hub:**
   - File: `docs/maintainers/planning/ci/README.md` (if exists)
   - Add phase links with scaffolding status

**Example hub entry:**

```markdown
| Phase | Name | Status |
|-------|------|--------|
| [Phase 1](phase-1.md) | Foundation | 🔴 Scaffolding |
| [Phase 2](phase-2.md) | Implementation | 🔴 Scaffolding |
```

**Checklist:**

- [ ] Feature hub updated with scaffolding links
- [ ] Release hub updated (if release transition)
- [ ] CI/CD hub updated (if CI/CD transition)
- [ ] Phase status shows `🔴 Scaffolding`
- [ ] Hub links verified

---

### 7. Summary Report

**Present to user:**

```markdown
## Setup Mode Complete - Scaffolding Ready

**Source:** [artifact-file or ADR]
**Type:** [Release/Feature/CI/CD]

### Documents Created

- `transition-plan.md` - Transition overview
- `phase-1.md`, `phase-2.md`, etc. - Phase scaffolding (~60-80 lines each)

### Scaffolding Summary

- [N] phases created
- Status: 🔴 Scaffolding (needs expansion)
- Estimated effort: [X] hours (total)

### Next Steps

1. **Review scaffolding** - Verify phase breakdown is correct
2. **Expand phases** - Run `/transition-plan [topic] --expand --phase N` for each phase
3. **Implement** - Use `/task-phase` to implement expanded phases

### Quick Commands

- Expand Phase 1: `/transition-plan [topic] --expand --phase 1`
- Expand all phases: `/transition-plan [topic] --expand --all`
```

---

## Expand Mode Workflow (`--expand`)

**When to use:** After scaffolding has been created (Setup Mode), use Expand Mode to fill in detailed TDD tasks.

**Prerequisite:** Phase scaffolding documents must exist with status `🔴 Scaffolding`.

---

### 1. Identify Phase(s) to Expand

**Determine scope:**

1. **Specific Phase** (`--phase N`):
   - Expand only the specified phase
   - Useful for incremental progress
   - Example: `/transition-plan [topic] --expand --phase 1`

2. **All Phases** (`--all`):
   - Expand all scaffolding phases at once
   - Useful after reviewing all scaffolding
   - Example: `/transition-plan [topic] --expand --all`

3. **Interactive** (no flag):
   - List phases with status
   - Prompt user to select phase
   - Show which phases need expansion (`🔴 Scaffolding`)

**Read phase scaffolding document:**

```bash
# Find phase documents
ls docs/maintainers/planning/features/[feature]/phase-*.md

# Check scaffolding status
grep "Status:" docs/maintainers/planning/features/[feature]/phase-1.md
```

**Checklist:**

- [ ] Phase(s) to expand identified
- [ ] Phase document exists
- [ ] Phase status is `🔴 Scaffolding`

---

### 2. Read Phase Scaffolding

**Extract from scaffolding:**

- Phase number and name
- Goals (list of objectives)
- Task categories (high-level groupings)
- Completion criteria (success measures)
- Deliverables (expected outputs)
- Dependencies (prerequisites and blocks)

**Identify expansion needs:**

- Which task categories need TDD breakdown?
- What code examples are needed?
- What implementation notes would help?

**Example scaffolding extraction:**

```markdown
# From phase-1.md scaffolding:
Goals:
1. Add Setup Mode subsection
2. Add Expand Mode subsection
3. Document mode selection

Task Categories:
- Setup Mode Documentation
- Expand Mode Documentation
- Flag Documentation

Deliverables:
- Updated Workflow Overview section
```

**Checklist:**

- [ ] Phase scaffolding read
- [ ] Goals extracted
- [ ] Task categories identified
- [ ] Deliverables understood

---

### 3. Determine TDD vs Non-TDD

**TDD Ordering applies when:**

- Phase involves code implementation
- Phase involves script creation
- Phase involves testable functionality

**Non-TDD Ordering for:**

- Documentation-only phases
- Configuration phases
- Planning phases

**Task Ordering Patterns:**

| Phase Type | Task Order | Example |
|------------|------------|---------|
| **Code + Tests (TDD)** | Tests → Implementation → Docs | Write tests, implement code, document |
| **Scripts (TDD)** | Tests → Script → Integration | Write bats tests, create script, integrate |
| **Documentation Only** | Create → Link → Verify | Create docs, add links, verify links work |
| **Configuration** | Plan → Implement → Validate | Define config, apply changes, verify |

**Decision Logic:**

```
IF phase creates code or scripts:
  → Use TDD ordering (RED → GREEN → REFACTOR)
ELSE IF phase creates documentation:
  → Use Create → Link → Verify ordering
ELSE:
  → Use logical dependency ordering
```

**Checklist:**

- [ ] Phase type determined (code/script/docs/config)
- [ ] Task ordering pattern selected
- [ ] TDD applicability decided

---

### 4. Expand Tasks with Detail

**This is the core expansion step.** Transform task categories into detailed, actionable tasks.

**For TDD phases (code/scripts):**

**TDD Task Structure:**

```markdown
### Task N: [Task Name]

**Purpose:** [Why this task exists]

**TDD Flow:**

1. **RED - Write failing test:**
   - [ ] Create test file: `tests/test_[feature].py`
   - [ ] Write test for [specific behavior]
   - [ ] Verify test fails (no implementation yet)

   **Test code:**
   ```python
   def test_feature_behavior():
       # Arrange
       ...
       # Act
       result = feature_function()
       # Assert
       assert result == expected
   ```

2. **GREEN - Implement minimum code:**
   - [ ] Create implementation file: `src/[feature].py`
   - [ ] Write minimum code to pass test
   - [ ] Run test, verify it passes

   **Implementation:**
   ```python
   def feature_function():
       # Minimum implementation
       return expected
   ```

3. **REFACTOR - Clean up:**
   - [ ] Review code for improvements
   - [ ] Extract helper functions if needed
   - [ ] Ensure tests still pass

**Checklist:**
- [ ] Test written and failing
- [ ] Implementation passes test
- [ ] Code refactored and clean
```

**For Documentation phases:**

```markdown
### Task N: [Task Name]

**Purpose:** [Why this task exists]

- [ ] Read existing content to understand current state
- [ ] Create new content as specified
- [ ] Verify content is complete and accurate
- [ ] Update any cross-references

**Content to Add:**
```markdown
[Specific markdown content to add]
```

**Checklist:**
- [ ] Content created
- [ ] Links verified
- [ ] Cross-references updated
```

**Expansion adds:**

| Section | Scaffolding | After Expansion |
|---------|-------------|-----------------|
| Tasks | Categories only | Full TDD breakdown |
| Code Examples | None | Language-specific samples |
| Testing Commands | None | Specific commands to run |
| Implementation Notes | None | Patterns, tips, examples |
| Progress Tracking | None | Task status table |

**Target expansion:**

- Scaffolding: ~60-80 lines
- Expanded: ~200-300 lines
- Added: ~150-200 lines of detail

**Checklist:**

- [ ] Task categories expanded to full tasks
- [ ] TDD flow added where applicable
- [ ] Code examples included
- [ ] Testing commands documented
- [ ] Implementation notes added

---

### 5. Update Phase Status

**Update status in phase document:**

**Header:**
```markdown
# Before:
**Status:** 🔴 Scaffolding (needs expansion)

# After:
**Status:** ✅ Expanded
```

**Footer:**
```markdown
# Before:
**Status:** 🔴 Scaffolding  
**Next:** Expand with `/transition-plan [topic] --expand --phase [N]`

# After:
**Status:** ✅ Expanded  
**Next:** Begin implementation with Task 1
```

**Remove placeholder message:**

```markdown
# Remove this from Tasks section:
> ⚠️ **Scaffolding:** Run `/transition-plan [topic] --expand --phase [N]` to add detailed TDD tasks.
```

**Add progress tracking table:**

```markdown
## 📊 Progress Tracking

| Task | Status | Notes |
|------|--------|-------|
| Task 1: [Name] | 🔴 Not Started | |
| Task 2: [Name] | 🔴 Not Started | |
```

**Checklist:**

- [ ] Header status updated to `✅ Expanded`
- [ ] Footer status updated
- [ ] Placeholder message removed
- [ ] Progress tracking table added

---

### 6. Update Hub Status

**Update feature hub (README.md):**

```markdown
# Before:
| [Phase 1](phase-1.md) | Workflow Overview | 🔴 Scaffolding |

# After:
| [Phase 1](phase-1.md) | Workflow Overview | ✅ Expanded |
```

**Update status-and-next-steps.md:**

```markdown
# Before:
| Phase 1: Workflow Overview | 🔴 Scaffolding | 0% | Needs expansion |

# After:
| Phase 1: Workflow Overview | ✅ Expanded | 0% impl | Ready for implementation |
```

**Checklist:**

- [ ] Feature hub updated
- [ ] Status document updated
- [ ] Phase listed as ready for implementation

---

### 7. Commit Changes

**Commit expanded phase:**

**Since expansion is documentation-only, use docs workflow:**

```bash
# Stage expanded phase
git add docs/maintainers/planning/features/[feature]/phase-N.md
git add docs/maintainers/planning/features/[feature]/README.md
git add docs/maintainers/planning/features/[feature]/status-and-next-steps.md

# Commit with descriptive message
git commit -m "docs(planning): expand Phase N scaffolding with detailed tasks

Expand Phase N ([Name]) from ~[X] lines scaffolding to ~[Y] lines
with detailed implementation tasks:

- Task 1: [Name]
- Task 2: [Name]
- ...

Includes [TDD breakdown / documentation steps / etc.]"

# Push to develop (docs can push directly)
git push origin develop
```

**Checklist:**

- [ ] Changes committed
- [ ] Commit message descriptive
- [ ] Pushed to develop

---

### Flag Handling

**`--phase N` Flag:**

```
/transition-plan [topic] --expand --phase N

Validation:
- Check phase-N.md exists
- Check status is 🔴 Scaffolding
- Error if phase already expanded

Processing:
- Expand single phase
- Update phase status
- Update hub
- Commit changes
```

**`--all` Flag:**

```
/transition-plan [topic] --expand --all

Processing:
- Find all phase-*.md files with 🔴 Scaffolding status
- Expand each phase in order (1, 2, 3, ...)
- Update each phase status
- Update hub once at end
- Single commit for all expansions
```

**Error Handling:**

| Error | Message | Action |
|-------|---------|--------|
| Phase not found | "Phase N does not exist" | List available phases |
| Already expanded | "Phase N already expanded" | Skip or use --force |
| No scaffolding | "No scaffolding phases found" | Run setup mode first |

---

### Summary Report

**Present to user after expansion:**

```markdown
## Expand Mode Complete

**Phase:** Phase [N] - [Name]
**Status:** 🔴 Scaffolding → ✅ Expanded

### Expansion Summary

- Lines: ~[X] → ~[Y] (+[Z] lines)
- Tasks: [N] detailed tasks added
- TDD: [Yes/No] - [TDD flow / documentation flow]

### Tasks Added

1. Task 1: [Name]
2. Task 2: [Name]
...

### Next Steps

1. Review expanded phase document
2. Begin implementation: `/task-phase [N] 1`
3. Or expand next phase: `/transition-plan [topic] --expand --phase [N+1]`
```

---

## From Reflection Mode

**When to use:**

- When reflection exists but artifacts haven't been created yet
- To streamline workflow (one command instead of two)
- When starting fresh from reflection

**Key principle:** Internally calls `/reflection-artifacts` first, then creates transition plans from generated artifacts.

---

### 1. Load Reflection File

**File location:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/reflections/reflection-*.md`
- Project-wide: `docs/maintainers/planning/notes/reflections/reflection-*.md`
- Alternative: `docs/maintainers/planning/reflections/reflection-*.md`
- Manual: `--from-reflection reflection-2025-12-07-mvp-complete.md`

**Extract from reflection:**

- "Actionable Suggestions" section
- "Recommended Next Steps" section
- Current state information

**Checklist:**

- [ ] Reflection file found
- [ ] File is readable and well-formatted
- [ ] Actionable suggestions identified

---

### 2. Generate Artifacts (Internal Call)

**Process:**

1. Internally call `/reflection-artifacts` workflow
2. Generate artifacts from reflection
3. Store artifacts in appropriate directories
4. Continue with transition plan creation

**Artifacts generated:**

- Release artifacts (if release suggestions found)
- Feature artifacts (if feature suggestions found)
- CI/CD artifacts (if CI/CD suggestions found)

**Checklist:**

- [ ] Artifacts generated successfully
- [ ] Artifacts placed in correct directories
- [ ] Artifact types determined

---

### 3. Create Transition Plans from Artifacts

**Process:**

- Use generated artifacts as input
- Follow "Artifact Mode" workflow (steps 2-6 above)
- Create transition plans from artifacts

**Checklist:**

- [ ] Transition plans created from artifacts
- [ ] Plans follow appropriate templates
- [ ] Plans are actionable

---

## From ADR Mode

**When to use:**

- When ADR documents exist from `/decision` command
- To transition from decisions to feature planning
- When research and decisions are complete

**Key principle:** Read ADR documents and automatically read requirements if they exist in research directory, then create transition plans.

---

### 1. Load ADR Document

**File location:**

- ADR: `docs/maintainers/decisions/[topic]/adr-[number]-[decision-name].md`
- Manual: `--from-adr decisions/auth-system/adr-001-auth-system.md`

**Extract from ADR:**

- Decision statement
- Consequences (positive and negative)
- Alternatives considered
- Decision rationale
- Requirements impact

**Checklist:**

- [ ] ADR file found
- [ ] File is readable and well-formatted
- [ ] Decision statement identified

---

### 2. Auto-Detect Requirements

**Automatic detection:**

1. **Extract topic from ADR path:**
   - ADR path: `decisions/[topic]/adr-001-[decision].md`
   - Topic: `[topic]`

2. **Check for requirements document:**
   - Path: `docs/maintainers/research/[topic]/requirements.md`
   - If exists, read automatically
   - If `--requirements` specified, use that path instead

3. **Extract from requirements:**
   - Functional requirements
   - Non-functional requirements
   - Constraints
   - Assumptions

**Checklist:**

- [ ] Topic extracted from ADR path
- [ ] Requirements document checked
- [ ] Requirements read (if exists)
- [ ] Requirements extracted

---

### 3. Determine Transition Type

**Auto-detection logic:**

- **Feature Transition (default):** Most ADRs lead to feature planning
- **CI/CD Transition:** If ADR mentions CI/CD, pipeline, automation
- **Infrastructure Transition:** If ADR mentions infrastructure, monitoring, logging

**Manual override:**

- Use `--type` option to force specific type

**Checklist:**

- [ ] Transition type determined
- [ ] Type is appropriate for ADR content

---

### 4. Parse ADR and Requirements Content

**Extract from ADR:**

- Decision statement → Feature/improvement description
- Consequences → Benefits and risks
- Alternatives considered → Options evaluated
- Decision rationale → Context and justification
- Requirements impact → Requirements to consider

**Extract from requirements (if exists):**

- Functional requirements → Feature requirements
- Non-functional requirements → Quality requirements
- Constraints → Implementation constraints
- Assumptions → Planning assumptions

**Organize into phases:**

- Break down implementation into logical phases
- Use decision rationale to inform phase structure
- Use requirements to define phase deliverables

**Checklist:**

- [ ] ADR content parsed
- [ ] Requirements content parsed (if exists)
- [ ] Implementation steps identified
- [ ] Phases organized

---

### 5. Create Transition Planning Documents

**Follow same structure as Artifact Mode (step 4 above):**

- Create transition plan document
- Include decision context
- Include requirements (if available)
- Organize into phases

**For Feature Transitions:**

- Create `feature-plan.md` with decision context
- Create `transition-plan.md` with phase breakdown
- Include requirements in feature plan

**For CI/CD Transitions:**

- Create `improvement-plan.md` with decision context
- Create `transition-plan.md` with step breakdown
- Include requirements in improvement plan

**Checklist:**

- [ ] Transition plan created
- [ ] Decision context included
- [ ] Requirements included (if available)
- [ ] Phases/steps organized

---

### 6. Create Phase Documents

**Follow same structure as Artifact Mode (step 5 above):**

- Extract phases from transition plan
- Create detailed `phase-#.md` files
- Include requirements in phase documents
- Link to ADR and research documents

**For Feature Transitions:**

- Use `/task-phase` workflow (TDD)
- Include requirements in phase deliverables
- Reference ADR in phase documents

**For CI/CD Transitions:**

- Use `/task-improvement` workflow (process/documentation)
- Include requirements in improvement steps
- Reference ADR in phase documents

**Checklist:**

- [ ] Phase documents created
- [ ] Requirements included in phases
- [ ] ADR referenced in phase documents
- [ ] Research documents linked

---

### 7. Update Planning Hubs

**Follow same structure as Artifact Mode (step 6 above):**

- Update feature/CI/CD hub
- Add transition plan link
- Add phase document links
- Reference ADR and requirements

**Checklist:**

- [ ] Planning hubs updated
- [ ] Links added
- [ ] ADR and requirements referenced

---

## Common Issues

### Issue: No Artifacts Found

**Solution:**

- Run `/reflection-artifacts` first to generate artifacts
- Or use `--from-reflection` to auto-generate artifacts
- Check artifact directory paths

### Issue: Transition Type Ambiguous

**Solution:**

- Use `--type` option to force specific type
- Review artifact content to determine type
- Check artifact file path for type hints

### Issue: Artifact Content Incomplete

**Solution:**

- Review artifact file for completeness
- Update artifact with additional context
- Re-run `/reflection-artifacts` if needed

---

### Issue: Phase Already Expanded

**Symptom:** Error when trying to expand a phase that's already expanded.

**Solution:**

- Check phase status: `grep "Status:" phase-N.md`
- If `✅ Expanded`, phase is already done
- Use `--force` to re-expand (overwrites existing content)
- Or edit phase document directly

---

### Issue: No Scaffolding Found

**Symptom:** `--expand` fails because no scaffolding exists.

**Solution:**

- Run setup mode first: `/transition-plan --from-adr [path]`
- Check phase files exist: `ls docs/maintainers/planning/features/[feature]/phase-*.md`
- Verify status is `🔴 Scaffolding`

---

### Issue: Scaffolding Structure Incorrect

**Symptom:** After setup, phase breakdown doesn't match expectations.

**Solution:**

- Edit scaffolding files directly before expanding
- Adjust phase boundaries in `transition-plan.md`
- Re-run setup with different source if needed
- Scaffolding is meant for human review - modify as needed

---

### Issue: TDD Ordering Wrong After Expand

**Symptom:** Tasks not in test-first order after expansion.

**Solution:**

- Edit phase document to reorder tasks
- Ensure test tasks come before implementation tasks
- Check "Determine TDD vs Non-TDD" logic in expansion
- For documentation phases, TDD ordering may not apply

---

## Tips

### When to Use Each Mode

**Setup Mode (default):**

- First time creating transition plan from new source
- When you want to review phase structure before detail
- When working with unfamiliar ADRs or artifacts
- When multiple stakeholders need to approve structure

**Expand Mode (`--expand`):**

- After scaffolding has been reviewed and approved
- When ready to add implementation detail
- Before starting `/task-phase` implementation
- When TDD task ordering is needed

**Incremental vs Batch:**

| Approach | Flag | When to Use |
|----------|------|-------------|
| **Incremental** | `--phase N` | Complex phases, want to review each |
| **Batch** | `--all` | Simple phases, already reviewed scaffolding |

**Rule of Thumb:**

- If unsure → Use Setup Mode first, review, then expand
- If familiar with source → Can use `--expand --all` directly

---

### Before Running

- **For Setup Mode:**
  - Ensure source exists (ADRs, artifacts, or reflection)
  - Review source content for completeness
  - Determine desired transition type

- **For Expand Mode:**
  - Ensure scaffolding exists (run setup first)
  - Review scaffolding for correct phase breakdown
  - Decide on incremental (`--phase N`) vs batch (`--all`)

### During Planning

- Review extracted steps for accuracy
- Organize steps chronologically
- Identify dependencies between steps

### After Planning

- Review transition plan for completeness
- Update plan with additional context if needed
- Begin implementation when ready

---

## Common Scenarios

### Scenario 1: Setup Scaffolding Only

**Use case:** Create scaffolding for human review before expanding.

```bash
# From ADRs
/transition-plan --from-adr decisions/auth-system/

# Output:
# - transition-plan.md
# - phase-1.md (🔴 Scaffolding)
# - phase-2.md (🔴 Scaffolding)
# - phase-3.md (🔴 Scaffolding)
```

**Next:** Review scaffolding, then use `--expand` when ready.

---

### Scenario 2: Expand Single Phase

**Use case:** Incrementally expand one phase at a time.

```bash
# Review scaffolding first
cat docs/maintainers/planning/features/auth-system/phase-1.md

# Expand Phase 1 only
/transition-plan auth-system --expand --phase 1

# Output:
# - phase-1.md updated (✅ Expanded, ~200-300 lines)
```

**Next:** Implement Phase 1 with `/task-phase`, then expand Phase 2.

---

### Scenario 3: Expand All Phases

**Use case:** Expand all scaffolding at once after review.

```bash
# After reviewing all scaffolding
/transition-plan auth-system --expand --all

# Output:
# - phase-1.md (✅ Expanded)
# - phase-2.md (✅ Expanded)
# - phase-3.md (✅ Expanded)
```

**Next:** Begin implementation with `/task-phase phase-1`.

---

### Scenario 4: Full Workflow (End-to-End)

**Use case:** Complete workflow from ADRs to expanded phases.

```bash
# Step 1: Create scaffolding
/transition-plan --from-adr decisions/auth-system/

# Step 2: Review scaffolding (human review)
# - Check phase breakdown
# - Verify goals and criteria
# - Confirm dependencies

# Step 3: Expand all phases
/transition-plan auth-system --expand --all

# Step 4: Implement
/task-phase phase-1
/task-phase phase-2
...
```

**Timeline:**

- Setup: ~5-10 min
- Human review: Variable
- Expand: ~5-10 min per phase
- Implement: Per phase estimate

---

## Reference

**Artifact Files:**

- Releases: `docs/maintainers/planning/releases/vX.Y.Z/checklist.md`
- Features: `docs/maintainers/planning/features/[feature-name]/feature-plan.md`
- CI/CD: `docs/maintainers/planning/ci/[improvement-name]/improvement-plan.md`

**Reflection Files:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/reflections/reflection-*.md`
- Project-wide: `docs/maintainers/planning/notes/reflections/reflection-*.md`

**Transition Plans:**

- `docs/maintainers/planning/releases/vX.Y.Z/transition-plan.md`
- `docs/maintainers/planning/features/[feature-name]/transition-plan.md`
- `docs/maintainers/planning/ci/[improvement-name]/transition-plan.md`

**Related Commands:**

- `/explore` - Start exploration and identify research topics
- `/research` - Conduct research and extract requirements
- `/decision` - Make decisions and create ADR documents
- `/reflection-artifacts` - Generate artifacts from reflection (run first, or auto-called)
- `/reflect` - Create reflection documents (if available)
- `/task-phase` - Implement feature phase tasks (reads `phase-#.md` files created by this command)
- `/task-improvement` - Implement CI/CD improvement phase tasks (reads `phase-#.md` files created by this command)
- `/task-release` - Implement release transition tasks
- `/pre-phase-review` - Review phase plans before implementation

**Related Templates:**

- `docs/PHASE-DOCUMENT-TEMPLATE.md` - Template for phase documents (used when creating phase-#.md files)
- `/pr` - Create PRs for completed work

---

**Last Updated:** 2025-12-15  
**Status:** ✅ Active  
**Next:** Use after `/decision` to transition from ADRs to planning, or use `--from-reflection` or `--from-artifacts` for other workflows (supports feature-specific and project-wide structures, enforces TDD task ordering)
