# Spike Command

Time-boxed experiment to validate technical assumptions before committing to implementation. Unlike research (which investigates options), a spike **builds something minimal** to prove an approach works.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Dev-Infra Structure (default):**
   - Explorations: `admin/explorations/[topic]/`
   - Spike learnings: `admin/explorations/[topic]/spike-learnings.md`
   - Spike code: `admin/explorations/[topic]/spike/`

2. **Template Structure (for generated projects):**
   - Explorations: `docs/maintainers/planning/explorations/[topic]/`
   - Spike learnings: `docs/maintainers/planning/explorations/[topic]/spike-learnings.md`
   - Spike code: `docs/maintainers/planning/explorations/[topic]/spike/`

3. **Lightweight Structure (no admin/ or docs/maintainers/):**
   - Spike learnings: `tests/tmp/explorations/[topic]/spike-learnings.md`
   - Spike code: `tests/tmp/explorations/[topic]/spike/`

**Auto-detection:**
- Check if `admin/explorations/` exists -> use dev-infra structure
- Check if `docs/maintainers/planning/explorations/` exists -> use template structure
- Otherwise -> use lightweight structure (gitignored temp folder)

**Topic Detection:**
- Use `--topic` option if provided
- If `--from-explore [topic]` provided, use that topic
- Otherwise, prompt user for topic name
- Sanitize topic name (kebab-case, no spaces)

---

## Workflow Overview

**When to use:**

- When technical uncertainty is high ("can it even work?")
- When hands-on validation is more efficient than desk research
- When getting it wrong would be costly to fix later
- When you need to test against a real environment (cluster, API, hardware)

**When NOT to use (use `/research` instead):**

- Comparing well-documented options
- Investigating best practices
- Low-risk, well-understood paths
- Questions of "what's the best way?" rather than "can it work?"

**Risk framework:** If a research topic has HIGH risk and the question is "will this work?", spike it. If the question is "what's the best way?", research it.

---

## Usage

**Command:** `/spike [topic] [options]`

**Examples:**

- `/spike auth-token-refresh` - Run a spike to validate token refresh approach
- `/spike auth-token-refresh --document-learnings` - Document learnings from completed spike
- `/spike auth-token-refresh --from-explore authentication-system` - Use exploration as context
- `/spike --dry-run` - Show what would be created without creating files

**Options:**

- `--from-explore [explore-topic]` - Read exploration for context and questions to validate
- `--document-learnings` - Document learnings from a completed spike (skip to Step 4)
- `--time-box [hours]` - Set time-box duration (default: 2-4 hours)
- `--dry-run` - Show what would be created without creating files
- `--force` - Overwrite existing spike learnings

---

## When to Spike vs Research

| Situation | Use Spike | Use Research |
|-----------|-----------|--------------|
| Technical uncertainty ("can it even work?") | Yes | |
| Architectural decision with high commitment | Yes | |
| User-facing UX that needs to be "felt" | Yes | |
| Need to test against a real environment | Yes | |
| Comparing well-documented options | | Yes |
| Investigating best practices | | Yes |
| Low-risk, well-understood path | | Yes |

### Risk Assessment Framework

During exploration, assess each topic against this matrix:

| Risk Level | Determination | Rationale |
|------------|---------------|-----------|
| HIGH | **Spike first** | Hard to pivot once committed |
| MEDIUM-HIGH | **Consider spike** | Benefits from hands-on validation |
| MEDIUM | Research only | Depends on other decisions |
| LOW | Research only | Clear path, low risk |

---

## Output Location

Spike output goes alongside the exploration (or in a gitignored temp folder for lightweight projects).

**Creates:**

```
explorations/[topic]/
  exploration.md           - (existing, from /explore)
  research-topics.md       - (existing, from /explore)
  spike-learnings.md       - Learnings from the spike (NEW)
  spike/                   - Throwaway spike code (NEW, optional)
    [prototype files]
```

---

## Step-by-Step Process

### 1. Identify Questions to Validate

Read the exploration and research topics (if available). Identify questions where:

- The answer is "can it work?" not "what's best?"
- There is technical uncertainty
- Hands-on validation is more efficient than desk research
- Getting it wrong would be costly to fix later

**From exploration, extract:**

- Specific technical questions to answer
- Edge cases to test
- Success criteria (what proves the approach works?)

**If `--from-explore` is provided:**

1. Read `explorations/[explore-topic]/exploration.md`
2. Read `explorations/[explore-topic]/research-topics.md`
3. Extract high-risk topics flagged for spiking
4. Use as context for defining spike scope

**Checklist:**

- [ ] Questions to validate identified
- [ ] Edge cases listed
- [ ] Success criteria defined

---

### 2. Define Success Criteria

Before building anything, state clearly what must be true for the spike to succeed.

**Output (displayed to user, then included in spike-learnings.md):**

```markdown
## Success Criteria

- [ ] Criterion 1: [What must be true for this approach to work?]
- [ ] Criterion 2: [What edge case must be handled?]
- [ ] Criterion 3: [What performance/behavior is acceptable?]
```

**Checklist:**

- [ ] Success criteria defined before building
- [ ] Criteria are specific and testable
- [ ] Time-box duration agreed (default: 2-4 hours)

---

### 3. Build Minimal Prototype

**Key principles:**

- **Throwaway mindset:** Code may be discarded. Don't polish.
- **Minimal scope:** Only build enough to answer the questions.
- **Real environment:** Test against actual infrastructure, not just theory.
- **Time-boxed:** Stop when time runs out, document what you learned regardless.

**Guidance for the spike:**

1. Set a timer (2-4 hours, or value from `--time-box`)
2. Build the minimum to answer your questions
3. Don't polish -- throwaway mindset
4. Stop when timer ends -- even if incomplete
5. Document as you go (notes, screenshots, error messages)

**Spike code location:**

- **Dev-Infra:** `admin/explorations/[topic]/spike/`
- **Template:** `docs/maintainers/planning/explorations/[topic]/spike/`
- **Lightweight:** `tests/tmp/explorations/[topic]/spike/`

**Note:** This step is primarily human-driven. The AI assists with:
- Setting up the spike directory
- Creating boilerplate/scaffolding if needed
- Helping debug during the spike
- Taking notes on findings as you go

**Checklist:**

- [ ] Timer set
- [ ] Spike directory created (if needed)
- [ ] Prototype built (or time expired)
- [ ] Notes captured during spike

---

### 4. Document Learnings

After the spike (or when time-box expires), create `spike-learnings.md`.

**Use `--document-learnings` to skip directly to this step** if you've already completed the spike and just need to document.

**File:** `explorations/[topic]/spike-learnings.md`

```markdown
# Spike Learnings: [Topic Title]

**Exploration:** [path to exploration directory]
**Created:** YYYY-MM-DD
**Time-box:** [X] hours
**Result:** [Validated | Partially Validated | Failed | Pivoted]

---

## Questions Answered

- [x] Q1: [Question] -- [Answer with evidence]
- [x] Q2: [Question] -- [Answer with evidence]
- [ ] Q3: [Question] -- [Not answered, needs research]

---

## Key Findings

### Finding 1: [Title]

[What we learned. Include specific evidence -- error messages, behavior observed, etc.]

### Finding 2: [Title]

[What surprised us or differed from expectations.]

---

## Edge Cases Tested

| Case | Input | Expected | Actual | Pass? |
|------|-------|----------|--------|-------|
| [Case 1] | [Input] | [Expected] | [Actual] | Yes/No |
| [Case 2] | [Input] | [Expected] | [Actual] | Yes/No |

---

## Go / No-Go

**Recommendation:** [Go | No-Go | Go with modifications]

**Rationale:** [Why this approach should or should not be used]

**Modifications needed (if any):**
- [Modification 1]
- [Modification 2]

---

## Refined Questions

New questions revealed by this spike (feed back to research):

1. [New question 1]
2. [New question 2]

---

## Spike Code

**Location:** [path to spike/ directory]
**Keep or discard:** [Keep as reference | Discard | Refactor into implementation]

---

## Next Steps

- [ ] [Next action based on findings]
- [ ] [Feed refined questions to /research if needed]
- [ ] [Proceed to /decision or /transition-plan if validated]
```

**Checklist:**

- [ ] spike-learnings.md created
- [ ] Questions answered with evidence
- [ ] Key findings documented
- [ ] Edge cases recorded
- [ ] Go/No-Go recommendation made
- [ ] Refined questions captured
- [ ] Next steps identified

---

### 5. Commit Changes

**IMPORTANT:** Always commit work before completing command.

**Since spikes produce documentation artifacts:**

```bash
git add explorations/[topic]/spike-learnings.md
# Only add spike/ code if it should be tracked (usually gitignored)
git commit -m "docs(spike): document [topic] spike learnings

Result: [Validated | Partially Validated | Failed | Pivoted]
Time-box: [X] hours

Key findings:
- [Finding 1]
- [Finding 2]

Recommendation: [Go | No-Go | Go with modifications]"
```

**Note:** Spike code in `spike/` is typically throwaway and may not need committing. The `spike-learnings.md` is the valuable artifact.

---

## Integration

```
/explore [topic]           <- Organize thoughts, identify themes
    |
    |  (explore output includes spike determination table)
    |
/spike [topic]             <- Validate high-risk assumptions (this command)
    |                         (optional, when technical uncertainty is high)
    |
/research --from-explore   <- Investigate remaining questions
    |                         (spike learnings inform research)
    |
/decision --from-research  <- Make decisions (ADRs)
    |                         (decisions backed by spikes have HIGH confidence)
    |
/transition-plan           <- Create implementation plan
```

**Note:** Spikes and research are iterative. A spike may reveal new questions that need research, and research may identify areas that benefit from a spike.

### Reading Spike Learnings in Downstream Commands

When `/research` or `/decision` is invoked with `--from-explore`:

1. Check for `spike-learnings.md` in the exploration directory
2. If present, read and incorporate findings
3. Mark spike-validated topics as high-confidence
4. Feed refined questions into research topics

---

## Common Scenarios

### Scenario 1: Spike from Exploration

**Situation:** Exploration identified a high-risk topic that needs validation.

**Action:**

```bash
/spike auth-token-refresh --from-explore authentication-system
```

**Output:**
- Reads exploration context and research topics
- Identifies questions to validate
- Defines success criteria
- Guides spike execution
- Creates spike-learnings.md

---

### Scenario 2: Standalone Spike

**Situation:** Quick technical question without prior exploration.

**Action:**

```bash
/spike websocket-reconnection
```

**Output:**
- Creates spike directory structure
- Defines questions and success criteria
- Guides spike execution
- Creates spike-learnings.md

---

### Scenario 3: Document After Manual Spike

**Situation:** You already ran the spike manually and want to document learnings.

**Action:**

```bash
/spike auth-token-refresh --document-learnings
```

**Output:**
- Prompts for learnings interactively
- Creates spike-learnings.md from your input
- Captures Go/No-Go recommendation

---

### Scenario 4: Time-Boxed Spike

**Situation:** Strict time constraint for the experiment.

**Action:**

```bash
/spike database-migration --time-box 1 --from-explore data-layer-redesign
```

**Output:**
- Sets 1-hour time-box
- Same workflow but emphasizes stopping at time limit
- Documents whatever was learned within the time

---

## Tips

### Best Practices

- **Define success criteria BEFORE building** -- prevents scope creep
- **Throwaway mindset** -- don't polish spike code
- **Stop when time expires** -- partial answers are still valuable
- **Document as you go** -- don't rely on memory after the spike
- **Test in real environments** -- theory isn't validation

### Spike vs Prototype vs POC

| Term | Duration | Quality | Purpose |
|------|----------|---------|---------|
| **Spike** | 2-4 hours | Throwaway | Answer "can it work?" |
| **Prototype** | Days | Demo quality | Show "how it could work" |
| **POC** | Weeks | Near-production | Prove "it does work at scale" |

This command is for **spikes** -- the quickest, most focused validation.

---

## Reference

**Spike Structure:**

- **Dev-Infra:** `admin/explorations/[topic]/spike-learnings.md`
- **Template Structure:** `docs/maintainers/planning/explorations/[topic]/spike-learnings.md`
- **Lightweight:** `tests/tmp/explorations/[topic]/spike-learnings.md`
- Spike code: `[explorations-path]/[topic]/spike/`

**Related Commands:**

- `/explore` - Start exploration and identify spike candidates (includes spike determination)
- `/research` - Conduct research on topics (spike learnings inform research)
- `/decision` - Make decisions based on research (spike-backed decisions are high-confidence)
- `/transition-plan` - Transition to feature planning

---

**Last Updated:** 2026-02-13
**Status:** ✅ Active
**Next:** Use after /explore identifies high-risk topics needing hands-on validation
