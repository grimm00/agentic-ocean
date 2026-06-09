---
name: narrative
description: >-
  Create a "story of the work" document after completing a feature or
  significant piece of work. Use when the user invokes /narrative and wants
  to capture the why, what, and how in a format suitable for demos, PR
  descriptions, and team knowledge sharing. Do NOT use mid-implementation —
  narratives are post-completion artifacts.
disable-model-invocation: true
---

# Narrative

Create a story of completed work by reading project artifacts, identifying
the narrative arc, and writing a document that answers three questions:

1. **Why did this work matter?** (business context, not ticket number)
2. **What made it interesting or hard?** (challenges, not just a diff)
3. **How did the approach evolve?** (decisions, discoveries, pivots)

```
gather context → identify story arc → copy template → write narrative → commit → stop
```

## Templates

This skill includes co-located templates in `templates/`. Copy the appropriate
template to the target path, then fill in the placeholders in place. Omit or
mark N/A for sections that don't apply.

| Template | When to use |
|----------|-------------|
| `templates/narrative.md` | Always — the core narrative document |
| `templates/demo-notes.md` | When `--demo` flag is provided |

## Options

| Invocation | Behavior |
|------------|----------|
| `/narrative [topic]` | Create narrative for the named topic |
| `/narrative [topic] --demo` | Also generate demo talking points |

## Workflow

### 1. Gather context

Read all relevant artifacts to reconstruct the story. Check each location
and use whatever exists:

| Source | What it provides |
|--------|-----------------|
| Explorations | How the problem space was understood |
| Research | What questions were investigated and what was found |
| Decisions (ADRs) | What approach was chosen and why |
| Implementation plan | How the work was phased |
| Git history | The actual sequence of changes |
| Spike learnings | What was validated before committing |

**Path detection:**

| Structure | Output path | Source paths |
|-----------|-------------|-------------|
| Dev-infra | `admin/services/[service]/narratives/[topic]/` | explorations, research, decisions, features under the service |
| Template project | `docs/maintainers/narratives/[topic]/` | explorations, research, decisions, features under docs/maintainers |

### 2. Identify the story arc

Every piece of work has a natural arc. Not all elements apply to every
narrative — a small bugfix is a shorter story than a multi-phase migration.
Consider:

- **The Problem** — what existed before, what was wrong or missing
- **The Constraints** — what made this harder than it looks
- **The Decision** — what approach was chosen from what alternatives
- **The Build** — how it was implemented and in what order
- **The Discoveries** — what changed the plan mid-flight
- **The Result** — what was produced and what patterns it established

### 3. Write the narrative

Copy `templates/narrative.md` to the output path. Fill in each section
with specifics from the gathered context.

If `--demo` is provided, also copy `templates/demo-notes.md` and write
talking points adapted to the specified audience. For PR descriptions,
use `/pr` with the `update-pr-description` skill instead — it produces
descriptions grounded in the actual diff, which is more actionable for
reviewers than a narrative summary.

### 4. Commit and stop

Commit with `docs(narrative): create [topic] narrative`. Then stop.

## Behavioral Contract

This is a **hybrid skill** — procedural steps (gather, copy, commit) plus
behavioral judgment (tone, evidence, arc identification). The procedural
parts are deterministic; the behavioral parts require calibration.

**Write as if explaining to a thoughtful colleague.** They know the domain
but haven't been following this specific project. Avoid jargon where plain
language works, but don't shy away from specifics when precision matters.
This is the tone — not corporate, not casual, not academic.

**Ground the story in specifics.** Commit hashes, error messages, code
snippets, before/after comparisons. A narrative without evidence is opinion.
A narrative with evidence is knowledge. Every claim should be traceable to
an artifact or commit.

**Show, don't tell.** Instead of "this was hard," show the error message
that surprised you. Instead of "the approach evolved," show the before/after
of the plan. The reader should *see* the difficulty, not be told about it.

**Include the wrong turns.** The discoveries that changed the plan are more
valuable than the final solution. If the initial approach was wrong and you
had to pivot, say so — that's the most useful part for future readers.

**Omit sections that don't serve the story.** Not every narrative needs a
Testing section. Not every bugfix has an Architecture Decision. The template
is a menu of possible sections, not a mandatory checklist. A narrative that
forces filler into empty sections is worse than one with fewer, richer
sections.

## Gotchas

**Writing a chronological dump instead of a story.** "First we did X, then
Y, then Z" is a changelog, not a narrative. A story has a problem, tension,
and resolution. Reorganize around the arc, not the timeline.

**Being vague about what made it hard.** "There were some challenges with
the API" tells the reader nothing. "The API returned 200 for malformed
requests, so our validation tests passed when they shouldn't have" is a
narrative. Specificity is the difference.

**Over-polishing into corporate prose.** The value of a narrative is
honesty, not polish. If the first attempt failed, say so. If the estimate
was wrong by 3x, say so. Sanitized narratives are useless for learning.

**Writing a narrative for unfinished work.** Narratives are post-completion
artifacts. The story isn't done until the work is done. If the user invokes
this mid-implementation, push back — suggest completing the work first or
using `/discuss` to think through the current state.

**Filling every template section with filler.** The template has sections
for Testing, Architecture Decisions, and Discoveries. If this was a
straightforward fix with no discoveries and no architecture decisions, those
sections should be omitted — not filled with "N/A" or generic content.
