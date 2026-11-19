# Principle: Each fact has one home

**Id:** `each-fact-has-one-home`
**Status:** Active
**Last Updated:** 2026-11-03

**Consumers (hard-require):** `docs-pass`.

**Load:** `read ~/.cursor/principles/each-fact-has-one-home.md` before deciding where a comment,
README section, wiki paragraph, PR sentence, or piece of evidence belongs.

---

## Statement

The documentation around a change lives on five surfaces, and each has one reader. A fact goes on
the surface whose reader needs it, and it is written there once. Other surfaces link to it rather
than restating it, because two copies of a fact drift apart and the reader can't tell which one is
current.

Three surfaces are tracked and describe the system as it is now: code comments, the README, and the
wiki. They form a ladder from narrow to broad. Two are off the ladder: the commit and PR carry
history, and scratch carries evidence.

## The surfaces

| Surface | Reader | Holds | Doesn't hold |
|---|---|---|---|
| Code comment | Someone about to edit that line | A constraint or hazard the code can't show, in two sentences or fewer. Often nothing. | Story numbers, requirement IDs, research, history, or anything the code already says |
| README | Someone running or configuring the role or repo without reading its code | What it does, its variables, how to run it, what it touches, and a link to the wiki for why | Design reasoning, cross-repo architecture, a step-by-step retelling of the tasks |
| Wiki | The team, and anyone who doesn't yet know which repo to open | Why the design is the way it is, how the mechanism works, the picture across repos, troubleshooting | Variable tables and commands that the README owns |
| Commit and PR | A reviewer now, or someone reading history later | What changed and why, what was removed, and what was verified | Pasted verification output, architecture explanations |
| Scratch | The author, and reviewers who ask | Verification output, diagnostic commands, working notes, requirement documents | Anything a reader needs without asking |

"Wiki" means the repo's durable doc root: the team's wiki space, if it has one. In a repo that
keeps maintainer docs in git (for example `docs/maintainers/`), it is that directory.

## Routing questions

Ask these in order for each comment, README section or paragraph. The first one that applies decides
where the fact goes.

1. **Does the code or config already say it?** Delete it.
2. **Does it describe a change?** ("no longer", "was", "replaced", "now", "for now".) It goes in the
   commit message or PR body. See `describe-the-present`.
3. **Is it evidence of how something was checked?** It stays in scratch. The PR says what was
   verified and where the evidence is.
4. **Will someone editing this line break something without it?** It stays as a comment, cut to two
   sentences or fewer. If the surrounding code carries no comments, it goes in the README instead
   (rule 5).
5. **Does someone running or configuring the thing need it without reading the code?** It goes in
   the README.
6. **Is it a reason, a mechanism, or something that spans repos, or does it need to be found from
   outside the repo?** It goes on the wiki.

If none applies, the fact probably isn't needed. Say so in the report rather than keeping it by
default.

## Rules

1. **Write each fact once.** The other surfaces link to it. A README links to the wiki page for the
   reasoning; a wiki page links to the README for the variables and commands.
2. **Moving a fact means rewriting it for the new reader.** A comment written for someone editing a
   line doesn't read well on a wiki page. Use the register the destination needs (`write` selects
   it).
3. **Working comments are allowed until the docs pass.** During implementation, comments can cite
   requirement IDs (`# FR1`) and explain at length. None of that survives the pass: the ID and the
   reasoning live in the requirements document in scratch, and the commit or PR links the story.
4. **A repo's README format rule wins over this principle for structure.** Required sections stay
   even when they're short. Only content inside a section, and optional sections, are candidates to
   move.
5. **No comment is a valid outcome.** Code with no comments is normal, and in a repo that mostly
   goes without them, the absence means the context lives in the README or the wiki. Match the
   comment density of the surrounding files: in a low-comment repo, the pass deletes far more
   comments than it keeps, and it doesn't add new ones.
6. **A missing fact is a finding, not a missing comment.** If the change adds a hazard or changes
   how to run something and no surface states it, report the addition on the surface that fits the
   repo. In a repo that comments its hazards, that can be a comment. Otherwise it's the README.
7. **When the destination isn't yours to edit, record the gap.** Another team's wiki page, or a page
   you can't write to, gets a doc-gap entry or a message to its owner. Dropping the fact is not an
   option.

## Anti-patterns

- A comment that cites a story number in place of saying what the code requires
- Adding comments to a file or repo that otherwise has none, so the change is the only commented
  code in sight
- A README "Extra Notes" section that is a design essay with no link to the wiki
- A wiki page that copies the README's variable table, so the two disagree within a release
- A PR description with pasted terminal output, or a section explaining the architecture
- Keeping a fact on two surfaces "to be safe"

## Pairing

| Load | For |
|------|-----|
| `~/.cursor/principles/describe-the-present.md` | Keeping tracked surfaces about the current state, and where history goes |
| `~/.cursor/principles/documentation-is-ownership.md` | Whether docs must exist at all, and keeping comments thin |
| `~/.cursor/registers/plain-informational.md` | How a moved fact's sentences are worded |
| `~/.cursor/registers/cold-reader-operator.md` | How a wiki page or runbook is structured for a cold reader |
