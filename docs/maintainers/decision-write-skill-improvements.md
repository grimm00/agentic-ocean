# agentic-ocean Improvements — `decision-write` Skill (standalone, design-bearing)

**Source:** agentic-ocean — `/decision` skill factoring (split a single-ADR depth pass out of the breadth workflow)
**Target:** new `corpus/skills/decision-write/` standalone skill (+ revert a prototype sub-mode from `corpus/skills/decision/`)
**Created:** 2026-06-24
**Last Updated:** 2026-06-24

> **Filing note (2026-06-24):** Captured as a flat file in `docs/maintainers/` to match
> the existing `decision-interview-template-fit-improvements.md` precedent and avoid
> setting precedent on the `opportunities/` tree shape before the maintainer settles the
> slug convention. Relocate when the tree convention is established.

---

## 📋 Overview

Running `/decision` on a real concern (a license-checker role in a private
work repo, 2026-06-23/24) surfaced a gap the operator named directly:
the ADRs came out as **"a lot of text but no design"** — they argue in prose but never
*show* the shape of the decision (no diagram, no representative snippet), so a reader has
to reconstruct it mentally.

The idea: a focused, **one-ADR-at-a-time** pass that (a) loads only that ADR's slice of
context — its interview cluster, the specific requirement IDs it cites, the relevant
research/spike sections, and any upstream ADRs — instead of the whole corpus, and
(b) **requires an illustrative design sketch** (mermaid + optional code/table). The trade
is deliberate: narrower scope in exchange for a more robust, substantiated write-up.

A **prototype was wired as a sub-mode** into the *deployed* decision skill
(`~/.cursor/skills/decision/`) plus a design-bearing template asset.
On reflection the operator decided it **should be its own standalone skill folder** —
consistent with the sibling skills (`spike`, `research`, `discuss`, …) which each live in
their own `corpus/skills/<name>/` directory — **not** a sub-mode bolted onto `decision`.
This opportunity hands that build to a fresh chat.

**Two reconciliation facts the builder must know:**

1. The prototype edits landed only in the **deployed** copy
   (`~/.cursor/skills/decision/`), **not** in the agentic-ocean source
   (`corpus/skills/decision/`). Source and deploy have diverged.
2. The standalone skill must be authored in the **source** (`corpus/skills/decision-write/`)
   and then deployed — not edited in `~/.cursor/skills` directly.

---

## 🎯 Improvements

### New standalone skill

- [ ] **Author `decision-write` as its own skill folder (source of truth)**
  - **Location:** `corpus/skills/decision-write/` (`SKILL.md` + `assets/`)
  - **Action:** Create a standalone skill mirroring the sibling-skill layout. It
    authors/upgrades **exactly one** ADR with focused context (only that ADR's interview
    cluster + cited FR/NFR/CON IDs + relevant research/spike sections + upstream ADRs)
    and a **mandatory** design sketch. Invocation `decision-write <target>` (number /
    `adr-NNN` / cluster-kebab). Steps: resolve target → load focused slice → author from
    the design-bearing ADR template → update **only** that ADR's row in the hub README +
    `decisions-summary.md` → STOP at the 🔴 Proposed → owner-accept gate. Inherit the
    `decision` behavioral contract (options dominance, one decision per ADR, traceability,
    planning-bleed ban). Precondition: `/decision` Steps 0–3 have already produced an
    interview + hub backlog.
  - **Prevents/Enables:** per-ADR depth without context bloat; consistent skill
    discoverability (own folder like the others); keeps `/decision` focused on breadth.
  - **Priority:** MEDIUM
  - **Effort:** MEDIUM

- [ ] **Carry the design-bearing ADR template as a `decision-write` asset**
  - **Location:** `corpus/skills/decision-write/assets/adr-with-design-template.md`
  - **Action:** The standard ADR structure **plus** a mandatory
    **"Design sketch (illustrative, non-binding)"** section after Decision: **≥1** mermaid
    diagram of the decision's shape, **≤1** representative code/task snippet, optional
    small table. Explicitly **forbid** full task files / complete variable schemas /
    end-to-end implementation steps (→ `write-plan`). A prototype already exists in the
    deployed copy at `~/.cursor/skills/decision/assets/adr-with-design-template.md` — lift
    it into the new skill rather than rewriting.
  - **Prevents/Enables:** substantiated, scannable ADRs; one reusable template.
  - **Priority:** MEDIUM
  - **Effort:** LOW

### Reconcile the prototype

- [ ] **Revert the sub-mode prototype from the `decision` skill**
  - **Location:** deployed `~/.cursor/skills/decision/SKILL.md` + `assets/adr-with-design-template.md`; and the source `corpus/skills/decision/SKILL.md`
  - **Action:** On 2026-06-24 a prototype was added to the **deployed** `decision` skill
    only: a `## Sub-mode: decision-write …` section, frontmatter/When-to-use/Step-4/asset-footer
    edits, and the `adr-with-design-template.md` asset. When the standalone skill lands,
    **revert** those sub-mode edits (keep `decision` as pure breadth), leaving at most a
    one-line cross-link ("for single-ADR depth, see `decision-write`"), and reconcile the
    deployed ↔ corpus divergence so source and deploy match again.
  - **Prevents/Enables:** avoids a half-built feature lingering in the deployed skill and
    a silent source/deploy drift.
  - **Priority:** HIGH (divergence hygiene)
  - **Effort:** LOW

- [ ] **Define the `decision` ↔ `decision-write` handoff**
  - **Location:** `corpus/skills/decision/SKILL.md` (Step 4); `corpus/skills/decision-write/SKILL.md`
  - **Action:** Decide whether `/decision` Step 4 (batch authoring) explicitly delegates
    per-ADR to `decision-write`, or whether they stay independent with a cross-link.
    Document the precondition either way.
  - **Prevents/Enables:** a clear seam between breadth and depth; no overlap confusion.
  - **Priority:** LOW
  - **Effort:** LOW

---

## 📝 Additional Notes

**Worked exemplars already exist** in a private work repo. Its three Phase-1 ADRs for the
license-checker role already carry the design sketch the new skill should produce — use
their shapes as reference output:

- ADR-001 (certificate custody) — topology mermaid + encrypted-variable snippet
- ADR-002 (apply mechanism) — apply-flow mermaid + Ansible task snippet
- ADR-003 (freshness gate) — gate decision-tree mermaid + state→action table

**Out of scope intentionally:** changing the breadth-flow `adr-template.md` to make the
design section mandatory there — the operator chose to keep design *optional* in
`/decision` and let `decision-write` own the *mandatory*-design path.

**References:**

- **Prototype (deployed, to reconcile):** `~/.cursor/skills/decision/SKILL.md`
  (sub-mode section) and `~/.cursor/skills/decision/assets/adr-with-design-template.md`
- **Source skill under split:** `corpus/skills/decision/SKILL.md`
- **Sibling-skill layout precedent:** `corpus/skills/spike/`, `corpus/skills/research/`
- **Sibling improvement (filing precedent):** `docs/maintainers/decision-interview-template-fit-improvements.md`
- **Trigger:** 2026-06-24 — operator realized `decision-write` should be a standalone
  skill folder with its own assets, not a sub-mode of `decision`.

---

**Last Updated:** 2026-06-24
