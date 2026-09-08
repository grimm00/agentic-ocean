# [Group Name]

**Feature:** [Feature Name]
**Group:** [Group Name]
**Status:** ✅ Expanded
**Last Updated:** YYYY-MM-DD

---

## Group overview

**Type:** [Code | Docs | Mixed — describe cohort mix, e.g. HCL scaffold + runbook]
**Cohort order:** [How Steps are ordered inside tasks — e.g. RED → GREEN → REFACTOR for TDD; outline → link → verify for docs]

**Cadence:** Each task uses research-shaped grounding, planning concerns:

| Field | Research analogue | Here means |
|-------|-------------------|------------|
| **Purpose** | Claim | What must become true when this task is done |
| **Grounding** | Evidence | FR/C IDs, topic findings, foundation — facts, not a restatement of Purpose |
| **Relevance** | Relevance | Why those facts matter *in this environment / this stage* |
| **Steps** | — | Ordered work in short readable prose — resource/CLI names as objects, not the whole step |
| **Files** | — | Paths touched (scratch vs durable repo, if both exist) |
| **Acceptance** | — | Observable done — verifiable without reading the author's mind |
| **Gotcha** | Gotchas / Analysis caveats | Failure modes, “do not”, scope traps |

**Authority:** [Relative links to requirements, research topics, foundation docs that govern this group]

**Out of scope for this group:** [What later groups/stages own — prevents expand creep]

---

## Tasks

- [ ] **Task [N]:** [Title from implementation-plan.md] ([FR-… / constraint IDs])

  - **Purpose:** [One paragraph — the claim this task proves]

  - **Grounding:**
    - [Requirement ID or finding]: [fact]
    - [Topic / foundation]: [fact]

  - **Relevance:** [Why this matters here and now — operator context, stage boundary, repo split, etc.]

  - **Steps:**
    1. [Short instruction you could read aloud — action + constraint; identifiers as objects]
    2. [Next instruction — not a bare comma-separated resource/CLI list]

  - **Files:**
    - [repo/path]: [what changes]

  - **Acceptance:**
    - [Observable criterion]
    - [Observable criterion]

  - **Gotcha:** [Single highest-risk mistake or scope trap for this task]

---

- [ ] **Task [N+1]:** [Title] ([IDs])

  - **Purpose:** …
  - **Grounding:** …
  - **Relevance:** …
  - **Steps:** …
  - **Files:** …
  - **Acceptance:** …
  - **Gotcha:** …

---

## Goals

1. [Group-level outcome — not a restatement of every task Purpose]
2. [Group-level outcome]

---

## Completion criteria

- [ ] Tasks [range] checkboxes done
- [ ] [Cross-task observable — what “group done” means for `/task` closeout]
- [ ] **Docs:** durable docs updated/split for this group (or “no durable doc change” / honest WIP) — `documentation-is-ownership`

---

## Dependencies

- **In:** [Prior groups, assumptions, access]
- **Out:** [What this group unblocks]

---

## Implementation notes (shoptalk)

- [Optional: operator tips, repo conventions, tone, deferrals — not duplicated from Gotchas]

---

**Last Updated:** YYYY-MM-DD
