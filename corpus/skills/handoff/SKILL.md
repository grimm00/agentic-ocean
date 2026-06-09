---
name: handoff
description: >-
  Produce a transient handoff markdown artifact capturing git + conversation
  state for cross-session continuity, or `--resume` the latest prior handoff.
  Independent of review/commit except when session included those flows.
disable-model-invocation: true
---

# Handoff

Maintain **conversation + repository continuity** via an intentionally **ignored**
Markdown snapshot.

```
detect layout ──► gather repo facts ──► fill template ──► write file ──► present
                                              ▲
                                    assets/handoff-template.md
```

Declarative filesystem layout expectations — **`references/structure.yaml`** (roots,
patterns, `--resume` search semantics).

---

## When to use

- End-of-session summaries with concrete next-session steps
- Teammate handoffs preserving branch + unfinished checklist context
- After deep review/commit cycles needing durable external memory

## When not to use

- Long-form retrospective insight capture → **`reflect`** (+ narrative tooling)
- Project-wide health summaries → **`status`**

---

## Configuration

Detection order (**first semantic match wins**):

| Layout | Artifact path |
|--------|---------------|
| Dev-Infra (`admin/tmp` or `admin/`) | `admin/tmp/handoffs/handoff-{topic}.md` |
| Template (`tmp/`) | `tmp/handoffs/handoff-{topic}.md` |
| Lightweight (fallback) | `tests/tmp/handoff-{topic}.md` |

Transient files **must remain gitignored**.

---

## Behavioral contract

| Obligation | Rationale |
|------------|-----------|
| **Never commit artifacts** silently | Operational noise + privacy |
| **`--resume` shows latest relevant doc** without mutation | Faster cold starts |
| **Topic default** derivation from git branch basename when omitted | Mirrors legacy ergonomics |

---

## Usage

| Invocation | Behavior |
|------------|----------|
| `handoff topic` | Write `handoff-topic.md` in resolved directory |
| (no topic) | Derive `{topic}` from current branch slug |
| `--resume` | Search + surface latest `handoff-*.md` |

---

## Workflow — create

### 1. Gather context

```bash
git branch --show-current
git log main..HEAD --oneline 2>/dev/null || git log develop..HEAD --oneline
git diff main..HEAD --stat 2>/dev/null || git diff develop..HEAD --stat
git status --short
gh pr list --state open --head "$(git branch --show-current)" 2>/dev/null || true
```

Record salient conversational milestones not visible in git (decisions, blockers).

### 2. Compose document

Copy **`assets/handoff-template.md`** to resolved output path substituting placeholders.

### 3. Persist + present

Write file ensuring parent directory exists (`mkdir -p`), echo absolute or repo-relative path, display body for verification.

---

## Workflow — `--resume`

1. For each **`references/structure.yaml`** handoff root, expand `**/handoff-*.md` consistent with subdirectory convention (dev-infra/template use trailing `handoffs/`).
2. If **zero** hits → STOP with guidance (create new handoff instead).
3. If **many** hits → chronological sort (mtime) SHOW list numbered → wait for explicit pick.
4. If **exactly one recent** plausible default → DISPLAY summary sections + condensed next-actions.

Never delete files in resume path unless user instructs separately.

---

## Gotchas

- **Missing ignores:** proactively warn committers if artifact path unexpectedly tracked.
- **Large workspaces:** diff stat only — avoid dumping patch bodies into handoff unintentionally.
- **Ambiguous slug:** sanitise `{topic}` to safe filename characters `[a-z0-9_-]+`.

---

## FR-8 (self-containment)

Skill + **`assets/handoff-template.md`** + declarative **`references/`** — archived commands not required.
