---
name: commit
description: >-
  Finalize staged work after pre-commit-review: confirm draft commit message,
  run git commit, optionally remove transient review artifacts. Procedural twin
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

1. **Dev-Infra:** `admin/tmp/reviews/`
2. **Template:** `tmp/reviews/`
3. **Lightweight:** `tests/tmp/reviews/`

**Folder basename pattern:** See upstream `artifact_folder.dirname_pattern` in **`pre-commit-review/references/structure.yaml`**.

**Required coupling files inside folder:** `summary.md` (**draft message** primary); `diff.patch` optional corroboration.

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
| `review-topic-YYYY-MM-DD` tail | Narrow search to matching folder |
| `--no-delete` | Keep transient review artifacts post-commit |
| `--message "…"` | Skip draft extraction; still show stat + confirm |

---

## Workflow

### 1. Resolve review context *(three-mode precedence)*

1. **Same-session:** If assistant already holds `{review_folder_path, draft_message}` from immediate prior **pre-commit-review**, reuse without disk read when still valid.
2. **Explicit token:** Match user-supplied substring against basename under each artifact root.
3. **Auto-latest:** Shell-equivalent aggregation `ls -dt <root>/review-*/ … | head -1` respecting detection order above.

If multiple ambiguous candidates remain without session hints → prompt user — **do not guess**.

Stop + warn when **no candidate** directories exist → suggest rerun **pre-commit-review**.

### 2. Read summary (`summary.md`)

Unless `--message`, parse **Draft Commit Message** section contents.

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

Use heredoc or equivalent safe quoting for multi-line conventional commits:

```bash
git commit -m "$(cat <<'EOF'
[user confirmed body]
EOF
)"
```

### 6. Cleanup

Unless `--no-delete`, remove resolved review directory (`rm -rf path`).

Echo kept path when retaining.

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
```

**Same-session optimum:** eliminates rediscovery latency.

**Cross-session:** deterministic folder search + **`summary.md`**.

---

## Gotchas

- **Contract drift kills automation:** dirname / required files renamed in **pre-commit-review** YAML require simultaneous commit SKILL + YAML tweak.
- **Stale staging** is frequent when switching branches mid-review — escalate instead of silently committing wrong files.
- **Multiple reviews:** auto-latest may surprise — prefer explicit basename in busy repos.
- **`.gitignore` gaps:** transient folders must remain ignored upstream; committing skill does not fix ignore tables.

---

## FR-8 (self-containment)

Executable with **Skills + git** alone; behavior references upstream YAML pointer — not archived command stubs.
