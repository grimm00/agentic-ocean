---
name: explore
description: >-
  Explore family parent. Provides orientation and shared conventions for the
  explore skill family. Do NOT invoke this skill directly — use one of the
  children listed below. Read this file when a child skill instructs you to
  load family conventions.
disable-model-invocation: true
---

# Explore — Skill Family

Organize unstructured thoughts into themed explorations with prioritized
research questions. This is the entry point of the thinking pipeline:

```
explore-start → (human review) → research → decision → transition-plan → task
                      ↑
          explore-amend (feedback loop from downstream)
```

## Available Skills

| Skill | When to use |
|-------|-------------|
| **explore-start** | New exploration: organize raw thoughts into themes and research questions |
| **explore-amend** | Append a new theme or question to an existing expanded exploration |

**Conduct mode is deprecated.** Explorations are created complete by explore-start.
Do not create or invoke an `explore-conduct` skill.

## Family Conventions

Children that reference this parent (`read ../SKILL.md`) inherit these conventions.
A child MAY operate without reading the parent — these conventions are opt-in, not
enforced by the platform.

### Path Detection

Explorations live in different locations depending on project structure. Detect
once and use consistently within a single invocation:

| Structure | Explorations path |
|-----------|-------------------|
| Dev-infra | `admin/services/[service]/explorations/[topic]/` |
| Template project | `docs/maintainers/explorations/[topic]/` |

**Detection rule:** if `admin/services/` exists, use dev-infra paths; otherwise
use template project paths. Explorations are top-level peers of `planning/`,
`research/`, and `decisions/` — never nested under `planning/`.

### Output Sizing

| Artifact | Target size |
|----------|-------------|
| Exploration (start) | ~80–120 lines |
| Research topics (start) | ~25–40 lines |
| Amended theme (amend) | ~15–25 lines per theme added |

Explorations are **self-sufficient artifacts**, not scaffolding. Each theme
should have enough context (~4-6 bullets) to stand alone. Research topics
include a Context line per topic. The user decides the next step: research,
amend, or implement directly.

### Commit Discipline

Explore skills create documentation artifacts. Commits use `docs(explore):` scope
and can push directly to the current branch (no PR required for docs-only changes).

### Topic Naming

Sanitize topic names to kebab-case: lowercase, hyphens for spaces, no special
characters. Example: `"Improve CI Pipeline"` → `improve-ci-pipeline`.

## When NOT to Use Explore

| Situation | Use instead |
|-----------|-------------|
| Reacting to findings without formalizing | `/discuss` |
| Ready to investigate specific questions | `/research` |
| Ready to make a decision | `/decision` |
| Capturing a quick internal improvement | `/int-opp` |
| Implementing planned work | `/task` |

## Related

- **Downstream:** `/research --from-explore` consumes research-topics.md
- **Lateral:** `/discuss` for thinking without artifacts
- **Spike:** `/spike --from-explore` for high-risk topics needing validation
