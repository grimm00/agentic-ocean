# Finding shape (research-conduct)

Each finding is a **claim** supported by **evidence**. Extra reasoning is welcome
when it maps facts onto *this* repo (backup-and-restore density). Do not treat
vendor pages as eternal truth.

Worked example of the shape (not a required topic):
`CatdogServices` `pre-implementation-gaps/research/topic-1-bootstrap-first-mover.md`.

---

## Kind

| Kind | Means | How it ages |
|------|--------|-------------|
| **Vendor-current** | What a vendor documents *now* | Product pages can change; date the source; re-check at implement |
| **This-repo policy** | Constraints already chosen here | Not an empirical vendor fact; amend only if policy changes |
| **Practitioner pattern** | Common recipes, not a spec | Useful, not guaranteed |
| **Synthesis** | This pass’s comparison or inference | Can be superseded by `/decision` or a spike |

If live work was **not** done, list it as an unchecked source. Do not imply hands-on
validation.

---

## Per-finding block

```markdown
### F#: <claim as the heading — a statement about the world, not “notes on X”>

**Kind:** Vendor-current | This-repo policy | Practitioner pattern | Synthesis
(optional: product name + as-of date)

**Source:** links, repo paths, `Web search: <query>`, or dated live inspection

**Evidence:**
- Facts from those sources. Do not paraphrase the heading.

**Relevance:**
Why those facts matter to *this* research question. Tables, caveats, and
project-specific mapping belong here. Not a one-sentence restatement of the claim.
```

Put the Kind table once under **Methodology** (or a one-line pointer to this file)
so reviewers know the labels.

---

## Density vs thinness

**Enough:** Source facts, then Relevance that names implications, exceptions, and
what was *not* verified (e.g. “not live-checked on this account”).

**Too thin:** Claim + one-line Evidence that restates the claim + “Relevance: this
answers the question.”

**Too circular:** Evidence that only repeats the heading (“CloudShell is suitable
because CloudShell is the bootstrap host”).

---

## Recommendations vs findings

- **Findings** assert; they do not close `/decision` items.
- **Recommendations** stay `[ ]` (follow-through). Do not check them because
  “research recommends this.”
- **Analysis** may use `[x]` for conclusions of *this pass*.

---

## Completeness (conduct)

A topic is not ✅ Complete unless each finding used this pass has Kind, Source,
Evidence, and Relevance, and Evidence does not merely restate the heading.
