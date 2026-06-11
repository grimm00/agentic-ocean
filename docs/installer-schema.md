# `installer.yaml` Schema (v1)

The installer (`install.sh`, Group 4) reads a declarative mapping that tells it
**what to symlink where**. The mapping is per-machine config and lives at
`~/.config/agentic-ocean/installer.yaml` (XDG) — not in this repo. This repo ships
[`installer.example.yaml`](../installer.example.yaml) as the starting point to copy.

> Why config, not in-repo: paths differ per machine/editor; the corpus is shared and
> versioned. Config is config; the corpus is a project (ADR-002 Theme 10).

---

## Shape

```yaml
schema_version: 1

sources:
  - name: <identifier>           # human label for the source repo
    root: <path>/corpus          # the corpus/ payload root of a source repo
    links:
      skills: <editor-target-dir>
      commands: <editor-target-dir>
      agents: <editor-target-dir>
  - name: ...                    # additional sources (e.g. the personal repo)
```

| Field | Meaning |
|-------|---------|
| `schema_version` | Integer; `1`. Bumped only on breaking schema changes. |
| `sources[]` | One block per corpus repo. **Multi-source** by design (core + personal; ADR-001). |
| `sources[].name` | Label (for logs / collision messages). |
| `sources[].role` | Optional; `core` or `personal`. Drives the ADR-001 core→personal check (see below). Omit it and the check is skipped. |
| `sources[].root` | The repo's **`corpus/`** payload root (not the repo root — repo root holds non-installable scaffolding). |
| `sources[].links.<kind>` | Maps a payload kind (`skills` / `commands` / `agents`) to the editor target dir it installs into. |

---

## Semantics

- **Per-item linking.** For each `source × kind`, the installer symlinks **each entry**
  under `root/<kind>/` into the target dir — `corpus/skills/<name>` →
  `<target>/<name>`. (It does **not** replace the target dir itself.) This is what lets
  multiple sources populate the same `~/.cursor/skills/` side by side.
- **Multi-source merge.** All sources linking into the same target dir is expected
  (core + personal both → `~/.cursor/skills/`).
- **Collision = additive, never clobber** (feature ADR-002). `~/.cursor/` is always a
  managed/shared space, so a target that the installer didn't create is never overwritten.
  On collision it compares contents: **identical → skip silently**; **differs → skip and
  warn**, then continue. `--force` replaces (destructive — unsafe against a managed/team
  config); `--strict` errors on a divergent collision. The same rule covers two sources
  exposing the same entry name into one target — a *divergent* clash there flags a real
  problem (e.g. accidental core→personal duplication, which Task 15's lint also guards).
- **Targets are parameterized.** No editor path is hardcoded in `install.sh`; everything
  comes from this file. Adding an editor (e.g. `~/.claude/skills`) = adding `links`
  entries, not changing the script.
- **Lookup order (Group 4).** `$XDG_CONFIG_HOME/agentic-ocean/installer.yaml` then
  `~/.config/agentic-ocean/installer.yaml`.
- **Core→personal check (ADR-001 invariant).** Before linking, if the config has both a
  `role: core` and a `role: personal` source, the installer verifies no **core** artifact
  references a **personal-only** entry (a name present in personal sources but not core) —
  else a core-only clone would break. By default a hit is an **error** that names the
  offending file; `--warn-only` downgrades it to a warning and proceeds. **Heuristic, not
  semantic:** it greps core files for personal-only names whole-word/fixed-string, so it
  can false-positive on a coincidental word and miss references made by a different name.
  Without role markers the check is skipped. (`--force` does *not* bypass it — separate concern.)

---

## Not in scope here

- The `install.sh` implementation (Group 4).
- Per-repo profiles at `~/.config/agentic-ocean/repos/` (ADR-003 — separate plan).
- Copy-mode fallback (contingency only; symlink confirmed working, C-INST-1 GO).

---

**Schema version:** 1 · **Related:** dev-infra ADR-002 (installation architecture), ADR-001 (core/personal split)
