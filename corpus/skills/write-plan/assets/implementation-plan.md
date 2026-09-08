---
task_count: [N]
groups:
  - name: "[Group 1 Name]"
    file: "tasks/01-group-name.md"
    tasks: [1, 2, 3]
  - name: "[Group 2 Name]"
    file: "tasks/02-group-name.md"
    tasks: [4, 5, 6, 7]
tasks_files:
  - "tasks/01-group-name.md"
  - "tasks/02-group-name.md"
---
# Implementation Plan — [Feature Name]

**Status:** 🔴 Not Started
**Created:** YYYY-MM-DD
**Last Updated:** YYYY-MM-DD
**Source:** [source path or description]

---

## 📋 Overview

[2-4 sentences describing the feature and what it achieves]

**Key Changes:**
- [Change 1]
- [Change 2]

---

## 🎯 Goals

1. **[Goal 1]** — [description]
2. **[Goal 2]** — [description]

---

## 📝 Implementation Plan

### [Group 1 Name]
- [ ] Task 1: [Task title]
- [ ] Task 2: [Task title]
- [ ] Task 3: [Task title]
- [ ] **Docs:** [update/split durable docs for this group — or “no durable doc change”]

### [Group 2 Name]
- [ ] Task 4: [Task title]
- [ ] Task 5: [Task title]
- [ ] **Docs:** [update/split durable docs — WIP marker OK until path closes]

---

## ✅ Definition of Done

- [ ] All tasks complete
- [ ] CI/CD passing
- [ ] **Docs ownership:** durable docs updated and/or split per group; WIP markers cleared or explicitly deferred (see `~/.cursor/principles/documentation-is-ownership.md`)
- [ ] Code comments stay thin (hazards / pointers only — narrative in docs/PRs)
- [ ] Templates synced

---

## 🔗 Related

- [Links to ADRs, design, prior stages]

---

**Last Updated:** YYYY-MM-DD
