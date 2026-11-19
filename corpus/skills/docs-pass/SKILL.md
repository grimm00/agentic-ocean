---
name: docs-pass
description: >-
  Reconcile the documentation around a change across its five surfaces: code
  comments, READMEs, the wiki, the commit and PR, and scratch. Trims comments
  and README text, routes each fact to the surface whose reader needs it, and
  drafts wiki changes. Reports first and applies only on confirmation; never
  commits and never publishes to the wiki without a separate explicit OK. Use
  when the user invokes /docs-pass, or after /implement and before
  /pre-commit-review.
disable-model-invocation: true
---

# Docs pass

Implementation leaves documentation in a working state: long comments, requirement IDs inline,
README sections that explain more than an operator needs, and a wiki page that predates the change.
This pass decides where each fact belongs, reports it, and applies the moves you confirm.

```
load → scope → comments → READMEs → wiki → history and evidence → report → STOP → apply on confirm
```

## Load (hard-require)

Read these before step 2. If any file can't be read, stop and say so.

| File | For |
|---|---|
| `~/.cursor/principles/each-fact-has-one-home.md` | The five surfaces and the routing questions. This skill applies it; it doesn't restate it. |
| `~/.cursor/principles/describe-the-present.md` | Spotting history and decision wording in tracked surfaces |
| `~/.cursor/registers/plain-informational.md` | Wording of any text the pass drafts |

Load these when the step needs them:

- **The repo's README format rule**, if one exists (often a `readme-format` rule under
  `~/.cursor/rules/`), before the README pass.
- **`~/.cursor/registers/cold-reader-operator.md`** before drafting a new wiki section or page.
- **The workspace's wiki rules**, if any, before reading or drafting a wiki page: page hierarchy,
  markup format, and the tools that read and write it.

A context variant (`docs-pass-<context>`, installed from a private corpus) names these files for a
particular workplace. Use it there.

## When to use

- After `/implement` finishes a task or a run, before `/pre-commit-review`
- When a branch has comments full of requirement IDs or reasoning that shouldn't ship
- When a README or wiki page may no longer match what the branch does

## When not to use

| Situation | Use instead |
|---|---|
| Only checking whether current docs are still true, with no change in flight | `cold-reader-sweep` |
| Writing a new doc from scratch | `write` |
| Implementation still in progress | Finish it first; the pass has to run again after more edits |

## Invocation

| Invocation | Behavior |
|---|---|
| `/docs-pass` | Branch diff against the default branch, plus uncommitted and untracked work |
| `--scope PATH` | Only changed files under `PATH` |
| `--no-wiki` | Skip step 5; report wiki destinations without reading pages |

---

## Workflow

### 1. Load

Read the files in **Load**.

### 2. Resolve scope

```bash
default=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main)
base=$(git merge-base HEAD "$default")
git diff --stat "$base"                    # committed on the branch plus the working tree
git diff -U5 "$base"                       # the hunks the comment pass reads
git ls-files --others --exclude-standard   # untracked files, read whole
```

On the default branch with only uncommitted work, `base` is `HEAD`.

| Surface | In scope |
|---|---|
| Comments | Comments the diff adds or changes; unchanged comments inside the same hunk; the comment heading the block (task, function, resource, handler) a changed line sits in |
| READMEs | For each changed file, the nearest `README.md` walking up to the repo root (for a role, the role README). The root README only if the change alters something it states. |
| Wiki | Pages linked from the in-scope READMEs, plus pages a doc-root search finds for the role or component name. Read up to five; list the rest as found but unread. |
| History and evidence | `pr-body.md` and `summaries/` in the review bundle, if one exists; the line of work's scratch tree |

Comments outside the hunks are out of scope. If one conflicts with the change, list it under
**Left alone** without editing it.

**Read the comment density.** Look at the rest of each changed file and a few sibling files (other
tasks in the role, other roles). Note whether the repo comments its code, comments only hazards, or
mostly goes without. Put it on the report's **Scope** line. In a low-comment repo, the context lives
in the README and wiki, and the comment pass works from that.

**Bounded stop:** no diff, stop and say so. More than about 30 changed files, ask for `--scope`.

### 3. Comment pass

For each comment in scope, apply the routing questions from `each-fact-has-one-home` and record one
verdict:

| Verdict | Meaning |
|---|---|
| keep | Already a constraint the code can't show, in two sentences or fewer |
| trim | Keep the constraint; give the shortened text |
| README / wiki | Move the fact up; name the section or page |
| PR | History or intent; it goes in `pr-body.md` |
| scratch | Evidence or working notes; confirm they exist in scratch, then delete the comment |
| delete | The code already says it, or the repo doesn't comment code like this |
| add | The change introduces a hazard no surface states, and the repo comments its hazards |

No comment is a valid outcome, and in a low-comment repo it's the usual one. There, a fact worth
keeping moves to the README or wiki instead of staying as a comment, and an "add" becomes a README
line. Don't add a comment to make the change look documented.

A story number or requirement ID is replaced by the statement it stood for, or removed if the
statement is already in the code.

### 4. README pass

For each in-scope README:

1. **Check it against the diff.** Flag variables, paths, commands, and claims about what the tasks
   do that the branch made untrue.
2. **Route its content.** Required sections from the format rule stay. Paragraphs inside them, and
   optional sections ("Extra Notes" and similar), get the same verdicts as comments, with "wiki" as
   the usual destination for design reasoning.
3. **Place what moved up from comments.** Say which section receives each item.

### 5. Wiki check

For each page read:

1. **Is it true after the change?** Flag statements the branch made untrue.
2. **Does it receive anything?** List the items moved up from READMEs and comments, and the section
   each would go in.
3. **Does it duplicate the README?** A copied variable table or command list becomes a link to the
   README.

If no page covers the area and step 3 or 4 routed something to the wiki, propose a page and its
place in the hierarchy. If the page belongs to another team or you can't edit it, the destination is
a doc-gap entry in the notes library, if it keeps one, or a message to its owner.

### 6. History and evidence

- History removed from comments and READMEs is listed for `pr-body.md`.
- Verification output pasted into `pr-body.md`, a README or a comment moves to scratch, and the PR
  keeps a line saying what was verified and where the evidence is.
- If evidence a comment pointed to isn't in scratch, say so. Don't delete the only copy.

### 7. Report, then STOP

In chat:

```
## Docs pass: <branch or description>

**Scope:** <n> files · <n> comments · READMEs: <paths> · Wiki: <pages read> (found, unread: <pages>)
**Comment density:** <comments code | hazards only | mostly none>, from <files looked at>

| # | Where | What it says (short) | Verdict | Question |
|---|---|---|---|---|
| 1 | `roles/x/tasks/main.yml:14` | FR1 rationale for excluding a daemon | trim → "<new text>" | 4 |
| 2 | `roles/x/README.md`, Extra Notes | How the apt hook triggers restarts | wiki: <page>, section <name> | 6 |

**Additions:** <missing comments or README lines>
**Stale:** <README or wiki statements the branch made untrue>
**For the PR:** <history and intent items>
**Left alone:** <out-of-scope comments that look stale>
```

Then ask which rows to apply ("all", a list of numbers, or edits to a row). Don't edit anything
before the reply.

### 8. Apply on confirmation

- **Repo files:** edit the confirmed comments and READMEs.
- **Wiki:** write drafts to the review bundle's `wiki-drafts/` (`<page-slug>.<ext>` in the wiki's
  native format, plus `<page-slug>.md` to read). Resolve the bundle the way `pre-commit-review` does
  (`~/.cursor/skills/pre-commit-review/references/structure.yaml`). Publish to the wiki only when
  the user explicitly says to publish that page.
- **PR body:** merge the history items into `pr-body.md`, following the repo's PR-description skill
  (`update-pr-description` or its context variant). Create the file if the bundle has none.
- **Doc gaps:** write the entry following that library's README.

Finish with the files changed, the drafts written, and the next step: `/pre-commit-review`.

---

## Gotchas

**Deleting a hazard because it reads like explanation.** A comment that stops someone breaking an
apply or a runtime path stays, trimmed if it's long. In a repo that doesn't comment, it moves to the
README rather than disappearing.

**Adding comments to a repo that doesn't use them.** An uncommented repo usually keeps its context
in the README and wiki. A new comment there is the only commented code in sight, and it reads as
noise. Route the fact to the README instead.

**Pasting a comment onto a wiki page.** A fact moved up is rewritten for the new reader in the
register the destination needs.

**Moving a required README section.** The format rule decides structure. Only content inside
sections and optional sections can move.

**Deleting a story number and losing the statement.** Replace the reference with what it stood for.

**Editing outside the hunks.** Out-of-scope comments are reported, not changed.

**Treating "apply all" as permission to publish.** It covers repo files and drafts. Publishing a
wiki page needs its own OK, per page.

**Keeping a fact in two places to be safe.** One home, and links from the others.

## Related

- `~/.cursor/principles/each-fact-has-one-home.md`: the model this skill applies
- **implement**: suggests this pass when a run finishes
- **pre-commit-review**: runs after this pass and owns the review bundle
- **cold-reader-sweep**: checks whether docs are true, without a change in flight
- **write**: drafting new prose in the right register

---

**Last Updated:** 2026-11-03
