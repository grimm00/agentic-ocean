---
name: pre-commit-review
description: >-
  Stage changes, capture a diff for review, and draft a commit message without
  committing. Hybrid skill: procedural staging plus behavioral diff-review
  guidance. Preserves the review-then-commit pause — STOP after presenting;
  never auto-commit. Use when the user invokes pre-commit-review, review, or
  needs the agentic pre-commit review workflow.
disable-model-invocation: true
---

# Pre-Commit Review

Stage changes, capture review artifacts, present a review bundle, **then STOP**.
This workflow exists because agentic edits are easy to commit before a human
actually reads them.

```
detect layout → pick files → stage → write summary + diff.patch → present → STOP (no commit)
```

**Authoritative artifact contract:** read `references/structure.yaml` — paths,
required files, and commit-skill coupling notes live there.

---

## When to use

- After substantive agentic edits and before any commit
- When the user asks for a staged diff, review folder, or `/review` equivalent
- When pairing with **commit** — this skill is always the first half

## When not to use

- User already committed and only wants a retrospective — use **narrative** or
  changelog workflows instead
- Pure ideation with no git changes — nothing to stage

---

## Configuration

**Review artifacts path (auto-detect, first match wins):**

1. **Dev-Infra:** `admin/tmp/reviews/` (if `admin/tmp` **or** `admin/` exists)
2. **Template project:** `tmp/reviews/` (if `tmp/` exists at repo root)
3. **Lightweight:** `tests/tmp/reviews/` (otherwise)

**Review folder shape:**

```
[artifact_base]/review-[description]-YYYY-MM-DD/
  summary.md
  diff.patch
```

**`.gitignore`:** Before writing, confirm the resolved base path is ignored. If
not, **warn** the user and do not silently write to a tracked location.

---

## Usage

| Invocation | Behavior |
|------------|----------|
| Review with description | Name the folder `review-{description}-YYYY-MM-DD` |
| Review without description | Derive a short description from branch name or changed files |
| `--scope PATH` | Restrict candidate files to that path |
| `--all` | Stage all changed files without confirmation |

---

## Workflow

### 1. Identify changed files

```bash
git status --short
```

Show staged, unstaged, and untracked files. **Exclude** items the user did not
intend to ship, scratch/temp files, and anything that may contain secrets.

| Mode | Selection rule |
|------|----------------|
| `--scope` | Only paths under the scope |
| `--all` | All changed files, no confirmation prompt |
| Default | List files; confirm with the user before staging |

**Bounded stop:** If nothing remains after filtering, **STOP** and explain why.

### 2. Stage files

```bash
git add [files]
```

Do not stage files the user rejected. If files were already staged, confirm they
should remain staged.

### 3. Capture review artifacts

1. Resolve `artifact_base` per **Configuration** + `references/structure.yaml`.
2. Create `review-[description]-YYYY-MM-DD/` under that base.
3. Copy `assets/summary-template.md` to `summary.md` **or** create `summary.md`
   from that template’s sections (do not paste the whole template into chat —
   fill it in the file).
4. Populate **Files Changed**, **Summary**, **Draft Commit Message** (Conventional
   Commits), and **Stats** (`git diff --staged --stat`).
5. Write `diff.patch`:

```bash
git diff --staged > [review-folder]/diff.patch
```

### 4. Present for review

Show the user:

1. Executive **summary** — what changed and why
2. **Draft commit message**
3. Line / file **stats** (`git diff --staged --stat`)
4. **Review folder path**
5. Reminder to open `diff.patch` for full detail

### 5. STOP and wait

**CRITICAL: Do NOT `git commit`.** After presentation, **stop** and wait for explicit
human approval. The user continues via **commit**, manual `git commit`, or edit /
unstage cycles.

---

## Behavioral Contract

**Hybrid skill.** Staging paths and artifact names are deterministic; summarizing,
risk spotting, and file-intent judgment require care.

**What “good review” looks like:**

- Explain the intent of the diff, not every line listing
- Call out risky areas (security, unintended edits, missing tests)
- Keep the draft message in conventional form: `type(scope): summary`

**What to scrutinize:**

- Surprise file touches and broad refactors slipped in by tooling
- Hardcoded secrets, unsafe defaults, or logging of sensitive data
- Tests/docs drift when behavior changed

---

## Integration

```
[changes made]
review  → pause (human reads summary + diff)
commit  → finalize (after approval)
```

**The pause is the entire point.** Do not compress review and commit into one step.

---

## Five-property rubric (self-check)

| Property | Obligation in this skill |
|----------|-------------------------|
| **Observable** | Name artifact paths/files; cite `references/structure.yaml`. |
| **Bounded** | Honor `--scope` / `--all` / confirmation; STOP on empty selection. |
| **Outcome-framed** | Deliver folder with `summary.md` + `diff.patch` + presentation bundle. |
| **Delta-only** | Long template lives in `assets/summary-template.md`, not repeated in chat. |
| **Failure-aware** | `.gitignore` warnings; secret/scratch exclusions; never commit here. |

---

## Gotchas

**Auto-committing after review.** Never. If the user says “ship it,” route them to
**commit** or a manual commit — do not improvise `git commit` from this skill.

**Skipping confirmation on large diffs.** Unless `--all` is explicit, show the file
list first.

**Pasting the whole diff into chat.** Use `diff.patch` on disk; keep chat to summary
+ stats unless the user asks for an excerpt.

**Wrong layout detection.** Re-read `references/structure.yaml` when both `admin/` and
`tmp/` exist — dev-infra wins when `admin/tmp` or `admin/` is present.

**Template sprawl in SKILL.** If the summary scaffold changes, edit
`assets/summary-template.md` only.

---

## Related

- **commit** — second half of review-then-commit; reads review context
- `references/structure.yaml` — machine-readable outputs and detection
- `assets/summary-template.md` — summary skeleton

---

**Last Updated:** 2026-05-03
