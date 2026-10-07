---
name: design
description: >-
  Design skill family parent. Orientation for first-win design docs between
  Final requirements and write-plan. Do NOT invoke directly — use design-start,
  design-revise, or design-visual. Children read this file first for path rules
  and contracts.
disable-model-invocation: true
---

# Design — Skill Family

Produce a **design.md** that names the first honest win and the shape that
makes it true — between Desire (requirements) and ordered chores (write-plan).

```
Final requirements → design-start → design-revise (reshape) → design-visual (optional)
        ↓                    ↓
   [Draft in .scratch]   [design-start --accept → Ready]
                              ↓
                         write-plan (from_design) → implement
```

**Desire** = what must be true. **Design** = how the pieces fit for the first
win, plus named later doors. **Plan** = task order. If you are writing
checkboxes or PR sequencing, stop — that is write-plan.

### Shape, not ledger

`design.md` is a **mutable shape**. When the understanding changes, rewrite the
affected sections so the doc still reads as one coherent picture.

That is the opposite of **amend** skills elsewhere in the pipeline
(**explore-amend**, **requirements-amend**): those **add records** (new theme,
new FR ID, tombstones) and avoid disturbing prior entries. Design does **not**
grow an amendment log, changelog appendix, or append-only decision trail inside
the file. History lives in git (and discuss notes if you want narrative).

There is **no design-amend** child. Use **design-revise**.

## Available Skills

| Skill | When to use |
|-------|-------------|
| **design-start** | New design.md substance; `--accept` to promote Draft → Ready |
| **design-revise** | Reshape an existing live design.md in place (not append-only) |
| **design-visual** | After substance exists: add or refresh diagrams in place |

## Family Conventions

Children open with `read ../SKILL.md`.

### Path Detection

Detect once; stay on that row for the invocation. Prefer the same topic
directory **requirements** / **explore-start** use.

| Structure | Draft (scratch) | Ready (durable) |
|-----------|-----------------|-----------------|
| Warm scratch + maintainers docs | `.scratch/[area]/[topic]/design.md` | `docs/maintainers/[area]/[topic]/design.md` |
| Template maintainer | `.scratch/[topic]/design.md` | `docs/maintainers/[topic]/design.md` |
| Admin feature tree | under feature scratch if used; else ask | `admin/services/[service]/features/[topic]/design.md` (sibling of Final requirements) |

**Detection order:**

1. If the topic already has Final `requirements.md` on a durable path → Ready
   design lands **beside that file**; Draft still starts under the matching
   `.scratch/…` tree when one exists.
2. Else if `.scratch/` + `docs/maintainers/` exist → warm-scratch / template row.
3. Else if `admin/services/` exists → admin feature-tree row.
4. Else stop and ask where design.md should live (do not invent a private layout).

**One live file.** If both Draft and Ready exist, stop and ask which is live
before editing.

**Topic:** kebab-case (`area/topic` → area + topic when the tree is nested).

### Status

| Status | Meaning |
|--------|---------|
| **Draft** | Under `.scratch/`; shape still in review; default not committed |
| **Ready** | On durable path beside Final requirements; OK as write-plan `from_design` input |

**Promotion:** `/design-start [topic] --accept` moves Draft → Ready (see
design-start). Do not invent a second parallel design.md.

### Document Job

A design.md must answer, **in plain language first**:

1. **First win** — one sentence: the smallest honest useful outcome.
2. **Main path** — how pieces connect for that win (spine, not every product).
3. **Must be solid** — what load-bears for the win.
4. **Later doors** — Desire this pass only names as attachment points.
5. **Qualities** — few attributes the shape must honor for this win.
6. **Open choices** — real undecided how-questions; not fake completeness.
7. **Non-goals** — what this design pass refuses to deepen.
8. **Visuals** — optional; filled by **design-visual** after 1–4 have substance.

Shop IDs (FR-N, work-block letters) are **citations after** a plain sentence.
If a cold reader needs the jargon to understand the win, rewrite the win.

### Output sizing (start)

| Artifact | Target |
|----------|--------|
| design.md after **design-start** | ~60–120 lines of real prose/tables (not counting empty template chrome) |
| Later doors table | usually 3–8 rows; if more, the first win is probably too big |
| Open choices | 0–5; empty is fine |

### Anti-scope (hard)

- No implementation task lists, file-edit checklists, or PR order.
- No restating the full requirements set as a second FR list.
- No pretending later doors are done.
- No “make all FRs true in slice 1” — Final Desire is the ceiling; the design
  scopes the first win and attaches the rest.
- No visuals-before-substance: **design-visual** only when sections **1–4**
  have real content (placeholders and `_Add via…_` do not count).

### Templates

| Template | Use |
|----------|-----|
| `templates/design.md` | Always for **design-start** — copy, then fill in place |

### Context worth loading (optional)

When present under the topic, skim for spine hints — do not paste wholesale:

- `notes/concepts/*work-blocks*` (from `/work-blocks`) or similar segmentation notes
- `notes/threads/*` discuss captures
- Quality catalog (see Quality Attributes below)

### Commit Discipline

Do not commit a Draft under `.scratch/` unless the user asks.

When writing or updating Ready:

`docs(design): [start|accept|revise|visual|update] [topic] design`

Do not push unless asked.

### Quality Attributes

Resolve catalog in order:

1. Project override: `.scratch/quality-attribute-catalog.md` if present
2. Corpus reference: `references/quality-attributes.md` (this skill) —
   installed as `~/.cursor/skills/design/references/quality-attributes.md`

Skim/select when filling Qualities. Prefer 2–4 attributes for the first win;
list deferrals in one short bullet or under non-goals — do not expand the
design to absorb every catalog row. `/work-blocks` may already have a skim;
reuse it, don’t restart from zero.

## Gotchas

**Shop talk as the voice of the doc.** Failure mode from real use: the agent
explains with FR numbers and block letters before the plain win. Fix: plain
sentence first; IDs in parentheses or a Cite column.

**Designing the whole topic equally.** Multi-product features need a spine +
later doors. Equal depth on every product is plan-shaped sprawl.

**Skipping Desire lock.** A vague Draft requirements set yields a vague
design. Prefer Final; if only Draft, say so in `Based on:` and get user OK.

**Promoting too early.** Ready means “good enough for write-plan,” not
“implementation finished.”

## When NOT to Use This Family

| Situation | Use instead |
|-----------|-------------|
| Thinking without writing | **discuss** |
| Desire not locked | **requirements-*** |
| Comparing options for an ADR | **decision** |
| Ordered implementation tasks | **write-plan-start** |
| In-transcript chart only | **/visualize** |
| Persisting discuss notes (not design) | **capture-discussion** |

## Related

- **Upstream:** Final `requirements.md`; optional `/work-blocks` map + notes
- **Downstream:** **write-plan-start** input mode `from_design`
- **Lateral:** **discuss** before start; **capture-discussion** for notes;
  **work-blocks** for multi-product segmentation before or beside design
- **Reference:** [`references/quality-attributes.md`](references/quality-attributes.md)
