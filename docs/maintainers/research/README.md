# Research Hub

**Purpose:** Research and analysis for architectural decisions  
**Status:** ✅ Active  
**Last Updated:** [DATE]

---

## 📋 Quick Links

### Active Research

*No active research yet. Use `/research [topic]` to start new research.*

---

## 🎯 Overview

This directory contains research documents, analysis, and requirements documentation that inform architectural decisions.

**Workflow:**
1. `/research [topic]` - Conduct structured research
2. `/decision [topic] --from-research` - Make decisions based on research
3. `/transition-plan --from-adr` - Transition to planning

---

## 📁 Directory Structure

```
docs/maintainers/research/
├── README.md                    # 📍 HUB - This file
└── [topic]/                    # Topic-specific research (created by /research command)
    ├── README.md               # Topic research hub
    ├── research-[topic].md    # Research documents for each topic
    ├── research-summary.md     # Summary of all research findings
    └── requirements.md         # Functional and non-functional requirements
```

---

## 🔄 Workflow

### Starting Research

Use the `/research` command to start new research:

```bash
/research [topic-name]
```

Or continue from exploration:

```bash
/research [topic-name] --from-explore [topic-name]
```

This creates:
- `docs/maintainers/research/[topic]/` directory
- Research documents for each research topic
- `research-summary.md` - Summary of all findings
- `requirements.md` - Functional and non-functional requirements (created automatically)
- `README.md` - Topic research hub

### Research → Decision → Planning

1. **Research** (`/research`) - Conduct structured research, extract requirements
2. **Decision** (`/decision`) - Make architectural decisions, create ADRs
3. **Transition** (`/transition-plan`) - Transition to feature planning

---

## 📋 Requirements Documentation

### Requirements Template

**Location:** `docs/maintainers/research/requirements-template.md`

This template provides a structure for documenting requirements discovered during research. The `/research` command automatically creates `requirements.md` files for each research topic, but you can also use this template manually.

**Template Structure:**
- **Functional Requirements (FR-N):** What the system must do
- **Non-Functional Requirements (NFR-N):** How the system must perform
- **Constraints (C-N):** Limitations and restrictions
- **Assumptions (A-N):** Beliefs taken for granted

### Requirements Workflow

1. **During Research:**
   - Requirements are discovered and documented
   - `/research` command automatically creates `requirements.md`
   - Requirements are extracted from research findings

2. **Requirements Storage:**
   - Location: `research/[topic]/requirements.md`
   - Created automatically by `/research` command
   - Can be created manually using `requirements-template.md`

3. **Requirements Usage:**
   - Inform architectural decisions (`/decision` command)
   - Used in transition planning (`/transition-plan` command)
   - Reference in ADRs and feature plans

### Using the Requirements Template

**Copy template for new research topic:**
```bash
cp docs/maintainers/research/requirements-template.md \
   docs/maintainers/research/[topic]/requirements.md
```

**Or let `/research` command create it automatically:**
```bash
/research [topic-name]
# Creates research/[topic]/requirements.md automatically
```

### Requirements Categories

**Functional Requirements (FR-N):**
- Describe what the system must do
- Features and capabilities
- Example: "System must support user authentication"

**Non-Functional Requirements (NFR-N):**
- Describe how the system must perform
- Quality attributes and system properties
- Example: "System must respond within 200ms"

**Constraints (C-N):**
- Limitations and restrictions
- Technical or business constraints
- Example: "Must use existing database infrastructure"

**Assumptions (A-N):**
- Beliefs taken for granted
- Conditions assumed to be true
- Example: "Users have modern browsers"

---

## 📚 Related Documentation

- **[Explorations Hub](../planning/explorations/README.md)** - Explorations and proof of concepts
- **[Decisions Hub](../decisions/README.md)** - Architecture Decision Records (ADRs)
- **[Feature Planning](../planning/features/README.md)** - Feature planning and implementation

---

**Last Updated:** [DATE]  
**Status:** ✅ Active

