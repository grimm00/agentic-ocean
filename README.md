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
| `corpus/skills/` | Core skills including `work-blocks`, `design`, `requirements`, `discuss`, `write-plan`, … (see `corpus/skills/`) |
| `corpus/commands/` | 19 workflow commands (`agent-dispatch`, `task`, `pr-validation`, `post-pr`, `release-*`, `fix-*`, …) — no duplicates of skills |
| `corpus/agents/` | `group-cycle.agent.md`, `research-orchestrator/` |
| `corpus/principles/` | Loadable norms (e.g. `documentation-is-ownership`) — equipped by skills/agents at runtime |
| `corpus/registers/` | Audience/voice modules (e.g. `cold-reader-operator`) — equipped when writing that audience’s prose |
| `install.sh` | Symlink-farm installer (additive, reversible). Maps from `corpus/` per `~/.config/agentic-ocean/installer.yaml`. |

## Core vs personal

This is the **core** half of a two-repo split ([dev-infra ADR-001](https://github.com/grimm00/dev-infra/blob/develop/admin/services/ai-workflow/features/skill-corpus-installation/decisions/adr-001-corpus-repo-split-model.md)):

- **Core (here):** general-purpose/durable, **or** depended on by a core artifact.
- **Personal (`agentic-ocean-personal`):** context-coupled, expirable, or private (`apprentice-*`, `ticket-*`, …).
- **Invariant:** core never depends on personal. (Verified at install by the core→personal check.)

## Installation

Per dev-infra ADR-002, skills install via a **symlink farm**: `install.sh` reads a mapping
from `~/.config/agentic-ocean/installer.yaml` and symlinks editor paths (`~/.cursor/skills/`,
`~/.cursor/principles/`, `~/.cursor/registers/`, …) into this repo's `corpus/`.

```bash
cp installer.example.yaml ~/.config/agentic-ocean/installer.yaml   # then adjust paths per machine
./install.sh                 # additive — skips (never clobbers) anything it didn't create
./install.sh --uninstall     # removes only its own links; corpus untouched
```

`--dry-run` previews, `--force` replaces a conflict (destructive), `--strict` errors on one,
`--warn-only` softens the core→personal check. Requires [`yq`](https://github.com/mikefarah/yq);
see `docs/installer-schema.md`.

### Fresh machine (one command)

`bootstrap.sh` clones the private personal repo as a sibling, seeds the config from
`installer.example.yaml` (rewriting corpus roots to the local clones), and runs `install.sh`:

```bash
git clone https://github.com/grimm00/agentic-ocean.git
cd agentic-ocean && ./bootstrap.sh        # add --core-only to skip the private personal repo
```

Idempotent and add-only; an existing `~/.config/agentic-ocean/installer.yaml` is left untouched.
The personal repo needs SSH/`gh` auth (`--core-only` otherwise). Requires `git` + `yq`.

## Testing

`bats tests/` runs the installer suite; `shellcheck install.sh` lints it. CI runs both on
every push/PR (`.github/workflows/ci.yml`).

- [`docs/config-vs-corpus.md`](docs/config-vs-corpus.md) — why the mapping lives in `~/.config/` while the corpus lives here (Theme 10)
- [`docs/installer-schema.md`](docs/installer-schema.md) — the `installer.yaml` mapping schema

## Versioning

Independent of dev-infra — `agentic-ocean` releases on its own cadence (SemVer,
`0.x` while stabilizing). Changes tracked in `CHANGELOG.md`.

---

**Status:** 🟠 Active (skill-corpus-installation Group 4 — installer complete: install/
uninstall, additive collisions, core→personal check, CI). Multi-machine clone → `install.sh`
(core + personal) lands in Group 5.
