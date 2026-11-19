---
name: commit
description: >-
  Finalize staged work after pre-commit-review: confirm the draft message from
  commit-msg.txt, run git commit -F, and delete commit-msg.txt and diff.patch
  from the review bundle. Never deletes the bundle, its summaries or the PR
  body. Procedural twin
  to pre-commit-review — never substitutes review judgement. Honors same-session,
  explicit folder, and auto-detect resolution paths.
disable-model-invocation: true
---

# Commit

Complete the **review-then-commit** pipeline **after** **pre-commit-review**
produced a transient review bundle and (typically) STOPped for human review.

```
resolve review folder → verify staged snapshot → confirm message → git commit → cleanup (optional)
```

**Upstream artifact contract:** `references/structure.yaml` declares the stable filenames
and path roots by **referencing `../pre-commit-review/references/structure.yaml`** — do **not**
hard-code divergent basename patterns without updating **both** skills.

```
pre-commit-review  →  STOP + human pause  →  commit (this skill)
```

---

## When to use

- Immediately after approving a **same-session or cross-session** staged review bundle
- User says `/commit`, names this skill, or wants finalize without re-running staging
- Paired workflows: ALWAYS follows **pre-commit-review** — never replaces it

## When not to use

- Changes unstaged / review missing → run **`pre-commit-review`** first
- Retrospective commentary only → **`narrative`** / journaling flows instead

---

## Configuration

**Review artifact roots (mirror pre-commit-review detection order):**

1. **Scratch space:** `<thinking_root>/reviews/` (`thinking_root` from
   `~/.config/cursor-skills/config.yaml`, default `.scratch`), when it exists
2. **Legacy fallbacks**, for repos with no scratch space: `admin/tmp/reviews/`, then
   `tmp/reviews/`, then `tests/tmp/reviews/`

**Folder basename pattern:** See upstream `artifact_folder.dirname_pattern` in **`pre-commit-review/references/structure.yaml`**.

**Coupling files inside the bundle:** `commit-msg.txt` (**draft message**, preferred); the newest
file in `summaries/` (fallback for the message, and the files-changed list); `diff.patch`
optional corroboration.

**Out of scope:** the bundle's branch artifacts — `summaries/`, `pr-body.md`, `plan-comments/`.
They span every commit in the bundle and feed **pr**. This skill deletes only `commit-msg.txt`
and `diff.patch`.

---

## Behavioral contract

| Obligation | Rationale |
|------------|-----------|
| **Confirm message + stat** before `git commit` | Preserves human gate from legacy command |
| **Never manufacture staging** silently | Misaligned staging defeats review intent |
| **Honor `--message` override** | Operator may correct draft faster than editing summary |

---

## Usage

| Invocation | Behavior |
|------------|----------|
| (none) | Auto-resolve folder via precedence in `references/structure.yaml` (`review_folder_resolution_modes`) |
| `review-<name>` name or tail | Narrow search to matching bundle |
| `--no-delete` | Keep `commit-msg.txt` and `diff.patch` (and the bundle) post-commit |
| `--message "…"` | Skip draft extraction; still show stat + confirm |

---

## Workflow

### 1. Resolve review context *(three-mode precedence)*

1. **Same-session:** If assistant already holds `{review_folder_path, draft_message}` from immediate prior **pre-commit-review**, reuse without disk read when still valid.
2. **Explicit token:** Match user-supplied substring against basename under each artifact root.
3. **Current branch:** on a feature branch, `<root>/review-<branch-slug>/`, where the slug is `git branch --show-current` with `/` replaced by `-`. On the default branch, the `review-<description>/` bundle that holds a `commit-msg.txt`; if more than one does, ask.
4. **Auto-latest:** Shell-equivalent aggregation `ls -dt <root>/review-*/ … | head -1` respecting detection order above.

A bundle with no `commit-msg.txt` has nothing pending to commit; skip it.

If multiple ambiguous candidates remain without session hints → prompt user — **do not guess**.

Stop + warn when **no candidate** directories exist → suggest rerun **pre-commit-review**.

### 2. Read the draft message

Unless `--message`, use `commit-msg.txt`. If it's missing, parse the **Draft Commit Message**
section of the newest file in `summaries/` (or of `summary.md` in a legacy per-commit
`review-<desc>-<date>/` folder).

Skip disk read entirely when trusted session carries identical payload.

### 3. Verify staging

```bash
git diff --staged --stat
```

Cases:

| Condition | Action |
|-----------|--------|
| Empty staging | Warn stale review; propose re-stage from summary bullets or rerun upstream skill |
| Mismatch suspicion | Optionally diff-hint vs `diff.patch` |

Never commit empty index.

### 4. Confirm

Present:

1. Final message body
2. Staged `--stat`

Await explicit confirmation or inline edits **before** `git commit`.

### 5. Commit

Commit from a file, so the body stays separate from the subject:

```bash
git commit -F [review-folder]/commit-msg.txt
```

If the user edited the message or passed `--message`, write the confirmed text to
`commit-msg.txt` first, then commit with `-F`. Don't pass a multi-line message through `-m`.

### 6. Cleanup

Unless `--no-delete`:

| Bundle state | Delete |
|---|---|
| Any `review-<name>/` bundle | `commit-msg.txt` and `diff.patch` only. Keep the folder, `summaries/`, `pr-body.md`, `plan-comments/` |
| Legacy `review-<desc>-<date>/` folder (no `summaries/`) | The whole folder |

Echo what was kept. On a feature branch, suggest `/pr` once the branch is ready. Removing the
bundle itself is a manual step after the PR merges, or after the line of work ends on the
default branch.

### 7. Present result

```bash
git log -1 --oneline
git status --short
```

---

## Integration

Compact mental model:

```text
pre-commit-review ──► STOP + human ──► commit ──► working tree progressing
        │                                 (repeat per commit)
        └── review-<name>/summaries/ + pr-body.md grow ──────────────► pr
```

**Same-session optimum:** eliminates rediscovery latency.

**Cross-session:** deterministic bundle search + the newest file in **`summaries/`**.

---

## Gotchas

- **Contract drift kills automation:** dirname / required files renamed in **pre-commit-review** YAML require simultaneous commit SKILL + YAML tweak.
- **Stale staging** is frequent when switching branches mid-review — escalate instead of silently committing wrong files.
- **Multiple reviews:** auto-latest may surprise — prefer explicit basename in busy repos.
- **`.gitignore` gaps:** transient folders must remain ignored upstream; committing skill does not fix ignore tables.
- **Deleting bundle artifacts:** `summaries/`, `pr-body.md`, and `plan-comments/` outlive every commit. Cleanup never deletes the bundle; the summaries are the only record of earlier commits that survives context loss.
- **Collapsed commit bodies:** a multi-line `-m` can flatten into one subject line. Always `-F`.

---

## FR-8 (self-containment)

Executable with **Skills + git** alone; behavior references upstream YAML pointer — not archived command stubs.
