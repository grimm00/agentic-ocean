# Register: Cold-reader operator

**Id:** `cold-reader-operator`  
**Status:** Active  
**Last Updated:** 2026-09-03

**Audience:** Next-week-you, or another operator, opening the doc **cold** — they
did not just finish the chat that built the system.

**Consumers (hard-require when writing this audience’s prose):** write-plan
(Docs / Mixed cohorts and Docs Acceptance); durable maintainer docs and
runbooks; group-cycle when emitting operator-facing docs; PR Summary/Why for
platform/operator changes.

**Load:** `read ~/.cursor/registers/cold-reader-operator.md` before drafting or
expanding that prose.

**Exemplar (imitate this shape):**  
`my-infra/docs/maintainers/aws/architecture.md` (as of the 2026-09-03
plain-language pass) — Start here → why → mental model → topology → detail →
glossary.

---

## Statement

Write so a cold reader can rebuild the mental model without the Slack/chat
history. Prefer **plain language**; keep product names when they are the real
nouns, but **define lab slang** and **link official product docs** on first use.

## Rules

1. **Start here** — ordered 3–5 step path for a cold open (what to read, what not
   to break, where to run commands).
2. **Why before inventory** — say what problem the thing solves before listing
   CIDRs, resources, or file paths.
3. **Define on first use** — lab metaphors and slang get a short gloss in-line
   (*soak* = trial-run in the cloud before trusting home; *pin* = lock to that
   commit). Optional **Glossary** table at the end for lookup.
4. **Link products, don’t lecture them** — EC2, EIP, VPC, OIDC, NAT, SSM, etc.
   may stay as names with a link to AWS (or upstream) docs on first mention.
5. **Metaphors that earn their keep** — one clear picture (shelf + notebooks,
   door + hallway) beats a pile of identifiers; introduce the metaphor, then use
   it consistently.
6. **Diagram when topology matters** — even a small mermaid beats forcing the
   reader to re-derive trust boundaries from bullets.
7. **Say what is not built yet** — mark WIP / future groups explicitly so cold
   readers do not hunt for a VM that does not exist.
8. **Keep HCL thin** — this register governs *docs and operator prose*, not
   comment essays in `.tf` (see `documentation-is-ownership`).

## Anti-patterns

- Identifier stew as the only explanation (`aws_vpc`, `aws_eip`, … with no verbs)
- Slang with no gloss (`soak`, `pin`, `fail closed`, `Pattern B`, `sticky Host`)
- Assuming the reader remembers Stage 1 chat (“we already migrated, remember?”)
- Essay-length Steps that restate Grounding; or telegraphic noun piles with no
  connective tissue

## When *not* to use this register

- Expert-only HCL Steps aimed at someone mid-apply who already has the mental
  model (still avoid pure identifier stew — write-plan Steps prose still applies).
- `/discuss` scratch thinking — no durable audience yet.

## Pairing

| Load | For |
|------|-----|
| `~/.cursor/principles/documentation-is-ownership.md` | Whether docs must exist / stay owned |
| `~/.cursor/registers/cold-reader-operator.md` | How those docs should read |
