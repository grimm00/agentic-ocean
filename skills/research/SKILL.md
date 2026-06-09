---
name: research
description: >-
  Research family parent. Provides orientation and shared conventions for
  research-setup, research-conduct, and research-consolidate. Do NOT invoke
  this skill directly — use a child skill listed below. Read this file when a
  child instructs you to load family conventions.
disable-model-invocation: true
---

# Research — Skill Family

Structured research from exploration or reflection through requirements ready
for decisions. This family replaces the multi-mode `/research` command:

```
research-setup → (human review) → research-conduct → (human review) → research-consolidate → /decision → /transition-plan
         ↑
    explore output & explore-amend
```

## Available Skills

| Skill | When to use |
|-------|-------------|
| **research-setup** | Initial scaffolding from exploration, reflection, or direct topic; **or** scaffold a late topic (`--add-topic` equivalent) into existing research |
| **research-conduct** | Fill research documents with findings, analysis, and requirements (web research, updates to summary and hub) |
| **research-consolidate** | After all topics are complete — reconcile exploration, dedupe and clean `requirements.md`, human-approved edits, Draft → Final |

**Conduct** and **consolidate** are separate skills so the largest behavioral
contracts stay isolated and reviewable (same rationale as explore separating
start vs amend).

## Family Conventions

Each child skill's `SKILL.md` opens with `read ../SKILL.md` — follow that
instruction before running child workflows. Path detection, topic naming, and
commit discipline are only specified here and are relied upon by every child.

### Path Detection

Detect structure **once** per invocation and stay consistent.

**Research directory (topic container):**

| Structure | Research path |
|-----------|---------------|
| Dev-infra | `admin/services/[service]/features/[topic]/research/` |
| Template project | `docs/maintainers/research/[topic]/` |
| Project-wide (maintainers research root exists) | `docs/maintainers/research/[topic]/` |

**Detection rule:** If `admin/services/` exists, use the dev-infra row (research
lives under the feature directory for that topic). If `docs/maintainers/research/`
exists and the dev-infra layout does not apply, use template / project-wide rows
as in the source `/research` command.

**Explorations (for `--from-explore`):** Use the **same exploration paths as the
explore family** — read `../explore/SKILL.md` Path Detection. Research reads
`research-topics.md` from the resolved exploration directory.

### Topic Naming

Sanitize research topic names to kebab-case: lowercase, hyphens for spaces, no
special characters. Align with explore family topic naming.

### Output Sizing (orientation)

| Artifact | Role |
|----------|------|
| Research hub `README.md` | Index + status table |
| Per-topic research docs | Question, methodology, findings, requirements discovered |
| `research-summary.md` | Cross-topic rollup |
| `requirements.md` | FR / NFR / constraints / assumptions |

Exact line targets live in **research-setup** (scaffolding) and
**research-conduct** (filled artifacts).

### Commit Discipline

Research artifacts are documentation. Use `docs(research):` commit scope unless
the project’s AGENTS.md prescribes a different pattern for maintainer docs.

### Filename Conventions (v1)

Initial setup creates per-topic files named `research-[question-name].md` (slug
from the question). **Add-topic** scaffolding creates `topic-N-[name].md` for
topic number `N` from `research-topics.md`. Both patterns may coexist in one
research directory until a future naming cleanup.

## When NOT to Use Research

| Situation | Use instead |
|-----------|-------------|
| Unstructured thinking before topics exist | **explore-start** or **explore-amend** |
| Conversation without file changes | **discuss** |
| Personal growth / retro | **reflect** |
| Time-boxed risk validation | **spike** |
| Executing an implementation plan | **task** workflow |

## Related

- **Upstream:** explore → `research-topics.md`
- **Downstream:** `/decision --from-research`, `/transition-plan --from-adr`
- **Lateral:** **explore** family for exploration paths and amend loop
- **Orchestration:** `~/.cursor/agents/research-orchestrator/` — agent that runs all incomplete topics in one pass (extracted from this skill family; orchestration is an agent concern, not a skill concern)
