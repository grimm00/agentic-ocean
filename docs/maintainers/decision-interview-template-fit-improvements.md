# agentic-ocean Improvements — `/decision` Interview Template Fit

**Source:** agentic-ocean — `/decision` skill template fit
**Target:** `corpus/skills/decision/assets/decision-interview.md` (+ light `SKILL.md` note)
**Created:** 2026-06-22
**Last Updated:** 2026-06-22

> **Filing note (2026-06-22):** Captured as a flat file in `docs/maintainers/` to avoid
> setting precedent on the `opportunities/` tree shape before the maintainer settles
> the project-slug convention (self-referential `agentic-ocean/` vs grouped-by-skill
> vs flat). Relocate when the tree convention is established.

---

## 📋 Overview

While running `/decision` on a **doctrine concern** (role management in a
private work repo, 2026-06-22) the stock `decision-interview.md` prompts
didn't fit the decision space. The template's prompts assume a product-shipping
context — *"upcoming release slice,"* *"latency / sizing instincts,"*
*"deployment cadence, audit logging, tenancy"* — and offer no parallel prompts
for doctrine / process decisions. Roughly half the stock prompts were
inapplicable, and the ones that did fit (friction-escalation, risk appetite)
didn't elicit the signal the ADR clusters actually needed — pain ranking
across clusters, audience anchor, conviction strength for divergent norms,
framing-instinct (standing policy vs one-off exception).

The operator tailored the interview file in-place, preserving the skill's
section headers so downstream references still resolve, and added a header
note documenting the tailoring for audit. That tailored file is the worked
example this opportunity refers to (see References).

The skill itself acknowledges genericness — *"skip prompts that genuinely
do not apply"* — but doesn't offer a doctrine-shaped alternative prompt set,
and doesn't document the in-place tailoring escape hatch as a first-class
option.

---

## 🎯 Improvements

### `decision-interview.md` template scope

- [ ] **Add doctrine-concern prompt variants alongside product-shipping prompts**
  - **Location:** `corpus/skills/decision/assets/decision-interview.md`
  - **Action:** For each anchor section (*User experience priorities*,
    *Constraints / instincts*, *Optional*), provide **parallel prompt sets**:
    keep the stock product-shipping prompts (release slice, latency, tenancy)
    **plus** add doctrine / process prompts (pain ranking across decision
    clusters, audience anchor, conviction strength for divergent norms,
    framing-instinct: standing policy vs one-off exception). Mark each set
    with the decision shape it fits. The agent picks or blends based on the
    topic's shape during step 0.
  - **Prevents/Enables:** Operator doesn't have to manually tailor the file
    for non-product-shipping `/decision` invocations. The doctrine prompt set
    elicits the signal that actually drives ADR sequencing for doctrine
    concerns (pain ranking, conviction strength) instead of misfiring on
    irrelevant product prompts.
  - **Priority:** MEDIUM
  - **Effort:** LOW

### `SKILL.md` guidance

- [ ] **Document the in-place tailoring escape hatch explicitly**
  - **Location:** `corpus/skills/decision/SKILL.md` — step 0 *(Interview priorities)*
  - **Action:** Add a sentence: operators MAY tailor the prompts in
    `decision-interview.md` for the topic at hand, **preserving section
    headers** (the skill's behavioral contract references this file in each
    ADR's *Decision Rationale*, and the section names anchor those
    references), and noting the tailoring in the file header for audit-trail
    honesty. Write a short generic worked example of the tailoring; the
    original lives in a private repo.
  - **Prevents/Enables:** Operator currently has to invent this pattern under
    STOP-gate pressure. Documenting it makes it a first-class option and
    protects the interview's audit trail from silent in-place edits.
  - **Priority:** MEDIUM
  - **Effort:** LOW

---

## 📝 Additional Notes

**Out of scope intentionally** (worth separate int-opps if the pattern recurs):

- The `decision` skill's `references/structure.yaml` doesn't list a
  *concern-first scratch* layout (`.scratch/[concern]/decisions/`) alongside
  `dev_infra_feature` and `template_project`. The operator mapped to the
  closest analog manually when resolving the decisions dir for the
  concern. Logged here, not bundled.

**References:**

- **Worked-example artifact (tailored interview):** in a private work repo at
  `.scratch/<concern>/decisions/decision-interview.md`; see its
  *"Tailored 2026-06-22"* header.
- **Stock template under critique:** [`corpus/skills/decision/assets/decision-interview.md`](../../corpus/skills/decision/assets/decision-interview.md)
- **Skill instructions:** [`corpus/skills/decision/SKILL.md`](../../corpus/skills/decision/SKILL.md)
- **Trigger:** 2026-06-22 `/decision` invocation on the role-management concern,
  gate-0 (Interview priorities) STOP — operator flagged prompts as
  cookie-cutter, picked *Option 2* (tailor in-place) over *Option 1* (skip
  prompts) or *Option 3* (improve skill).

---

**Last Updated:** 2026-06-22
