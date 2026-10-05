---
name: requirements-review
description: >-
  Review a requirements document for duplicates, stale text, gaps, and
  priority, then mark it Final after explicit approval. Use when the user
  wants /requirements-review or to close a Draft requirements set. Do NOT
  scaffold (requirements-setup), append a single new requirement
  (requirements-amend), or reconcile an exploration (research-consolidate).
disable-model-invocation: true
---

# Requirements Review

Before proceeding, read `../SKILL.md` for path detection, document shape, IDs,
and commit discipline.

Quality gate for one requirements document. Propose changes, stop for
approval, then edit. This is not research consolidation: there is no
exploration to reconcile and no topic set to fold together.

## Modes

| Mode | Behavior |
|------|----------|
| **Apply** | Edit the file only after the user approves the proposal. |
| **Dry-run** | User says preview, dry-run, or "don't apply". Stop at the proposal. Do not write the file. |

## Workflow

### 1. Preconditions

The scratch `requirements.md` exists and has body text past the empty
scaffold. If it is missing, stop and point at **requirements-setup**. If the
only copy is already **Final** on the explore path, stop unless the user asked
to send it back to Draft. If both copies exist, stop and ask which is live.

### 2. Lineage and coverage

Read the whole file. Produce these tables before any edit:

| ID | One-line statement | Source |
|----|--------------------|--------|

| Section | Requirement the user or a research topic named that has no ID yet? | Note |
|--------|---------------------------------------------------------------------|------|

The second table is empty when nothing outside the file was provided. Do not
go search for gaps.

### 3. Classify each ID

One primary bucket. If more than one fits, pick the dominant one and mention
the other in the proposal note.

| Category | Trigger | Proposed action |
|----------|---------|-----------------|
| **Redundancy** | Two IDs describe the same behavior; one is narrower | Keep the narrower; tombstone the other |
| **Superseded** | A later **Updated** line narrows or contradicts an earlier ID | Rewrite or tombstone the older |
| **Gap** | Coverage table has a named requirement with no ID | Add, with the next ID |
| **Stale** | Wording cites a design or count the rest of the file no longer matches | Replacement text |
| **Priority** | A constraint is written as a functional requirement, or the reverse | Move prefix; note the old ID |

### 4. Proposal — stop

Present, then wait:

- Merges
- Removals (tombstones)
- Additions
- Modifications
- Prefix moves
- Counts before → after (`FR` / `NFR` / `C` / `A`)

Do not edit until the user says approved, apply, or an equivalent. "Maybe" is
not approval. Dry-run stops here.

### 5. Apply

1. Make only the approved edits on the scratch copy.
2. Renumber a prefix only if removals left a gap and the user asked for
   contiguous IDs. Do it once. Search the repo for the old IDs and update
   those references in the same change.
3. Set **Status** to **Final** and **Updated** to today.
4. Move the file to the explore-start directory. Remove the scratch copy.
   The Final file is the only copy.

### 6. Commit

```
docs(requirements): review [topic] requirements

Draft → Final
```

## Gotchas

**Research reconcile.** Exploration themes and research-topic findings are
**research-consolidate**. If a finding is not already a requirement or a
coverage-table row the user handed you, leave it out.

**Partial apply.** Do not land the merges and skip the removals. The proposal
is one set.
