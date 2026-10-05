---
name: requirements
description: >-
  Requirements family parent. Shared conventions for requirements-setup,
  requirements-amend, and requirements-review. Do NOT invoke this skill
  directly — use a child skill. Read this file when a child says to load
  family conventions.
disable-model-invocation: true
---

# Requirements — Skill Family

The requirements document for a topic, with or without research. This family
owns `requirements.md`. Research may discover candidates. It does not scaffold,
number, or finalize this file.

```
requirements-setup → (human review) → requirements-amend → requirements-review → /decision
                                              ↑
                         implementation, discussion, or research candidates
```

**Review**, not consolidate. Consolidate meant folding research topics into one
list. This gate reads one requirements document, proposes cleanup, and flips
Draft → Final after approval. There is nothing to squash.

## Available Skills

| Skill | When to use |
|-------|-------------|
| **requirements-setup** | New `requirements.md` for a topic. Scaffold only, plus any statements the user already gave. |
| **requirements-amend** | Add or edit requirements in place. No renumber. No Draft → Final. |
| **requirements-review** | After the set is ready to close: redundancy, stale text, gaps, priority. Human approval, then Draft → Final. |

## Family Conventions

Each child opens with `read ../SKILL.md`. Path detection, IDs, document shape,
and commit discipline live only here.

### Path Detection

Use the same topic directory **explore-start** would. Read `../explore/SKILL.md`
Path Detection and stay on that row for the invocation.

`requirements.md` sits in the topic directory, next to `exploration.md`. The
exploration files do not have to exist yet.

| Status | File |
|--------|------|
| Draft | the scratch topic directory + `requirements.md` |
| Final | the durable topic directory + `requirements.md` |

On a template project that is `.scratch/[topic-path]/requirements.md` until
review, then `docs/maintainers/[topic-path]/requirements.md`. A topic path may
include a parent area, as in `game-host-management/palworld`. `.scratch/` is
gitignored. A
Draft is not committed. **requirements-review** is what moves the file out of
scratch onto the durable topic directory.

One file only. If both the scratch copy and the explore-path copy exist, stop
and ask which one is live. Do not edit both.

**Existing research copy:** If `research/[topic]/requirements.md` exists and
neither path above does, stop. Ask before moving it.

### Topic Naming

Kebab-case: lowercase, hyphens, no special characters. Same rule as explore
and research.

### Document Shape

```markdown
# Requirements: [Topic]

**Status:** Draft
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD

## Overview

[What this set is for. One paragraph.]

## Functional

## Non-functional

## Constraints

## Assumptions
```

One requirement:

```markdown
### FR-1: [short name]

[One or two sentences.]

**Source:** [where this came from]
**Updated:** YYYY-MM-DD — [one line, only when amended]
```

### IDs

| Prefix | Section |
|--------|---------|
| `FR` | Functional |
| `NFR` | Non-functional |
| `C` | Constraints |
| `A` | Assumptions |

Each prefix numbers from 1. **Amend** uses max+1 and never renumbers.
**Review** may renumber once, after the user approves removals, and must fix
every reference to the old IDs.

An explicit removal during amend leaves a tombstone instead of a hole:

`### FR-3: removed YYYY-MM-DD — [why]`

### Commit Discipline

Do not commit a Draft. It is under `.scratch/`.

The first commit is the move to Final, from **requirements-review**:

`docs(requirements): review [topic] requirements`

Do not push unless asked. Sending a Final document back to Draft removes it
from the explore path and writes it under `.scratch/` again. Commit that
removal only when the user asked to commit:

`docs(requirements): return [topic] requirements to draft`

## When NOT to Use Requirements

| Situation | Use instead |
|-----------|-------------|
| Open questions, no statements yet | **explore-start** or **research-setup** |
| Filling findings from sources | **research-conduct** |
| Conversation without a document | **discuss** |
| Executing an implementation plan | **task** |

## Related

- **Upstream:** the user, or **Requirements Discovered** in a research topic
- **Downstream:** `/decision`, then the plan and task workflow
- **Not this family:** **research-consolidate** reconciles exploration with
  research topics. It does not edit this document.
