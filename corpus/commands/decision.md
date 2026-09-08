# Decision Command

Make decisions based on research findings. Creates Architecture Decision Records (ADRs) - one ADR per decision point.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Dev-Infra Structure (default):**
   - Decisions: `admin/decisions/[topic]/`
   - Research: `admin/research/[topic]/`
   - Requirements: `admin/research/[topic]/requirements.md`

2. **Template Structure (for generated projects):**
   - Decisions: `docs/maintainers/decisions/[topic]/`
   - Research: `docs/maintainers/research/[topic]/`
   - Requirements: `docs/maintainers/research/[topic]/requirements.md`

3. **Project-Wide Structure:**
   - Decisions: `docs/maintainers/decisions/[topic]/`
   - Research: `docs/maintainers/research/[topic]/`
   - Requirements: `docs/maintainers/research/[topic]/requirements.md`

**Topic Detection:**
- Use `--topic` option if provided
- Otherwise, auto-detect from research source
- Sanitize topic name (kebab-case, no spaces)

---

## Workflow Overview

**When to use:**

- After research is complete
- When you need to make decisions based on research findings
- To document architecture decisions

**Key principle:** One ADR per decision point. Multiple decisions may be needed for a single topic.

**Workflow:**
```
/decision [topic] --from-research [research-doc]
  → Reads research documents
  → Reads requirements document
  → Identifies decision points
  → Creates ADR for each decision
  → Outputs: ADR documents (one per decision)
```

---

## Usage

**Command:** `/decision [topic] --from-research [research-doc] [options]`

**Examples:**

- `/decision auth-system --from-research auth-system/research-summary.md` - Make decisions based on research
- `/decision database-choice --from-research database-choice/research-summary.md --requirements database-choice/requirements.md` - Include requirements
- `/decision --dry-run` - Show what would be created without creating files

**Options:**

- `--from-research [research-doc]` - Read research documents (required)
- `--requirements [requirements-doc]` - Read requirements document (optional, auto-detected if exists)
- `--topic [topic]` - Specify topic name (overrides auto-detection)
- `--decision-point [point]` - Create ADR for specific decision point only
- `--dry-run` - Show what would be created without creating files

---

## Step-by-Step Process

### 1. Identify Research Source

**Read research documents:**

1. **Read research summary:**
   - **Dev-Infra:** `admin/research/[topic]/research-summary.md`
   - **Template Structure:** `docs/maintainers/research/[topic]/research-summary.md`
   - Extract key findings and recommendations

2. **Read research documents:**
   - **Dev-Infra:** `admin/research/[topic]/research-*.md`
   - **Template Structure:** `docs/maintainers/research/[topic]/research-*.md`
   - Extract findings and analysis

3. **Read requirements (if exists):**
   - **Dev-Infra:** `admin/research/[topic]/requirements.md`
   - **Template Structure:** `docs/maintainers/research/[topic]/requirements.md`
   - Extract functional and non-functional requirements

**Checklist:**

- [ ] Research summary read
- [ ] Research documents read
- [ ] Requirements document read (if exists)

---

### 2. Identify Decision Points

**Extract decision points from research:**

- What decisions need to be made?
- What alternatives were considered?
- What are the trade-offs?
- What are the constraints?

**For each decision point:**

- Decision question: [What needs to be decided?]
- Alternatives: [What options are available?]
- Criteria: [What criteria will be used?]

**Checklist:**

- [ ] Decision points identified
- [ ] Alternatives identified for each decision
- [ ] Decision criteria identified

---

### 3. Create Decisions Hub

**Location Detection:**

- **Dev-Infra:** `admin/decisions/[topic]/`
- **Template Structure:** `docs/maintainers/decisions/[topic]/`
- **Project-Wide:** `docs/maintainers/decisions/[topic]/`

**Auto-detection:**
- Check if `admin/decisions/` exists → use dev-infra structure
- Check if `docs/maintainers/decisions/` exists → use template structure
- Otherwise → use project-wide structure

**Directory structure:**

```
decisions/[topic]/
├── README.md                    # Decisions hub
├── adr-001-[decision-1].md      # ADR for decision 1
├── adr-002-[decision-2].md      # ADR for decision 2
└── decisions-summary.md          # Summary of all decisions
```

**Create decisions hub:**

**File:** `docs/maintainers/decisions/[topic]/README.md`

```markdown
# [Topic Name] - Decisions Hub

**Purpose:** Decisions for [topic description]  
**Status:** 🔴 Pending  
**Created:** YYYY-MM-DD  
**Last Updated:** YYYY-MM-DD

---

## 📋 Quick Links

- **[Decisions Summary](decisions-summary.md)** - Summary of all decisions
- **[Research Hub](../../research/[topic]/README.md)** - Related research
- **[Requirements](../../research/[topic]/requirements.md)** - Requirements document

### ADR Documents

- **[ADR-001: Decision 1](adr-001-[decision-1].md)** - [Decision description]
- **[ADR-002: Decision 2](adr-002-[decision-2].md)** - [Decision description]

---

## 🎯 Decisions Overview

[Brief description of decisions to be made]

**Decision Points:** [N] decisions  
**Status:** 🔴 Pending

---

## 📊 Decision Status

| Decision | Status | ADR |
|----------|--------|-----|
| [Decision 1] | 🔴 Proposed | [adr-001-[decision-1].md](adr-001-[decision-1].md) |
| [Decision 2] | 🔴 Proposed | [adr-002-[decision-2].md](adr-002-[decision-2].md) |

---

## 🚀 Next Steps

1. Review ADR documents
2. Approve or modify decisions
3. Use `/transition-plan --from-adr` to transition to planning

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Decisions directory created
- [ ] Decisions hub created
- [ ] Decision points listed in hub

---

### 4. Create ADR Documents

**For each decision point:**

**File:** `docs/maintainers/decisions/[topic]/adr-[number]-[decision-name].md`

```markdown
# ADR-[Number]: [Decision Name]

**Status:** [Proposed | Accepted | Deprecated | Superseded]  
**Created:** YYYY-MM-DD  
**Last Updated:** YYYY-MM-DD

---

## Context

[What is the issue we're trying to address? What decision needs to be made?]

**Related Research:**
- [Research Summary](../../research/[topic]/research-summary.md)
- [Research Documents](../../research/[topic]/README.md)

**Related Requirements:**
- [Requirements Document](../../research/[topic]/requirements.md)

---

## Decision

[What is the change we're proposing or have decided to make?]

**Decision:** [Clear statement of the decision]

---

## Consequences

### Positive

- [Positive consequence 1]
- [Positive consequence 2]

### Negative

- [Negative consequence 1]
- [Negative consequence 2]

---

## Alternatives Considered

### Alternative 1: [Name]

**Description:** [What is this alternative?]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

**Why not chosen:** [Reason for not choosing this alternative]

---

### Alternative 2: [Name]

**Description:** [What is this alternative?]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

**Why not chosen:** [Reason for not choosing this alternative]

---

## Decision Rationale

[Why was this decision made? What factors influenced the decision?]

**Key Factors:**
- [Factor 1]
- [Factor 2]

**Research Support:**
- [Research finding that supports decision]

---

## Requirements Impact

[How does this decision impact requirements?]

**Requirements Affected:**
- [Requirement 1]
- [Requirement 2]

**Requirements Refined:**
- [Refined requirement 1]
- [Refined requirement 2]

---

## References

- [Research Summary](../../research/[topic]/research-summary.md)
- [Research Documents](../../research/[topic]/README.md)
- [Requirements Document](../../research/[topic]/requirements.md)

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] ADR document created for each decision
- [ ] ADR documents linked in hub
- [ ] Decision rationale documented
- [ ] Alternatives considered documented

---

### 5. Create Decisions Summary

**File:** `docs/maintainers/decisions/[topic]/decisions-summary.md`

```markdown
# Decisions Summary - [Topic Name]

**Purpose:** Summary of all decisions made  
**Status:** 🔴 Pending  
**Created:** YYYY-MM-DD  
**Last Updated:** YYYY-MM-DD

---

## 📋 Decisions Overview

[Brief summary of decisions made]

**Decision Points:** [N] decisions  
**Status:** 🔴 Pending

---

## 🎯 Key Decisions

### Decision 1: [Decision Name]

**Decision:** [Decision statement]

**Status:** [Proposed | Accepted]

**ADR:** [adr-001-[decision-1].md](adr-001-[decision-1].md)

---

### Decision 2: [Decision Name]

**Decision:** [Decision statement]

**Status:** [Proposed | Accepted]

**ADR:** [adr-002-[decision-2].md](adr-002-[decision-2].md)

---

## 📋 Requirements Impact

[Summary of how decisions impact requirements]

**See:** [requirements.md](../../research/[topic]/requirements.md) for complete requirements

---

## 🚀 Next Steps

1. Review ADR documents
2. Approve or modify decisions
3. Use `/transition-plan --from-adr` to transition to planning

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Decisions summary created
- [ ] Key decisions documented
- [ ] Requirements impact documented

---

### 6. Update Decisions Hub

**Update decisions hub:**

**File location (auto-detected):**
- **Dev-Infra:** `admin/decisions/README.md`
- **Template Structure:** `docs/maintainers/decisions/README.md`
- **Project-Wide:** `docs/maintainers/decisions/README.md`

```markdown
# Decisions Hub

**Purpose:** Architecture Decision Records (ADRs)  
**Status:** ✅ Active  
**Last Updated:** YYYY-MM-DD

---

## 📋 Quick Links

### Recent Decisions

- **[Topic 1]([topic-1]/README.md)** - [Description] (✅ Accepted)
- **[Topic 2]([topic-2]/README.md)** - [Description] (🔴 Proposed)

---

## 🎯 Overview

This directory contains Architecture Decision Records (ADRs) documenting key decisions.

**Workflow:**
1. `/explore [topic]` - Start exploration
2. `/research [topic] --from-explore [topic]` - Conduct research
3. `/decision [topic] --from-research` - Make decisions
4. `/transition-plan --from-adr` - Transition to planning

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Decisions hub created/updated
- [ ] New decisions added to quick links

---

### 7. Commit and Push Changes

**IMPORTANT:** Always commit work before completing command.

**Reference:** [Commit Workflow](../../docs/COMMIT-WORKFLOW.md) - Central commit workflow documentation, especially [Documentation/Chore Branches](../../docs/COMMIT-WORKFLOW.md#documentationchore-branches) section

**Since decisions are documentation-only, use docs-only workflow:**

**Branch naming:**

- Format: `docs/decision-[topic]` (e.g., `docs/decision-template-generation-testing-automation`)

**Steps:**

1. **Check current branch:**

   ```bash
   git branch --show-current
   ```

2. **Create docs branch (if not already on one):**

   ```bash
   git checkout -b docs/decision-[topic]
   ```

3. **Stage all changes:**

   ```bash
   git add admin/decisions/[topic]/  # or docs/maintainers/decisions/[topic]/
   ```

4. **Commit with proper message:**

   ```bash
   git commit -m "docs(decisions): add [topic] decisions

   Created ADR documents:
   - Decisions hub
   - ADR-001: [Decision 1]
   - ADR-002: [Decision 2]
   - Decisions summary

   Related: [Context]"
   ```

5. **Push branch:**

   ```bash
   git push origin docs/decision-[topic]
   ```

6. **Merge directly to develop (docs-only, no PR needed):**

   ```bash
   git checkout develop
   git pull origin develop
   git merge docs/decision-[topic] --no-edit
   git push origin develop
   ```

7. **Clean up branch:**
   ```bash
   git branch -d docs/decision-[topic]
   git push origin --delete docs/decision-[topic]
   ```

8. **Verify no uncommitted changes:**
   ```bash
   git status --short
   ```

---

## Integration with Other Commands

### Decision → Planning Flow

1. **`/decision [topic] --from-research`** - Make decisions
   - Reads research documents
   - Reads requirements document
   - Creates ADR documents (one per decision)
   - Outputs: ADR documents

2. **`/transition-plan --from-adr [adr-file]`** - Transition to planning
   - Reads ADR document
   - Automatically reads requirements if they exist
   - Creates feature plan and phase documents
   - Outputs: Transition plan + Feature plan + Phase documents

---

## Common Scenarios

### Scenario 1: Single Decision

**Situation:** One decision point identified

**Action:**
```bash
/decision auth-system --from-research auth-system/research-summary.md
```

**Output:**
- Decisions hub created
- One ADR document created
- Decisions summary created
- Ready for transition to planning

---

### Scenario 2: Multiple Decisions

**Situation:** Multiple decision points identified

**Action:**
```bash
/decision database-choice --from-research database-choice/research-summary.md
```

**Output:**
- Decisions hub created
- Multiple ADR documents created (one per decision)
- Decisions summary created
- Ready for transition to planning

---

## Tips

### When to Use

- **After research** - Research complete, ready to make decisions
- **Before planning** - Decisions inform planning
- **Architecture decisions** - Document important decisions

### Best Practices

- **One ADR per decision** - Keep decisions focused
- **Document alternatives** - Show what was considered
- **Link to research** - Connect decisions to research findings
- **Update requirements** - Document how decisions affect requirements

---

## Reference

**Decision Structure:**

- **Dev-Infra:** `admin/decisions/[topic]/`
- **Template Structure:** `docs/maintainers/decisions/[topic]/`
- **Project-Wide:** `docs/maintainers/decisions/[topic]/`
- ADRs: `[decisions-path]/[topic]/adr-[number]-[decision-name].md`

**Related Commands:**

- `/research` - Conduct research before making decisions
- `/transition-plan` - Transition to feature planning after decisions

---

**Last Updated:** 2025-12-07  
**Status:** ✅ Active  
**Next:** Use to make decisions based on research findings, creating one ADR per decision point

