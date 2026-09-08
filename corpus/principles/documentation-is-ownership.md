# Principle: Documentation is ownership

**Id:** `documentation-is-ownership`  
**Status:** Active  
**Last Updated:** 2026-09-03

**Consumers (hard-require):** write-plan family · plan-review · group-cycle agent ·
PR / post-PR / pr-validation / task workflows when asserting Done.

**Load:** `read ~/.cursor/principles/documentation-is-ownership.md` before
scaffolding DoD, expanding Acceptance, opening/merging a PR, or declaring a
group complete.

---

## Statement

**Docs mean full ownership.** Work that changes lived truth, operator path,
trust boundaries, or public contracts is incomplete until durable documentation
reflects it — same bar as tests green or plan applies clean.

**Flip side (same principle):** code comments stay **thin** and local. Docs and
PR bodies do the heavy lifting for narrative context. Comments earn their keep
when they prevent a lived failure or carry operator-facing plan/apply errors;
they must not re-host architecture essays that will drift.

## Rules

1. **Plan it** — implementation plans and task groups include explicit **Docs**
   steps (or Acceptance) next to the work that needs them — not only a stage-end
   checkbox.
2. **Ship it with the change** — durable docs land in the same PR/tranche as the
   code (or an honest **WIP** marker until the path closes). Silence is not WIP.
3. **Split when link-worthy** — same test as capture-discussion: if future-you
   would link the concept without the whole stage narrative, give it its own
   doc; otherwise append the hub/index. Cross-link both ways.
4. **Thin HCL/code comments** — one-line file role or pointer to docs; keep
   apply/runtime hazards inline; put FR/NFR essays and “why this design” in docs.
5. **PRs carry context** — PR Summary/Why explain intent; do not rely on comment
   archaeology in the diff.

## WIP

Markers like `Status: 🟠 WIP — … pending Group N` are allowed until the full
path finishes. Incomplete-with-marker beats omitted. Clear WIP when the path
closes (or explicitly defer with a fix/backlog pointer).

## Filter (avoid ceremony)

Require doc writes when the group changes platform shape, trust boundary, state
layout, tags, operator procedure, or user-facing behavior. Pure internal
refactors may note “no durable doc change.” Default is ownership — not a novel
per group.

## Anti-patterns

- HCL/README restating the architecture doc
- “Docs later” with no WIP marker
- Principle loaded at plan time then ignored at PR/merge
- Every comment block citing FR-IDs the docs already own

## Project pointers

Repos choose their durable doc roots (e.g. my-infra `docs/maintainers/aws/`).
This principle does not prescribe filenames — only that ownership is documented
and comments stay thin.
