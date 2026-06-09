---
name: explore-amend
description: >-
  Append a new theme and research question to an existing exploration. Use when
  the user invokes /explore [topic] --amend and wants to add a theme surfaced by
  downstream work (research, spikes, discussion) without overwriting or
  reorganizing existing content. Do NOT use for creating new explorations
  (/explore-start) or for read-only thinking (/discuss).
disable-model-invocation: true
---

# Explore Amend

Before proceeding, read `../SKILL.md` for family conventions (path detection,
output sizing, topic naming, commit discipline).

Append a new theme and corresponding research question to an existing
exploration. This is a **mutation skill** — it modifies files that already
contain user-reviewed content. The core contract is: append without
disturbing what's already there.

```
read existing exploration → validate it exists → count themes/topics
  → append theme → append question → update spike table
  → add amendment metadata → commit → stop
```

## Options

| Invocation | Behavior |
|------------|----------|
| `/explore-amend [topic] "description"` | Append theme described in the quoted text |
| `/explore-amend [topic]` | Prompt: "What theme do you want to add?" |

The description is the user's raw thought. Preserve it — don't rewrite it into
a sanitized summary.

## Workflow

### 1. Locate and validate the existing exploration

Use family conventions for path detection. Read `exploration.md` at the
resolved path.

- **Exploration exists:** proceed to step 2.
- **No exploration found:** error — suggest `/explore-start [topic]` first.

### 2. Count existing themes and topics

Read `exploration.md` and count headings matching `### Theme N:` to determine
the next theme number. Read `research-topics.md` and count headings matching
`### Topic N:` to determine the next topic number.

These counts MUST drive the numbering. Do not hardcode or guess.

### 3. Append the new theme to `exploration.md`

Insert the new theme at the end of the `## 🔍 Themes` section, before the next
`---` separator or `## ❓ Key Questions` heading.

**Theme format** (~15-25 lines, per family output sizing):

```markdown
### Theme [N+1]: [Descriptive Name]
- [Context-rich bullet preserving user's description]
- [Why this matters or who it affects]
- [What the concern implies]
- [Source: what downstream work surfaced this — research topic, spike, discussion]
```

### 4. Append a corresponding question to `## ❓ Key Questions`

Add a numbered question at the end of the Key Questions list:

```markdown
N+1. [Question derived from the new theme]
```

### 5. Update the spike determination table

Add a new row to the `## 🧪 Spike Determination` table:

```markdown
| [Theme N+1 topic] | [HIGH/MEDIUM-HIGH/MEDIUM/LOW] | [Yes/Consider/No] | [Rationale] |
```

### 6. Add amendment metadata

Add an `**Amended:**` line to the exploration.md metadata block (below
`**Created:**`):

```markdown
**Amended:** YYYY-MM-DD — [brief reason, e.g., "research surfaced auth concern"]
```

If amendment lines already exist, append a new one — do not replace previous
amendments. The amendment log is an append-only record.

### 7. Append a new topic to `research-topics.md`

If `research-topics.md` does not exist or is missing the `## 📋 Topics Identified`
section, error and suggest running `/explore-start` to recreate the exploration.
Do not create `research-topics.md` from scratch — that's explore-start's job.

Insert a new topic at the end of the `## 📋 Topics Identified` section:

```markdown
### Topic [M+1]: [Name]

**Question:** [Core question derived from the new theme]
**Priority:** [High | Medium | Low]
**Context:** [One sentence — why this question matters, referencing the source]
```

### 8. Commit and stop

Commit both files with `docs(explore): amend [topic] exploration with [brief]`.
Then **stop.** Do not proceed to research or further amendments.

## Behavioral Contract

**Append, never overwrite.** The exploration contains user-reviewed content.
Every modification this skill makes is an *addition* at a known insertion point.
No existing text is edited, moved, reformatted, or deleted.

**Auto-number correctly.** Count existing `### Theme N:` headings to get the
current max, then use max+1. Do the same for `### Topic N:` in
research-topics.md. Off-by-one errors in numbering corrupt the exploration's
structure.

**Update the spike determination table.** Every new theme gets a risk assessment
row. The table is the record of what needs validation — omitting it means the
new theme is invisible to spike planning.

**Add amendment metadata.** The `**Amended:**` line creates an audit trail.
Without it, there's no record that the exploration was modified after initial
creation or by whom/why.

**Preserve existing content verbatim.** Do not fix typos, reformat bullet
points, adjust heading levels, reorder themes, or "improve" existing content.
The user reviewed it as-is. Unsolicited edits during an amend are trust-breaking
mutations.

## Gotchas

**Editing existing themes "while you're in there."** The temptation to fix a
typo or improve phrasing in Theme 2 while appending Theme 4 is strong. Don't.
The user reviewed Themes 1-3 — any edit to them is an unsolicited mutation.
If something needs changing, flag it in chat; the user decides.

**Misnumbering the new theme.** If the exploration has Themes 1-3 and you
create "Theme 3" instead of "Theme 4," you've overwritten Theme 3's heading.
Always count existing headings programmatically; don't assume from memory.

**Appending in the wrong section.** The theme goes in `## 🔍 Themes`, the
question in `## ❓ Key Questions`, the row in `## 🧪 Spike Determination`.
Inserting a theme below Key Questions or a question inside the Themes section
breaks the document structure.

**Forgetting to update research-topics.md.** The amend touches two files, not
one. If you only update exploration.md, the research pipeline won't see the
new question. Both files must be updated in the same commit.

**Replacing the amendment metadata instead of appending.** A second amend
should produce two `**Amended:**` lines, not overwrite the first. The metadata
is an append-only log.

**Manufacturing a theme from the description.** If the user says "we should
think about caching," the theme is about caching — not about "performance
optimization strategies." Preserve the user's framing; don't generalize or
corporate-ify it.
