# Requirements Template

**Purpose:** Template for documenting requirements discovered during research  
**Status:** Template  
**Last Updated:** [DATE]

---

## 📋 Overview

This template provides a structure for documenting requirements discovered during research. Use this template when creating `requirements.md` files for research topics.

**Workflow:**
1. Requirements are discovered during research (`/research` command)
2. Requirements are stored in `research/[topic]/requirements.md`
3. Requirements inform architectural decisions (`/decision` command)
4. Requirements are used in transition planning (`/transition-plan` command)

---

## ✅ Functional Requirements

Functional requirements describe what the system must do - the features and capabilities it must provide.

**Format:** `FR-N: [Requirement Name]`

**Template:**

```markdown
### FR-1: [Requirement Name]

**Description:** [What the system must do]

**Source:** [Research document or discovery source]

**Priority:** High/Medium/Low

**Status:** 🔴 Pending / 🟠 In Progress / ✅ Complete

---

### FR-2: [Requirement Name]

[Similar format]
```

**Example:**

```markdown
### FR-1: Workflow Automation Commands Integration

**Description:** Templates must include all workflow automation commands in `.cursor/commands/` directory.

**Source:** research-workflow-automation-commands-integration.md

**Priority:** High

**Status:** 🔴 Pending
```

---

## 🎯 Non-Functional Requirements

Non-functional requirements describe how the system must perform - quality attributes, constraints, and system properties.

**Format:** `NFR-N: [Requirement Name]`

**Template:**

```markdown
### NFR-1: [Requirement Name]

**Description:** [How the system must perform]

**Source:** [Research document or discovery source]

**Priority:** High/Medium/Low

**Status:** 🔴 Pending / 🟠 In Progress / ✅ Complete

---

### NFR-2: [Requirement Name]

[Similar format]
```

**Example:**

```markdown
### NFR-1: Template Structure Consistency

**Description:** Templates must maintain consistent structure across all template types.

**Source:** Template structure analysis

**Priority:** High

**Status:** 🔴 Pending
```

---

## ⚠️ Constraints

Constraints are limitations or restrictions that the system must operate within.

**Format:** `C-N: [Constraint Name]`

**Template:**

```markdown
### C-1: [Constraint Name]

**Description:** [What limits or restricts the system]

**Source:** [Research document or discovery source]

**Impact:** [How this constraint affects the system]

---

### C-2: [Constraint Name]

[Similar format]
```

**Example:**

```markdown
### C-1: Sourcery Review Quota Limit

**Description:** Weekly diff character limit for Sourcery reviews.

**Source:** Project workflow constraints

**Impact:** Docs-only phases should use direct merge workflow to preserve quota for code reviews.
```

---

## 💡 Assumptions

Assumptions are beliefs or conditions that are taken for granted but may not be verified.

**Format:** `A-N: [Assumption Name]`

**Template:**

```markdown
### A-1: [Assumption Name]

**Description:** [What is assumed to be true]

**Source:** [Research document or discovery source]

**Validation:** [How to validate this assumption]

---

### A-2: [Assumption Name]

[Similar format]
```

**Example:**

```markdown
### A-1: Commands Support Template Structure

**Description:** Commands already support template structure (`docs/maintainers/` paths) through auto-detection.

**Source:** Command analysis

**Validation:** Test commands in generated projects to verify path detection works correctly.
```

---

## 📝 Usage Guidelines

### When to Create Requirements

- During research phase (`/research` command)
- When exploring new features or improvements
- Before making architectural decisions
- When planning major changes

### How to Use This Template

1. **Copy this template:**
   ```bash
   cp docs/maintainers/research/requirements-template.md \
      docs/maintainers/research/[topic]/requirements.md
   ```

2. **Fill in requirements:**
   - Add functional requirements (FR-1, FR-2, etc.)
   - Add non-functional requirements (NFR-1, NFR-2, etc.)
   - Add constraints (C-1, C-2, etc.)
   - Add assumptions (A-1, A-2, etc.)

3. **Update as research progresses:**
   - Add new requirements as discovered
   - Update status as requirements are addressed
   - Document validation results

### Requirements Numbering

- **Functional Requirements:** FR-1, FR-2, FR-3, etc.
- **Non-Functional Requirements:** NFR-1, NFR-2, NFR-3, etc.
- **Constraints:** C-1, C-2, C-3, etc.
- **Assumptions:** A-1, A-2, A-3, etc.

### Status Tracking

- 🔴 **Pending** - Requirement identified but not yet addressed
- 🟠 **In Progress** - Requirement being worked on
- ✅ **Complete** - Requirement satisfied

---

## 🔗 Related Documentation

- **[Research Hub](README.md)** - Research documents and analysis
- **[Decisions Hub](../decisions/README.md)** - Architecture Decision Records (ADRs)
- **[Feature Planning](../planning/features/README.md)** - Feature planning and implementation

---

**Last Updated:** [DATE]  
**Status:** Template

