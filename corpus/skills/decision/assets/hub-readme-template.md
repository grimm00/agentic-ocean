# Decisions Hub — `{Topic readable title}`

**Purpose:** Index every Architecture Decision Record for `{topic-kebab}`, linking outward
to research summaries, requirements extracts, and the decision interview artifact.

Replace `{topic-kebab}` consistently with sanitized naming (hyphen-separated lowercase).

---

## Linked inputs

| Artifact | Typical location |
|-----------|------------------|
| Research summary | `research/research-summary.md` *(adjust depth if mirrored elsewhere)* |
| Requirements | `${topic-root}/requirements.md` OR `research/requirements.md` |
| Decision interview | `./decision-interview.md` |

---

## ADR index

Maintain a Markdown table naming each planned/proposed/completed ADR file.

| File | Decision (one sentence) | Status |
|------|--------------------------|--------|
| `adr-001-example-topic.md` | … | 🔴 Proposed |

Use your repository’s emoji legend if documented; fallback: 🔴 Proposed • 🟡 Under review • ✅ Accepted • ⚫ Superseded.

---

## Supporting summary checklist

Once multiple ADRs exist, keep **`decisions-summary.md`** synced so humans can skim without
opening every lengthy document.
