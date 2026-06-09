---
name: research-conduct
description: >-
  Fill research documents with findings, analysis, and requirements after
  scaffolding: web research, per-topic updates, summary and requirements.md
  sync, hub status. Use when the user wants /research --conduct or to run
  research on one or all topics. Do NOT scaffold new research trees
  (research-setup) or consolidate requirements (research-consolidate).
disable-model-invocation: true
---

# Research Conduct

Before proceeding, read `../SKILL.md` for family conventions (path detection,
topic naming, output sizing, commit discipline, filename conventions).

You perform **active research**: web search, findings, analysis, recommendations,
and requirement extraction into existing scaffolded files. You do **not** create
initial research directory structure (that is **research-setup**).

---

## When to use

- After **research-setup** (or add-topic) produced hub + per-topic docs +
  `research-summary.md` + `requirements.md` skeleton.
- When the user asks to “conduct research”, “run --conduct”, or fill findings
  for topic *N* / topic name *X*.

---

## Preconditions

1. Resolve the research directory using `../SKILL.md` path rules.
2. Hub `README.md`, `research-summary.md`, `requirements.md`, and at least one
   per-topic research file exist.
3. If not, **stop** and point the user to **research-setup**.

---

## Scope

| Invocation | Scope |
|------------|--------|
| All topics | Every per-topic file in the research directory that is not yet ✅ Complete (or user explicitly asks to re-run a complete topic — then confirm overwrite policy). |
| Single topic | `--topic-num N` / `--topic-name slug` / natural language: only that topic’s document. |

**Topic order (all topics):** Use the hub **Research Status** table top-to-bottom,
but **stable-sort** rows so **higher-priority topics are conducted first**. Map emojis/labels
to order: 🔴 High (or “High”) before Medium before Low before unknown/unset.
Within the same priority band, keep the table’s top-to-bottom order.

---

## Workflow

### 1. Identify research to conduct

1. List candidate topic files (`research-*.md`, `topic-*.md`) from the hub links
   and directory listing.
2. For each selected topic, open its document and read: Research Question,
   Research Goals, Methodology, Sources.
3. **Checklist (must be true before web search):** research question stated;
   goals listed; intent is clear.

### 2. Conduct web research (required)

**Web search is mandatory** for this skill in v1: do not mark a topic complete
without at least **one** successful `web_search` (or platform-equivalent) call
per topic conducted, except if the user explicitly **aborts** conduct after
availability failure (document the failure in the topic under **Findings** or
**Methodology** and **stop**).

**Query minimum (bounded):** For each topic, derive and **record** at least one
query from each of:

1. The main research question (paraphrase ok).
2. Each explicit sub-question bullet/heading in the topic doc (if any).
3. Each **unchecked** methodology/source line that implies external lookup.

Place recorded queries in the topic doc (e.g. under **Methodology** as a short
“**Queries executed**” list, or adjacent to **Findings**) so reviewers can see
coverage.

**Finding quality:** Each finding MUST include:

- A heading or title;
- **Source:** credible link, document name, or “Web search: `<query>`”;
- **Relevance:** one or two sentences tying the finding to the research
  question.

### 3. Fill in the research document

Update the topic file minimally but completely for this pass:

1. **Findings** — additive entries unless the user asked to replace stale text.
2. **Analysis** — insights that cite which findings support them; use checkbox
   lists where the template already does.
3. **Recommendations** — checkbox list aligned to findings.
4. **Requirements Discovered** — checkbox list of candidate reqs; do **not**
   invent formal FR IDs here unless the project template already does — prefer
   carrying them into `requirements.md` with proper IDs in the next step.

### 4. Update research status inside the topic

Set **Status:** `✅ Complete` and **Completed:** `YYYY-MM-DD` only if **all** are
true:

- Findings section has ≥1 finding with Source + Relevance.
- Analysis and Recommendations are non-empty (or explicitly marked N/A with
  reason if the question is purely factual).
- Research Goals checklist has all items resolved `[x]` or intentionally
  deferred with an explicit note (deferrals are **user-approved** — default is to
  keep working until goals are met or user stops).
- Methodology **Sources** checklist reflects what was consulted (checked where
  used).

### 5. Update summary and requirements (`delta-only`)

**research-summary.md:** Add or update **Key Findings** entries that point back to
the topic file just conducted. Do not delete other topics’ summary material.

**requirements.md:** Append new FR/NFR/Constraint/Assumption entries following
the project’s ID scheme **only** for net-new discoveries from this conduct
pass. When extending an existing requirement, edit that entry **in place** and
add a one-line “**Updated after:** `<topic-file>`” note — avoid renumbering
in conduct (renumber belongs to **research-consolidate**).

### 6. Update hub status

Sync the hub **Research Status** table: topic row → ✅ Complete for files
finished this pass; priorities unchanged unless conduct explicitly proved an
adjustment (then note rationale in summary or topic).

### 7. Commit

Use family commit discipline (`docs(research):` unless AGENTS.md overrides):

```
docs(research): conduct <topic-slug> research

Topics: <list>
Web: <N> search passes (min 1 per topic)
```

**Failure-aware:** If git commit is not possible (no git, sandbox), list changed
paths and stop — do not claim the topic is “done for the team” without user
commit.

---

## Natural-language mapping

| User says | Action |
|-----------|--------|
| “Conduct all research for X” | All incomplete topics in research X |
| “Research topic 3” | Map to `topic-3-*.md` or hub order `#3` — confirm file |
| “Just the API topic” | Match `--topic-name` / slug against filenames |

---

## Behavioral Contract

Every obligation below is written to satisfy: **observable**, **bounded**,
**outcome-framed**, **delta-only**, **failure-aware**.

- **Tooling:** At least one web search per topic unless user aborts after tool
  failure; failures are documented, not hidden.
- **Traceability:** Findings have Source + Relevance; queries are listed.
- **Ordering:** Hub priority sort rules above; no arbitrary “importance”
  ordering without hub basis.
- **Scope:** No scaffolding, no consolidation merges, no Draft→Final flip.
- **Human alignment:** Stop on conflicting user instructions (e.g., “skip web
  search but mark complete”).

---

## Gotchas

**Skipping web search.** Tier-1 contract item from the audit (C1). Fabricating
sources or marking complete without search violates the skill — see **STOP**
rules above.

**Priority ties.** If the hub lacks priority markers, conduct in filesystem order
**after** verifying with the user or using exploration `research-topics.md`
order if paired — don’t silently invent priority.

**FR renumbering in conduct.** Avoid; duplicates and cleanup belong in
**research-consolidate** so decision-makers see one gate.

**Wrong research root (dev-infra).** Legacy command text sometimes says
`admin/research/`; always prefer `../SKILL.md` detection — feature research lives
under `admin/services/.../research/` when `admin/services/` exists.

**Running setup mid-conduct.** If files are missing, that’s **research-setup**,
not conduct — prevents half-scaffolded commits.

**Push policy.** Default: do not `git push`; the command showed `push` — follow
project norms (many repos use PRs). Commit locally unless user asks to push.

---

**Skill boundaries:** Web research + topic/requirements/summary/hub updates.
**research-setup** scaffolds; **research-consolidate** cleans requirements after
all topics complete.
