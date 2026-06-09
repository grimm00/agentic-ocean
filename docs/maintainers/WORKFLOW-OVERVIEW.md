# Workflow Overview

**Purpose:** Comprehensive guide to all available workflows in this project  
**Status:** ✅ Active  
**Last Updated:** [Date]

---

## 📋 Quick Links

### Workflow Guides

- **[Exploration/Research/Decision Workflow](WORKFLOW-EXPLORATION-RESEARCH-DECISION.md)** - Discovery and decision-making process
- **[Feature Development Workflow](WORKFLOW-FEATURE-DEVELOPMENT.md)** - Feature planning and implementation
- **[CI/CD Improvement Workflow](WORKFLOW-CICD-IMPROVEMENT.md)** - CI/CD process improvements

### Example Documents

- **[Example Exploration](examples/example-exploration.md)** - Sample exploration document
- **[Example Research](examples/example-research.md)** - Sample research document
- **[Example ADR](examples/example-adr.md)** - Sample architecture decision record
- **[Example Feature Plan](examples/example-feature-plan.md)** - Sample feature plan

---

## 🎯 Overview

This project uses structured workflows to manage development, planning, and decision-making. Each workflow is designed to support specific activities and integrates with workflow automation commands for efficiency.

### Available Workflows

1. **Exploration → Research → Decision → Planning** - For discovering and evaluating new ideas
2. **Feature Development** - For planning and implementing features
3. **CI/CD Improvement** - For improving CI/CD processes and workflows
4. **Status Updates** - For tracking progress and maintaining documentation

---

## 🚀 Quick Start

### New to the Project?

**Start here:**

1. **Read this overview** - Understand available workflows
2. **Review example documents** - See concrete examples of each document type
3. **Choose your workflow** - Based on what you're trying to accomplish:
   - **New idea?** → Use Exploration/Research/Decision workflow
   - **New feature?** → Use Feature Development workflow
   - **CI/CD improvement?** → Use CI/CD Improvement workflow

### Common Scenarios

**Scenario 1: I have a new idea**

→ Use [Exploration/Research/Decision Workflow](WORKFLOW-EXPLORATION-RESEARCH-DECISION.md)
- Start with `/explore` command
- Follow exploration → research → decision → planning sequence

**Scenario 2: I need to implement a feature**

→ Use [Feature Development Workflow](WORKFLOW-FEATURE-DEVELOPMENT.md)
- Create feature plan
- Use `/task-phase` to implement phases
- Use `/pr` to create pull requests

**Scenario 3: I want to improve CI/CD**

→ Use [CI/CD Improvement Workflow](WORKFLOW-CICD-IMPROVEMENT.md)
- Create improvement plan
- Use `/task-improvement` to implement phases
- Follow process/documentation workflow

---

## 📊 Workflow Comparison

| Workflow | Purpose | Commands | Output |
|----------|---------|----------|--------|
| **Exploration/Research/Decision** | Discover and evaluate ideas | `/explore`, `/research`, `/decision`, `/transition-plan` | Exploration docs, research docs, ADRs, feature plans |
| **Feature Development** | Plan and implement features | `/task-phase`, `/pr`, `/post-pr` | Feature plans, phase docs, PRs |
| **CI/CD Improvement** | Improve CI/CD processes | `/task-improvement`, `/pr` | Improvement plans, phase docs, PRs |
| **Status Updates** | Track progress | Automatic via commands | Status documents updated |

---

## 🔄 Workflow Integration

### How Workflows Connect

```
Exploration → Research → Decision → Feature Development
     ↓            ↓           ↓              ↓
  /explore    /research   /decision    /task-phase
     ↓            ↓           ↓              ↓
  Planning → Feature Plan → Phases → Implementation
```

### Workflow Automation

All workflows integrate with Cursor commands for automation:

- **Commands create documents** - Commands generate structured documents automatically
- **Commands update status** - Status documents updated automatically
- **Commands follow patterns** - Consistent structure across all workflows

---

## 📚 Detailed Guides

### Exploration/Research/Decision Workflow

**When to use:** New ideas, proof of concepts, architecture decisions

**Key steps:**
1. Explore idea (`/explore`)
2. Research topics (`/research`)
3. Make decisions (`/decision`)
4. Create transition plan (`/transition-plan`)

**See:** [Exploration/Research/Decision Workflow Guide](WORKFLOW-EXPLORATION-RESEARCH-DECISION.md)

### Feature Development Workflow

**When to use:** Implementing new features, enhancements

**Key steps:**
1. Create feature plan
2. Break into phases
3. Implement phases (`/task-phase`)
4. Create PR (`/pr`)
5. Update status (`/post-pr`)

**See:** [Feature Development Workflow Guide](WORKFLOW-FEATURE-DEVELOPMENT.md)

### CI/CD Improvement Workflow

**When to use:** Improving CI/CD processes, workflows, automation

**Key steps:**
1. Create improvement plan
2. Break into phases
3. Implement phases (`/task-improvement`)
4. Create PR (`/pr`)
5. Update status (`/post-pr`)

**See:** [CI/CD Improvement Workflow Guide](WORKFLOW-CICD-IMPROVEMENT.md)

---

## 💡 Best Practices

### Workflow Selection

- **Use Exploration/Research/Decision** for uncertain or complex decisions
- **Use Feature Development** for well-defined features
- **Use CI/CD Improvement** for process improvements

### Document Organization

- **Follow hub-and-spoke pattern** - Hub files link to detailed guides
- **Use consistent structure** - Follow template patterns
- **Keep documents current** - Update status as work progresses

### Command Usage

- **Use commands when possible** - Commands ensure consistency
- **Review generated documents** - Commands create structure, you add content
- **Follow command workflows** - Commands guide you through process

---

## 🔗 Related Documentation

### Planning

- [Planning Hub](planning/README.md) - Planning overview
- [Feature Planning](planning/features/README.md) - Feature development
- [CI/CD Planning](planning/ci/README.md) - CI/CD improvements

### Research and Decisions

- [Research Hub](research/README.md) - Research workflow
- [Decisions](decisions/) - Architecture decisions (ADRs)

### Examples

- [Example Documents](examples/) - Concrete examples of each document type

---

## ❓ Troubleshooting

### Which workflow should I use?

- **New idea or concept?** → Exploration/Research/Decision
- **Implementing a feature?** → Feature Development
- **Improving CI/CD?** → CI/CD Improvement

### How do I get started?

1. Read the relevant workflow guide
2. Review example documents
3. Use commands to create documents
4. Follow workflow steps

### Where are documents created?

- **Explorations:** `planning/explorations/[topic]/`
- **Research:** `research/[topic]/`
- **Decisions:** `decisions/[topic]/`
- **Features:** `planning/features/[feature-name]/`
- **CI/CD:** `planning/ci/[improvement-name]/`

---

**Last Updated:** [Date]  
**Status:** ✅ Active  
**Next:** Choose a workflow guide to get started

