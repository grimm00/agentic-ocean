---
name: research-consolidate
description: >-
  After all research topics are complete: reconcile exploration themes vs
  findings, analyze requirements for redundancy/gaps/stale text, present a
  human-approved consolidation proposal, then merge/remove/add/renumber and
  move requirements Draft → Final. Use for /research --consolidate. Do NOT
  conduct web research (research-conduct) or scaffold trees (research-setup).
disable-model-invocation: true
---

# Research Consolidate

Before proceeding, read `../SKILL.md` for family conventions (path detection,
topic naming, commit discipline, filename conventions).

You are the **quality gate** between incremental research and `/decision`:
exploration reconciliation (if applicable), structured requirement analysis,
**explicit** lineage tables, human-approved edits, then Draft → Final.

---

## When to use

- User requests `/research [topic] --consolidate` or natural-language equivalent.
- After **research-conduct** has marked all topics ✅ Complete (warnings if not).

---

## Modes

| Mode | Behavior |
|------|-----------|
| **Apply** | After explicit human approval of the consolidation proposal, mutate files and commit. |
| **Dry-run** | `--dry-run` or user asks “preview only”: run through proposal **STOP**; do **not** edit `requirements.md`, hub, or topic files except optional scratch notes in chat. |

---

## Workflow

### 1. Validate preconditions

1. Research directory exists (per `../SKILL.md`).
2. `requirements.md` exists with body content beyond placeholders.
3. If any hub topic row is not ✅ Complete: **warn** with verbatim message pattern:
   “Topic N is not complete. Consolidation works best after all topics are
   finished. Continue anyway?” — proceed only on **yes**/explicit proceed.
4. **Errors (stop):** mutually exclusive with conduct or add-topic in the same
   invocation (mirror command table intent).

### 2. Exploration reconciliation

**Purpose:** Surface stale exploration framing before requirement surgery.

1. Resolve exploration directory paired with this research topic using
   **`../../explore/SKILL.md` Path Detection** (same pairing **research-setup**
   used — if unknown, ask which exploration topic name to read).
2. Read `exploration.md` (themes, open questions) and spike table if present.
3. Read `research-summary.md` + all completed topic docs.
4. For each exploration theme row, answer in a **Reconciliation table**:

| Theme | Still accurate? | Evidence (topic file + heading) | Severity (Mandatory / Recommended / None) |

**Severity rules (bounded):**

- **Mandatory:** Theme claim **contradicted** by a cited finding in topic docs.
- **Recommended:** Theme **narrowed**, reframed, or partially outdated but not
  contradicted.
- **None:** Theme consistent with research.

5. Present **Exploration Reconciliation** markdown (Mandatory / Recommended /
   Spike updates subsections).
6. **STOP — human gate 1:** User may run **explore-amend**, defer, or skip.
   Skipping is allowed; record “user skipped reconciliation amendments” if they
   decline.

### 3. Read all artifacts (no implicit “mental model”)

Read in full: `requirements.md`, `research-summary.md`, every `topic-*.md` and
`research-*.md` in scope.

**Requirement lineage (required table)** — produce before analysis:

| Req ID | One-line statement | Source topic file(s) | Primary finding anchor |

**Finding coverage (required table):**

| Topic file | Recommendations / major findings still missing from `requirements.md`? | Note |

These tables replace undocumented “mental model” work (audit G4 → Tier 1).

### 4. Analyze requirements

For **each** requirement ID, classify **at most one** primary bucket per item
(redundancy OR superseded OR gap OR stale OR priority — if multiple apply,
pick the **dominant** action and mention secondary in proposal notes):

| Category | Observable trigger | Action |
|----------|---------------------|--------|
| **Redundancy** | Two IDs describe same behavior; later topic states superset | Merge into more specific; note absorbed IDs |
| **Superseded** | Later finding contradicts or narrows earlier FR text | Remove or rewrite older |
| **Gap** | Recommendation in summary/topic with no matching FR | Propose addition with source |
| **Stale** | Wording references old architecture/counts after later topic | Propose replacement text |
| **Priority** | Blocking vs polish mismatch vs hub priorities | Propose new priority + one-line reason |

### 5. Present consolidation proposal — STOP (human gate 2)

Output the structured sections:

- Merges (N → M)
- Removals
- Additions (with proposed IDs if apply-mode later)
- Modifications
- Priority changes
- Counts before → after (FR/NFR/C/A)

**CRITICAL:** **Do not** apply file edits in apply-mode until the user explicitly
approves (“approved”, “apply”, equivalent). **Dry-run always stops here.**

### 6. Apply changes (approved apply-mode only)

1. Merge/remove/add/modify per approval.
2. **Renumber:** If removals leave gaps and project style requires contiguous
   IDs, renumber **once** in this step and fix cross-references in topic docs /
   summary.
3. Set `requirements.md` overview status from **Draft** to **Final** only after
   edits succeed.
4. Update absorb/supersedes notes inline where merges happen.

### 7. Update research summary

- Refresh requirements counts in **research-summary.md**.
- Fix stale checkboxes in Key Insights when the consolidation resolves them.
- Next steps: point to `/decision --from-research` / project equivalent.

### 8. Commit (apply-mode only)

```
docs(research): consolidate <topic-slug> requirements

- Merged: …
- Removed: …
- Added: …
- Modified: …
Draft → Final
```

---

## Natural-language mapping

| User says | Mode |
|-----------|------|
| “Consolidate research” | Apply after approval |
| “Show consolidation without applying” | Dry-run |
| “Preview consolidate” | Dry-run |

---

## Behavioral Contract

Five-property rubric on behavioral lines:

- **STOP gates** are explicit and observable (two human checkpoints).
- **Tables** make lineage and coverage reviewable (no undescribed mental model).
- **Dry-run** guarantees no requirement mutations.
- **Delta reporting:** Proposal lists every ID touched before apply.
- **Failure-aware:** On unclear approval (“maybe”), re-ask; do not apply partial
  unauthorized merges.

---

## Gotchas

**Incomplete topics.** Consolidation **after** conduct is the happy path;
continuing without completion is user-risk — always warn once.

**Exploration path drift.** Dev-infra explorations often live under
`admin/services/.../explorations/` — match `explore` path rules; don’t invent a
fourth layout (audit inconsistency note).

**Renumber ripple.** Renumbering FRs without updating topic cross-references
breaks traceability — search for old IDs before commit.

**Dry-run documentation.** It is easy to accidentally paste proposal into
`requirements.md` — in dry-run, **no file writes** to tracked artifacts.

**conduct leakage.** Web search here is out of scope; gaps are **proposed** FRs
for humans to validate, not secretly researched mid-consolidation.

---

**Skill boundaries:** Reconciliation + requirement cleanup + Draft→Final.
**research-conduct** produces evidence; **research-setup** produced structure.
