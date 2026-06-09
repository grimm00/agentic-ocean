---
name: research-setup
description: >-
  Scaffold research directory layout for a topic: hub, per-topic documents from
  exploration/reflection/direct input, requirements skeleton, summary, and
  parent research index updates. Use when the user wants /research setup,
  /research --from-explore, /research --from-reflect, or to add a late topic
  (/research --add-topic N). Do NOT use for conducting research (research-conduct)
  or consolidating requirements (research-consolidate).
disable-model-invocation: true
---

# Research Setup

Before proceeding, read `../SKILL.md` for family conventions (path detection,
topic naming, commit discipline, filename conventions).

You create **structure only**: templates and links so humans can review before
long-running **research-conduct** work. Do not perform web research in this
skill.

---

## Modes

| Mode | Trigger | Outcome |
|------|---------|--------|
| **Setup** | Single input source: `--from-explore`, `--from-reflect`, or direct `--topic` / inline topic | New `research/[topic]/` tree (or dev-infra feature `research/`) |
| **Add topic** | Research tree exists + topic index `N` from `research-topics.md` | New `topic-N-[name].md` + hub/summary updates |

Accept **one** setup source only (explore **or** reflect **or** direct). Error
if mutually exclusive flags would collide (same rules as legacy command:
`--add-topic` excludes initial `--from-explore`).

**Natural-language invocation:** Map user intent to the same modes without
requiring CLI flags. Examples: “Scaffold research from exploration *auth*” →
Setup with from-explore; “Add topic 4 to this research” → Add topic with *N=4*.
Confirm `N` and whether to overwrite when a target file already exists (equivalent
to `--force`).

**Layout detection failure:** After checking `../SKILL.md` path rules, if the
repo matches **none** of the known layouts, **stop** and report which predicates
were evaluated (`admin/services/`, `docs/maintainers/research/`, etc.). Do not
create a new research tree under an assumed or ad-hoc root.

---

## Setup Mode Workflow

### 1. Identify research source and topics

1. **`--from-explore [explore-topic]`:** Resolve exploration directory per
   `../../explore/SKILL.md` Path Detection. Read `research-topics.md`. Derive
   research topic directory name from CLI `--topic` if present, else align with
   the exploration topic naming convention.
2. **`--from-reflect [path]`:** Read the reflection file. Extract sections
   titled **Actionable Suggestions** or **Opportunities for Improvement** (or
   closest equivalent headings). Each distinct suggestion becomes a research
   topic with a clear question line.
3. **Direct topic:** Use `[topic]` from invocation. If there are no discrete
   questions yet, ask the user for a numbered list of research questions before
   creating files.

**Checklist:** Source chosen; topic list explicit; target paths detected per
family conventions.

### 2. Create research directory and hub

Create `README.md` for the research topic with:

- Purpose, status 🔴 Research, created/updated dates
- Quick links to `research-summary.md`, `requirements.md`, and each per-topic file
- **Research status** table: one row per topic with 🔴 Not Started
- Short research overview and next steps pointing to conduct then consolidate

### 3. Create per-topic research documents

For **each** topic, add one markdown file:

- **Initial setup:** `research-[question-slug].md` where slug is kebab-case from
  the question title.
- Fill the scaffold sections: Research Question, Research Goals (checkbox list),
  Methodology (placeholder), Sources checklist (include a line that web search
  is expected **in conduct**), empty Findings / Analysis / Recommendations /
  Requirements Discovered / Next Steps.

Use the project’s established section headings so **research-conduct** can
fill them without reformatting.

### 4. Create `research-summary.md`

Skeleton with overview counts, empty “Key Findings”, Requirements Summary pointer
to `requirements.md`, and next steps listing conduct before consolidate.

### 5. Create `requirements.md`

Skeleton: Overview, Functional / Non-functional / Constraints / Assumptions
sections with **no** fabricated FR IDs — status **Draft**. Optional placeholder
lines inviting extraction during conduct.

### 6. Update parent research index (if present)

If the repo uses a parent `docs/maintainers/research/README.md` (or equivalent
per detected layout), add this topic to Active Research with 🔴 Research
status.

### 7. Commit

Commit all new paths with:

`docs(research): scaffold [topic] research ([N] topics)`

**Stop** after presenting what was created and where conduct should begin. Do
not run web search or mark topics complete.

---

## Add Topic Mode Workflow

### Preconditions

1. Research directory for `[topic]` already exists.
2. Read **exploration** `research-topics.md` from the same exploration pairing
   used when research was created (resolve path per explore conventions).
3. Topic **`N`** exists in that file (`### Topic N:` or equivalent heading).
4. Target filename `topic-N-[name].md` must not exist unless the user explicitly
   requests `--force` / overwrite.

### Steps

1. Parse topic block: Question, Context, Priority, and any listed methodology
   hints.
2. Create `topic-N-[name].md` using the **same section scaffold** as Setup step 3.
3. Update hub `README.md` status table + quick link for the new file.
4. Append placeholder subsection to `research-summary.md`:

   `### Topic N: [Name] (🔴 Not Started)` + one line that findings arrive after conduct.

5. Commit: `docs(research): scaffold topic N ([slug]) for [topic]`

---

## Behavioral Contract

**Scaffold only.** Do not execute **research-conduct** (no web search, no filled
findings, no “complete” status on topics).

**One setup source** for initial setup; do not merge exploration and reflection
inputs in a single run unless the user explicitly provides a single merged list
(in that case treat as direct topic with enumerated questions).

**Preserve slugs** consistently with topic titles; do not rename an existing
research directory in this skill (new topic directory creation is **setup** on
a new `[topic]` name only).

**Never silently overwrite** reviewed artifacts. If paths exist, stop and
request `--force` / user confirmation.

**Observable completion:** Every listed topic has a file; hub lists each file;
`requirements.md` and `research-summary.md` exist; commit succeeded.

---

## Gotchas

**Wrong exploration path.** Dev-infra explorations live under
`admin/services/.../explorations/`, not a flat `admin/explorations/` root. If
`research-topics.md` is not found, re-resolve using **explore** path rules before
creating duplicate directories.

**Mixing filename conventions.** Initial topics may be `research-*.md` while
amended topics use `topic-N-*.md`. Updating the hub table is mandatory so both
are linked.

**Skipping the commit.** Scaffolding without a commit makes the handoff to
conduct fragile; always commit after setup or add-topic.

**Running conduct inside setup.** Web search and filled findings belong in
**research-conduct**. Doing them here blurs review gates and duplicates the
largest behavioral contract.

**Add-topic without exploration sync.** Topic `N` must exist in the exploration’s
`research-topics.md`. If the user amended exploration but did not sync the
file, stop and ask them to fix exploration first.

---

**Skill boundaries:** Setup + add-topic only. **research-conduct** fills
content; **research-consolidate** cleans requirements after all topics are
complete.
