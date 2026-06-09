# agentic-ocean

The **core** AI-agent corpus: the skills, commands, and agents you and your AI
agents are equipped with across repos. Shareable and durable — the basis for any
future second consumer.

> Generated from a dev-infra `standard-project` template (hence `docs/maintainers/`,
> CI, `.dev-infra.yml`), then repurposed as a flat corpus. App scaffolding
> (`backend/`, `frontend/`, `tests/`) was trimmed.

---

## What's here

All installable content lives under **`corpus/`** (separated from repo scaffolding):

| Path | Contents |
|------|----------|
| `corpus/skills/` | 14 core skills (`commit`, `decision`, `discuss`, `explore`, `handoff`, `int-opp`, `narrative`, `plan-review`, `pre-commit-review`, `reflect`, `research`, `spike`, `update-pr-description`, `write-plan`) |
| `corpus/commands/` | 20 core commands (workflow: `agent-dispatch`, `task`, `pr-validation`, `post-pr`, `release-*`, `fix-*`, …) |
| `corpus/agents/` | `group-cycle.agent.md`, `research-orchestrator/` |
| `install.sh` | *(coming in Group 4)* — symlink-farm installer; `corpus/` is the single payload root it maps from |

## Core vs personal

This is the **core** half of a two-repo split ([dev-infra ADR-001](https://github.com/grimm00/dev-infra/blob/develop/admin/services/ai-workflow/features/skill-corpus-installation/decisions/adr-001-corpus-repo-split-model.md)):

- **Core (here):** general-purpose/durable, **or** depended on by a core artifact.
- **Personal (`agentic-ocean-personal`):** context-coupled, expirable, or private (`apprentice-*`, `ticket-*`, …).
- **Invariant:** core never depends on personal. (Verified at install — Group 4.)

## Installation (preview)

Per dev-infra ADR-002, skills install via a **symlink farm**: an installer reads a
mapping from `~/.config/agentic-ocean/installer.yaml` and symlinks editor paths
(`~/.cursor/skills/`, …) into this repo. Confirmed working on Cursor (C-INST-1). The
`install.sh` lands in Group 4; until then this repo is the source of truth, manually linked.

## Versioning

Independent of dev-infra — `agentic-ocean` releases on its own cadence (SemVer,
`0.x` while stabilizing). Changes tracked in `CHANGELOG.md`.

---

**Status:** 🟠 Bootstrapping (skill-corpus-installation Group 2). Multi-machine
install (clone → `install.sh`) lands in Groups 4–5.
