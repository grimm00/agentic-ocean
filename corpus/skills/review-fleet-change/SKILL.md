---
name: review-fleet-change
description: >-
  Review a change that deploys to many machines (a role, script, systemd unit,
  template or job) by answering six questions the diff cannot: is the stated
  problem the real one, what changes where, what does it decide on someone's
  behalf, what happens when it is wrong, how would anyone know it worked, and
  do the words match the code. Gathers a receipt for each, weighs findings as
  blocking, question or suggestion, and returns draft comments without posting.
  Use when the user says /review-fleet-change, wants to review a teammate's PR
  beyond the diff, or passes --self to check their own change before opening a
  PR. For diff-only passes use a diff review skill such as /review-bugbot.
disable-model-invocation: true
---

# Review Fleet Change

A reviewer of fleet automation adds the most outside the diff. Answer six questions, get a receipt
for each, weigh the findings, and hand back draft comments. **Read-only: never post a comment,
approve, request changes or edit the PR.** The user posts.

```
confirm target ──► read PR + diff ──► six questions (a receipt each) ──► weigh ──► draft ──► STOP
        └── optional first: a diff review skill for the diff-local pass
```

**Status:** v0, written from one review (a teammate's unattended-upgrades PR). Revise after the
next one: the six may merge or split on a different kind of change.

A context variant (`review-fleet-change-<context>`, installed from a private corpus) names the log
search, inventory, ticket system and notes library for a particular workplace. Use it there.

---

## When to use

- Reviewing a teammate's PR to something that runs on many hosts, beyond what the diff shows
- `--self`: before opening your own PR, as the author-side check (see below)

Not for diff-only passes (`/review-bugbot`, `/review-security`, or a team's own diff reviewer),
for writing a commit (`/pre-commit-review`), or for judging a whole ticket.

## Preflight

1. **Confirm the target.** "This" means the checked-out branch, not the file open in the editor.
   Run `git branch --show-current` and `git log --oneline origin/<base>..HEAD` first. Ask only if
   it is still ambiguous.
2. **Read the PR.** `gh pr view <n> --repo <org>/<repo> --json
   title,body,author,state,reviews,comments` (set `GH_HOST` for a GitHub Enterprise host). Read the
   whole body and every existing review.
3. **Read the diff** (`git diff origin/<base>...HEAD`) and the **whole files it touches**, plus the
   file that deploys each one (the role task that copies a script, the unit that runs it).
4. **Note what automated reviews already found** and do not repeat it. They are diff-local; your
   value is the six questions below.

## The six questions

For each, gather a receipt: a command and its output, a query, or `file:line`. Mark every claim
**verified**, **inferred** or **untested**. If a question does not apply, say why in one line.

| # | Question | Check | Source |
|---|---|---|---|
| 1 | **Is that the actual problem?** | Find the PR's cause claim and the evidence for it. Check any premise ("raises the limit", "fixes the hang") against what existed before. Search for a second ticket or note about the same symptom. | Platform defaults (`systemctl show`, man pages), the fleet's log search, the ticket system, the notes library |
| 2 | **What changes on a machine, and which machines?** | Trace the deployment path: which role, which host groups, build time or a pull-based run, first run, hosts already in a bad state. | The playbook that includes the role, the inventory, host and group vars, the role's `tasks/main.yml` |
| 3 | **What does it decide on someone's behalf?** | List every default taken, answer given, limit, timeout, package source, permission or schedule the change sets or relies on. Find the prior value for each. | The package's own template or script, and the internal package repo if the team repackages it |
| 4 | **What happens when it is wrong?** | Loud or silent, reversible or not, and who would find out. A hang is neither a failure nor a success, so a failure query will not show it. | The fleet's log search, the service's logs |
| 5 | **How would we know it worked?** | Is there a check that could have come out differently, run on the consumer, with an exit condition? Propose one if not. | `systemctl show`, a log-search count going to zero, a before/after on one host |
| 6 | **Do the words match the code?** | Quote each claim in the PR body, commit messages, code comments and README, and check it against the line. | The diff |

**Quantify before weighing.** If a finding depends on how often something happens (a new time
limit, a retry, a schedule), measure it from fleet data first. Frequency usually decides the
weight.

**Evidence honesty.** Say which host a result came from. If a command needs a host you cannot
reach (your shell may not be the user's machine and may have no systemd), give the user the
exact read-only command and use their pasted output. Absence of a failure in logs is not evidence
when the failure mode is a hang.

## Weigh

Apply the test: *if this were wrong, would the fix fail or hurt someone?*

| Weight | Meaning |
|---|---|
| **Blocking** | Merging as it stands would harm a host, or the premise is wrong |
| **Question** | The author's answer decides whether it is a problem |
| **Suggestion** | An improvement the author may take or leave |

Separate what the **fix needs** from what only **raises the PR's risk**. Depth of a comment should
follow impact if wrong, times how likely the author is to already know.

## Output

```
## Review: <title> (#<n>)

**Checked:** what you ran or read, with the host for each result
**Not checked:** what you did not run (always includes "I did not run the change" unless you did)

### Blocking / Questions / Suggestions
- **[Q<#>] <short title>** (`file:line`): the claim, the receipt, what to ask.

### Draft comments (not posted)
<one per finding, in question form with the receipt attached>
```

Frame each draft comment as a question with a receipt. State what you checked and what you did
not. "I confirmed X on the current unit, not on the change" is complete; "this is wrong" with no
receipt asks the author to take it on trust.

Cite every code reference by location: `path:line` or a line range, and quote the lines when
they carry the argument. The reader may not have the file open or the concept in working memory.
A file that exists only on a host gets its host path.

## `--self` (before opening your own PR)

Answer the same six about your own change before `/pre-commit-review`:

- Q1 goes in **Why**, Q5 in **Testing done**, Q2 and Q4 in **Next Steps / Considerations**.
- Q3 and Q6 you answer by reading your own diff as a stranger would.
- Anything you answer "I don't know" is work to do before opening the PR, not a risk to disclose
  afterwards.

## Gotchas

- Do not turn the six into a checklist ritual. Each must produce a check or an explained skip.
- Do not redo the diff-local review. Run a diff review skill first if you want that, then spend
  the time here.
- A premise phrased as a change of degree ("increase", "raise", "allow longer") may assume a
  prior value. Check it.
- One host's result does not generalise: label hosts, and propose one command that puts all the
  evidence on a single machine.
- Do not post or approve. End by offering `/capture-discussion` for what the review taught.

## Reference

- `references/example-upgrade-timeout.md` — a worked example: the six questions, a sizing query
  and a draft comment, adapted from the review this skill came from.
