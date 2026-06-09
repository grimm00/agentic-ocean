---
name: reflect
description: >-
  Analyze project state after substantial work: synthesize recent commits, PRs,
  status, and optional phase learnings into a structured reflection with
  actionable suggestions. Use when the user invokes /reflect or wants a calm
  review of patterns and next steps. Do NOT replace /int-opp — reflect produces
  a reflection artifact; int-opp captures template-facing opportunities.
disable-model-invocation: true
---

# Reflect

Produce a **structured reflection** on project state: what is working, what
could improve, and **evidence-backed** suggestions. This is a **hybrid skill** —
deterministic gather/write steps plus judgment about emphasis — bounded by the
behavioral contract.

```
detect paths → gather → patterns → opportunities & risks → suggestions → write report → hub link → commit
```

## Templates

| Template | When to use |
|----------|-------------|
| `templates/reflection-report.md` | Always — copy to target path, then fill |

## Path detection

| Context | Status doc | Reflection output directory | Filename pattern |
|---------|------------|----------------------------|------------------|
| **Dev-infra** | Feature planning under `admin/services/.../features/[feature]/` **or** service meta; also read root `AGENTS.md` context | **`admin/planning/notes/reflections/`** (centralized) | `reflection-[topic]-YYYY-MM-DD.md` |
| **Template — feature** | `docs/maintainers/planning/features/[feature]/status-and-next-steps.md` | `docs/maintainers/planning/features/[feature]/reflections/` | `reflection-[scope]-YYYY-MM-DD.md` |
| **Template — project-wide** | `docs/maintainers/planning/status-and-next-steps.md` (if present) | `docs/maintainers/planning/notes/reflections/` or `docs/maintainers/planning/reflections/` | `reflection-[scope]-YYYY-MM-DD.md` |

**Feature name:** `--feature` if provided; else inferred from single feature folder or status doc path.

**Learnings inputs (optional):**

- `--include-learnings` — latest phase learnings for the detected feature (search `docs/.../learnings/`, `admin/planning/opportunities/internal/.../learnings/` per command conventions).
- `--include-learnings all` — read **all** phase learnings available for the feature; build **Cross-Phase** section only with citations per cluster.

## When to use

- After a major phase or release cadence
- Before a big decision or replan
- When the team wants a single readable snapshot (not a backlog dump)

## Options (surface)

| Flag / scope | Behavior |
|--------------|----------|
| `/reflect` | Full pass on detected default scope |
| `/reflect --recent [days]` | Weight commits/PRs in last *days* (default 7) |
| `/reflect --phase` | Anchor “Current State” on phase fields in status doc |
| `/reflect --workflow` | Emphasize process friction over code observations |
| `/reflect --code-quality` | Emphasize implementation patterns |
| `/reflect --documentation` | Emphasize docs/hubs |
| `/reflect --technical-debt` | Emphasize risk/defect themes |
| `/reflect --include-fixes` | Pull deferred fix hubs into “Potential Issues” |
| `--include-learnings` / `--include-learnings all` | As in Path detection |
| `/reflect --actionable-only` | Emit Current State plus suggestion-shaped sections only |

If flags conflict, prefer explicit `--feature` and the narrowest scope flag the user repeated last.

## Workflow

### 1. Gather context

1. **Git:** Summarize `git log` for the period (`--recent` window or sensible default).
2. **PRs:** `gh pr list --state merged --limit 10` when available; if unavailable, note **failure** in the report once.
3. **Status:** Read the detected `status-and-next-steps.md`; capture current group/phase line verbatim where useful.
4. **Learnings:** If requested, read learnings files completely before synthesis — do not invent summaries without file quotes or paraphrases tied to paths.

**Checklist:** Period stated; status doc path cited; learnings paths listed when used.

### 2. Pattern scan (bounded)

From gather results only:

- **Development:** testing hooks, review cadence, commit shape (observable).
- **Workflow:** PR batching, docs updates, automation commands referenced in commits.
- **Documentation:** hub/README drift *only if* filenames or missing links are observable.

Avoid personality judgments; translate to **patterns** with **evidence** (commit subject, file path, metric).

### 3. Opportunities and risks

For each item:

- **Opportunity:** named gap + **effort** guess (Quick / Moderate / Significant) + **first step**.
- **Risk:** what could go wrong + **mitigation** + priority emoji.

If evidence is weak, move item to **Open uncertainties** appendix instead of main lists.

### 4. Build suggestions

Each suggestion **must** follow the block format in `templates/reflection-report.md`:

- Priority, effort, impact
- Context with **citation** (path, PR #, or date range)
- Numbered next steps

**`--actionable-only`:** omit purely descriptive sections except **Current State**; keep only suggestion-shaped blocks.

### 5. Write reflection file

1. Copy `templates/reflection-report.md` to the resolved output path.
2. Replace placeholders; **omit** sections that add no value (do not pad with N/A).
3. For dev-infra, **always** use `admin/planning/notes/reflections/` even when reflecting a service feature — this matches the command’s centralization rule.

### 6. Hub link

If `reflections/README.md` exists beside the output, add this file to its index with one-line summary + date.

### 7. Commit (docs-style)

Reflections are documentation:

1. Prefer branch `docs/reflect-[feature-or-scope]-YYYY-MM-DD` when not already on a docs branch (follow project Git Flow for docs merges).
2. Commit message example:

```text
docs(reflection): create [scope] reflection

- Analyzed [period]
- Captured opportunities and risks with evidence
```

Push/merge per repo policy (`COMMIT-WORKFLOW.md` / maintainer guide). If tooling unavailable, stop after writing files and tell the user what is uncommitted.

## Behavioral Contract

**Evidence over vibe.** Claims tie to artifacts (paths, PR numbers, commit ranges). If data is missing, state the gap — **observable**, **failure-aware**.

**Actionable, not lyrical.** Suggestions include a **next step** a reader could schedule — **outcome-framed**, **bounded** by the template sections.

**Calibrated uncertainty.** Conflicting signals or thin data → short “Open uncertainties” instead of false precision — **failure-aware**, **delta-only** (only new synthesis beyond raw logs).

**Scope discipline.** Reflect is not `/int-opp`: opportunity backlog for templates belongs in int-opp; reflect may **link** to existing opportunity docs rather than duplicating them — **delta-only**.

**No fabricated metrics.** Percentages, coverage numbers, or phase counts must come from files or tools; otherwise omit — **observable**.

## Gotchas

**Wrong output path on dev-infra.** Feature planning still writes reflections under `admin/planning/notes/reflections/` — do not mirror template `docs/.../features/.../reflections/` on this repo layout.

**Suggestion dumps.** Long unstructured bullet lists belong in drafts; ship the template sections or trim.

**Skipping learnings files.** `--include-learnings all` requires actually reading each file — surface counts without filenames is insufficient.

**Over-asserting from quiet repos.** Few commits in window → say so; do not dramatize.

**Mixing personal critique with facts.** Keep “Potential Issues” tied to observable drift or explicit user-provided concerns.

**Forgetting README hub updates.** If a reflections hub exists and you skip it, the artifact is harder to discover.

## Related

- `/int-opp` — capture template opportunities after phase work
- `/research`, `/decision`, `/transition-plan` — downstream of reflection insights when strategic
