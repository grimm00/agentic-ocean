# Principle: Artifacts live with the work

**Id:** `artifacts-live-with-the-work`  
**Status:** Active  
**Last Updated:** 2026-09-09

**Consumers (hard-require):** explore family · write-plan family · capture-discussion.

**Load:** `read ~/.cursor/principles/artifacts-live-with-the-work.md` before creating
the first artifact of a line of work, or whenever resolving where an artifact goes.

---

## Statement

The artifacts of one line of work — exploration, research, decisions, planning,
narratives, spikes — belong **together under one root named for the topic**, not
scattered by artifact type across the repo. Downstream skills join an existing line
of work; they do not invent a second home for it.

The root itself is **configuration, not corpus**. A skill never hardcodes it: the same
corpus has to work in a repo that version-controls its thinking and in one that throws
it away.

**Default is untracked.** Thinking is not committed to a repo's history unless the
operator asked for that.

## Layout

```
<thinking_root>/<topic>/exploration.md
<thinking_root>/<topic>/research-topics.md
<thinking_root>/<topic>/research/       # created by /research
<thinking_root>/<topic>/decisions/      # created by /decision
<thinking_root>/<topic>/planning/       # created by /write-plan
<thinking_root>/<topic>/narratives/     # created by /narrative
<thinking_root>/<topic>/spike/          # created by /spike
```

`<topic>` is the line of work in kebab-case — the same directory every downstream
skill reuses. Resolve the root **once per invocation** and use it consistently.

## Resolution

Read the shared config at `${XDG_CONFIG_HOME:-$HOME/.config}/cursor-skills/config.yaml`,
then apply in order:

1. An explicit flag on the invocation (e.g. `--dir`) — wins over everything.
2. `repos.<slug>.<key>`, where `slug` is `basename $(git remote get-url origin) .git`.
3. The top-level `<key>`.
4. The key's built-in default.

A **missing or silent config is not an error** — the default applies. Note the
asymmetry: this principle file is hard-required for its consumers, but the config
file it describes is optional.

### Keys

| Key | Consumers | Default | Tracked? |
|-----|-----------|---------|----------|
| `thinking_root` | explore, write-plan, and the downstream `research/` · `decisions/` · `narratives/` · `spike/` trees | `.scratch` | gitignored |
| `notes_root` | capture-discussion | `notes/` at workspace root | repo's choice |

`docs/maintainers` is the recommended `thinking_root` override when thinking should
be version-controlled and shared.

`notes_root` is a **standalone library**, not a topic subtree — notes outlive any one
line of work, so they are rooted separately and keep a flat shape.

## Commit discipline follows the root

The root decides whether there is anything to commit:

- **Tracked root** (e.g. `docs/maintainers`) — commit with the skill's docs scope
  (`docs(explore):`, `docs([topic]):`); docs-only may push directly per repo habit;
  never force-push.
- **Gitignored root** (the `.scratch` default) — the tree is intentionally untracked.
  There is nothing to commit: **skip the commit step and stop after writing the files.**

Never infer "commit" from habit. Check the root first.

## Legacy layouts

Artifact-first layouts predate this principle:

- `docs/maintainers/explorations/<topic>/` · `docs/maintainers/planning/features/<feature>/`
- `admin/services/<service>/explorations/<topic>/` · `admin/services/<service>/features/<feature>/planning/`
- `<project>/<feature>/planning/` (CatdogServices-style)

If a line of work **already** lives at one of these, warn and **work in place**. Do not
migrate or split it silently. New work uses the topic-first layout.

## Anti-patterns

- Hardcoding a root in a SKILL.md — that is config's job, and it makes the corpus
  non-portable
- Splitting one line of work across two roots because a later skill re-resolved
  independently
- Committing a `.scratch` tree, or tracking it "to keep it safe"
- Migrating an existing legacy tree without asking

## Not for `/discuss`

`/discuss` is read-only by contract and creates no artifacts, so it has no root to
resolve.
