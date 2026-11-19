---
name: requirements-amend
description: >-
  Add or edit requirements in an existing requirements document without
  renumbering or marking it Final. Use when the user wants /requirements-amend
  or to record a requirement found in implementation, discussion, or research.
  Do NOT scaffold a new document (requirements-setup) or close Draft
  (requirements-review).
disable-model-invocation: true
---

# Requirements Amend

Before proceeding, read `../SKILL.md` for path detection, document shape, IDs,
and commit discipline.

Change an existing requirements document. Append or edit in place. Do not
renumber. Do not set status to Final.

## When to use

- The user adds, changes, or drops a requirement on a document that already
  exists.
- Research recorded a candidate under **Requirements Discovered** and the user
  wants it in the document.
- `--collect`: gather every unticked candidate across the topic and promote the ones the user
  picks (see below).

## Collect mode (`--collect`)

Candidates follow the family's **Requirement Candidates** convention (`../SKILL.md`).

1. Search the topic directory (exploration, research topics, `work-blocks.md`, `design.md`,
   `planning/`, `decisions/`) and any
   captured notes that link to the topic for headings named `Requirements Discovered`. Read each
   unticked `- [ ]` candidate.
2. List them in chat: kind, text, source file, date. Mark likely duplicates of existing IDs, but
   don't merge them.
3. Ask which to promote, edit, or skip. Promote nothing the user didn't choose.
4. For each promoted candidate, write the next ID as in step 2 below, with **Source** naming the
   file it came from. Then tick it in its source file: `- [x] … → FR-n`.
5. Leave skipped candidates unticked. Stop as in step 4.

## Workflow

### 1. Open the document

Read the scratch copy while status is Draft. If only the Final file exists,
stop. The user has to send it back to Draft first: move it to the scratch
path, set **Status** to Draft, and leave the explore path empty. Commit that
removal only when the user asked to commit. If neither file exists, stop and
point at **requirements-setup**. If both exist, stop and ask which is live.

### 2. Apply only the requested change

Read the highest number for the prefix you need.

| Request | Write |
|---------|--------|
| New requirement | Next ID (`max + 1`). **Source** names where it came from: user statement, implementation, or a research topic file. |
| Change existing text | Same ID. Add **Updated:** `YYYY-MM-DD — [why]`. |
| Drop an ID the user names | Tombstone: `### FR-3: removed YYYY-MM-DD — [why]`. Do not reuse the number. |

Leave every other requirement as it is. Do not merge duplicates here. That is
**requirements-review**.

### 3. Touch the header

Set **Updated** to today. Leave **Status** as Draft.

### 4. Stop

Do not commit. The edit stays in scratch. List the IDs touched.

## Gotchas

**Renumbering.** A hole is a tombstone, not an invitation to shift FR-4 down
to FR-3. Renumber happens once, in review, after approval.

**Quiet scope growth.** Do not add a neighboring requirement because it seems
implied. Ask, or wait for another amend.
