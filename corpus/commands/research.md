# Research Command

Conduct structured research following standardized workflow. Has four modes:
1. **Setup Mode** (default) - Creates research documents for each research topic/question
2. **Conduct Mode** (`--conduct`) - Actually performs research, fills in findings, and extracts requirements
3. **Add Topic Mode** (`--add-topic`) - Scaffolds a late-arriving topic into existing research
4. **Consolidate Mode** (`--consolidate`) - Reviews accumulated requirements for redundancies, gaps, and staleness before decision phase

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Dev-Infra Structure (default):**
   - Research: `admin/research/[topic]/`
   - Requirements: `admin/research/[topic]/requirements.md`
   - Explorations: `admin/explorations/[topic]/`

2. **Template Structure (for generated projects):**
   - Research: `docs/maintainers/research/[topic]/`
   - Requirements: `docs/maintainers/research/[topic]/requirements.md`
   - Explorations: `docs/maintainers/planning/explorations/[topic]/`

3. **Project-Wide Structure:**
   - Research: `docs/maintainers/research/[topic]/`
   - Requirements: `docs/maintainers/research/[topic]/requirements.md`
   - Explorations: `docs/maintainers/planning/explorations/[topic]/`

**Topic Detection:**
- Use `--topic` option if provided
- Otherwise, auto-detect from input source
- Sanitize topic name (kebab-case, no spaces)

---

## Workflow Overview

**When to use:**

- After exploration identifies research topics
- When reflect artifacts identify opportunities needing research
- To conduct structured research on a specific topic

**Key principle:** Follow standardized research workflow, create documents for each research topic, extract requirements discovered during research, then consolidate before decisions.

**Four Modes:**

### Setup Mode (Default)
```
/research [topic] --from-explore [topic]
  → Reads research topics from exploration
  → Creates research hub
  → Creates research document for each topic (templates)
  → Creates requirements skeleton
  → Outputs: Research structure ready for conducting
```

### Conduct Mode (`--conduct`)
```
/research [topic] --conduct [--topic-num N]
  → Reads existing research document(s)
  → Uses web search to find information
  → Fills in findings with sources
  → Analyzes findings and draws insights
  → Makes recommendations
  → Extracts requirements
  → Updates summary and requirements docs
  → Commits changes
```

### Add Topic Mode (`--add-topic`)
```
/research [topic] --add-topic N
  → Reads Topic N from research-topics.md
  → Scaffolds topic-N-[name].md using research document template
  → Updates research hub README.md with new topic link
  → Updates research-summary.md with placeholder entry
  → Outputs: New topic scaffolded, ready for --conduct
```

**When to use Add Topic Mode:**

- After `/explore --amend` added a new theme and research topic
- When research surfaces a question that warrants its own topic
- Any time a new topic appears in `research-topics.md` after initial scaffolding

### Consolidate Mode (`--consolidate`)
```
/research [topic] --consolidate
  → Validates all topics are complete
  → Reconciles exploration with research findings (mandatory/recommended)
  → Reads all requirements (FRs, NFRs, Constraints, Assumptions)
  → Cross-references against research findings and recommendations
  → Identifies: redundancies, superseded items, gaps, stale descriptions
  → Presents analysis for human review (STOP and wait)
  → After approval: merges, removes, adds, modifies, renumbers
  → Updates research summary counts
  → Updates requirements.md status from Draft to Final
  → Commits changes
```

**When to use Consolidate Mode:**

- After all research topics are complete, before the decision phase
- When research topics were conducted over multiple sessions (drift accumulates)
- When later topics superseded or refined findings from earlier topics
- When `/explore --amend` added topics that overlap with original requirements
- When the exploration's themes may be stale relative to research findings (exploration reconciliation)

---

## Usage

**Command:** `/research [topic] [--from-explore|--from-reflect|--topic|--conduct] [options]`

**Setup Mode Examples:**

- `/research auth-system --from-explore new-authentication-system` - Create research structure from exploration
- `/research ci-optimization --from-reflect reflection-project-2025-12-07.md` - Create research structure from reflection
- `/research database-choice --topic "PostgreSQL vs MongoDB"` - Create research structure for direct topic
- `/research --dry-run` - Show what would be created without creating files

**Conduct Mode Examples:**

- `/research experimental-template --conduct` - Conduct ALL research topics for a topic
- `/research experimental-template --conduct --topic-num 1` - Conduct research for topic #1 only
- `/research experimental-template --conduct --topic-name user-demand` - Conduct specific topic by name

**Add Topic Mode Examples:**

- `/research workflow-simplification --add-topic 6` - Scaffold Topic 6 from research-topics.md
- `/research auth-system --add-topic 3 --force` - Re-scaffold Topic 3 (overwrite existing)

**Consolidate Mode Examples:**

- `/research workflow-simplification --consolidate` - Review and clean up all requirements
- `/research auth-system --consolidate --dry-run` - Show proposed changes without applying

**Options:**

- `--from-explore [explore-topic]` - Read research topics from exploration document (Setup Mode)
- `--from-reflect [reflection-file]` - Read opportunities from reflection artifacts (Setup Mode)
- `--topic [topic]` - Direct topic specification (Setup Mode)
- `--conduct` - Actually perform research (Conduct Mode)
- `--add-topic [N]` - Scaffold a single new topic from research-topics.md (requires existing research structure)
- `--consolidate` - Review and clean up accumulated requirements before decision phase
- `--topic-num [N]` - Research specific topic by number (with --conduct)
- `--topic-name [name]` - Research specific topic by name (with --conduct)
- `--dry-run` - Show what would be done without making changes

---

## Step-by-Step Process

### 1. Identify Research Source

**Determine input source:**

1. **From Exploration (`--from-explore`):**
   - **Dev-Infra:** Read `admin/explorations/[explore-topic]/research-topics.md`
   - **Template Structure:** Read `docs/maintainers/planning/explorations/[explore-topic]/research-topics.md`
   - Extract research topics/questions
   - Use explore-topic as research topic name (or use --topic to override)

2. **From Reflection (`--from-reflect`):**
   - Read reflection document
   - Extract "Actionable Suggestions" or "Opportunities for Improvement"
   - Convert suggestions to research topics
   - Use topic from command or prompt user

3. **Direct Topic (`--topic` or no flag):**
   - Use provided topic
   - Prompt user for research questions if needed

**Checklist:**

- [ ] Research source identified
- [ ] Research topics extracted
- [ ] Topic name determined

---

### 2. Create Research Hub

**Location Detection:**

- **Dev-Infra:** `admin/research/[topic]/`
- **Template Structure:** `docs/maintainers/research/[topic]/`
- **Project-Wide:** `docs/maintainers/research/[topic]/`

**Auto-detection:**
- Check if `admin/research/` exists → use dev-infra structure
- Check if `docs/maintainers/research/` exists → use template structure
- Otherwise → use project-wide structure

**Directory structure:**

```
research/[topic]/
├── README.md                    # Research hub
├── research-[question-1].md     # Research document for question 1
├── research-[question-2].md     # Research document for question 2
├── research-summary.md          # Summary of all research
└── requirements.md              # Requirements discovered during research
```

**Create research hub:**

**File:** `docs/maintainers/research/[topic]/README.md`

```markdown
# [Topic Name] - Research Hub

**Purpose:** Research for [topic description]  
**Status:** 🔴 Research  
**Created:** YYYY-MM-DD  
**Last Updated:** YYYY-MM-DD

---

## 📋 Quick Links

- **[Research Summary](research-summary.md)** - Summary of all research findings
- **[Requirements](requirements.md)** - Requirements discovered during research
- **[Research Documents](research-*.md)** - Individual research documents

### Research Documents

- **[Research: Question 1](research-[question-1].md)** - [Question description]
- **[Research: Question 2](research-[question-2].md)** - [Question description]

---

## 🎯 Research Overview

[Brief description of research goals]

**Research Topics:** [N] topics  
**Status:** 🔴 Research

---

## 📊 Research Status

| Research Topic | Status | Document |
|----------------|--------|----------|
| [Question 1] | 🔴 Not Started | [research-[question-1].md](research-[question-1].md) |
| [Question 2] | 🔴 Not Started | [research-[question-2].md](research-[question-2].md) |

---

## 🚀 Next Steps

1. Complete research documents for each topic
2. Review requirements in `requirements.md`
3. Use `/decision [topic] --from-research` to make decisions

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Research directory created
- [ ] Research hub created
- [ ] Research topics listed in hub

---

### 3. Create Research Documents

**For each research topic/question:**

**File:** `docs/maintainers/research/[topic]/research-[question-name].md`

```markdown
# Research: [Question Name]

**Research Topic:** [Topic Name]  
**Question:** [Specific research question]  
**Status:** 🔴 Research  
**Created:** YYYY-MM-DD  
**Last Updated:** YYYY-MM-DD

---

## 🎯 Research Question

[What specific question is this research addressing?]

---

## 🔍 Research Goals

- [ ] Goal 1: [What do we need to understand?]
- [ ] Goal 2: [What information is needed?]
- [ ] Goal 3: [What comparisons are needed?]

---

## 📚 Research Methodology

[How will this research be conducted?]

**Note:** Web search is **allowed and encouraged** for research. Use web search tools to find current information, best practices, documentation, examples, and real-world implementations. This helps ensure research is based on up-to-date information and industry standards.

**Sources:**
- [ ] Source 1: [Description]
- [ ] Source 2: [Description]
- [ ] Source 3: [Description]
- [ ] Web search: [Use web search for current information, documentation, examples]

---

## 📊 Findings

### Finding 1: [Title]

[Description of finding]

**Source:** [Source reference]

**Relevance:** [Why this finding matters]

---

### Finding 2: [Title]

[Description of finding]

**Source:** [Source reference]

**Relevance:** [Why this finding matters]

---

## 🔍 Analysis

[Analysis of findings]

**Key Insights:**
- [ ] Insight 1: [Description]
- [ ] Insight 2: [Description]

---

## 💡 Recommendations

- [ ] Recommendation 1: [Description]
- [ ] Recommendation 2: [Description]

---

## 📋 Requirements Discovered

[Any requirements discovered during this research]

- [ ] Requirement 1: [Description]
- [ ] Requirement 2: [Description]

---

## 🚀 Next Steps

1. [Next action]
2. [Next action]

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Research document created for each topic
- [ ] Research documents linked in hub
- [ ] Status tracking initialized

---

### 4. Create Research Summary

**File:** `docs/maintainers/research/[topic]/research-summary.md`

```markdown
# Research Summary - [Topic Name]

**Purpose:** Summary of all research findings  
**Status:** 🔴 Research  
**Created:** YYYY-MM-DD  
**Last Updated:** YYYY-MM-DD

---

## 📋 Research Overview

[Brief summary of research conducted]

**Research Topics:** [N] topics  
**Research Documents:** [N] documents  
**Status:** 🔴 Research

---

## 🔍 Key Findings

### Finding 1: [Title]

[Summary of finding]

**Source:** [research-[question].md](research-[question].md)

---

### Finding 2: [Title]

[Summary of finding]

**Source:** [research-[question].md](research-[question].md)

---

## 💡 Key Insights

- [ ] Insight 1: [Description]
- [ ] Insight 2: [Description]

---

## 📋 Requirements Summary

[Summary of requirements discovered]

**See:** [requirements.md](requirements.md) for complete requirements document

---

## 🎯 Recommendations

- [ ] Recommendation 1: [Description]
- [ ] Recommendation 2: [Description]

---

## 🚀 Next Steps

1. Review requirements in `requirements.md`
2. Use `/decision [topic] --from-research` to make decisions
3. Decisions will create ADR documents

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Research summary created
- [ ] Key findings documented
- [ ] Requirements referenced

---

### 5. Create Requirements Document

**File:** `docs/maintainers/research/[topic]/requirements.md`

```markdown
# Requirements - [Topic Name]

**Source:** Research on [topic]  
**Status:** [Draft | Final]  
**Created:** YYYY-MM-DD  
**Last Updated:** YYYY-MM-DD

---

## 📋 Overview

This document captures requirements discovered during research on [topic].

**Research Source:** [research-summary.md](research-summary.md)

---

## ✅ Functional Requirements

### FR-1: [Requirement Name]

**Description:** [Requirement description]

**Source:** [research-[question].md](research-[question].md)

**Priority:** [High | Medium | Low]

**Status:** 🔴 Pending

---

### FR-2: [Requirement Name]

**Description:** [Requirement description]

**Source:** [research-[question].md](research-[question].md)

**Priority:** [High | Medium | Low]

**Status:** 🔴 Pending

---

## 🎯 Non-Functional Requirements

### NFR-1: [Requirement Name]

**Description:** [Requirement description]

**Source:** [research-[question].md](research-[question].md)

**Priority:** [High | Medium | Low]

**Status:** 🔴 Pending

---

### NFR-2: [Requirement Name]

**Description:** [Requirement description]

**Source:** [research-[question].md](research-[question].md)

**Priority:** [High | Medium | Low]

**Status:** 🔴 Pending

---

## ⚠️ Constraints

### C-1: [Constraint Name]

**Description:** [Constraint description]

**Source:** [research-[question].md](research-[question].md)

---

## 💭 Assumptions

### A-1: [Assumption Name]

**Description:** [Assumption description]

**Source:** [research-[question].md](research-[question].md)

---

## 🔗 Related Documents

- [Research Summary](research-summary.md)
- [Research Documents](README.md)

---

## 🚀 Next Steps

1. Review and refine requirements
2. Use `/decision [topic] --from-research` to make decisions
3. Decisions may refine requirements

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Requirements document created
- [ ] Requirements extracted from research documents
- [ ] Requirements categorized (functional, non-functional, constraints, assumptions)

---

### 6. Update Research Hub

**Update research hub:**

**File location (auto-detected):**
- **Dev-Infra:** `admin/research/README.md`
- **Template Structure:** `docs/maintainers/research/README.md`
- **Project-Wide:** `docs/maintainers/research/README.md`

```markdown
# Research Hub

**Purpose:** Research documents and analysis  
**Status:** ✅ Active  
**Last Updated:** YYYY-MM-DD

---

## 📋 Quick Links

### Active Research

- **[Topic 1]([topic-1]/README.md)** - [Description] (🔴 Research)
- **[Topic 2]([topic-2]/README.md)** - [Description] (🟡 Analysis)

---

## 🎯 Overview

This directory contains research documents supporting exploration and decision-making.

**Workflow:**
1. `/explore [topic]` - Start exploration
2. `/research [topic] --from-explore [topic]` - Conduct research
3. `/decision [topic] --from-research` - Make decisions
4. `/transition-plan --from-adr` - Transition to planning

---

**Last Updated:** YYYY-MM-DD
```

**Checklist:**

- [ ] Research hub created/updated
- [ ] New research added to quick links

---

### 7. Commit and Push Changes

**IMPORTANT:** Always commit work before completing command.

**Reference:** [Commit Workflow](../../docs/COMMIT-WORKFLOW.md) - Central commit workflow documentation, especially [Documentation/Chore Branches](../../docs/COMMIT-WORKFLOW.md#documentationchore-branches) section

**Since research is documentation-only, use docs-only workflow:**

**Branch naming:**

- Format: `docs/research-[topic]` (e.g., `docs/research-template-generation-testing-automation`)

**Steps:**

1. **Check current branch:**

   ```bash
   git branch --show-current
   ```

2. **Create docs branch (if not already on one):**

   ```bash
   git checkout -b docs/research-[topic]
   ```

3. **Stage all changes:**

   ```bash
   git add admin/research/[topic]/  # or docs/maintainers/research/[topic]/
   ```

4. **Commit with proper message:**

   ```bash
   git commit -m "docs(research): add [topic] research

   Created research documents:
   - Research hub with [N] research topics
   - [Research document 1]
   - [Research document 2]
   - Requirements document ([N] FRs, [N] NFRs)

   Related: [Context]"
   ```

5. **Push branch:**

   ```bash
   git push origin docs/research-[topic]
   ```

6. **Merge directly to develop (docs-only, no PR needed):**

   ```bash
   git checkout develop
   git pull origin develop
   git merge docs/research-[topic] --no-edit
   git push origin develop
   ```

7. **Clean up branch:**
   ```bash
   git branch -d docs/research-[topic]
   git push origin --delete docs/research-[topic]
   ```

8. **Verify no uncommitted changes:**
   ```bash
   git status --short
   ```

---

## Add Topic Mode Workflow (`--add-topic`)

**When to use:** After `/explore --amend` adds a new theme and topic to an already-scaffolded research, use Add Topic Mode to scaffold the new topic document into the existing research structure.

### 1. Validate Existing Research Structure

**Checks:**

1. Research directory exists for topic (e.g., `admin/research/[topic]/`)
2. If not, error: "No research structure found for [topic]. Run `/research [topic] --from-explore` first."
3. Read `research-topics.md` from exploration directory
4. Validate topic number N exists in `research-topics.md`
5. Check `topic-N-[name].md` doesn't already exist (error if it does, unless `--force`)

**Error Messages:**

| Situation | Message |
|-----------|---------|
| No research structure | "No research structure found for [topic]. Run `/research [topic] --from-explore` first." |
| Topic N not in research-topics.md | "Topic N not found in research-topics.md. Check topic number." |
| Topic document already exists | "Topic N already scaffolded. Use `--force` to re-scaffold." |
| `--add-topic` + `--conduct` | "Error: --add-topic and --conduct are mutually exclusive. Scaffold first, then conduct." |
| `--add-topic` + `--from-explore` | "Error: --add-topic and --from-explore are mutually exclusive. Use --from-explore for initial setup." |

---

### 2. Scaffold New Topic Document

1. Read Topic N from `research-topics.md` (Question, Context, Priority, Rationale, Suggested Approach)
2. Create `topic-N-[name].md` using the standard research document template (same template as Setup Mode Step 3)
3. Populate template with topic metadata from `research-topics.md`:
   - Research Question from the topic's Question field
   - Research Goals derived from the topic's Context and Suggested Approach
   - Research Methodology from the topic's Suggested Approach
   - Status set to `🔴 Research`

---

### 3. Update Research Hub

1. Read existing `README.md` in the research directory
2. Add new topic to the research status table with `🔴 Not Started` status
3. Add link to new topic document in the Quick Links section

---

### 4. Update Research Summary

1. Read existing `research-summary.md`
2. Add placeholder entry for Topic N:

```markdown
### Topic N: [Topic Name] (🔴 Not Started)

*Findings to be added after research is conducted.*
```

---

### 5. Commit

```bash
git add research/[topic]/
git commit -m "docs(research): scaffold topic N ([topic-name]) for [topic]"
```

**After scaffolding, conduct the new topic:**

```bash
/research [topic] --conduct --topic-num N
```

---

## Conduct Mode Workflow (`--conduct`)

**When to use:** After research structure has been created (Setup Mode or Add Topic Mode), use Conduct Mode to actually perform the research.

### 1. Identify Research to Conduct

**Determine scope:**

1. **All Topics** (`/research [topic] --conduct`):
   - Process all research documents in the topic directory
   - Research high-priority topics first

2. **Specific Topic** (`--topic-num N` or `--topic-name [name]`):
   - Research only the specified topic
   - Useful for incremental progress

**Read the research document:**

```bash
# Example: Read research-user-demand.md
# Extract: Question, Goals, Methodology, Sources to investigate
```

**Checklist:**

- [ ] Research document(s) identified
- [ ] Research question understood
- [ ] Goals clear
- [ ] Sources to investigate listed

---

### 2. Conduct Web Research

**IMPORTANT:** Web search is **required** for Conduct Mode.

**For each research topic:**

1. **Formulate search queries** based on:
   - The research question
   - Sub-questions listed
   - Sources mentioned in methodology

2. **Execute web searches:**
   - Use `web_search` tool for current information
   - Search for industry patterns, best practices
   - Look for real-world examples and implementations
   - Find documentation, tutorials, case studies

3. **Document findings:**
   - Record each finding with source
   - Note relevance to research question
   - Capture quotes or key data points

**Example searches for "User Demand" research:**
```
- "experimental features adoption rate software"
- "beta feature user preferences developer tools"
- "feature flags user opt-in patterns"
- "early adopter vs mainstream user preferences"
```

**Checklist:**

- [ ] Search queries formulated
- [ ] Web searches executed
- [ ] Findings documented with sources
- [ ] Relevance noted for each finding

---

### 3. Fill In Research Document

**Update the research document with actual findings:**

```markdown
## 📊 Findings

### Finding 1: Industry Adoption Patterns

Early adopter segments typically represent 10-15% of user base for developer tools.
Studies show beta/experimental feature opt-in rates vary from 5-25% depending on
how features are communicated and the perceived value.

**Source:** [Web search: "beta feature adoption rates developer tools"]

**Relevance:** Helps set expectations for experimental template adoption.

---

### Finding 2: Communication is Key

Projects with clear stability communication (like Rust editions, Node.js LTS)
see higher adoption of experimental features because users understand the risk.

**Source:** [Rust Edition Guide, Node.js Release Schedule documentation]

**Relevance:** Supports need for clear stability communication in our approach.
```

**Analysis section:**

```markdown
## 🔍 Analysis

Based on the findings, we can expect:
- 5-15% of users would likely opt-in to experimental features
- Clear communication significantly increases adoption confidence
- Low-friction opt-in (flag vs separate template) affects adoption

**Key Insights:**
- [x] Insight 1: Early adopter segment exists and wants experimental features
- [x] Insight 2: Communication quality directly impacts adoption rates
```

**Recommendations section:**

```markdown
## 💡 Recommendations

- [x] Recommendation 1: Implement experimental template with clear stability indicators
- [x] Recommendation 2: Provide easy upgrade path when features graduate
```

**Requirements discovered:**

```markdown
## 📋 Requirements Discovered

- [x] REQ-1: Stability levels must be clearly visible in template documentation
- [x] REQ-2: Users should be able to identify which commands are experimental
```

**Checklist:**

- [ ] Findings filled in with sources
- [ ] Analysis completed
- [ ] Key insights documented
- [ ] Recommendations made
- [ ] Requirements extracted

---

### 4. Update Research Status

**Update the research document status:**

```markdown
**Status:** ✅ Complete
**Completed:** YYYY-MM-DD
```

**Update research goals:**

```markdown
## 🔍 Research Goals

- [x] Goal 1: Understand what percentage of users would opt-in
- [x] Goal 2: Identify which experimental features would be most valuable
- [x] Goal 3: Assess user comfort level with instability
```

**Update methodology sources:**

```markdown
**Sources:**
- [x] Web search: Industry adoption patterns
- [x] Web search: Beta feature communication
- [x] Case studies: Rust, Node.js, VS Code
```

---

### 5. Update Summary and Requirements

**Update `research-summary.md`:**

```markdown
## 🔍 Key Findings

### Finding 1: User Demand Exists

Research confirms 5-15% early adopter segment for developer tools.
Communication quality significantly impacts adoption rates.

**Source:** [research-user-demand.md](research-user-demand.md)
```

**Update `requirements.md`:**

Add any new requirements discovered during research:

```markdown
### FR-5: Stability Indicators

**Description:** Each command must display its stability level (Stable/Experimental)

**Source:** [research-user-demand.md](research-user-demand.md)

**Priority:** High

**Status:** 🔴 Pending
```

---

### 6. Update Hub Status

**Update the research hub status table:**

```markdown
## 📊 Research Status

| Research Topic | Priority | Status | Document |
|----------------|----------|--------|----------|
| User Demand | 🔴 High | ✅ Complete | [research-user-demand.md](research-user-demand.md) |
| Implementation Approach | 🔴 High | 🔴 Not Started | [research-implementation-approach.md](research-implementation-approach.md) |
```

---

### 7. Commit Research Results

**Commit with clear message:**

```bash
git add admin/research/[topic]/
git commit -m "docs(research): conduct [topic-name] research

Completed research for [topic]:
- [N] findings documented with sources
- [N] key insights identified
- [N] recommendations made
- [N] requirements discovered

Sources: [List key sources]"
```

**Push changes:**

```bash
git push origin develop
```

---

### Conduct Mode Output

**After conducting research, you should have:**

1. ✅ Filled research document(s) with actual findings
2. ✅ Sources documented for each finding
3. ✅ Analysis and insights completed
4. ✅ Recommendations made
5. ✅ Requirements extracted
6. ✅ Summary updated
7. ✅ Hub status updated
8. ✅ Changes committed

**Next step:** Use `/research [topic] --consolidate` when all research is complete, then `/decision [topic] --from-research`.

---

## Consolidate Mode Workflow (`--consolidate`)

**When to use:** After all research topics are complete, before the decision phase. Requirements accumulate incrementally across topics and sessions -- later topics often refine, supersede, or duplicate earlier ones. Consolidation is the quality gate between research and decisions.

**Why this matters:** Requirements extracted from Topic 1 might be stated vaguely because the answer wasn't yet known. By Topic 6, the same concept may be captured with precision. Without consolidation, the decision phase inherits noise: duplicates, contradictions, and gaps that force the decision-maker to do cleanup work that belongs in research.

### 1. Validate Pre-Conditions

**Checks:**

1. Research directory exists for topic
2. All topics in research hub are marked `✅ Complete`
3. If any topic is incomplete, warn: "Topic N is not complete. Consolidation works best after all topics are finished. Continue anyway? (y/n)"
4. `requirements.md` exists and has content

**Error Messages:**

| Situation | Message |
|-----------|---------|
| No research structure | "No research structure found for [topic]. Nothing to consolidate." |
| No requirements.md | "No requirements document found. Run `--conduct` to extract requirements first." |
| `--consolidate` + `--conduct` | "Error: --consolidate and --conduct are mutually exclusive." |
| `--consolidate` + `--add-topic` | "Error: --consolidate and --add-topic are mutually exclusive." |

---

### 2. Exploration Reconciliation

**Purpose:** Research often overturns, refines, or answers the exploration's open questions. Before cleaning up requirements, verify the exploration still reflects what research found. If it doesn't, the decision phase inherits stale framing.

**Process:**

1. Read `exploration.md` themes and key questions from the exploration directory
2. Read `research-summary.md` and completed topic documents
3. Cross-reference each theme against research findings:
   - Is the theme's framing still accurate?
   - Has research answered the theme's open questions?
   - Are the theme's concerns addressed or contradicted?
   - Is the spike determination table current (completed spikes, new candidates)?
4. Categorize discrepancies by severity:

| Severity | Meaning | Action |
|----------|---------|--------|
| **Mandatory** | Theme contradicted or overturned by research | Must amend before proceeding to decisions |
| **Recommended** | Theme significantly refined but not contradicted | Should amend for accuracy; skippable if time-constrained |

5. Present reconciliation report:

```markdown
## Exploration Reconciliation

### Mandatory (N items)
| Theme | Discrepancy | Research Source |
|-------|-------------|---------------|
| Theme N: [name] | [what's stale or wrong] | Topic N |

### Recommended (N items)
| Theme | Refinement | Research Source |
|-------|-----------|---------------|
| Theme N: [name] | [what's changed] | Topic N |

### Spike Table Updates
- N spikes completed since last exploration update
- N new spike candidates identified by research
```

6. **STOP and wait for human review**
7. User decides which items to address:
   - **Mandatory:** Run `/explore --amend` for each (or batch into a single amend)
   - **Recommended:** User decides -- amend now or note for later
   - **No items:** Skip -- proceed to requirements analysis
8. After amendments (if any), continue to Step 3

**Note:** This step is non-blocking. If the user chooses to skip all amendments, consolidation continues. The value is in surfacing discrepancies, not enforcing corrections.

---

### 3. Read All Artifacts

Read the following documents in full:

1. **`requirements.md`** -- all FRs, NFRs, Constraints, Assumptions
2. **`research-summary.md`** -- findings, insights, recommendations
3. **All topic documents** (`topic-*.md`) -- for cross-referencing sources and finding coverage gaps

Build a mental model of:
- Which topics produced which requirements
- Which requirements reference the same underlying concept
- Which findings led to recommendations that are NOT yet captured as requirements

---

### 4. Analyze Requirements

For each requirement, assess against these categories:

#### 3a. Redundancies (same concept stated multiple times)

Look for:
- Two FRs describing the same artifact or behavior from different angles
- An early-topic FR stated vaguely + a later-topic FR stated precisely (the later one supersedes)
- FRs that were "confirmed" by a later topic but also had a new FR added that says the same thing

**Action:** Merge into the more specific/complete version. Note which FR IDs were absorbed.

#### 3b. Superseded Items (later findings replaced earlier ones)

Look for:
- FRs whose descriptions use language from early topics that was refined by later topics
- FRs marked "AMENDED" or "REVISED" where the original is still present separately
- FRs that were extracted before a design decision was made, and the decision changed the requirement's scope

**Action:** Update or remove the superseded version. Keep the current understanding.

#### 3c. Gaps (research findings or recommendations not captured as requirements)

Look for:
- Recommendations in `research-summary.md` that have no corresponding FR
- Constraints or assumptions that imply requirements but none exist
- Template, doc-gen, or command changes identified in findings that lack an FR

**Action:** Add new FRs with clear source attribution.

#### 3d. Stale Descriptions (wording doesn't reflect current understanding)

Look for:
- FRs that reference "single document" when the tiered model was adopted later
- FRs with counts or specifics that changed (e.g., "9 commands" when the breakdown was refined)
- FRs that still reference concepts that were decided differently

**Action:** Update descriptions to reflect the current state of research.

#### 3e. Priority Adjustments

Look for:
- FRs marked Medium that are actually blocking (should be High)
- FRs marked High that are actually cleanup/polish (should be Medium or Low)
- FRs whose priority should change based on dependency ordering

**Action:** Adjust priorities with brief justification.

---

### 5. Present Analysis for Review

**CRITICAL: STOP and wait for human approval.**

Present the proposed changes in a structured summary:

```markdown
## Consolidation Proposal

### Merges (N items → M items)
| Action | Items | Kept | Rationale |
|--------|-------|------|-----------|
| Merge  | FR-X + FR-Y | FR-X (expanded) | FR-Y is a subset of FR-X |

### Removals (N items)
| Item | Rationale |
|------|-----------|
| FR-Z | Superseded by FR-W (later topic, more specific) |

### Additions (N new items)
| New ID | Name | Source | Rationale |
|--------|------|--------|-----------|
| FR-NN  | ... | Topic N finding | Gap: recommendation not captured |

### Modifications (N items)
| Item | Change | Rationale |
|------|--------|-----------|
| FR-A | Updated description | Reflects tiered model from Topic 3 |

### Priority Changes (N items)
| Item | Old | New | Rationale |
|------|-----|-----|-----------|
| FR-B | Medium | High | Blocking for template work |

### Counts: Before → After
- Functional Requirements: X → Y
- Non-Functional Requirements: X → Y
- Constraints: X → Y
- Assumptions: X → Y
```

**Wait for user to review and approve, modify, or reject changes.**

---

### 6. Apply Changes

After human approval:

1. **Apply merges:** Update the kept FR with expanded description; add "Absorbs FR-X" note to source
2. **Apply removals:** Remove the FR entry entirely (don't leave stubs)
3. **Apply additions:** Add new FRs at the end of the appropriate section with next available ID
4. **Apply modifications:** Update descriptions, priorities, sources
5. **Renumber if needed:** If removals create gaps, renumber to maintain sequential IDs. Update all cross-references in research documents that reference old FR numbers.
6. **Update `requirements.md` status:** Change from `Draft` to `Final`
7. **Update header counts:** Ensure the overview section reflects accurate counts

---

### 7. Update Research Summary

1. Update `research-summary.md` Requirements Summary section with new counts
2. Fix any stale checkboxes in Key Insights (e.g., items resolved by later topics still showing unchecked)
3. Update the Next Steps to indicate consolidation is complete

---

### 8. Commit

```bash
git add admin/research/[topic]/
git commit -m "docs(research): consolidate [topic] requirements

Reviewed N requirements across M categories:
- Merged: [list merged FRs]
- Removed: [list removed FRs]
- Added: [list new FRs]
- Modified: [list modified FRs]
- Final counts: X FRs, Y NFRs, Z Constraints, W Assumptions

Requirements status: Draft → Final"
```

---

### Consolidate Mode Output

**After consolidation, you should have:**

1. ✅ Exploration reconciled with research findings (mandatory/recommended items addressed)
2. ✅ All requirements reviewed for redundancy, gaps, and staleness
3. ✅ Human-approved changes applied
4. ✅ requirements.md status changed to Final
5. ✅ Research summary counts updated
6. ✅ Stale insights/checkboxes fixed
7. ✅ Changes committed

**Next step:** Use `/decision [topic] --from-research` -- the decision phase now receives clean, non-redundant requirements.

---

## Integration with Other Commands

### Research → Decision → Planning Flow

```
/explore [topic]                        ← Setup: scaffolding
    ↓ human review
/explore [topic] --conduct              ← Conduct: full exploration
    ↓
/research [topic] --from-explore        ← Setup: scaffold all topics
    ↓
/research [topic] --conduct --topic-num N  ← Conduct: research topics
    ↓ (new question from research?)
/explore [topic] --amend                ← Feedback: add theme + research topic
    ↓
/research [topic] --add-topic N         ← Add Topic: scaffold new topic
    ↓
/research [topic] --conduct --topic-num N  ← Conduct: research new topic
    ↓ (all topics complete)
/research [topic] --consolidate         ← Consolidate: review + clean requirements
    ↓ human review
/decision [topic] --from-research       ← Decisions: create ADRs
    ↓
/transition-plan --from-adr             ← Planning: create implementation plan
```

**Command Details:**

1. **`/research [topic] --from-explore [topic]`** - Setup research structure
   - Reads research topics from exploration
   - Creates research documents for all topics
   - Outputs: Research documents + `requirements.md`

2. **`/research [topic] --from-reflect [reflection-file]`** - Research from reflection
   - Reads opportunities from reflection
   - Creates research documents
   - Outputs: Research documents + `requirements.md`

3. **`/research [topic] --add-topic N`** - Scaffold late-arriving topic
   - Reads Topic N from `research-topics.md` (added by `/explore --amend`)
   - Scaffolds single topic document into existing research structure
   - Updates hub and summary
   - Outputs: New topic ready for `--conduct`

4. **`/decision [topic] --from-research`** - Make decisions
   - Reads research documents
   - Reads requirements document
   - Creates ADR documents
   - Outputs: ADR documents

5. **`/transition-plan --from-adr`** - Transition to planning
   - Reads ADR documents
   - Automatically reads requirements if they exist
   - Creates feature plan and phase documents
   - Outputs: Transition plan + Feature plan + Phase documents

---

## Common Scenarios

### Scenario 1: Setup from Exploration

**Situation:** Exploration identified research topics, need to create structure

**Action:**
```bash
/research auth-system --from-explore new-authentication-system
```

**Output:**
- Research hub created
- Research documents created (templates)
- Requirements skeleton created
- Ready for Conduct Mode

---

### Scenario 2: Setup from Reflection

**Situation:** Reflection identified opportunities needing research

**Action:**
```bash
/research ci-optimization --from-reflect reflection-project-2025-12-07.md
```

**Output:**
- Research hub created
- Research documents created (templates)
- Requirements skeleton created
- Ready for Conduct Mode

---

### Scenario 3: Conduct All Research

**Situation:** Research structure exists, ready to actually research

**Action:**
```bash
/research experimental-template --conduct
```

**Output:**
- All research documents filled in with findings
- Web searches conducted for each topic
- Analysis and recommendations completed
- Requirements extracted
- Summary updated
- Ready for decision phase

---

### Scenario 4: Conduct Single Topic

**Situation:** Want to research incrementally, one topic at a time

**Action:**
```bash
/research experimental-template --conduct --topic-num 1
# or
/research experimental-template --conduct --topic-name user-demand
```

**Output:**
- Single research document filled in
- Web searches conducted for that topic
- Findings, analysis, recommendations for that topic
- Hub status updated for that topic
- Continue with next topic when ready

---

### Scenario 5: Add Topic from Exploration Amendment

**Situation:** During research on workflow-simplification, a new question emerged about code ownership boundaries. `/explore --amend` was used to add Theme 5 and Topic 6 to the exploration. Now the research needs a scaffolded document for Topic 6.

**Action:**

```bash
/research workflow-simplification --add-topic 6
```

**Output:**
- `topic-6-dev-infra-code-boundary.md` scaffolded with template
- Research hub updated with new topic link
- Research summary updated with placeholder entry
- Ready for `--conduct --topic-num 6`

**Follow-up:**

```bash
/research workflow-simplification --conduct --topic-num 6
```

---

### Scenario 6: Consolidate Before Decisions

**Situation:** All 6 research topics are complete. Requirements were extracted incrementally across topics and sessions. Later topics (Topic 6) revised earlier requirements (from Topic 3). Some FRs are redundant, some descriptions are stale.

**Action:**

```bash
/research workflow-simplification --consolidate
```

**Output:**
- Analysis of all 30 FRs, 10 NFRs, 10 Constraints, 9 Assumptions
- Proposed merges (e.g., FR-22 + FR-30 → single FR), removals (e.g., FR-5 superseded), additions (e.g., missing rules file update FR), modifications (e.g., FR-1 updated for tiered model)
- Human reviews and approves changes
- Requirements renumbered, status changed to Final
- Ready for `/decision --from-research` with clean input

**Follow-up:**

```bash
/decision workflow-simplification --from-research
```

---

## Tips

### When to Use Each Mode

**Setup Mode:**
- After exploration identifies research topics
- After reflection identifies opportunities
- When you need research structure but not ready to research yet

**Conduct Mode:**
- When research structure already exists
- When ready to actually investigate topics
- When you have time for web searches and analysis

**Add Topic Mode:**
- After `/explore --amend` added a new research topic
- When a new question surfaced during research that warrants its own topic
- When the exploration was amended and research-topics.md has un-scaffolded topics

**Consolidate Mode:**
- After all research topics are complete, before `/decision`
- When research spanned multiple sessions (drift is likely)
- When later topics revised or superseded earlier topics
- When you want a clean, non-redundant requirements set for the decision phase

### Best Practices

- **Setup first, conduct later** - Create structure when planning, conduct when ready
- **Document sources** - Every finding needs a source reference
- **Use web search** - Required for Conduct Mode, ensures current information
- **Extract requirements** - Capture requirements as you research
- **Update summary** - Keep research summary current after each topic
- **Incremental progress** - Use `--topic-num` to research one topic at a time
- **Consolidate before deciding** - Run `--consolidate` after all topics are complete; accumulated requirements always have redundancies and gaps

---

## Reference

**Research Structure:**

- **Dev-Infra:** `admin/research/[topic]/`
- **Template Structure:** `docs/maintainers/research/[topic]/`
- **Project-Wide:** `docs/maintainers/research/[topic]/`
- Requirements: `[research-path]/[topic]/requirements.md`

**Related Commands:**

- `/explore` - Start exploration and identify research topics
- `/decision` - Make decisions based on research
- `/transition-plan` - Transition to feature planning

---

**Last Updated:** 2026-03-25  
**Status:** ✅ Active  
**Next:** Use Setup Mode to create structure, Conduct Mode to research, Consolidate Mode to clean up before decisions

