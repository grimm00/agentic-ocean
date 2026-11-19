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
explore-start → (human review) → research → decision → write-plan → implement
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

Lines of work are **topic-first**: one directory per line of work, named for the
topic, with `exploration.md` standing at its root and `research/`, `planning/`,
`decisions/`, `narratives/`, and `spike/` as sibling subdirectories created by
downstream skills.

```
<thinking_root>/<topic>/exploration.md
<thinking_root>/<topic>/research-topics.md
<thinking_root>/<topic>/research/      # created later by /research
<thinking_root>/<topic>/decisions/     # created later by /decision
<thinking_root>/<topic>/planning/      # created later by /write-plan
```

Before creating the first artifact, **`read ~/.cursor/principles/artifacts-live-with-the-work.md`**
and resolve `<thinking_root>` from it (config key `thinking_root`, default
`.scratch`) — once per invocation, then use it consistently.

Explorations are top-level peers of `planning/`, `research/`, and `decisions/` —
never nested under `planning/`.

**Legacy layouts** — `docs/maintainers/explorations/<topic>/` and
`admin/services/<service>/explorations/<topic>/`. If a topic already exists at one
of these, warn and work in place rather than splitting it; do not migrate silently.

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

Explore skills create documentation artifacts, so `<thinking_root>` decides whether
there is a commit at all:

- **Tracked** (e.g. `docs/maintainers`) — `docs(explore):` scope, pushed directly to
  the current branch (no PR required for docs-only changes).
- **Gitignored** (the `.scratch` default) — the artifacts are intentionally
  untracked. Skip the commit and stop after writing the files.

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
| Implementing planned work | `/implement` |

## Related

- **Downstream:** `/research --from-explore` consumes research-topics.md
- **Lateral:** `/discuss` for thinking without artifacts
- **Spike:** `/spike --from-explore` for high-risk topics needing validation
