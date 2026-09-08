# Registers

Loadable **audience / voice** modules for skills and agents. Sibling of
`principles/`, `skills/`, and `agents/` under `~/.cursor/`.

```
~/.cursor/
├── principles/   ← what must be true (ownership, DoD)
├── registers/    ← how to say it (audience, plain language, jargon)
├── skills/
└── agents/
```

A register is not a principle and not a workflow. It answers: *who is reading,
and how should we write so they can re-enter cold?*

## Contract

1. **Hard-require for listed consumers** when authoring durable prose (architecture,
   runbooks, Docs-type plan Steps, PR Summary aimed at operators). Missing file →
   stop and say so.
2. **Opt-in by name** — do not load every register. Pick the audience for the
   artifact (default for maintainer/operator docs: `cold-reader-operator`).
3. **Exemplar over abstraction** — when a lived doc already nails the register,
   cite it in the register file so agents can imitate concrete shape.

## Registry

| Register | Path | Audience | Consumers (must load when writing that audience’s prose) |
|----------|------|----------|----------------------------------------------------------|
| Cold-reader operator | [`cold-reader-operator.md`](./cold-reader-operator.md) | Next-week-you / another operator re-entering cold | `write-plan` when Type is Docs/Mixed or Docs Acceptance; durable `docs/maintainers/**` and runbook authoring; `group-cycle` when writing operator-facing docs; PR Summary/Why when the change is operator/platform narrative |

## Adding a register

1. New kebab-case file here.
2. Row in the registry + Consumers header in the file.
3. One-line **Load** in each consumer (`read ~/.cursor/registers/<file>.md` before …).
4. Prefer naming an **exemplar path** (a real doc that already does it well).

---

**Last Updated:** 2026-09-03
