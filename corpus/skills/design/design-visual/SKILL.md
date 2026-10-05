---
name: design-visual
description: >-
  Add or refresh diagrams in an existing design.md after first-win substance
  exists. Use when the user invokes /design-visual. Do NOT create a new design
  from scratch (design-start) or replace prose with pictures alone.
disable-model-invocation: true
---

# Design Visual

Before proceeding, **`read ../SKILL.md`** for paths, anti-scope, and gotchas.

Add **durable visuals into design.md** so write-plan and cold readers see the
main path and later-door seams. This is not `/visualize` (in-transcript only)
and not Canvas.

```
locate design.md → verify substance (sections 1–4) → choose 1–3 diagrams → write Visuals → stop
```

## When to use

- design.md sections **1–4** already have real content (not placeholders).
- User says `/design-visual` or wants Mermaid/flow figures **in the design file**.

## When not to use

- No design.md or empty first-win / main path / doors → **design-start** first.
- Only want a chat diagram → **/visualize**.
- Want tasks → **write-plan-start**.

## Options

| Invocation | Behavior |
|------------|----------|
| `/design-visual [topic]` | Update Visuals on the live design.md |
| `/design-visual [topic] --dry-run` | Propose diagram list + Mermaid in chat; no file write |
| `/design-visual [topic] --replace` | Replace existing Visuals body (default: refresh/merge by title) |

## Preconditions

1. Live design.md resolved (Draft or Ready — ask if both).
2. **Substance gate (hard):** sections **1 First win**, **2 Main path**,
   **3 Must be solid**, and **4 Later doors** are non-placeholder. Empty tables
   or “TBD” rows fail the gate → stop and point at **design-start** /
   **design-revise**.

## Workflow

### 1. Locate and read

Read the full design.md. Note first win, main path, must-be-solid, later doors,
open choices. Visuals must not contradict that prose.

### 2. Choose a small set of diagrams

Default budget: **1–3** figures. Prefer:

| Diagram | When |
|---------|------|
| Main path flow | Default yes — unless section 2’s ASCII is enough and user declines |
| Trust / boundary | Who may hold secrets / who runs plan / who is untrusted |
| Later-door attachment | One sketch showing doors as side exits, not equal peers |

Do not diagram every later door in depth. Do not invent boxes the prose never
named. Prefer plain labels; optional `(FR-N)` after the label.

### 3. Write into the file

Ensure `## 8. Visuals` (or `## Visuals`) exists.

For each figure:

```markdown
### [Short title]

[One sentence: what a cold reader should take away.]

\`\`\`mermaid
flowchart LR
  A[Plain label] --> B[Plain label]
\`\`\`
```

Allowed: Mermaid `flowchart`, `sequenceDiagram`. Skip exotic diagram types
unless the user asks.

`--dry-run`: show proposed figures in chat only.

`--replace`: overwrite the Visuals section body. Default: update/merge by
`###` title when possible; append new titles.

Update `**Updated:**` date. Do **not** change Status (Draft stays Draft).

### 4. Contradiction check

If a clear diagram cannot be drawn without adding components absent from
sections 1–4, **do not invent them**. Flag the gap in chat; suggest
**design-revise** or discuss.

### 5. Stop

Point at the file; list figure titles. Do not expand open choices or rewrite
the first win in the same turn unless the user asked.

## Behavioral contract

- **Substance before ink:** gate on sections 1–4.
- **Prose is source of truth:** visuals illustrate; they do not silently add
  architecture.
- **Small budget:** more than three figures → ask first (usually sprawl).
- **Durable artifact:** write design.md; do not only chat the Mermaid unless
  `--dry-run`.

## Gotchas

**Pretty diagram, wrong win.** If the picture shows secret-aware CI as
load-bearing while the first win says it is a later door, fix the diagram —
or flag that the prose is inconsistent.

**Replacing `/visualize`.** Chat-only pictures are fine for thinking; this
skill is for the file write-plan will read.

## Related

- **design-start** — create substance; `--accept` for Ready
- **design-revise** — reshape substance when prose is wrong
- **/visualize** — ephemeral in-transcript diagrams
- **write-plan-start** — next when shape is accepted
