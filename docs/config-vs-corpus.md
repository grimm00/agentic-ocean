# Config vs Corpus (Theme 10)

**Glossary:** the **corpus** is the actual skills/commands/agents content (this repo); the
**mapping** is the `installer.yaml` that says which corpus entries symlink to which editor
paths.

Two distinct things, deliberately kept apart:

| | Corpus | Config |
|--|--------|--------|
| **What** | The skills/commands/agents themselves | The install *mapping* (`installer.yaml`) + per-repo profiles |
| **Where** | A project dir, e.g. `~/Projects/agentic-ocean/` (this repo) | `~/.config/agentic-ocean/` (XDG) |
| **Nature** | Shared, versioned, portable across machines | Per-machine, paths differ, not shared |
| **Lifecycle** | `git clone` + `git pull` like any repo | Written once per machine (by the installer / by hand) |

## Why the split

The **corpus** is content you want versioned and identical everywhere — so it lives in
a git repo and travels by `clone`. The **mapping** is inherently machine-specific:
where your editor looks (`~/.cursor/skills/`), where you cloned the corpus
(`~/Projects/...`), which editors you run. Baking that into the repo would make the repo
non-portable (every machine would need a different committed value).

So: **config is config, corpus is a project, and the installer bridges them.** The
installer reads `~/.config/agentic-ocean/installer.yaml` and symlinks the corpus's
`corpus/<kind>/` entries into the editor paths that file names. Move to a new machine →
`clone` the corpus, drop an `installer.yaml` in XDG config (copy
[`installer.example.yaml`](../installer.example.yaml)), run the installer.

This is the XDG Base Directory split (config in `~/.config/`, project source elsewhere),
and the same separation behind tools like `git config`, `direnv`, and `mise`.

## See also

- [`installer-schema.md`](installer-schema.md) — the `installer.yaml` mapping schema
- [dev-infra **ADR-002** — Installation & Distribution Architecture](https://github.com/grimm00/dev-infra/blob/develop/admin/services/meta/features/skill-template-separation/decisions/adr-002-installation-architecture.md) (Theme 10) — the source decision
- [dev-infra **ADR-001** — Corpus Repository Split Model](https://github.com/grimm00/dev-infra/blob/develop/admin/services/ai-workflow/features/skill-corpus-installation/decisions/adr-001-corpus-repo-split-model.md) — the core/personal split

---

**Related:** [ADR-002](https://github.com/grimm00/dev-infra/blob/develop/admin/services/meta/features/skill-template-separation/decisions/adr-002-installation-architecture.md) (Theme 10) · [ADR-001](https://github.com/grimm00/dev-infra/blob/develop/admin/services/ai-workflow/features/skill-corpus-installation/decisions/adr-001-corpus-repo-split-model.md) (core/personal split)
