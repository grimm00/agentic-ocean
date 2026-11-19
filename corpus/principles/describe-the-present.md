# Principle: Code and docs describe the present

**Id:** `describe-the-present`
**Status:** Active
**Last Updated:** 2026-11-03

**Consumers (hard-require):** `write` skill · `docs-pass` skill.

**Load:** `read ~/.cursor/principles/describe-the-present.md` before drafting or reviewing code
comments, READMEs, or any other durable doc that ships with the code.

---

## Statement

**Code comments and READMEs say what is true now.** How it got that way (decisions, reversals,
what changed, what it used to be) goes in commit messages, PR descriptions, and decision records,
which are versioned alongside the change itself.

A comment that says "no longer does X" only makes sense to someone who knew it once did X. The
change it describes sits in the diff, and the diff is where a reader looking for history goes.
The comment outlives that context and becomes noise, or misleads.

## Rules

1. **State facts in the present tense.** What the code does, what it requires, what breaks if it
   changes, what isn't built.
2. **Don't narrate change.** Avoid "no longer", "now", "was", "used to", "replaced", "moved",
   "reverted", and "instead of the old …".
3. **Don't narrate decisions.** Avoid "accepted for now", "we decided", "for now", and
   "temporarily". State the constraint and its consequence instead. A limitation is a present
   fact: "Neither image is pinned by digest, so …".
4. **A TODO names the work and its reason.** It doesn't predict an event elsewhere ("when X
   merges, repin"). Pending changes that depend on other work belong in a ticket or plan.
5. **Saying what isn't built is present state.** "Nothing checks this automatically" and
   "callers aren't authenticated" are facts about the code as it stands, and belong in it.
6. **Story numbers stay out of code comments.** The commit and PR link the code to its story. In a
   README or wiki page, a story number can follow a present-state statement as a pointer, but it
   can't replace the statement.

## Where history goes

| Kind of information | Home |
|---|---|
| What changed, and why | Commit message body |
| Context for reviewers, what was removed by omission | PR description |
| A decision and the alternatives weighed | Decision record or ADR |
| Working notes, reversals, how a lesson was learned | `.scratch/` threads and notes |
| Work that depends on something not done yet | Ticket or plan task |

## Before and after

| Before | After |
|---|---|
| The token must be read-only on the image path, not the service account's full reach. | The token is scoped to one image repository and can write there. |
| That's accepted for now, because the reach is one repository. | (Removed. The facts around it already state the reach and the risk.) |
| Neither image is digest-pinned yet, so until they are, this token could replace what the cluster pulls. | Neither image is pinned by digest, so anyone holding this token could push a different image under the tag the cluster runs. |
| Admin network only, until callers authenticate. | The service accepts calls from the admin network without authenticating them. |
| The prefix goes away when the upstream fix merges; repin then. | Clusters run main-branch builds only. (The repin lives in the plan.) |
| TODO: pin to digest once the image is confirmed stable | TODO: pin by digest, so what runs can't change without a commit. |

## Anti-patterns

- Comments that read as a changelog entry ("Moved from X", "Was Y before the refactor")
- "For now" with no stated condition, which leaves the reader guessing whether the code is current
- Keeping a superseded explanation struck through in a README; strike-through history belongs in
  `.scratch/` and decision records, not shipped docs
- A TODO whose trigger is another repo's unmerged branch

## When *not* to apply

Commit messages, PR descriptions, changelogs, decision records, handoffs, and `.scratch/` notes
are history by design. This principle governs the artifacts a reader treats as a description of
the current system.

## Pairing

| Load | For |
|------|-----|
| `~/.cursor/principles/documentation-is-ownership.md` | Whether docs must exist, and keeping comments thin |
| `~/.cursor/principles/describe-the-present.md` | Keeping comments and docs about the current state |
| `~/.cursor/principles/each-fact-has-one-home.md` | Which surface (comment, README, wiki, PR, scratch) a fact belongs on |
| `~/.cursor/registers/plain-informational.md` | How sentences, headings and bold leads are worded |
| `~/.cursor/registers/cold-reader-operator.md` | How a doc is structured for someone reading cold |
