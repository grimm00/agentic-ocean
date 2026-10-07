# <Topic> — work blocks (A–…)

**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD
**Origin:** <Discussion thread / requirements set this map came from>
**Status:** Working map — not a formal plan or decision record. Use to walk scope one block at a time.
**Context:** <One line: why this pass exists now>

---

## The idea in one sentence

<Several products sharing a story — name them and the order-of-honesty that matters (e.g. recovery before CI polish).>

---

## Why this exists

Sitting on the whole topic felt like one blob. Segmenting makes it obvious which pieces are requirements-done vs still implement-only.

Walk **A → B → …** (or pick a single letter) without replaying the full discuss thread.

---

## Blocks

### A — <short name>

**Job:** <One sentence.>

| Piece | Status |
|---|---|
| <piece> | <Exists / FR locked / discussed / open / gap / implement open> |

**Depends on:** <Nothing in this list (foundation) | other letters>  
**Unblocks:** <What becomes honest after this block>

---

### B — <short name>

**Job:** <One sentence.>

| Piece | Status |
|---|---|
| <piece> | <status> |

**Depends on:** <letters>  
**Unblocks:** <outcomes>

---

<!-- Add C, D, … as needed. Prefer fewer sharper blocks over many tiny ones. -->

---

## Suggested walk order

1. **A** — <why first>
2. **B** — <…>
3. <Parallel note if any letters can advance together>
4. <What must not be pretended ready early>

---

## Gaps (called out so they don’t hide)

| Gap | Why it matters | Likely home |
|---|---|---|
| **`<gap>`** | <why> | Block <X> / FR-? / implement |

---

## Quality attributes (catalog skim)

**Act on with <letter>:** <Attribute> — <one line why it bites this block>.

**Deferred** (do not expand the current block to absorb these): <Attribute list>.  
Pointer: project override if any, else
`~/.cursor/skills/design/references/quality-attributes.md`

---

## How to use this one-by-one

For each letter: skim the table → decide “done / amend requirements / implement / defer” → only then open the next letter. Don’t re-merge the letters into one mega-task mid-walk.

Related formal artifacts when a block graduates:

- Requirements amend / `/requirements-review`
- `/design-start` when a spine / first win is clear
- `/explore-amend` or Theme N if the cut needs an exploration home
- `/write-plan` when a block is ready for sequenced implementation

---

## Cross-references

- **Parent thread:** `<path>`
- **Requirements:** `<path>`
- **Related concepts:** `<paths>`
- **Research / design:** `<paths if any>`
