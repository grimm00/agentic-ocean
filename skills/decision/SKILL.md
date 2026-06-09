---
name: decision
description: >-
  Create Architecture Decision Records from research: human decision-interview
  first, then one ADR per decision point with alternatives and rationale.
  Use after research is complete and the user wants /decision or ADR authoring.
  Do NOT run implementation planning inside this skill — hand off afterwards.
disable-model-invocation: true
---

# Decision

Make **documented architecture decisions** from research artifacts using a staged
workflow: constrained interview (**`assets/decision-interview.md`**) → hub index
(**`assets/hub-readme-template.md`**) → ADR files seeded from **`assets/adr-template.md`**.

Treat those files under `assets/` as **copy-on-write templates** beside the eventual
disk paths declared in **`references/structure.yaml`**.

Hybrid skill: scaffolding rules + deliberate behavioral judgment framing **options,
not pre-baked mandates**.

North star — users stay paced through explicit priority capture before narrowing to a
recommended alternative set (see behavioral contract).

---

## When to use

- Research summaries + topic dossiers justify ADR-ready questions.
- User says `/decision`, `/decisions`, or analogous natural language.

## When not to use

- Research scaffolding missing substantive findings → **`research-setup`** instead.
- Ideation wanting zero records → **`discuss`** until intent firms.
- Need implementation task breakdown afterwards → **`write-plan-setup`** / execution flows.

---

## Path resolution

Pick **exactly one layout row**, stay scoped to that subtree for remainder:

| Structure | Topic root | Decisions dir | Typical research pointers |
|-----------|------------|---------------|---------------------------|
| Dev-infra feature | `admin/services/[service]/features/[topic]/` | `[topic-root]/decisions/` | `research/research-summary.md`, `research/requirements.md` mirrors |
| Template maintainer | `docs/maintainers/` | `docs/maintainers/decisions/[topic]/` | Matching `research/[topic]/` summaries |
| Project-wide | `docs/maintainers/` | `docs/maintainers/decisions/[topic]/` | same as maintainer |

Do **not** route dev-infra feature work through `admin/decisions/[topic]/` hubs — feature-local
`/decisions/` keeps traceability symmetrical with research siblings.

Detailed glob expectations: **`references/structure.yaml`**.

---

## Preconditions

1. Human or agent declares `topic` + readable research corpus.
2. After inspection: if summaries contain **zero** articulated decision questions &
   unresolved constraints, STOP — escalate back to **`research-conduct`**.

---

## Workflow

### 0. Interview priorities

Goal: constrain sequencing before authoring ADRs.

1. Resolve decisions directory (`…/decisions/` under topic root).
2. Target path **`[decisions-dir]/decision-interview.md`**.
3. If missing → copy tailoring instructions from **`assets/decision-interview.md`**, create file,
   then STOP until human fills materially **or** types explicit textual waiver mirrored in-chat.
4. If present but empty anchors remain → STOP with targeted prompts referencing missing sections.

### 1. Absorb research corpus

Sequential reads: hub README (if exists) → summary → dossiers → consolidated requirements.

Deliverable: prioritized unknown clusters + linkage map for rationales later.

### 2. Identify decision clusters

For cluster:

1. One crisp question headline (will map 1:1 to ADRs).
2. At least **two** differentiated alternatives annotated with +/- trade space.
3. Criteria tags (risk, portability, staffing, rollout windows).

Expose ordered backlog to operator for ACK before writes.

### 3. Maintain decisions hub README

Seed / refresh using **`assets/hub-readme-template.md`** — emphasize links table + statuses.

### 4. Author ADRs (one file per outstanding decision)

Filename pattern `adr-[NNN]-[kebab].md` synced with numbering policy in **`references/structure.yaml`**.

Structural obligations mirror **`assets/adr-template.md`** (Context, Decision, Consequences ±,
Alternatives, Rationale bridging interview, Requirements impact, References). Default lifecycle
starts **🔴 Proposed** pending owner acceptance gates.

### 5. Maintain `decisions-summary.md`

One-screen synopsis cross-linking statuses + fallout for PM stakeholders.

### 6. Touch parent README only if precedent exists

Prefer append-only hyperlink entries when repos already maintain aggregator docs (see YAML map).

### 7. Commit guidance — bounded autonomy

Recommend `git add …` coverage + concise `docs(decisions):` style commit message bodies; STOP before
automatic merges lacking policy certainty.

---

## Behavioral contract

- **Options dominance:** forbid single-path ADRs posing as exhaustive unless research logged why.
- **One decision per ADR.** Bundle only tightly coupled deltas with explicit bridging narrative.
- **Traceability enforced:** citations must be openable Markdown-relative paths audiences already trust.
- **Interview gravity:** waived flows must visibly echo waiver text inside ADRs (no invisible skips).
- **Bounded analysis:** once mandatory sections materially satisfied → yield to human approval loops.
- **Failure-aware:** conflicting numbering / hub divergence → escalate with corrective menu (append /
  resequence / reconcile) before overwriting.

Observable / bounded / outcome-framed / delta-only interpretations align with Stage 3 five-property gate.

---

## Gotchas

- Mis-targeting **`admin/decisions/`** hubs for bounded feature scopes — breaks onboarding paths.
- Silent interview skips — yields mis-prioritized ADR waterfalls.
- **Placeholder ADRs** masquerading as finished — placeholders belong in drafts branches only.
- Merged winner hallucination — rewind to enumerated trade space if critique absent.
- **Planning bleed:** never mint `implementation-plan.md` herein — escalate to **`write-plan-setup`**.

Asset pointers keep templates versioned beside skill instructions for FR-8 self-containment.

---

**Structured map:** `references/structure.yaml`  
**Interview seed:** `assets/decision-interview.md` • **Hub seed:** `assets/hub-readme-template.md` • **ADR seed:** `assets/adr-template.md`
