---
name: design-start
description: >-
  Create or accept a first-win design.md from Final requirements: name the win,
  main path, must-be-solid pieces, and later doors. Use when the user invokes
  /design-start. Do NOT reshape an existing design (design-revise), add diagrams
  (design-visual), or write implementation tasks (write-plan).
disable-model-invocation: true
---

# Design Start

Before proceeding, **`read ../SKILL.md`** for paths, status, document job,
anti-scope, sizing, gotchas, and commit discipline.

Create a **complete-enough first-win design** — substance only. Visuals are a
follow-on skill. Reshaping later is **design-revise**.

```
resolve topic + requirements → first-win sentence → fill template → stop
                              ↘ --accept: Draft → Ready beside Final requirements
```

## When to use

- Final (or clearly locked) requirements exist and the shape before planning is
  unclear.
- User says `/design-start` or wants a design.md for write-plan `from_design`.
- User accepts a reviewed Draft (`--accept`).

## When not to use

- No usable requirements → **requirements-setup** / amend / review first.
- Existing design needs reshaping → **design-revise**.
- Only need diagrams on an existing solid design → **design-visual**.
- Still thinking out loud → **discuss**.
- Ready to sequence tasks → **write-plan-start**.

## Options

| Invocation | Behavior |
|------------|----------|
| `/design-start [topic]` | Create Draft design.md for topic |
| `/design-start [topic] --dry-run` | Show paths + proposed first-win sentence; no write |
| `/design-start [topic] --force` | Overwrite existing Draft after stating what will be replaced |
| `/design-start [topic] --accept` | Promote live Draft → Ready (durable path); set Status Ready |

## Preconditions

1. Topic known (arg or clear feature context).
2. Readable requirements (prefer Final on durable path; else Draft with explicit
   user OK — record that in `Based on:`).
3. For create: target Draft does not exist — unless `--force`.
4. For `--accept`: Draft exists and human has reviewed (or waives in chat).

## Workflow

### 1. Resolve paths

Use family path detection. Default create path: **Draft** under `.scratch/…/design.md`.

Load:

- Final or live `requirements.md` (required)
- Optional: `notes/concepts/*` (including `*work-blocks*`), `notes/threads/*`,
  quality catalog — project override if present, else
  `../references/quality-attributes.md` (spine / Qualities hints only)

If both Draft and Ready exist and the user did not say which is live → stop.

### 2. Mode branch

| Mode | Action |
|------|--------|
| **Create** (default) | Continue to first-win → write new Draft from template |
| **`--dry-run`** | Print Draft path, Ready path, requirements path, first-win sentence → stop |
| **`--force`** | State what will be wiped → then Create overwrite of Draft |
| **`--accept`** | Skip create; go to step 5 |

If the user asked to change an existing design without `--force` / `--accept`,
hand off to **design-revise** — do not treat start as the reshape path.

### 3. Propose the first win

Write **one plain sentence** for section 1 before filling the rest. Prefer the
smallest honest win that does not claim later doors are done.

**Multi-product check:** if notes or requirements span several products, the
design’s job is the **spine** for the first win; other products become later
doors — not equal-depth chapters.

If you cannot state the win plainly, stop and suggest **discuss** — do not
emit a vague overview.

### 4. Copy template and fill (create / force)

Copy `../templates/design.md` to the Draft path. Fill sections **1–7**.

Rules:

- Section **8 Visuals**: leave the placeholder. Do not add Mermaid here.
- Plain language first; requirement IDs only as citations.
- Open choices stay open; do not fake ADRs.
- Hit family sizing targets; if later doors explode, shrink the first win.
- `Based on:` must point at the requirements file actually read.
- Status **Draft**.

### 5. Accept (promote)

Only with `--accept` (or clear “accept this design” + topic):

1. Confirm Draft content is the intended live substance.
2. Ensure durable parent dir exists (same directory as Final `requirements.md`
   when possible).
3. Move/copy Draft → Ready path; set **Status: Ready**; refresh **Updated:**.
4. Remove or leave Draft? **Prefer delete Draft** after successful Ready write
   so one live file remains. If delete feels wrong, stop and ask.
5. Suggest commit message per family discipline; do not commit unless asked.

### 6. Stop

Present:

- Path written (and Status)
- First-win sentence (create) or “Ready at …” (accept)
- Later-doors count
- Next: `/design-revise` if needed → `/design-visual` → `/write-plan`
  (`from_design`) after Ready

Do not start write-plan, design-revise, or design-visual unless asked this turn.

## Behavioral contract

- **First win or bust:** no one-sentence win → no file (except `--dry-run`
  showing the stuckness).
- **Spine not catalog:** equal-depth product design is a failure mode.
- **No plan leakage:** zero task checkboxes, zero “edit file X next.”
- **Delta-only chat:** point at the file; do not dump the full doc in chat.

## Gotchas

**“Make FR-1–N true for slice 1.”** That mixes Desire ceiling with first-win
scope. Translate to: which Desire must the *shape* satisfy now vs name as a
door.

**Accept without Final requirements.** Allowed only with user OK; Ready design
beside a missing Final requirements file is a smell — warn.

**Reshape via start.** Changing an existing picture is **design-revise**, not
another start (unless `--force` wipe of Draft).

## Related

- **design-revise** — reshape living design.md
- **design-visual** — diagrams after substance
- **write-plan-start** — `from_design` when Status is Ready (or user explicitly
  plans from Draft)
