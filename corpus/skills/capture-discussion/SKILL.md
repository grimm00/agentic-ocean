---
name: capture-discussion
description: >-
  Promote `/discuss` thread content into a persistent notes library with smart
  splitting and cross-referencing. Use when the user wants to capture insights
  from a discussion, when a sub-concept emerges that's worth standalone capture,
  or after a substantive `/discuss` thread that should outlast the chat session.
disable-model-invocation: true
---

# Capture Discussion

Take in-flight `/discuss` thread content and produce one or more persistent notes files. Decide whether to append to an existing thread record, create a new standalone concept doc, or both. Keep cross-references bidirectional. Preserve enough of the back-and-forth (the user's first-pass answers, what got confirmed, what got refined) that future-you can re-enter the thread cold.

```
identify content ──► survey notes dir ──► decide append vs split ──► compose ──► cross-ref
                                                    ▲
                                      templates/thread-record.md
                                      templates/concept-doc.md
```

This is the deliberate companion to `/discuss`. The discuss skill is read-only by contract; this skill is the explicit, user-invoked promotion step that exits read-only mode and writes.

---

## When to use

- A `/discuss` thread has produced substantive content the user wants to refer back to.
- During a `/discuss` thread, a sub-concept has emerged that warrants standalone capture (e.g. a foundational mental model that will be referenced from multiple future threads).
- After a `/discuss` thread ends, the user wants the insights persisted before the chat context is lost.

## When NOT to use

- The user is mid-`/discuss` and wants to keep thinking — don't proactively capture. Discuss-mode is a firewall; wait for explicit invocation.
- The content belongs in a project-formal artifact (research findings, decisions, plans). Use `/research`, `/decision`, `/write-plan` instead.
- The user just wants a chat-only summary. Use `/discuss --summary`.

---

## Configuration

### Default notes location

`notes/` at workspace root. Create with `mkdir -p notes/` if missing.

### Override

`--dir <path>` to use a different location.

### File naming

| Aspect | Convention |
|---|---|
| Filename | kebab-case topic, no dates, no `discuss-` prefix (e.g. `dom-fundamentals.md`, not `discuss-dom-fundamentals-2026-05-26.md`) |
| Dates | Inside the file as `Created:` / `Updated:` lines, never in filename |
| Type prefix | Drop by default. Reintroduce via folder structure (`notes/discuss/`, `notes/concepts/`) only if/when the library gains multiple artifact types |

---

## Workflow

### 1. Survey

Read the contents of the resolved notes directory. Identify:

- Existing thread-record files (cover whole `/discuss` threads)
- Existing concept docs (cover single foundational concepts)
- Their cross-reference structure

If the directory doesn't exist, create it.

### 2. Identify capture scope

What is being captured?

- **Whole thread snapshot** — preserve the full back-and-forth (first-pass answers, what got confirmed/refined, open threads).
- **Single sub-concept that emerged** — promote one self-contained idea into its own doc.
- **Both** — when a thread has produced a standalone-worthy concept AND there's thread context worth preserving separately.

### 3. Decide: append, split, or both

| Situation | Action |
|---|---|
| Small refinement tied to the thread | Append to existing thread-record |
| Substantive standalone concept (foundational, likely referenced from elsewhere) | New concept doc + brief summary in thread-record linking to it |
| Multiple concepts emerged | Multiple concept docs, brief summary in thread-record for each |
| No existing thread-record and the discussion was substantial | New thread-record (+ any concept docs that split out) |

**The splitting test:** *If you can imagine future-you (or another agent) wanting to link to this concept without the thread context, split it out into its own doc.*

This skill is **not strict** on append-vs-new-file. Use judgment. State the call in chat so the user can push back. The cost of being wrong is low (rename / merge later).

### 4. Compose

Use the templates:

- **Thread record** → `templates/thread-record.md` (rolling thread doc)
- **Concept doc** → `templates/concept-doc.md` (standalone foundational concept doc)

Read each template once at the start of composition; don't re-read per file. Replace placeholders with actual content; omit sections that don't apply.

### 5. Cross-reference

| Direction | Update |
|---|---|
| Parent → child | Thread record's **What got refined** (or equivalent section) gets a brief mention with a link to the new concept doc. Thread record's **Cross-references** section gets the new file listed. |
| Child → parent | Concept doc's **Origin** header field names the parent thread. Concept doc's **Cross-references** section links back to the parent. |
| Status updates | If the new content partially addresses an item in the parent's **Open threads** or **Follow-up questions** section, mark that item with the status (e.g. "In progress — see `<file>.md`" or "Partially answered: <one-line summary>"). Don't pretend the item is untouched. |

### 6. Confirm and present

- Show the final file list and what changed in each.
- For renames or deletes, **always** ask before executing.
- Note any conventions established (header style, naming) so the user can push back.

---

## File structure produced

The skill produces some combination of:

```
notes/
├── <topic>.md              # Thread record (one per /discuss thread)
└── <sub-concept>.md        # Concept doc (one per standalone foundational concept)
```

Flat structure by default. Add folders (`notes/discuss/`, `notes/concepts/`) only when the user explicitly wants the split, or when the library has grown enough that scanning a flat list is painful.

---

## Behavioral contract

**Preserve the user's voice.** First-pass answers go in verbatim-ish (under "My first-pass answers" or equivalent). The point is not to clean up the user's thinking — it's to preserve a record of where they were so they can see growth.

**Confirm before destructive operations.** Renames, deletes, and folder restructures always get a confirmation step. Adding new content is fine without asking; removing or restructuring is not.

**Bidirectional cross-references always.** Every link from parent to child gets a corresponding link from child to parent. Otherwise the library decays into orphans.

**Update status, don't hide it.** When this skill partially addresses an open thread or follow-up question, mark the parent's section accordingly. Don't leave items looking untouched when work has happened.

**Date conventions are inside files, not filenames.** Filename = topic. Header = `Created:` / `Updated:` lines. This makes files renameable without breaking the rolling-update story.

**Respect judgment over rules.** The append-vs-split decision is a judgment call. Document the call in chat ("I'm splitting this out because…") so the user can push back.

**Exit `/discuss` mode explicitly.** This skill writes files. If invoked during a `/discuss` thread, name the mode switch in the response so the user knows they've moved out of read-only collaborative thinking.

---

## Gotchas

- **Don't write while the user is still mid-thought.** Wait for explicit invocation. Don't promote content "helpfully" mid-discussion.
- **Don't duplicate the parent's content in the concept doc.** The concept doc should stand alone, but it shouldn't restate the thread's open questions or the user's first-pass — that lives in the parent.
- **Don't lose follow-up questions.** When a follow-up question gets partially or fully answered by the new content, mark it; don't silently drop it.
- **Don't reorganize without permission.** If the user already has a notes convention (different directory, different naming), use it. Propose changes — don't impose them.
- **Don't pad with N/A sections.** Templates list common sections; omit any that don't apply rather than filling with placeholder text.

---

## Related

- **`/discuss`** — the read-only thinking mode this skill captures from.
- **`/handoff`** — for session-end state preservation (different shape: state-of-work-and-what's-next, not content insights).
- **`/explore`, `/research`, `/decision`** — for promoting content to project-formal artifacts when the discussion outgrows notes.
- **`/reflect`** — for project-state reflection (different shape: evidence-backed observations from git/PRs/status docs, not learning content).
