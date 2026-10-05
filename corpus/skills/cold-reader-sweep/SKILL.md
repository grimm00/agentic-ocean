---
name: cold-reader-sweep
description: >-
  Read operator and maintainer pages as someone who was not in the chat, and
  report where a path, command, or procedure no longer matches the tree. Use
  when the user says cold reader, coldreader, docs sweep, or asks whether the
  current pages are still true before more work.
disable-model-invocation: true
---

# Cold-reader sweep

A cold reader has the repo and not the conversation. Current procedure pages
are what they will follow. This skill reports where those pages and the tree
disagree. It does not edit unless the user asks for the fixes in the same turn.

```
scope the pages → read each page against the files it names → report → stop
```

## When to use

- Before the next implementation group, when docs may still describe the last tree
- After a move or rename, to see which operator pages still name the old path
- When the user says "cold reader" or "docs sweep"

## When not to use

- Authoring a new plan or requirements
- Rewriting historical narrative or archived plans on purpose
- A full editorial pass on tone with no claim that a page is wrong

## Scope

1. If the user names pages, use those.
2. Otherwise use the **Docs** lines of the current plan group, plus any page
   the branch diff would make stale.
3. Include a service README when a wiki page sends the reader there for the steps.
4. Leave narrative and archived plans out unless the user includes them. They
   record how the thing was built.

If `~/.cursor/registers/cold-reader-operator.md` or
`~/.cursor/principles/documentation-is-ownership.md` is on disk, read it and
apply it. If it is missing, use the checks below.

## Checks

Read the page, then open the path or command it tells the reader to use.

Flag a line when:

- A path, command, or filename on the page is not in the tree
- The page still describes a procedure the code no longer does
- A name is only clear if you were in the chat
- The page tells the operator to do something the plan has not landed yet.
  Say that. Do not "fix" ahead of the plan
- A secret, address, or credential the repo keeps out of git would be added by
  making the page more specific

A README says what the operator does. A wiki page says why. Do not move that
split to make the pages match.

## Report

In chat only:

```
## Cold-reader sweep

**Pages read:** …

- `path` — the sentence. The tree has … instead.
- `path` — still true.

**Left alone:** historical pages, and anything the next plan group owns.
```

No file writes. No commit. If the user then asks to fix the list, edit only
the flagged current-procedure lines.
