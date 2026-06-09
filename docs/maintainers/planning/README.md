# Planning Hub

**Purpose:** Central coordination for project planning and roadmap management  
**Status:** ✅ Active  
**Last Updated:** [Date]

---

## 📋 Quick Links

### Core Planning

- **[Features](features/README.md)** - Feature-based planning and tracking
- **[Releases](releases/README.md)** - Release management and versioning
- **[Phases](phases/README.md)** - Development phase tracking
- **[Notes](notes/README.md)** - Planning insights and decisions

### CI/CD Planning

- **[CI/CD](ci/README.md)** - Continuous integration and deployment planning

---

## 🎯 Overview

The planning directory organizes all project planning activities using a hub-and-spoke documentation pattern. Each planning area has its own directory with focused documentation.

### Planning Philosophy

1. **Feature-Based Planning** - Organize work around user-facing features
2. **Hub-and-Spoke Documentation** - Clear entry points with detailed spoke documents
3. **Progressive Disclosure** - Overview → Plan → Task Groups → Analysis
4. **Status Tracking** - Consistent indicators and progress monitoring
5. **Decision Documentation** - Rationale and context preservation

---

## 📁 Directory Structure

```
planning/
├── features/                   # 📡 SPOKE - Feature planning
│   └── [feature-name]/        # Individual feature directories
│       ├── README.md          # Feature hub
│       ├── implementation-plan.md  # Task index with groups
│       ├── status-and-next-steps.md # Current status
│       ├── tasks/             # Task group details
│       │   ├── 01-group-name.md
│       │   └── 02-group-name.md
│       └── fix/               # Troubleshooting docs
├── releases/                  # 📡 SPOKE - Release management
│   ├── README.md              # Release hub
│   ├── history.md             # Release timeline
│   └── vX.Y.Z/                # Version-specific
│       ├── checklist.md       # Release checklist
│       └── release-notes.md   # Release notes
├── phases/                    # 📡 SPOKE - Development phases
│   └── *.md                   # Phase documentation
├── notes/                     # 📡 SPOKE - Planning insights
│   ├── opportunities/         # Feature opportunities
│   └── *.md                   # Planning notes
└── ci/                        # 📡 SPOKE - CI/CD planning
    └── [project-name]/        # CI project directories
```

---

## 🎨 Planning Patterns

### Feature Development Lifecycle

1. **Discovery** - Identify feature opportunity
2. **Planning** - Create `implementation-plan.md` with task groups
3. **Implementation** - Execute tasks with status tracking (`/task`)
4. **Completion** - Document results and lessons learned

### Release Management

1. **Planning** - Create release directory with checklist
2. **Preparation** - Complete checklist items
3. **Release** - Deploy and document
4. **Post-Release** - Update history and roadmap

### Task Group Tracking

1. **Definition** - Clear task boundaries and deliverables
2. **Execution** - Status tracking and progress updates
3. **Completion** - Results documentation and handoff
4. **Review** - Lessons learned and process improvement

---

## 📊 Current Status

### ✅ Active Planning

- [Active feature 1]
- [Active release 1]

### 🟡 Planned Items

- [Planned feature 1]
- [Planned release 1]

### 📈 Planning Metrics

- [Planning metric 1]
- [Planning metric 2]

---

## 🚀 Quick Start

### Starting a New Feature

1. Create feature directory: `features/[feature-name]/`
2. Run `/transition-plan` to generate scaffolding, or create manually:
   - `implementation-plan.md` — Task index with YAML frontmatter
   - `status-and-next-steps.md` — Progress tracking
   - `tasks/` directory with group files (e.g., `01-foundation.md`)
3. Create README.md hub with quick links
4. Expand task groups: `/transition-plan [feature] --expand --group N`
5. Implement tasks: `/task next`

### Planning a Release

1. Create release directory: `releases/vX.Y.Z/`
2. Add checklist.md with release steps
3. Write release-notes.md
4. Update history.md and roadmap.md

### Documenting Decisions

1. Create note in `notes/` directory
2. Document options and rationale
3. Link to related planning documents
4. Update status as decisions are made

---

## 📚 Related Documents

### Planning Guides

- [Feature Planning](features/README.md) - Feature development process
- [Release Process](releases/README.md) - Release management guide
- [Phase Management](phases/README.md) - Development phase tracking

### External References

- [Hub-and-Spoke Best Practices](../../../../docs/BEST-PRACTICES.md) - See hub-and-spoke documentation patterns

---

**Last Updated:** [Date]  
**Status:** ✅ Active  
**Next:** [Next planning task]
