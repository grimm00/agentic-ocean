---
name: design-revise
description: >-
  Reshape an existing design.md in place when the first-win picture changes.
  Use when the user invokes /design-revise. Mutates the living shape — does NOT
  append amendment records (that is explore-amend / requirements-amend style).
  Do NOT create a new design (design-start) or only add diagrams (design-visual).
disable-model-invocation: true
---

# Design Revise

Before proceeding, **`read ../SKILL.md`** for paths, status, document job,
“shape not ledger,” anti-scope, and commit discipline.

Change the **living picture** in design.md so it stays coherent. Prefer
rewriting the sections that are wrong over appending “Amendment N” blocks.

```
locate live design.md → understand revise intent → reshape sections → stop
```

## Revise vs amend (pipeline contrast)

| | **design-revise** | **explore-amend / requirements-amend** |
|--|-------------------|----------------------------------------|
| Mental model | Mutable shape | Append-only (or ID-stable) ledger |
| Typical move | Replace / rewrite a section | Add a new theme, FR, or tombstone |
| Prior text | May be removed or folded in | Preserved; new record added |
| Changelog in file | No | Often yes (Updated lines / new IDs) |

If the user says “amend the design” or “edit the design,” treat it as
**design-revise** unless they explicitly want a requirements/explore-style
append (then redirect — do not invent design-amend).

## When to use

- First win, main path, doors, qualities, or open choices need to change.
- User says `/design-revise`, “reshape the design,” or “update the design doc”
  with directional intent.
- A diagram or discuss thread showed the prose is inconsistent.

## When not to use

- No design.md yet → **design-start**.
- Blind full rescaffold from template → **design-start --force** (Draft only)
  after stating impact.
- Diagrams only → **design-visual**.
- Promote Draft → Ready → **design-start --accept**.
- Thinking without writing → **discuss**.

## Options

| Invocation | Behavior |
|------------|----------|
| `/design-revise [topic] "…"` | Apply the quoted intent to the live design |
| `/design-revise [topic]` | Use the rest of the user message as intent; if empty, ask once |
| `/design-revise [topic] --dry-run` | Show planned section diffs in chat; no write |

## Preconditions

1. Exactly one live design.md (Draft or Ready). If both exist, stop and ask.
2. User intent is clear enough to know **which sections** move.
3. Substance still aims at a first win — if the revise abandons first-win
   framing entirely, stop and confirm before turning the doc into a full-topic
   encyclopedia.

## Workflow

### 1. Locate and read

Resolve live path per family rules. Read the full design.md.

### 2. Parse intent into section touches

Map the request onto document jobs (first win, main path, must-be-solid, later
doors, qualities, non-goals, open choices). Visuals:

- If the revise **invalidates** existing diagrams, either update them in the
  same turn (small, obvious label fixes) or strip/flag Visuals and tell the
  user to run **design-visual**.
- Do not use this skill as a back door to invent a large new diagram set —
  hand off to **design-visual**.

### 3. Reshape in place

- Rewrite the affected sections so the whole file still reads as **one** shape.
- Remove or fold obsolete claims; do **not** leave a trailing `## Amendments`
  / `## Changelog` / “Update 2026-…:” ledger in the body.
- Refresh `**Updated:**` date.
- Keep **Status** (Draft vs Ready) unless the user is also accepting — Ready
  revises stay Ready; do not silently demote.
- Preserve plain-language-first; fix jargon-only passages when you touch them.
- Re-check anti-scope: no task lists, no full FR restatement.

`--dry-run`: summarize section-level before/after in chat; do not write.

### 4. Consistency pass (short)

After changes, skim:

- Does section 1 still match section 2?
- Are later doors still doors (not secretly load-bearing in the main path)?
- Do open choices still belong (drop resolved ones; do not append “resolved”
  history — just remove or fold into prose)?

### 5. Stop

Point at the file; list sections touched. Suggest **design-visual** if figures
are stale; **write-plan** only if Status is Ready and the user asks.

Do not commit unless asked.

## Behavioral contract

- **Rewrite, don’t accumulate.** The file is the current shape, not a diary.
- **Surgical by default.** Touch only what the intent requires; don’t
  “improve” unrelated sections.
- **No silent rescaffold.** Full template reset is **design-start --force**,
  not this skill.
- **Delta-only chat.** Describe what changed; don’t paste the whole design.

## Gotchas

**Amendment reflex.** Agents trained on explore/requirements amend will want
to append. Resist. Delete or rewrite the wrong paragraph.

**Ready drift.** Revising Ready is allowed — the shape is still mutable — but
call out if the change is large enough that write-plan should be re-checked.

## Related

- **design-start** — create; `--accept` promote
- **design-visual** — diagrams after substance stable enough
- **explore-amend** / **requirements-amend** — ledger-style siblings (not this)
