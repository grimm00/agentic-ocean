# Architecture Decisions Hub

**Purpose:** Central hub for documenting architectural decisions  
**Status:** ✅ Active  
**Last Updated:** [DATE]

---

## 📋 Quick Links

### Architecture Decision Records (ADRs)

*No ADRs yet. Use `/decision [topic]` to create new ADRs.*

---

## 🎯 Overview

This directory documents architectural decisions made for the project, following the Architecture Decision Record (ADR) format. Each decision includes context, rationale, consequences, and references to supporting research.

### Decision Lifecycle

1. **Proposed** - Decision under consideration
2. **Approved** - Decision approved, ready for implementation
3. **Implemented** - Decision implemented and verified
4. **Superseded** - Decision replaced by a newer decision

---

## 📁 Directory Structure

```
docs/maintainers/decisions/
├── README.md                    # 📍 HUB - This file
└── [topic]/                    # Topic-specific decisions (created by /decision command)
    ├── README.md               # Topic decisions hub
    ├── adr-001-[decision].md  # Individual ADR documents
    ├── adr-002-[decision].md
    └── decisions-summary.md    # Summary of all decisions
```

---

## 🔄 Workflow

### Making Decisions

Use the `/decision` command to make decisions based on research:

```bash
/decision [topic-name] --from-research docs/maintainers/research/[topic]/research-summary.md
```

This creates:
- `docs/maintainers/decisions/[topic]/` directory
- ADR documents for each decision point
- `decisions-summary.md` - Summary of all decisions
- `README.md` - Topic decisions hub

### Decision → Planning

1. **Decision** (`/decision`) - Make architectural decisions, create ADRs
2. **Transition** (`/transition-plan`) - Transition to feature planning

---

## 📚 Related Documentation

- **[Explorations Hub](../planning/explorations/README.md)** - Explorations and proof of concepts
- **[Research Hub](../research/README.md)** - Research documents and analysis
- **[Feature Planning](../planning/features/README.md)** - Feature planning and implementation

---

**Last Updated:** [DATE]  
**Status:** ✅ Active

