---
name: write-plan-expand
description: >-
  Expand one scaffolding task-group file with detailed Purpose, Steps/TDD, Files,
  and Acceptance criteria. Primary skill: **write-plan-expand**; legacy alias
  `/transition-plan … --expand` maps here. Read ../SKILL.md first. Does not
  recreate implementation-plan roots.
disable-model-invocation: true
---

# Write-Plan Expand

Before proceeding, **`read ../SKILL.md`** for path rules and frontmatter parity.

---

## When to use

- A planning tree exists with `🔴 Scaffolding` group headers.
- User specifies **group index (1-based)** or **matching group title**, or narrowly
  scopes `--all` for tiny plans only.
- After human review agrees skeleton structure is sane.

## When not to use

- **Setup never ran** — impossible to locate `groups[]` pointers.
- Destructive regen requested without **`--force` / repo policy**.
- Operational coding only — unrelated to deepening markdown planning tasks.

---

## Preconditions (stop if unmet)

1. `implementation-plan.md` readable with YAML `groups`, `tasks_files`,
   coherent `task_count`.
2. Target group file resolved from frontmatter (`groups[].file`).
3. That file exists and banner shows scaffolding (`🔴`), unless caller explicitly re-expands.

---

## Expand workflow

**Goal:** One group file earns full operational detail — still markdown only.

**Trigger cues:** **write-plan-expand** with `--group N`; legacy `/transition-plan [feature] --expand --group N`; or natural-language equivalents.

1. **Resolve target** by numeric index mapping into `groups[]` OR fuzzy title match
   confirmed with operator.
2. **Open file** (`tasks/NN-….md`).
3. **Status gate:** scaffolding expected. Already `✅ Expanded` ⇒ skip unless user forces.
4. **Classify cohort** — sets how each task subsection is authored:
   | Type | Order inside each task row |
   |------|----------------------------|
   | Code + automated tests | RED → GREEN → REFACTOR phrasing inside Steps |
   | Scripts / tooling | Bats (Bash Automated Testing System) tests → script → integration |
   | Docs / coordination | outline → link → verify reads |
5. **Rewrite each `- [ ] Task …` block** adding **Purpose**, **Steps or TDD Flow**,
   **Files**, **Acceptance** per this skill’s Expand quality bar (aligns with **write-plan**/transition-plan-era guidance).
6. **Header flip:** replace `🔴 Scaffolding` with **`✅ Expanded`; remove scaffolding callout**.
7. **Commit:** scoped message documenting which group absorbed detail.

---

## Classify-and-rewrite rules

1. Maintain **checkbox ↔ global task numbering** parity with sibling rows in implementation-plan.md.
2. Do **not** delete sibling group files nor shrink `tasks_files`.
3. If group mixes types, tag each bullet cluster — readers may split later downstream.
4. Prefer linking long reference URLs instead of pasting verbatim upstream PDFs/logs.

---

## Behavioral contract

- **Observable:** After expand, reviewer can trace each implementation-plan checkbox bullet
  to explicit acceptance language in-group.
- **Bounded:** Exactly one group's primary prose mutates unless `--all` miniature plan flagged.
- **Outcome-framed:** Deliver updated group markdown plus suggested commit skeleton.
- **Delta-only:** Minimize duplication of YAML spec — cite frontmatter truths instead.
- **Failure-aware:** Structural mismatch (`task_count`), missing scaffolding, contradictory IDs
   → STOP with diff summary suggestion.

---

## Gotchas

1. Expand ≠ Setup — never wipe `implementation-plan.md` accidentally during polish passes.
2. Large programs (many groups): avoid `--all` — expansion context balloon risk.
3. Emoji / status cues must mirror house style from template assets (`status-and-next-steps`).
4. Staging drift: verifying `tasks_files[]` unchanged catches silent renames mid-expand.
5. Cross-stage repos: expanding wrong `planning-stageN` folder orphaned from active work.

---

## Related

- **write-plan-setup** — prerequisite skeleton emission.
- **plan-review** — consistency audit post-expansion bursts.
- Output focus: **`../references/structure.yaml`** (`expand_output`).
