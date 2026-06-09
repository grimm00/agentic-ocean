# Explorations Hub

**Purpose:** Active explorations and proof of concepts  
**Status:** ✅ Active  
**Last Updated:** [DATE]

---

## 📋 Quick Links

### Active Explorations

*No active explorations yet. Use `/explore [topic]` to start a new exploration.*

---

## 🎯 Overview

This directory contains active explorations, proof of concepts, and abstract ideas being explored before research and decision phases.

**Workflow:**
1. `/explore [topic]` - Start exploration
2. `/research [topic] --from-explore [topic]` - Conduct research
3. `/decision [topic] --from-research` - Make decisions
4. `/transition-plan --from-adr` - Transition to planning

---

## 📁 Directory Structure

```
docs/maintainers/planning/explorations/
├── README.md                    # 📍 HUB - This file
└── [topic]/                    # Topic-specific exploration (created by /explore command)
    ├── README.md               # Topic exploration hub
    ├── exploration.md         # Main exploration document
    └── research-topics.md     # Research topics identified
```

---

## 🔄 Workflow

### Starting an Exploration

Use the `/explore` command to start a new exploration:

```bash
/explore [topic-name]
```

This creates:
- `docs/maintainers/planning/explorations/[topic]/` directory
- `exploration.md` - Main exploration document
- `research-topics.md` - Research topics identified
- `README.md` - Topic exploration hub

### Exploration → Research → Decision

1. **Exploration** (`/explore`) - Organize abstract ideas, identify research topics
2. **Research** (`/research`) - Conduct structured research, extract requirements
3. **Decision** (`/decision`) - Make architectural decisions, create ADRs
4. **Transition** (`/transition-plan`) - Transition to feature planning

---

## 📚 Related Documentation

- **[Research Hub](../../research/README.md)** - Research documents and analysis
- **[Decisions Hub](../../decisions/README.md)** - Architecture Decision Records (ADRs)
- **[Feature Planning](../features/README.md)** - Feature planning and implementation

---

**Last Updated:** [DATE]  
**Status:** ✅ Active

