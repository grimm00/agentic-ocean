---
name: explore-start
description: >-
  Create a new exploration from unstructured input. Use when the user invokes
  /explore [topic] (without --amend) and wants to organize raw thoughts, ideas,
  or a brain dump into a self-sufficient exploration with prioritized research
  questions. Do NOT use for appending to an existing exploration (/explore-amend)
  or for implementing planned work (/task).
disable-model-invocation: true
---

# Explore Start

Before proceeding, read `../SKILL.md` for family conventions (path detection,
output sizing, topic naming, commit discipline).

Create a self-sufficient exploration from unstructured input. The output is a
complete artifact at the exploration level of abstraction — it describes *what
the problem space looks like* without prescribing *what to do about it*. The
user reviews it, then decides the next step: research, amend, or implement
directly.

```
input → parse themes + questions → create exploration → commit → stop
```

## Input Sources

Accept exactly one input source. Error if multiple are provided.

| Source | Flag | What it provides |
|--------|------|------------------|
| Inline text | `/explore "thoughts..."` or `--input "text"` | Raw ideas to organize |
| File | `--input path/to/file.txt` | Reads file content as input |
| start.txt | `--from-start` | Project initialization notes |
| Reflection | `--from-reflect [path]` | Actionable suggestions from a `/reflect` output |
| Interactive | *(no flag)* | Prompt: "What topic would you like to explore?" |

**If `--from-reflect`:** extract only the "Actionable Suggestions" section. If that
section is missing, warn and use the full document.

**If `--from-start`:** search current directory then project root for `start.txt`.
Error if not found or empty.

## Workflow

### 1. Resolve topic and detect conflicts

Sanitize the topic name per family conventions (kebab-case). Then check whether
an exploration already exists at the detected path:

- **No existing directory:** proceed to step 2.
- **Existing exploration:** warn and suggest `/explore-amend` to append new themes.
  Do not overwrite — the existing exploration contains user-reviewed content.

### 2. Extract themes and questions

Parse the input for distinct ideas, concerns, and open questions.

**Theme extraction:**
1. Identify distinct ideas or concerns in the input
2. Group related thoughts into thematic clusters
3. Name each theme with a descriptive noun phrase (2–5 words)
4. Preserve the user's original phrasing under each theme
5. Add enough context per theme (~4-6 bullets) that the theme stands alone:
   who's affected, why it matters, what the concern implies

**Question extraction:**
1. Collect explicit questions (sentences ending in `?`)
2. Convert implicit uncertainty markers (`"maybe"`, `"not sure"`, `"what about"`,
   `"consider"`) into research questions
3. Prioritize by apparent importance in the input (High / Medium / Low)
4. Add a one-sentence Context line per question explaining why it matters

### 3. Create exploration files

Create three files in the exploration directory. Use the path detected per
family conventions.

**`README.md`** (~20 lines) — hub with quick links to exploration.md and
research-topics.md.

**`exploration.md`** (~80–120 lines) — the core exploration:

```markdown
# Exploration: [Topic]

**Created:** YYYY-MM-DD

---

## 🎯 What We're Exploring

[2–3 sentence summary extracted from input]

---

## 🔍 Themes

### Theme 1: [Descriptive Name]
- [Core concern preserving user's words]
- [Why this matters or who it affects]
- [What the concern implies for the project]
- [Related considerations or adjacent concerns]

### Theme 2: [Descriptive Name]
- [Core concern preserving user's words]
- [Why this matters or who it affects]
- [What the concern implies for the project]
- [Related considerations or adjacent concerns]

---

## ❓ Key Questions

1. [Question]
2. [Question]

---

## 🧪 Spike Determination

| Topic | Risk Level | Spike? | Rationale |
|-------|------------|--------|-----------|
| [From themes] | [HIGH/MEDIUM-HIGH/MEDIUM/LOW] | [Yes/Consider/No] | [Brief] |

**Risk framework:** HIGH = spike first (hard to pivot), MEDIUM-HIGH = consider
spike, MEDIUM/LOW = research only.

---

## 🚀 Next Steps

Review this exploration, then:
- `/explore-amend` to add new themes from downstream discovery
- `/research --from-explore` to investigate open questions
- Proceed directly to implementation if the exploration is sufficient
```

**`research-topics.md`** (~25–40 lines) — prioritized questions with context:

```markdown
# Research Topics — [Topic]

**Created:** YYYY-MM-DD

---

## 📋 Topics Identified

### Topic 1: [Name]

**Question:** [Core question]
**Priority:** [High | Medium | Low]
**Context:** [One sentence — why this question matters]

### Topic 2: [Name]

**Question:** [Core question]
**Priority:** [High | Medium | Low]
**Context:** [One sentence — why this question matters]

---

## 🚀 Next Steps

Use `/research --from-explore [topic]` to investigate these questions.
```

### 4. Commit and stop

Commit all three files with `docs(explore): create [topic] exploration`.
Then **stop and present the exploration summary to the user.** Do not proceed
to research or implementation — the human review step is the whole point.

## Behavioral Contract

**Create exactly three files.** Do not create additional files, directories, or
artifacts beyond README.md, exploration.md, and research-topics.md.

**Preserve the user's language.** Themes should use the user's words, not
paraphrased corporate summaries. The exploration is a mirror of their thinking,
not a rewrite.

**Make themes self-sufficient.** Each theme should have enough context (~4-6
bullets) that a reader understands the concern without needing to read the
original input or conduct research. But stay at bullet-point depth — not
multi-paragraph analysis. Analysis is research territory, not exploration.

**Assess spike risk for every theme.** The spike determination table is not
optional. Every theme gets a row with a risk level and rationale.

**Stop after committing.** Do not start research, create additional explorations,
or suggest immediate next actions beyond reviewing the exploration. The
checkpoint exists so the user can discard, redirect, or proceed to implementation
without further ceremony.

## Gotchas

**Writing analysis instead of exploration.** Themes should describe *what the
concern is* and *why it matters*, not *what to do about it*. If you're
recommending solutions, comparing options, or weighing tradeoffs, you've crossed
into research territory. Stay in the problem space.

**Making themes too thin.** Two bullet points that just restate the user's words
aren't self-sufficient. Add context: who's affected, why it matters, what the
concern implies. A reader should understand the theme without reading the
original input.

**Merging the user's distinct thoughts into one theme.** If the user mentions
authentication AND notification in the same paragraph, those are likely two
themes, not one. Err toward splitting; the user can merge during review.

**Inventing questions the user didn't imply.** Extract questions from the
input. If the user didn't express uncertainty about a topic, don't manufacture
a research question for it. The spike determination table is where you assess
risk — the questions section reflects the user's actual uncertainties.

**Creating the directory without checking for conflicts.** An existing
exploration at the same path means the user has prior work. Overwriting it
silently is a data-loss risk. Always check and warn.

**Skipping the commit.** The exploration must be committed before stopping.
If the user abandons the exploration, the commit makes it recoverable. If
they proceed, the commit creates a clean diff for the next step.

**Proceeding to research without stopping.** The human review step exists so the
user can decide whether to research, amend, implement directly, or discard. Even
if the user seems eager to continue, stop after the commit. They invoke the next
step explicitly.
