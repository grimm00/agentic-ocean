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
| `install.sh` | Symlink-farm installer (additive, reversible). Maps from `corpus/` per `~/.config/agentic-ocean/installer.yaml`. |

## Core vs personal

This is the **core** half of a two-repo split ([dev-infra ADR-001](https://github.com/grimm00/dev-infra/blob/develop/admin/services/ai-workflow/features/skill-corpus-installation/decisions/adr-001-corpus-repo-split-model.md)):

- **Core (here):** general-purpose/durable, **or** depended on by a core artifact.
- **Personal (`agentic-ocean-personal`):** context-coupled, expirable, or private (`apprentice-*`, `ticket-*`, …).
- **Invariant:** core never depends on personal. (Verified at install by the core→personal check.)

## Installation

Per dev-infra ADR-002, skills install via a **symlink farm**: `install.sh` reads a mapping
from `~/.config/agentic-ocean/installer.yaml` and symlinks editor paths (`~/.cursor/skills/`,
…) into this repo's `corpus/`.

```bash
cp installer.example.yaml ~/.config/agentic-ocean/installer.yaml   # then adjust paths per machine
./install.sh                 # additive — skips (never clobbers) anything it didn't create
./install.sh --uninstall     # removes only its own links; corpus untouched
```

`--dry-run` previews, `--force` replaces a conflict (destructive), `--strict` errors on one,
`--warn-only` softens the core→personal check. Requires [`yq`](https://github.com/mikefarah/yq);
see `docs/installer-schema.md`. The full clone→install multi-machine flow (core + personal
together) lands in Group 5.

## Testing

`bats tests/` runs the installer suite; `shellcheck install.sh` lints it. CI runs both on
every push/PR (`.github/workflows/ci.yml`).

## Versioning

Independent of dev-infra — `agentic-ocean` releases on its own cadence (SemVer,
`0.x` while stabilizing). Changes tracked in `CHANGELOG.md`.

---

**Status:** 🟠 Active (skill-corpus-installation Group 4 — installer complete: install/
uninstall, additive collisions, core→personal check, CI). Multi-machine clone → `install.sh`
(core + personal) lands in Group 5.
