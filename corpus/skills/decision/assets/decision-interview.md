# Decision Interview — `{topic-kebab}`

Human priorities **before** clustering decision points into ADRs. Replace `{topic-kebab}`
if you rename the slug.

**Status:** 🔴 Awaiting input *(update when ready for clustering — or annotate explicit waiver in ADRs)*

---

## How to use

Prefer short bullets; skip prompts that genuinely do not apply. The agent should
still **STOP** early if priorities + constraints remain empty unless the operator
explicitly sends a textual waiver (`waive decision interview` equivalent).

---

## User experience priorities

- Which workflows must feel meaningfully improved in the upcoming release slice?
- What friction reliably escalates incidents or rework today?

---

## Constraints / instincts

- Non-negotiable scope cuts ("never in v1", compliance walls, mandated stacks)
- Architectural risk appetite (prefers incremental vs bold refactors)

---

## Optional — architecture / validation prompts

- Latency / sizing instincts someone should sanity-check before debating alternates?
- Operational requirements (deployment cadence, audit logging, tenancy, etc.)

---

Agents must reference this file (`decisions/decision-interview.md` for typical layouts)
inside each ADR’s **Decision Rationale** whenever content here influenced ordering.
