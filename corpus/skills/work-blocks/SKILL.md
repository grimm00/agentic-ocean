---
name: work-blocks
description: >-
  Segment a multi-product feature into lettered work blocks after substantive
  Draft requirements and /discuss, before /write-plan. Writes a concept map
  (job / status / depends / unblocks, walk order, Gaps, light quality-attribute
  skim). Use when the user invokes /work-blocks, when dependencies or colocated
  concerns argue with each other, or when the topic feels like one blob with
  half-specified pieces. Do NOT use at first explore theme, for a single clear
  product with no cross-block deps, as a formal plan, or as requirements-amend.
disable-model-invocation: true
---

# Work Blocks

Lay-of-the-land segmentation for late requirements. Turn a mega-feature blob into
lettered products that share a story, so gaps and walk order are visible before
planning.

```
survey artifacts → name the story → cut lettered blocks
  → Gaps table → quality skim → write concept doc → stop
```

This skill **writes**. It is the deliberate companion to `/discuss` (read-only)
and sits beside `/capture-discussion` — capture preserves thread/concept notes;
work-blocks produces the segmentation map. It is **not** a plan and **not** a
requirements amend.

Repo-layout agnostic: follow whatever notes / scratch / docs tree the project
already uses. Do not invent a home-lab layout at work.

---

## When to use

- After substantive Draft requirements + `/discuss`, when dependencies or
  colocated concerns (stores, configs, CI vs local) start arguing with each other
- When the topic feels like one blob and half-specified / never-written pieces
  are hard to see
- Before `/write-plan` or `/design-start`, when the user wants a one-by-one walk
  of scope (design still picks a spine; this map makes the products visible)
- Explicit `/work-blocks [topic]` (or `/work-blocks --dir <path>`)

## When NOT to use

| Situation | Use instead |
|-----------|-------------|
| First explore theme / early brainstorm | `/explore`, `/discuss` |
| Single clear product, no cross-block deps | Stay in requirements / discuss |
| Persisting a discuss thread or one concept | `/capture-discussion` |
| Adding or editing FR/NFR IDs | `/requirements-amend` |
| First-win shape / Qualities deep-dive | `/design-start` |
| Sequenced implementation steps | `/write-plan` |
| Closing Draft → Final | `/requirements-review` |

Too early → segment fiction. Too late → half-built wrong cut. Rough trigger:
enough Draft requirements / discuss that second-source-of-truth or dependency
arguments appear.

---

## Options

| Invocation | Behavior |
|------------|----------|
| `/work-blocks [topic]` | Segment the named feature/topic |
| `/work-blocks` | Infer topic from branch, open scratch/notes, or recent discuss |
| `/work-blocks --dir <path>` | Force notes/concept output directory |

---

## Path resolution

Prefer the project’s existing notes taxonomy. Do **not** invent a new root when
one already exists:

1. **`--dir <path>`** if passed
2. **Feature / topic notes** — if the topic already has a notes tree
   (`notes/concepts/`, or under `.scratch/…/notes/concepts/`, or the repo’s
   equivalent), write there; create `concepts/` under that notes tree if missing
3. **Shared scratch notes** — `.scratch/notes/concepts/` when that library exists
   and the topic is cross-cutting
4. **Workspace `notes/concepts/`** — only if neither of the above exists
5. If the layout is unclear → ask once; do not assume a private-repo path

File name: `{topic}-work-blocks.md` (kebab-case, no dates in the filename).
Dates live inside the file as `Created:` / `Updated:`.
Update in place when the file already exists.

### Quality catalog resolution

1. **Project override** — `.scratch/quality-attribute-catalog.md` or a
   project-local `QUALITY-ATTRIBUTES.md` if present
2. **Corpus reference** — `~/.cursor/skills/design/references/quality-attributes.md`
   (sibling of this skill when installed from the same corpus)
3. If neither exists → skip skim; note that in chat

---

## Workflow

### 1. Survey

Read what exists for the topic (skip missing paths; do not invent content):

- Draft or Final `requirements.md`
- Topic `notes/threads/`, `notes/concepts/` (or equivalent)
- Exploration / research summary if present
- Any prior `{topic}-work-blocks.md` (update in place rather than duplicate)

State in chat which artifacts you loaded.

### 2. One-sentence story

Write the shared story: several products, one narrative. Prefer recovery /
conventions / shared inputs framing when it fits — not a feature shopping list.

### 3. Cut lettered blocks

Usually **A–F** (fewer is fine; more than ~8 means cut too fine). For each block:

| Field | Meaning |
|-------|---------|
| **Job** | One sentence — what this product does |
| **Piece table** | Named pieces with status (exists / FR locked / discussed / open / gap / implement open) |
| **Depends on** | Other letters (or “nothing — foundation”) |
| **Unblocks** | What becomes honest after this block |

Force “several products sharing a story,” not phases of one mega-task.

Ask about **conventions and recovery** (shared keys, env vs instance, sensitive
vs not, generate-before-consume). Do **not** force one schema per feature.

### 4. Suggested walk order

Numbered list: which letter first, what can run in parallel, what must not be
pretended ready (e.g. CI without durable inputs + a trusted render/generate path).

### 5. Gaps table

Separate from block status so holes don’t hide inside open discuss threads:

| Gap | Why it matters | Likely home |
|-----|----------------|-------------|
| … | … | Block X / FR-? / implement |

If a gap later gets an FR, keep the row and mark requirements-done / implement
open — do not delete history that made the hole visible.

### 6. Quality-attribute skim (light)

Resolve the catalog (see Path resolution). For each attribute that **bites a
block now**, one line — UX **and** DevX / operator / agent experience.

- **Act on with [letter]:** attributes that change this pass
- **Deferred:** attributes that must not expand the current block

This is **not** a full NFR checklist. Deep selection stays at `/design`
Qualities when that exists.

### 7. Write and stop

1. Read `templates/work-blocks.md`; fill placeholders; omit unused sections
2. Write/update the concept doc under the resolved `notes/concepts/` path
3. Cross-link parent thread / requirements / related concepts when they exist
4. Present: path written, block letters + one-line jobs, gap count, suggested
   next letter to walk
5. Suggest (do not run): `/requirements-amend` for named FR gaps,
   `/design-start` when a spine is clear, `/write-plan` when a block is ready
   to sequence
6. Do **not** amend requirements, write a plan, or commit unless the user asks

---

## Behavioral contract

**Writable companion, not discuss.** Exit read-only deliberately. Name the mode
switch if invoked after `/discuss`.

**Map, not plan.** No task checkboxes, no week estimates, no implementation
sequence beyond “walk letter X before Y.”

**Gaps stay visible.** Half-specified and never-written pieces belong in the
Gaps table or piece status — not only in chat.

**Preserve user framing.** Keep their language for anxiety / ambiguity (“I don’t
know what I’m asking for specifically,” “second source of truth,” etc.) in the
story / gaps.

**Layout-agnostic.** Follow the repo in front of you. Home layouts and work
layouts both work; neither is assumed.

**One-by-one thereafter.** Tell the user: for each letter, decide
done / amend requirements / implement / defer — then open the next letter.
Do not re-merge A–F into one mega-task mid-walk.

---

## Gotchas

**Segmenting at first theme.** Early cuts invent products that don’t exist yet.
Wait for dependency arguments.

**Turning blocks into a plan or a design.** Walk order ≠ `/write-plan`. Spine +
Qualities ≠ this map — hand off to `/design-start` when the first win is clear.

**Hiding gaps inside piece tables.** If it has no FR and isn’t implemented, it
is a Gap (or explicitly “implement open” after FR lock).

**Full NFR essay during skim.** One line per biting attribute. Catalog deep
selection is design’s job.

**Inventing a notes root.** Prefer the feature/topic notes tree already in use.

**Amending FRs from this skill.** Name missing FRs in Gaps; leave
`/requirements-amend` to the user.

**Ignoring the corpus catalog.** Prefer the design `references/` file when no
project override exists — do not skip the skim silently.

---

## Related skills

- `/discuss` — read-only thinking; promote here when multi-product smell appears
- `/capture-discussion` — persist threads/concepts; may defer segmentation here
- `/requirements-amend` / `/requirements-review` — when gate needs an FR or close-out
- `/design-start` — first-win shape after products are visible; reads work-blocks notes
- `/write-plan` — after a block (or thin slice) is ready to sequence
- `/int-opp` — capture learnings that improve this skill later
