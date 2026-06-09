# Exploration/Research/Decision Workflow

**Purpose:** Guide for discovery and decision-making workflow  
**Status:** ✅ Active  
**Last Updated:** [Date]

---

## 📋 Quick Links

- **[Workflow Overview](WORKFLOW-OVERVIEW.md)** - All available workflows
- **[Research Hub](research/README.md)** - Research documentation
- **[Decisions](decisions/)** - Architecture Decision Records (ADRs)
- **[Planning Hub](planning/README.md)** - Feature planning

### Example Documents

- **[Example Exploration](examples/example-exploration.md)** - Sample exploration document
- **[Example Research](examples/example-research.md)** - Sample research document
- **[Example ADR](examples/example-adr.md)** - Sample architecture decision record

---

## 🎯 Overview

The Exploration/Research/Decision workflow helps you discover, evaluate, and make informed decisions about new ideas, features, or architectural changes. This workflow guides you from initial exploration through structured research to documented decisions and planning.

### Workflow Sequence

```
Exploration → Research → Decision → Planning
    ↓           ↓          ↓          ↓
 /explore   /research  /decision  /transition-plan
```

### When to Use

- **New ideas or concepts** - When you have an idea that needs exploration
- **Proof of concepts** - Before committing to implementation
- **Architecture decisions** - When making significant technical choices
- **Feature evaluation** - When evaluating whether to build a feature

---

## 🚀 Quick Start

### Step 1: Explore

Start with exploration to organize your thoughts and identify research questions:

```bash
/explore [topic-name]
```

**Example:**
```bash
/explore user-authentication
```

**Output:**
- Exploration document created
- Research topics identified
- Ready for research phase

### Step 2: Research

Conduct structured research on topics identified in exploration:

```bash
/research [topic] --from-explore [topic]
```

**Example:**
```bash
/research user-authentication --from-explore user-authentication
```

**Output:**
- Research documents created for each topic
- Requirements document created
- Ready for decision phase

### Step 3: Decision

Make decisions based on research findings:

```bash
/decision [topic] --from-research
```

**Example:**
```bash
/decision user-authentication --from-research
```

**Output:**
- Architecture Decision Records (ADRs) created
- Decisions documented
- Ready for planning phase

### Step 4: Transition to Planning

Create transition plan and feature plan from decisions:

```bash
/transition-plan --from-adr
```

**Example:**
```bash
/transition-plan --from-adr
```

**Output:**
- Transition plan created
- Feature plan created
- Phase documents created (if applicable)
- Ready for implementation

---

## 📖 Detailed Workflow

### Phase 1: Exploration

**Purpose:** Organize thoughts, identify research questions, structure initial ideas

**Command:** `/explore [topic]`

**What it creates:**
- `planning/explorations/[topic]/exploration.md` - Main exploration document
- `planning/explorations/[topic]/research-topics.md` - List of research questions
- `planning/explorations/[topic]/README.md` - Exploration hub

**Key activities:**
1. **Describe the idea** - What are you exploring?
2. **Identify questions** - What needs to be researched?
3. **Prioritize topics** - Which questions are most important?
4. **Document context** - Why is this exploration needed?

**Example exploration topics:**
- New feature ideas
- Proof of concepts
- Architecture alternatives
- Technology evaluations

**Next step:** Move to research phase when you have clear research questions

---

### Phase 2: Research

**Purpose:** Conduct structured research to answer questions identified in exploration

**Command:** `/research [topic] --from-explore [topic]`

**What it creates:**
- `research/[topic]/README.md` - Research hub
- `research/[topic]/research-[question].md` - Research document for each question
- `research/[topic]/research-summary.md` - Summary of all research
- `research/[topic]/requirements.md` - Requirements discovered during research

**Key activities:**
1. **Read research topics** - From exploration document
2. **Conduct research** - Investigate each question
3. **Document findings** - Record sources, findings, analysis
4. **Extract requirements** - Identify functional/non-functional requirements
5. **Summarize research** - Create research summary

**Research structure:**
- Research questions
- Findings with sources
- Analysis and comparisons
- Key recommendations
- Requirements (FR-N, NFR-N, C-N, A-N)

**Next step:** Move to decision phase when research is complete

---

### Phase 3: Decision

**Purpose:** Make informed decisions based on research findings

**Command:** `/decision [topic] --from-research`

**What it creates:**
- `decisions/[topic]/README.md` - Decisions hub
- `decisions/[topic]/adr-[number]-[decision].md` - Architecture Decision Record for each decision
- `decisions/[topic]/decisions-summary.md` - Summary of all decisions

**Key activities:**
1. **Read research documents** - Review research findings
2. **Read requirements** - Understand requirements from research
3. **Identify decision points** - What decisions need to be made?
4. **Evaluate alternatives** - Consider options for each decision
5. **Document decisions** - Create ADR for each decision point
6. **Record rationale** - Why was this decision made?

**ADR structure:**
- Context
- Decision
- Consequences (positive/negative)
- Alternatives considered
- Decision rationale

**Next step:** Move to planning phase when decisions are made

---

### Phase 4: Transition to Planning

**Purpose:** Transition from decisions to implementation planning

**Command:** `/transition-plan --from-adr`

**What it creates:**
- `planning/features/[feature-name]/transition-plan.md` - Transition plan
- `planning/features/[feature-name]/feature-plan.md` - Feature plan
- `planning/features/[feature-name]/phase-1.md` - Phase documents (if applicable)

**Key activities:**
1. **Read ADR documents** - Review decisions made
2. **Create feature plan** - High-level feature planning
3. **Break into phases** - Plan implementation phases
4. **Create phase documents** - Detailed phase planning
5. **Document transition** - How to move from decision to implementation

**Transition plan structure:**
- Summary of decisions
- Feature overview
- Implementation approach
- Phase breakdown
- Success criteria

**Next step:** Begin feature development workflow

---

## 💡 Best Practices

### Exploration Phase

- **Be specific** - Clear topic names help organization
- **Focus on questions** - Identify what needs to be researched
- **Prioritize** - Mark high/medium/low priority research topics
- **Document context** - Why is this exploration needed?

### Research Phase

- **Use multiple sources** - Don't rely on single source
- **Document sources** - Include links and references
- **Be objective** - Present findings fairly
- **Extract requirements** - Identify FR-N, NFR-N, C-N, A-N
- **Create summary** - Synthesize findings

### Decision Phase

- **One ADR per decision** - Don't combine multiple decisions
- **Consider alternatives** - Evaluate options fairly
- **Document rationale** - Why was this decision made?
- **Record consequences** - Positive and negative impacts
- **Link to research** - Reference research findings

### Transition Phase

- **Review decisions** - Ensure all decisions are considered
- **Plan phases** - Break work into manageable phases
- **Set success criteria** - Define what success looks like
- **Document approach** - How will implementation proceed?

---

## 🔄 Workflow Integration

### Integration with Feature Development

After completing the Exploration/Research/Decision workflow, you transition to feature development:

```
Exploration → Research → Decision → Feature Development
     ↓           ↓          ↓              ↓
  /explore   /research  /decision    /task-phase
```

### Integration with Commands

All phases integrate with Cursor commands:

- **`/explore`** - Creates exploration structure
- **`/research`** - Creates research documents
- **`/decision`** - Creates ADR documents
- **`/transition-plan`** - Creates feature plan

### Document Organization

Documents are organized following hub-and-spoke pattern:

- **Hub files** - `README.md` files provide navigation
- **Spoke documents** - Individual documents focus on specific topics
- **Consistent structure** - Same patterns across all phases

---

## 📊 Workflow Diagram

```
┌─────────────┐
│  New Idea   │
└──────┬──────┘
       │
       ▼
┌─────────────┐     /explore
│ Exploration │ ────────────────────┐
└──────┬──────┘                     │
       │                             │
       ▼                             │
┌─────────────┐     /research        │
│   Research  │ ───────────────────┤
└──────┬──────┘                     │
       │                             │
       ▼                             │
┌─────────────┐     /decision        │
│  Decision   │ ───────────────────┤
└──────┬──────┘                     │
       │                             │
       ▼                             │
┌─────────────┐     /transition-plan │
│  Planning    │ ────────────────────┘
└──────┬──────┘
       │
       ▼
┌─────────────┐
│Feature Dev  │
└─────────────┘
```

---

## ❓ Common Questions

### When should I use this workflow?

Use this workflow when:
- You have a new idea that needs evaluation
- You're making significant architecture decisions
- You need to research before committing to implementation
- You want structured decision-making process

### Can I skip phases?

- **Exploration** - Can skip if research questions are clear
- **Research** - Required for informed decisions
- **Decision** - Required before planning
- **Transition** - Required to move to implementation

### How long does this workflow take?

- **Exploration:** 15-30 minutes
- **Research:** 1-4 hours (depends on complexity)
- **Decision:** 30-60 minutes
- **Transition:** 30-60 minutes

**Total:** 2-6 hours (depending on complexity)

### What if I need to revisit a phase?

You can revisit any phase:
- Update exploration document
- Add more research documents
- Create additional ADRs
- Update transition plan

---

## 🔗 Related Documentation

### Workflow Guides

- [Workflow Overview](WORKFLOW-OVERVIEW.md) - All workflows
- [Feature Development Workflow](WORKFLOW-FEATURE-DEVELOPMENT.md) - Implementation workflow
- [CI/CD Improvement Workflow](WORKFLOW-CICD-IMPROVEMENT.md) - Process improvements

### Command Documentation

- `/explore` - Exploration command
- `/research` - Research command
- `/decision` - Decision command
- `/transition-plan` - Transition planning command

### Example Documents

- [Example Exploration](examples/example-exploration.md)
- [Example Research](examples/example-research.md)
- [Example ADR](examples/example-adr.md)

---

**Last Updated:** [Date]  
**Status:** ✅ Active  
**Next:** Start with `/explore [topic]` to begin exploration

