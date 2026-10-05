---
name: requirements-setup
description: >-
  Scaffold a requirements document for a topic, including statements the user
  already gave. Use when the user wants /requirements-setup or a requirements
  doc without a research cycle. Do NOT amend an existing document
  (requirements-amend) or mark it Final (requirements-review).
disable-model-invocation: true
---

# Requirements Setup

Before proceeding, read `../SKILL.md` for path detection, document shape, IDs,
and commit discipline.

Create the requirements file and stop. Do not research. Do not invent
requirements the user did not state.

## When to use

- A topic needs `requirements.md` and the file is not there yet.
- The cycle has no research topics. Research is optional, not a prerequisite.

## Workflow

### 1. Resolve the path

Use family path detection. Write the Draft under `.scratch/`, in the directory
explore-start would use. If that scratch file or the Final file already
exists, stop and point at **requirements-amend**. If a research-tree
`requirements.md` exists and neither of those does, stop and ask before moving
it.

### 2. Take statements from the user

Use only what this invocation already states. If there are no statements, write
the empty document shape and ask for a numbered list. Do not draft stand-in
requirements to fill the sections.

Classify each statement:

| Kind | Prefix |
|------|--------|
| Behavior the system must have | `FR` |
| Quality bar (performance, safety, operability) | `NFR` |
| A limit on how it may be built | `C` |
| Something treated as true so the set can proceed | `A` |

**Source** for these entries is `user, YYYY-MM-DD`.

### 3. Write the file

Status **Draft**. Overview is one paragraph from the user's purpose, or a
single line that the overview is not written yet. No IDs except the statements
from step 2.

### 4. Stop

Do not commit. A Draft stays in scratch. Present the scratch path and the IDs
written. Do not start amend or review.

## Gotchas

**Invented requirements.** Empty sections are valid. A plausible FR the user
did not say is not.

**Second file.** Never create the scratch path while a research-tree
`requirements.md`, or a Final file on the explore path, already exists for the
same topic.
