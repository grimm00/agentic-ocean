# Quality Attribute Catalog

Standing reference for **UX and DevX / operator / agent** experience. Used as a
**light skim** during `/work-blocks` and a **deeper selection** during `/design`
(Qualities / NFR sign-off). Grow from project learnings, not from theory.

**Consumers:** `work-blocks` (skim), `design` family (select for first win)
**Also read:** a project override when present (e.g. `.scratch/quality-attribute-catalog.md`
or `docs/QUALITY-ATTRIBUTES.md`); feature-local notes win for that repo; this
file stays the default.

---

## How to use

| Pass | Depth | Output |
|------|-------|--------|
| `/work-blocks` | Skim | One line per attribute that **bites a letter now**; list deferrals |
| `/design` | Select | Prefer **2–4** attributes for the first win; deferrals in one short bullet or non-goals |

Do **not** turn the catalog into a full NFR essay during segmentation. Do **not**
expand the current block or first win to absorb every row.

---

## Catalog

| Attribute | When applicable | Typical questions |
|-----------|-----------------|-------------------|
| **Usability / DevX** | Always | Can a new operator (or fresh machine) recover intent without tribal knowledge? Is the happy path obvious for humans **and** agents? |
| **Shippability** | Multi-stage / multi-block features | Which block must be honest before the next block’s claims are true? Can a thin slice ship without pretending later doors are done? |
| **Maintainability** | Always | Will the next person find the source of truth? Are conventions shared without forcing one schema everywhere? |
| **Migration Safety** | Changes to existing patterns | What breaks for in-flight consumers? Is there a rollback story? |
| **Backward Compatibility** | Downstream consumers | Who still reads the old shape? What is the cutover rule? |
| **Lifecycle** | Distributable artifacts | Who owns install / upgrade / uninstall? Which letter or door? |
| **Testability** | Logic or behavioral contracts | What contract can fail silently (transforms, joins, auth)? |
| **Portability** | Cross-platform / multi-runner | Does CI invent a second path the laptop does not use? |
| **Context Efficiency** | Agent-facing surfaces | Can an agent act from durable notes without replaying the whole discuss? |
| **Observability** | Runtime or control-plane paths | What does an operator see on decrypt/config miss, bad join, plan/deploy fail? |
| **Security** | Secrets or access | Who holds keys? Where must secrets never land (bootstrap artifacts, shared docs, logs)? |

---

## DevX / operator skim prompts

Use when scanning multi-product maps:

- **Fresh environment** — can intent and pointers be regenerated or recovered?
- **Secrets path** — who holds keys; does CI invent a second secrets story?
- **Shippability** — which letter must land before the next claim is honest?
- **Lifecycle** — which letter owns day-2 upgrade / uninstall?
- **Conventions vs one schema** — shared keys and generate-before-consume rules without forcing one file format

---

## Integration

```
/work-blocks skim  →  /design Qualities (deep)  →  NFR sign-off (same catalog)
```

1. Resolve catalog: project override if present, else this file
   (`~/.cursor/skills/design/references/quality-attributes.md` when installed).
2. Skim or select; name deferrals explicitly so they do not vanish.
3. Retroactive audit is fine when new attributes appear after a design is Ready.

---

## Evolution

- Add attributes when a real project discovers a miss (e.g. Lifecycle).
- Prefer new **typical questions** over new abstract rows.
- Keep UX and DevX in the same catalog — operator experience is not optional flavor.

---

**Last Updated:** 2026-10-07
