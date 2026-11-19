# Register: Plain informational

**Id:** `plain-informational`
**Status:** Active
**Last Updated:** 2026-09-30

**Audience:** Teammates reading team-facing docs to find out what's true and what to do. They
want the fact, then the reason. They don't want to decode a phrase first.

**Consumers (hard-require when writing this audience's prose):** READMEs in team repos; wiki
page drafts; PR descriptions; ticket and change-request text; meeting agenda items.

**Load:** `read ~/.cursor/registers/plain-informational.md` before drafting or rewording that
prose.

**Exemplar (imitate this shape):** the Before and after table below. In a README's "Design
decisions" section, each bold lead is a plain, complete statement of fact, and the sentences after
it give the reason and the consequence.

---

## Statement

Say what is true, in the words you'd use to explain it to a teammate at their desk. Headings name
what's in the section. Bold leads state the fact in full. The reason comes after, stated as a
concrete consequence rather than an abstraction.

## Rules

1. **Headings describe their content.** "Design decisions", not "Decisions baked in". No idioms,
   metaphors or wordplay in headings or labels.
2. **A bold lead is a complete, informational sentence.** A reader who reads only the bold text
   should come away with the fact. "Terraform manages auth mounts, roles and policies. It doesn't
   manage secret values." rather than "Terraform owns plumbing, never secret values."
3. **No slogan shapes.** Avoid constructions that read as mottos: "X, never Y", "A, not B" as a
   whole lead, "is a claim; a plan is a check", parallel or mirrored clauses, and "ever" for
   emphasis. They're memorable but leave the reader to reconstruct the fact.
4. **Give the consequence, concretely.** "A secret value in Terraform would end up in the state
   file in plain text" rather than "recreates the plaintext-on-disk problem".
5. **Define a term the first time it's used.** "A trust domain is a set of workloads allowed to read
   the same credentials", then use the term.
6. **Plain imperatives.** "Don't store real secrets on DEV." rather than "No real secrets on DEV,
   ever."
7. **No em-dashes as structural connectives.** Use a full stop, a colon, or parentheses.
8. **Match the surrounding register.** In a repo or channel with terse existing posts, be at least
   as terse. Cut context rather than add it.

## Before and after

| Before | After |
|---|---|
| Decisions baked in | Design decisions |
| Terraform owns plumbing, never secret values. | Terraform manages auth mounts, roles and policies. It doesn't manage secret values. |
| A consumer is a trust domain, not a server. | Consumers are grouped by trust domain. |
| Role names are environment-independent; namespaces aren't. | Role names are the same in every cluster; namespaces differ by environment. |
| `prevent_destroy` on auth mounts. | Terraform can't destroy an auth mount (`prevent_destroy`). |
| Read-only policies only. | All policies are read-only. |
| No real secrets on DEV, ever. | Don't store real secrets on DEV. |
| A wiki page can explain *why* something exists; it isn't evidence that it does. | Documentation can explain why a resource exists, but only the plan shows that it's there. |

## Anti-patterns

- Bold leads that are fragments or labels (`Client self-review.`) with the actual fact buried in the
  next sentence
- Epigrams and chiasmus in team docs, even accurate ones
- Idioms that assume shared culture ("baked in", "the light-bulb", "for free")
- Abstract nouns standing in for the consequence ("the plaintext-on-disk problem")

## When *not* to use this register

- Personal `.scratch/notes/` concept docs and `/discuss` threads, where a memorable phrase is how a
  lesson gets recalled later. Titles there can stay pithy. Translate them into this register when
  the idea moves into a team-facing doc.

## Pairing

| Load | For |
|------|-----|
| `~/.cursor/registers/cold-reader-operator.md` | How a document is structured for someone re-entering cold (start here, why before inventory, glossary) |
| `~/.cursor/registers/plain-informational.md` | How its sentences, headings and bold leads are worded |

`cold-reader-operator` allows "metaphors that earn their keep" for building a mental model. That
still holds in explanatory prose. This register keeps metaphors out of headings, labels and bold
leads, which a reader skims for facts.
