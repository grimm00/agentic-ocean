# Principles

Loadable normative modules for **skills** and **agents**. Sibling of `skills/`
and `agents/` under `~/.cursor/`.

```
~/.cursor/
├── principles/     ← what must be true
├── registers/      ← how to say it (audience / voice)
├── skills/
└── agents/
```

A principle is not a workflow. Skills/agents **read** the relevant principle
file(s) at runtime when their contract touches “done,” durable docs, or where
context lives — then apply that norm while executing.

**Related:** audience/voice modules live in [`../registers/`](../registers/README.md)
(e.g. `cold-reader-operator` for plain-language maintainer docs).

## Contract

1. **Hard-require for listed consumers** — if the consumer’s SKILL.md / agent
   file says to load a principle, **`read` it before the step that asserts
   done** (or scaffolds Acceptance/DoD). Missing file → stop and say so.
2. **Opt-in by name** — skills do not load every principle. The table below is
   the registry; add rows when a new principle ships.
3. **Not for `/discuss`** — discuss stays read-only and non-normative unless the
   user explicitly asks to reason about a principle.

## Registry

| Principle | Path | Consumers (must load) |
|-----------|------|------------------------|
| Documentation is ownership | [`documentation-is-ownership.md`](./documentation-is-ownership.md) | `write-plan` (parent + setup + expand), `plan-review`, `group-cycle` agent; also `/pr`, `/post-pr`, `/pr-validation`, `/task*` commands when those workflows assert Done |

## Adding a principle

1. New kebab-case file in this directory.
2. Row in the registry above + “Consumers” list in the principle’s header.
3. One-line **Load** instruction in each consumer’s SKILL.md / agent file
   (`read ~/.cursor/principles/<file>.md` before …).

---

**Last Updated:** 2026-09-03
