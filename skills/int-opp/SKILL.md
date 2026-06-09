---
name: int-opp
description: >-
  Capture internal improvement opportunities from project work. Use when the
  user invokes /int-opp after completing a phase, feature, or significant piece
  of work and wants to document learnings and actionable improvements while
  they're fresh. Do NOT use for creating explorations (/explore-start) or for
  read-only thinking (/discuss).
disable-model-invocation: true
---

# Internal Opportunities

Capture learnings from project work to improve dev-infra templates and future
projects. The goal is actionable documentation, not retrospective prose.

```
identify project → detect/create opportunity directory
  → determine type (learning or improvement)
  → create document from template → fill with specifics → commit → stop
```

## Templates

This skill includes co-located templates in the `templates/` directory. Use them
as the starting structure for each document type:

| Template | Use when |
|----------|----------|
| `templates/learnings.md` | Capturing what worked, what didn't, time analysis |
| `templates/improvements.md` | Documenting actionable items for other projects |
| `templates/project-hub.md` | Creating a new project's opportunity directory |

Copy the appropriate template to the target path, then fill in the placeholders
in place. Omit or mark N/A for sections that don't apply — the template is a
prompt for what to consider, not a mandatory checklist. Do not invent a format
from scratch.

## Options

| Invocation | Behavior |
|------------|----------|
| `/int-opp` | Capture learnings for current project (auto-detect) |
| `/int-opp [project]` | Specify project explicitly |
| `/int-opp [project] --new-project` | Create opportunity directory for a new project |
| `/int-opp [project] --phase N` | Phase-specific learnings (auto-detects feature) |
| `/int-opp [project] --phase N --feature [name]` | Phase learnings grouped by feature |

## Workflow

### 1. Identify the project

If no project specified, detect from context: git remote name, current
directory, or branch name. Check if the project already has an opportunity
directory.

**Path detection:**

| Structure | Opportunities path |
|-----------|-------------------|
| Dev-infra | `admin/planning/opportunities/internal/[project]/` |
| Template project | `docs/maintainers/opportunities/[project]/` |

### 2. Create project directory (if `--new-project` or project doesn't exist)

Read `templates/project-hub.md`, fill in project details, and create:

```
[opportunities-path]/[project]/
├── README.md              ← from templates/project-hub.md
├── learnings/
│   └── README.md          ← simple hub linking to learning documents
└── improvements/
    └── README.md          ← simple hub linking to improvement documents
```

### 3. Determine opportunity type

| Signal | Type |
|--------|------|
| Default (most cases) | **Learning** — what worked, what didn't, discoveries |
| Explicitly actionable items for other projects | **Improvement** — checklist of changes to make |
| Both in one capture | Create both — one learning + one improvement document |

The user's input usually makes the type obvious. If ambiguous, default to
learning and note potential improvements within it.

### 4. Create the document

Read the appropriate template from `templates/`. Fill in all placeholders
with specifics from the user's input and project context.

**Learnings** (`templates/learnings.md`):
- File: `learnings/[topic]-learnings.md` or `learnings/[feature]/phase-N-learnings.md`
- Fill in: what worked, what needs improvement, discoveries, time analysis

**Improvements** (`templates/improvements.md`):
- File: `improvements/[topic]-improvements.md`
- Fill in: actionable items with location, action, priority, effort

### 5. Update hub documents

Add the new document to the project's learnings or improvements hub README.
Update the main opportunities hub if this is a new project.

### 6. Commit and stop

Commit with `docs(int-opp): capture [project] learnings — [topic]`.
Docs-only — can push directly to current branch.

## Behavioral Contract

**Capture while fresh.** The value of int-opp is immediacy. The user just
finished work and has context in their head. Don't ask for information that's
already in the project's artifacts — read the phase document, commit history,
or status file and extract what you need.

**Be specific, not generic.** "Testing was hard" is useless. "The 48-test
bats suite caught 3 bugs in argument parsing that would have shipped" is a
learning. Every item should name what happened and why it matters.

**Create actionable improvements, not wish lists.** Each improvement item
needs a location (where to make the change), an action (what to do), and a
priority. "We should improve testing" is a wish. "Add `--dry-run` flag to
`new-project.sh` (scripts/new-project.sh, MEDIUM priority)" is actionable.

**Preserve the user's framing.** If the user says "the template validation
was a lifesaver," that's the framing. Don't rewrite it as "automated testing
provided value." The user's words carry context that sanitized summaries lose.

**Don't duplicate existing artifacts.** If the phase document already has a
time breakdown, reference it — don't copy it into the learnings document. The
learning should add *interpretation* (why it took that long, what to do
differently), not repeat data.

## Gotchas

**Writing a retrospective essay instead of structured learnings.** The
templates have sections for a reason. Fill in the sections, don't write
flowing prose that buries the actionable insights. If someone can't scan
the document and find the improvements in 30 seconds, it's too narrative.

**Capturing improvements without location or priority.** Every improvement
needs to say *where* the change goes and *how important* it is. Without
these, improvements accumulate as a backlog nobody triages.

**Asking the user to enumerate everything they learned.** The user invoked
`/int-opp` — they have something to capture. Read their input and the
project's recent artifacts (phase docs, commits, status) to fill in context.
Don't interview them for 10 minutes before creating the document.

**Creating an opportunity directory that already exists.** Check first.
Overwriting an existing project hub destroys links to previously captured
learnings. Always check if the directory exists before creating.

**Mixing learnings and improvements in one document.** If both types are
present, create two documents — one learning, one improvement. They serve
different audiences (the learning is for the team, the improvement is for
the template maintainer) and have different lifespans.

**Forgetting to update the hub README.** The document is only discoverable
if it's linked from the hub. Always add the new document to the project's
learnings or improvements hub, and update the main opportunities hub for
new projects.
