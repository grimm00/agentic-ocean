---
name: write
description: >-
  Draft durable prose (READMEs, runbooks, wiki pages, maintainer docs,
  role documentation, architecture docs) using the correct register for the
  audience. Selects cold-reader-operator for operator/maintainer docs and
  runbooks; plain-informational for team READMEs, wiki drafts, PR text,
  and ticket text. Hard-loads the register before writing. Use when the
  user asks to write, draft, or rewrite a README, runbook, wiki page,
  role doc, or any durable team-facing prose, or says "/write".
disable-model-invocation: true
---

# Write

Draft durable prose for a named artifact, loading the correct register for the
audience before putting any words down.

```
identify artifact + audience → select register → load register + principle → draft → confirm → write
```

## Register Selection

Load the register **before drafting**. Hard-require: if the file cannot be read,
stop and say so — do not proceed without it.

| Audience | Register to load | When |
|---|---|---|
| Operator re-entering cold | `~/.cursor/registers/cold-reader-operator.md` | Maintainer docs, runbooks, architecture docs, `docs/maintainers/**`, operator-facing READMEs |
| Teammate scanning for facts | `~/.cursor/registers/plain-informational.md` | Team READMEs, wiki pages, PR descriptions, ticket text, agenda items |

**When the artifact has both audiences** (e.g., a README with a cold-open
structure *and* team-facing fact sections): load `cold-reader-operator` for the
document structure pass, then `plain-informational` for the heading and
sentence pass. Make each load explicit — do not blend from memory.

**Default if unclear:** ask one question — *who reads this cold?* — then default
to `plain-informational` if operator re-entry is not the answer.

## Principle (hard-require)

Read `~/.cursor/principles/describe-the-present.md` before drafting or reviewing
anything a reader treats as a description of the current system: READMEs,
runbooks, maintainer docs, wiki pages, and code comments. If the file
cannot be read, stop and say so.

It doesn't apply to PR descriptions, commit messages, changelogs, or decision
records. Those carry history by design.

## Workflow

### 1. Identify artifact and audience

Gather from context or ask:
- What is the artifact? (README, runbook, role doc, wiki page, …)
- Who reads it cold? (Operator re-entering the system, or teammate scanning for facts?)
- Where does it live? (file path or wiki URL)

### 2. Load the register and the principle

```bash
# operator docs / runbooks / maintainer prose:
read ~/.cursor/registers/cold-reader-operator.md

# team READMEs / wiki / PR text / ticket text:
read ~/.cursor/registers/plain-informational.md

# anything describing the current system (not PR text or commit messages):
read ~/.cursor/principles/describe-the-present.md
```

Do not draft until the files have been read. The register governs structure,
headings, bold leads, sentence shape, and anti-patterns — not just tone. The
principle governs tense: what the doc says is true now.

### 3. Gather context

Read whatever exists before writing over it:
- Existing file content (if any)
- Related docs in the same directory (sibling README, role defaults)
- For role docs: `roles/<role>/defaults/main.yml` for variable names and defaults
- Relevant git history (`git log --oneline -10`) if the doc is tracking a change
- Any linked tickets, plans, or explorations the user mentions

### 4. Draft

Follow the loaded register. The rules below are a reminder only — the loaded
file is the authority.

**cold-reader-operator shape:**
- "Start here" section first: 3–5 ordered steps for a cold open
- Why before inventory (problem before CIDRs / file paths / role lists)
- Define every term and metaphor on first use; optional Glossary at the end
- Link upstream product docs on first mention; do not lecture them

**plain-informational shape:**
- Headings describe their content — no idioms, wordplay, or mottos
- Bold lead is a complete, informational sentence (the fact); reason follows
- Give the concrete consequence, not the abstract label
- Plain imperatives; no em-dashes as structural connectives

**describe-the-present:**
- State what is true now, in the present tense
- No change narration ("no longer", "was", "replaced", "moved")
- No decision narration ("for now", "accepted", "we decided"); state the
  constraint and its consequence
- History goes in commits, PR descriptions, and decision records

### 5. Present

Show the drafted prose in a fenced markdown block. Outside the block, note:
- Which register was used and why
- Sections or terms that need the user's input before they're final
- Whether the output is a new file or a rewrite of an existing one

### 6. Write (on confirmation only)

After the user confirms, write the file. Do not write without confirmation.
If the destination is a wiki with its own markup (for example Confluence storage
format), follow the workspace's rule for that format; a markdown draft is not
what the wiki's write tools expect.

## Specialized Skills — Check First

Before using this skill, check whether a more specific one applies:

| Artifact | Use instead |
|---|---|
| Implementation plan | `write-plan-start` |
| Post-completion story | `narrative` |
| PR description | `update-pr-description`, or its context variant if one is installed |
| Trimming comments and routing a branch's docs across README, wiki, and PR | `docs-pass` |

A context variant (`write-<context>`, installed from a private corpus) may add
artifact types and destinations for a particular workplace. Use it there.
`write` is the fallback for everything else.

## Gotchas

**Writing before loading the register.** The draft will drift from register
rules even if the intent is right. Load first; do not approximate from memory.

**Both audiences in one doc.** Make two explicit load calls — structure pass
with `cold-reader-operator`, sentence pass with `plain-informational`. Informal
blending produces neither register.

**Overwriting before confirming.** Show the draft, get confirmation, then write.

**Bold leads that are fragments.** `plain-informational` rule 2: the bold lead
must be a complete informational sentence. A reader skimming only the bold text
should come away with the fact.

**Skipping the exemplar.** Each register names a concrete exemplar that
already nails the register. Read it when the doc being drafted is similar in
shape — it is more actionable than re-reading the rules alone.

**Narrating history in a doc that describes the system.** A rewrite driven by a
change tends to explain the change ("no longer checks X", "accepted for now").
The reader of a README or comment needs the current state; the change belongs
in the commit message or PR. Scan the draft for change and decision wording
before presenting it.
