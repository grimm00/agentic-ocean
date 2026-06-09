---
name: spike
description: >-
  Time-boxed technical spike: define success criteria, build the minimum to
  answer "can it work?", document evidence in spike-learnings.md, and commit.
  Use when the user invokes /spike or wants hands-on validation before larger
  implementation. Do NOT use for comparing well-documented options or desk
  research — use research instead.
disable-model-invocation: true
---

# Spike

Run a **time-boxed experiment** to validate technical assumptions before
committing to implementation. A spike **builds something minimal** to prove an
approach works; research investigates options and practice.

```
detect paths → questions & criteria → time-boxed build → document learnings → commit
```

## Templates

| Template | When to use |
|----------|-------------|
| `templates/spike-learnings.md` | Always — copy to the target `spike-learnings.md` path, then fill in place |

## Path detection

| Structure | Spike learnings | Spike code (throwaway) |
|-----------|-----------------|-------------------------|
| **Dev-infra** | `admin/services/[service]/features/[topic]/spikes/spike-learnings.md` | `.../spikes/` (same feature topic) |
| **Template** | `docs/maintainers/planning/explorations/[topic]/spike-learnings.md` | `.../explorations/[topic]/spike/` |
| **Lightweight** | `tests/tmp/explorations/[topic]/spike-learnings.md` | `tests/tmp/explorations/[topic]/spike/` |

**Detection order:** If `admin/services/` exists → dev-infra. Else if `docs/maintainers/planning/explorations/` exists → template. Else → lightweight (gitignored temp).

**Topic:** From `--topic`, `--from-explore [name]`, or explicit user name; normalize to kebab-case, no spaces.

## When to spike vs research

| Situation | Spike | Research |
|-----------|-------|----------|
| “Can it even work?” / high technical uncertainty | Yes | |
| Must exercise real environment (API, cluster, device) | Yes | |
| Compare documented options or “best practice” | | Yes |
| Low-risk, well-understood path | | Yes |

If exploration exists, prefer questions flagged **high risk** and viability-shaped (“will it work?”).

## Options

| Invocation | Behavior |
|------------|----------|
| `/spike [topic]` | Full flow from questions through learnings |
| `/spike [topic] --from-explore [explore-topic]` | Load exploration + research-topics for scope |
| `/spike [topic] --document-learnings` | Skip build; write/update learnings from completed spike |
| `/spike [topic] --time-box [hours]` | Use explicit hour limit (default 2–4 if unset) |
| `/spike --dry-run` | Show paths and plan; do not write files |
| `/spike [topic] --force` | Allow overwriting existing `spike-learnings.md` when policy says stop |

## Workflow

### 1. Identify questions to validate

From exploration (if `--from-explore`) or user prompt, list only questions where:

- The answer must be demonstrated, not read from docs alone.
- Wrong assumptions would be expensive to unwind.

**Checklist (before criteria):** Each question is falsifiable; edge cases named; links to exploration paths recorded when used.

### 2. Define success criteria (before building)

Display to the user, then ensure the same criteria appear under `## Success Criteria` at the top of the working learnings doc (create from template if new file):

- Each criterion is **testable** (pass/fail or observable behavior).
- **Time-box** duration is stated (hours).

If `--document-learnings`, synthesize criteria from what was already run only if the user confirms; otherwise focus on filling evidence sections.

### 3. Time-boxed minimal build

- Start timer for agreed hours (`--time-box` or default 2–4).
- Build **only** what is needed to answer the questions; **no polish**.
- **When time expires:** stop building and move to documentation — partial results are valid.

Spike code lives under the **Spike code** path for the detected structure. Do **not** treat prototype polish as success.

### 4. Document learnings

Copy `templates/spike-learnings.md` to the resolved `spike-learnings.md` path (unless appending to an existing file per user).

Fill:

- **Questions Answered** — each line cites **evidence** (command output, log, observed behavior).
- **Key Findings** and **Edge Cases** — no uncited claims.
- **Go / No-Go** — explicit recommendation + rationale.
- **Refined Questions** — feed forward to research/exploration.

If `--dry-run`, stop after printing planned paths and criteria.

### 5. Commit

Commit **spike-learnings.md** (and spike code **only** if the user wants it tracked — default is learnings only):

```text
docs(spike): document [topic] spike learnings

Result: [Validated | Partially Validated | Failed | Pivoted]
Time-box: [X] hours
```

## Behavioral Contract

**Criteria before code.** Success criteria appear in the learnings file before substantive implementation work begins. If criteria change mid-spike, record the change and why — **observable**, **delta-only**.

**Hard stop at time-box.** When the timer boundary is hit, **stop** building and document what was proven, disproven, or unknown — **bounded**, **failure-aware** (partial is allowed).

**Throwaway scope.** Prefer deleting or ignoring polish; the artifact of record is `spike-learnings.md`, not prettified prototype — **outcome-framed**.

**Evidence, not opinions.** Every finding references an observation the reader could reproduce or inspect (error text, metric, screenshot reference, command) — **observable**, **outcome-framed**.

**Route correctly.** If the user’s need is comparators or literature-style answers, **stop** and point to research — **failure-aware** (wrong workflow).

## Gotchas

**Polishing spike code.** Any time spent on style or extensibility beyond the question is scope creep; capture the urge as a “next step,” not spike work.

**Skipping success criteria.** Starting implementation without written criteria makes Go/No-Go useless — always write criteria first.

**Confusing spike with POC or prototype.** Spikes are hours and throwaway; longer-lived demos belong to different workflows.

**Merging spike and research.** If questions are “what’s best?” or options are already documented, desk research fits better than a spike.

**Forgetting to commit learnings.** Untracked learnings drift — commit the markdown artifact even when spike code is discarded.

**Dry-run still needs clarity.** `--dry-run` should output topic, paths, and planned criteria so reviewers can sanity-check before writes.
