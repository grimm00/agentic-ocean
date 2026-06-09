---
name: research-orchestrate
description: >-
  Run all incomplete research topics in one autonomous pass with cross-topic
  awareness. Produces filled research docs plus a recommendations.md file
  listing proposed upstream mutations (explore amends, spike candidates) without
  executing them. Use when multiple topics are scaffolded and the user wants
  throughput over per-topic human gates.
disable-model-invocation: true
---

# Research Orchestrate

Before proceeding, read `../SKILL.md` for family conventions (path detection,
topic naming, output sizing, commit discipline, filename conventions).

You run **all incomplete research topics** in a single pass. You produce the
same artifacts as research-conduct (filled topic docs, updated summary, updated
requirements) but do so continuously — no stop between topics. You also produce
a `recommendations.md` file collecting proposed upstream mutations for human
review.

```
resolve research dir → identify incomplete topics → sort by priority
  → conduct each topic (web search, findings, analysis, recommendations)
  → cross-reference across topics → write recommendations.md → commit → stop
```

---

## When to use

- After **research-setup** produced hub + per-topic docs + summary + requirements
- When multiple topics are incomplete and the user wants them all conducted
  without manual dispatch between each one
- When cross-topic awareness would improve research quality (findings in one
  topic inform queries in another)

## When NOT to use

- Single topic remaining — use **research-conduct** directly
- No scaffolding exists — use **research-setup** first
- You need to consolidate/finalize — use **research-consolidate**

---

## Options

| Invocation | Behavior |
|------------|----------|
| `/research-orchestrate` | Conduct all incomplete topics in detected research directory |
| `/research-orchestrate --from-explore [topic]` | Resolve research directory from exploration pairing |
| `/research-orchestrate --dry-run` | Show which topics would be conducted and in what order; do not write |

---

## Workflow

### 1. Resolve and validate research directory

Use `../SKILL.md` path detection rules. Verify:
- Hub `README.md` exists with a Research Status table
- `research-summary.md` exists
- `requirements.md` exists
- At least one per-topic file exists that is not yet Complete

If any are missing, **stop** and point to **research-setup**.

### 2. Identify incomplete topics and sort by priority

Read the hub Research Status table. Collect all rows where status is not
Complete. Sort by priority: High before Medium before Low. Within the same
priority band, maintain table order (top to bottom).

If `--dry-run`, display the ordered list and stop.

### 3. Conduct each topic sequentially

For each topic in priority order, perform the **research-conduct workflow**:

1. Read the topic file: Research Question, Goals, Methodology, Sources
2. Execute web search (mandatory — at least one per topic)
3. Record queries executed in the topic doc
4. Fill Findings (with Source + Relevance per finding)
5. Fill Analysis (citing which findings support insights)
6. Fill Recommendations (checkbox list)
7. Fill Requirements Discovered (checkbox list)
8. Mark Sources checklist for what was consulted
9. Mark Research Goals as resolved
10. Set Status to Complete with date

**Cross-referencing rule:** Before starting each topic after the first, review
findings from previously completed topics in this pass. If any finding directly
answers or informs the current topic's question:
- Cite it by reference ("See Topic N, Finding M") rather than re-researching
- Adjust queries to avoid duplicating coverage
- Note the cross-reference in the current topic's Analysis

### 4. Update summary and requirements (once, at end)

After all topics are conducted:

- **research-summary.md:** Add Key Findings entries for each newly completed
  topic. Update status counts.
- **requirements.md:** Append new entries from all topics conducted in this
  pass. Follow existing ID scheme. Do not renumber.

### 5. Update hub status

Set all conducted topic rows to Complete in the Research Status table.

### 6. Write recommendations.md

Create (or overwrite) `recommendations.md` in the research directory:

```markdown
# Research Orchestrator Recommendations

**Generated:** YYYY-MM-DD
**Topics conducted:** [count]
**Web searches executed:** [count]

---

## Proposed Exploration Amends

<!-- Themes that surfaced during research but belong upstream in the exploration -->

- Theme: "[description]" — surfaced by Topic N Finding M
  - Why: [one sentence on why this belongs in the exploration]

## Spike Candidates

<!-- Questions that need hands-on validation, not more desk research -->

- "[question]" — Topic N found this needs hands-on validation
  - Evidence: [what finding triggered this]

## Cross-Topic Notes

<!-- How findings in one topic affected another -->

- Topic N finding X informed Topic M — [how the methodology or queries changed]

## Deferred Items

<!-- Anything intentionally skipped with rationale -->

- [item] — deferred because [reason]
```

If no recommendations exist for a section, write "None identified." rather than
omitting the section.

### 7. Commit and stop

Single commit covering all files modified in this pass:

```
docs(research): orchestrate [topic] research ([N] topics conducted)

Topics: [list of topic slugs]
Web: [count] search passes
Recommendations: [count] amends proposed, [count] spike candidates
```

**Stop** after committing. Present:
1. Summary of topics conducted
2. Key cross-references discovered
3. Recommendations requiring human action (amends, spikes)

---

## Behavioral Contract

**Autonomous conduct, not autonomous mutation.** Fill research docs (same write
permissions as research-conduct) but NEVER modify exploration files, NEVER run
explore-amend, NEVER start spikes, NEVER run research-setup or
research-consolidate. Recommend only.

**Web search mandatory per topic.** Same contract as research-conduct — at least
one successful web search per topic. Document failures; do not fabricate sources.

**Cross-reference, don't duplicate.** If Topic 3's findings answer part of
Topic 5, cite by reference. Do not re-research the same question.

**Hard boundary: no consolidation.** Do not flip Draft to Final on requirements,
do not dedupe, do not merge. That's research-consolidate's job after human
review of recommendations.

**Commit once at the end.** A single commit for the entire pass, not per-topic
commits. This keeps the diff reviewable as one unit.

**Recommendations are suggestions, not actions.** The recommendations.md file is
an editorial buffer. The user decides what gets promoted. Writing "Proposed
Exploration Amend" does not authorize modifying the exploration.

**Priority ordering is mandatory.** High-priority topics first. Do not reorder
based on personal judgment of "what's interesting" — use the hub table.

---

## Gotchas

**Modifying the exploration "while you're researching."** The strongest
temptation in a long-running pass is to append a theme to the exploration when
you discover something significant. Don't. Write it in recommendations.md. The
user runs explore-amend if they agree.

**Skipping web search for "obvious" topics.** Even if a topic seems answerable
from local files alone, the contract requires at least one web search. This
prevents the orchestrator from becoming a file-reorganization tool that claims
"research complete" without external validation.

**Losing cross-topic context in a long pass.** After conducting 4-5 topics,
earlier findings may fade from working memory. Before starting each new topic,
explicitly re-read the Key Findings from the summary (which you've been
updating) to maintain cross-topic awareness.

**Recommending too many amends.** Not every interesting finding belongs in the
exploration. Amend recommendations should be reserved for findings that
genuinely expand the problem space — not just "this is related." Cap at 3-5
amend recommendations per pass unless the research truly surfaced that many new
themes.

**Running consolidation at the end.** After conducting all topics, the natural
urge is to clean up requirements and mark things Final. Stop. The human review
gate between orchestrate and consolidate exists because the user may disagree
with findings or want to redirect before finalizing.

**Treating recommendations.md as append-only across runs.** Each orchestrate
pass overwrites recommendations.md with fresh output. Previous recommendations
that weren't acted on are lost — this is intentional. If the user wanted them
preserved, they would have promoted them before re-running.
