# Reflection & Suggestions Command

Analyze project state, recent work, and patterns to provide actionable suggestions and insights. Particularly useful after development cycles to identify opportunities, potential issues, and improvements.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Feature-Specific Structure (default):**

   - Status: `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`
   - Reflections: `docs/maintainers/planning/features/[feature-name]/reflections/reflection-*.md`
   - Fix tracking: `docs/maintainers/planning/features/[feature-name]/fix/README.md`

2. **Project-Wide Structure:**
   - Status: `docs/maintainers/planning/status-and-next-steps.md` (if exists)
   - Reflections: `docs/maintainers/planning/notes/reflections/reflection-*.md`
   - Fix tracking: `docs/maintainers/planning/fix/README.md` (if exists)

**Feature Detection:**

- Use `--feature` option if provided
- Otherwise, auto-detect:
  - Check if `docs/maintainers/planning/features/` exists
  - If single feature exists, use that feature name
  - If multiple features exist, search for status documents in each
  - If no features exist, use project-wide structure

**Learnings Paths:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/learnings/` (if exists)
- Project-wide: `docs/maintainers/planning/notes/learnings/` (if exists)
- Opportunities: `docs/maintainers/planning/opportunities/internal/` (if exists)

---

## Workflow Overview

**When to use:**

- After completing a phase or development cycle
- Before starting new work (to identify opportunities)
- When feeling stuck or unsure of next steps
- To get fresh perspective on project state
- After significant changes or refactoring

**Key principle:** Provide thoughtful analysis and actionable suggestions based on current project state, patterns, and best practices.

---

## Usage

**Command:** `/reflect [scope] [options]`

**Examples:**

- `/reflect` - Full project reflection (default)
- `/reflect --recent` - Focus on recent work (last 7 days)
- `/reflect --phase` - Reflect on current phase
- `/reflect --workflow` - Analyze workflow efficiency
- `/reflect --code-quality` - Focus on code quality patterns
- `/reflect --documentation` - Review documentation completeness
- `/reflect --technical-debt` - Identify technical debt
- `/reflect --feature my-feature` - Specify feature name

**Options:**

- `--recent DAYS` - Focus on work from last N days (default: 7)
- `--scope SCOPE` - Focus area (phase, workflow, code-quality, documentation, technical-debt)
- `--feature [name]` - Specify feature name (overrides auto-detection)
- `--include-fixes` - Include deferred fixes in analysis
- `--include-learnings` - Reference phase learnings (single phase or latest)
- `--include-learnings all` - Include learnings from all phases, identify common patterns
- `--actionable-only` - Only show actionable suggestions

---

## Step-by-Step Process

### 1. Analyze Recent Work

**Gather context:**

1. **Recent commits:**

   ```bash
   git log --since="7 days ago" --oneline --all
   ```

2. **Recent PRs:**

   ```bash
   gh pr list --state merged --limit 10
   ```

3. **Current phase/feature status:**

   - Feature-specific: Read `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`
   - Project-wide: Read `docs/maintainers/planning/status-and-next-steps.md` (if exists)
   - Check current phase completion
   - Review next steps

4. **Recent learnings:**
   - If `--include-learnings` (single): Check latest phase learnings document (if exists)
   - If `--include-learnings all`: Read all phase learnings for feature (if feature detected)
   - Review improvement documents (if exists)

**When `--include-learnings all` is used:**

1. **Detect feature name:**

   - From `--feature` flag (if provided)
   - From git branch name
   - From current directory context
   - From feature status document

2. **Find all phase learnings:**

   - Check `admin/planning/opportunities/internal/[project]/learnings/[feature-name]/` (feature-grouped)
   - Check `admin/planning/opportunities/internal/[project]/learnings/` for `[feature-name]-phase-*-learnings.md` (legacy)
   - Read all phase learnings documents

3. **Identify common patterns:**
   - Group similar "What Worked Well" observations
   - Group similar "What Needs Improvement" observations
   - Group similar "Unexpected Discoveries"
   - Identify recurring issues across phases
   - Note patterns that appear in multiple phases

**Checklist:**

- [ ] Recent commits analyzed
- [ ] Recent PRs reviewed
- [ ] Current phase/feature status checked
- [ ] Learnings reviewed (single or all phases, if requested)
- [ ] Common patterns identified (if `--include-learnings all`)

---

### 2. Analyze Project Patterns

**Identify patterns:**

1. **Development patterns:**

   - TDD adoption
   - Code review practices
   - Testing coverage trends
   - Documentation updates

2. **Workflow patterns:**

   - PR creation frequency
   - Fix batch implementation
   - Documentation updates
   - Command usage

3. **Code patterns:**

   - Repeated code structures
   - Common issues in reviews
   - Architecture consistency
   - Test patterns

4. **Documentation patterns:**
   - Documentation completeness
   - Update frequency
   - Hub-spoke structure usage
   - Learnings capture

**Checklist:**

- [ ] Development patterns identified
- [ ] Workflow patterns analyzed
- [ ] Code patterns reviewed
- [ ] Documentation patterns assessed

---

### 3. Identify Opportunities

**Look for:**

1. **Quick wins:**

   - Low-hanging fruit
   - Easy improvements
   - Accumulated small issues
   - Documentation gaps

2. **Efficiency improvements:**

   - Workflow bottlenecks
   - Repeated manual steps
   - Missing automation
   - Process improvements

3. **Quality improvements:**

   - Test coverage gaps
   - Code quality issues
   - Documentation gaps
   - Technical debt

4. **Strategic opportunities:**
   - Feature improvements
   - Architecture enhancements
   - Tool integrations
   - Process optimizations

**Checklist:**

- [ ] Quick wins identified
- [ ] Efficiency opportunities found
- [ ] Quality improvements noted
- [ ] Strategic opportunities considered

---

### 4. Identify Potential Issues

**Look for:**

1. **Risks:**

   - Technical debt accumulation
   - Documentation drift
   - Process inconsistencies
   - Missing tests

2. **Bottlenecks:**

   - Workflow friction
   - Repeated issues
   - Manual processes
   - Knowledge gaps

3. **Inconsistencies:**

   - Code style variations
   - Process deviations
   - Documentation gaps
   - Pattern inconsistencies

4. **Dependencies:**
   - Blocking issues
   - Prerequisites missing
   - Integration concerns
   - Resource constraints

**Checklist:**

- [ ] Risks identified
- [ ] Bottlenecks found
- [ ] Inconsistencies noted
- [ ] Dependencies reviewed

---

### 5. Generate Suggestions

**Organize suggestions by:**

1. **Priority:**

   - 🔴 **High Priority** - Address soon
   - 🟡 **Medium Priority** - Consider soon
   - 🟢 **Low Priority** - Nice to have

2. **Category:**

   - **Workflow** - Process improvements
   - **Code Quality** - Code improvements
   - **Documentation** - Documentation updates
   - **Architecture** - Structural improvements
   - **Testing** - Test improvements
   - **Tooling** - Tool/automation improvements

3. **Effort:**
   - **Quick** - < 1 hour
   - **Moderate** - 1-4 hours
   - **Significant** - 1+ days

**Suggestion format:**

```markdown
### [Category]: [Suggestion Title]

**Priority:** [Priority Level]  
**Effort:** [Effort Level]  
**Impact:** [Impact Description]

**Context:**
[Why this suggestion matters, what pattern/issue it addresses]

**Suggestion:**
[Specific actionable suggestion]

**Benefits:**

- Benefit 1
- Benefit 2

**Next Steps:**

1. Step 1
2. Step 2

**Related:**

- [Related documentation]
- [Related issues/PRs]
```

**Checklist:**

- [ ] Suggestions prioritized
- [ ] Categories assigned
- [ ] Effort estimated
- [ ] Actionable steps provided

---

### 6. Generate Reflection Report

**IMPORTANT:** Reflection files must be saved to the `reflections/` subdirectory:

**File Location:**

**IMPORTANT:** For dev-infra, all reflections are centralized in `admin/planning/notes/reflections/` regardless of whether they're feature-specific or CI/CD-specific. This ensures all reflections are in one place for easy discovery and maintenance.

- **Centralized (dev-infra):** `admin/planning/notes/reflections/reflection-[topic]-[date].md`
- **Feature-specific (templates):** `docs/maintainers/planning/features/[feature-name]/reflections/reflection-[scope]-[date].md`
- **Project-wide (templates):** `docs/maintainers/planning/notes/reflections/reflection-[scope]-[date].md`
- **Alternative:** `docs/maintainers/planning/reflections/reflection-[scope]-[date].md`

**Examples:**

- CI/CD reflection (dev-infra): `admin/planning/notes/reflections/reflection-template-generation-testing-automation-2025-12-08.md`
- Feature reflection (dev-infra): `admin/planning/notes/reflections/reflection-templates-enhancement-2025-12-08.md`
- Feature reflection (templates): `docs/maintainers/planning/features/my-feature/reflections/reflection-phase6-2025-12-06.md`
- Full project (templates): `docs/maintainers/planning/notes/reflections/reflection-2025-12-06.md`

**Report structure:**

```markdown
# Project Reflection - [Date]

**Scope:** [Full Project / Recent Work / Phase / etc.]  
**Period:** [Time period analyzed]  
**Generated:** [Date]

---

## 📊 Current State

### Recent Activity

- **Commits:** [N] commits in last [N] days
- **PRs Merged:** [N] PRs
- **Current Phase/Feature:** [Phase/Feature name] ([Status])
- **Test Coverage:** [X]% (if available)
- **Documentation:** [Status]

### Key Metrics

- **Phases Complete:** [X]/[Y] ([Z]%) (if applicable)
- **Fixes Implemented:** [N] (if applicable)
- **Deferred Issues:** [N] (if applicable)
- **Learnings Captured:** [N] phases (if applicable)

---

## ✅ What's Working Well

### [Category 1]

**Pattern:** [What pattern is working]
**Evidence:** [What shows it's working]
**Recommendation:** [Keep doing this]

### [Category 2]

[Similar format]

---

## 🟡 Opportunities for Improvement

### [Category 1]

**Issue:** [What could be better]
**Impact:** [Why it matters]
**Suggestion:** [How to improve]
**Effort:** [Estimated effort]

### [Category 2]

[Similar format]

---

## 🔴 Potential Issues

### [Issue 1]

**Risk:** [What the risk is]
**Impact:** [Potential impact]
**Mitigation:** [How to address]
**Priority:** [Priority level]

### [Issue 2]

[Similar format]

---

## 💡 Actionable Suggestions

### High Priority

#### [Suggestion Title]

**Category:** [Category]  
**Priority:** 🔴 High  
**Effort:** [Effort]

**Suggestion:**
[Detailed suggestion]

**Benefits:**

- Benefit 1
- Benefit 2

**Next Steps:**

1. [Action 1]
2. [Action 2]

**Related:**

- [Related items]

---

### Medium Priority

[Similar format for medium priority suggestions]

---

### Low Priority

[Similar format for low priority suggestions]

---

## 🎯 Recommended Next Steps

1. **Immediate (This Week):**

   - [Action 1]
   - [Action 2]

2. **Short-term (Next 2 Weeks):**

   - [Action 1]
   - [Action 2]

3. **Long-term (Next Month):**
   - [Action 1]
   - [Action 2]

---

## 📈 Trends & Patterns

### Positive Trends

- [Trend 1]
- [Trend 2]

### Areas of Concern

- [Concern 1]
- [Concern 2]

### Emerging Patterns

- [Pattern 1]
- [Pattern 2]

---

## 🔍 Cross-Phase Learnings (if --include-learnings all)

**When `--include-learnings all` is used, include this section:**

### Recurring Successes

**Patterns that worked well across multiple phases:**

#### [Pattern Name]

**Phases:** Phase 1, Phase 2, Phase 4  
**Frequency:** 3/5 phases

**Observation:**
[Common observation across phases]

**Why it's valuable:**
[Why this pattern is important]

**Recommendation:**
[How to leverage this pattern]

---

### Persistent Issues

**Issues mentioned in multiple phases:**

#### [Issue Name]

**Phases:** Phase 2, Phase 4, Phase 5  
**Frequency:** 3/5 phases  
**Priority:** 🔴 High (recurring issue)

**Issue:**
[Common issue description]

**Impact:**
[How this affects development]

**Suggested Solution:**
[How to address this recurring issue]

**Related Phases:**

- Phase 2: [Brief note]
- Phase 4: [Brief note]
- Phase 5: [Brief note]

---

### Emerging Patterns

**Patterns that become clearer across phases:**

#### [Pattern Name]

**Evolution:**

- Phase 1: [Initial observation]
- Phase 3: [Refinement]
- Phase 5: [Clear pattern]

**Insight:**
[What this pattern reveals]

**Action:**
[What to do with this insight]

---

**Last Updated:** [Date]  
**Next Reflection:** [Suggested date]
```

**After creating reflection:**

- Update reflections README if exists:
  - Feature-specific: `docs/maintainers/planning/features/[feature-name]/reflections/README.md`
  - Project-wide: `docs/maintainers/planning/notes/reflections/README.md`
- Add to appropriate section (Project-Wide or Feature-Specific)

**Checklist:**

- [ ] Report generated
- [ ] File saved to `reflections/` subdirectory
- [ ] Reflections README updated with link (if exists)
- [ ] Current state analyzed
- [ ] Opportunities identified
- [ ] Issues noted
- [ ] Suggestions prioritized
- [ ] Next steps recommended

---

### 8. Commit and Push Changes

**IMPORTANT:** Always commit work before completing command.

**Reference:** [Commit Workflow](../../docs/COMMIT-WORKFLOW.md) - Central commit workflow documentation, especially [Documentation/Chore Branches](../../docs/COMMIT-WORKFLOW.md#documentationchore-branches) section

**Since reflections are documentation-only, use docs-only workflow:**

**Branch naming:**

- Format: `docs/reflect-[feature]-[date]` or `docs/reflect-[scope]-[date]` (e.g., `docs/reflect-templates-enhancement-2025-12-08`)

**Steps:**

1. **Check current branch:**

   ```bash
   git branch --show-current
   ```

2. **Create docs branch (if not already on one):**

   ```bash
   git checkout -b docs/reflect-[feature]-[date]
   ```

3. **Stage all changes:**

   ```bash
   git add docs/maintainers/planning/notes/reflections/  # or feature-specific path
   ```

4. **Commit with proper message:**

   ```bash
   git commit -m "docs(reflection): create [feature] reflection

   Created reflection document:
   - Analyzed [scope/period]
   - Identified patterns and opportunities
   - Provided actionable suggestions

   Related: [Feature or context]"
   ```

5. **Push branch:**

   ```bash
   git push origin docs/reflect-[feature]-[date]
   ```

6. **Merge directly to develop (docs-only, no PR needed):**

   ```bash
   git checkout develop
   git pull origin develop
   git merge docs/reflect-[feature]-[date] --no-edit
   git push origin develop
   ```

7. **Clean up branch:**

   ```bash
   git branch -d docs/reflect-[feature]-[date]
   git push origin --delete docs/reflect-[feature]-[date]
   ```

8. **Verify no uncommitted changes:**
   ```bash
   git status --short
   ```

---

## Common Scenarios

### Scenario 1: Post-Phase Reflection

**Situation:** Just completed Phase 4, want to reflect on progress

**Action:**

```bash
/reflect --phase --include-learnings
```

**Output:**

- Phase completion analysis
- What worked well
- What could improve
- Suggestions for next phase
- Reference to phase learnings (if available)

---

### Scenario 1b: Cross-Phase Reflection

**Situation:** Completed multiple phases, want to identify common patterns

**Action:**

```bash
/reflect --feature templates-enhancement --include-learnings all
```

**Output:**

- Analysis of all phases
- Common patterns identified
- Recurring successes highlighted
- Persistent issues prioritized
- Cross-phase insights documented

---

### Scenario 2: Workflow Efficiency Review

**Situation:** Want to improve development workflow

**Action:**

```bash
/reflect --workflow --recent 14
```

**Output:**

- Workflow bottlenecks identified
- Process improvements suggested
- Automation opportunities
- Efficiency gains possible

---

### Scenario 3: Technical Debt Review

**Situation:** Want to identify and address technical debt

**Action:**

```bash
/reflect --technical-debt --include-fixes
```

**Output:**

- Technical debt identified
- Deferred fixes reviewed (if applicable)
- Prioritization suggestions
- Action plan for addressing

---

### Scenario 4: Full Project Reflection

**Situation:** Want comprehensive project analysis

**Action:**

```bash
/reflect
```

**Output:**

- Complete project state analysis
- All categories reviewed
- Comprehensive suggestions
- Strategic recommendations

---

## Tips

### When to Reflect

- **After each phase** - Capture learnings while fresh
- **Before major decisions** - Get perspective
- **When stuck** - Fresh ideas
- **Monthly** - Regular health check

### What to Focus On

- **Patterns** - What's repeated?
- **Gaps** - What's missing?
- **Friction** - What's slowing you down?
- **Opportunities** - What could be better?

### Using Suggestions

- **Prioritize** - Focus on high-impact, low-effort first
- **Batch** - Group related suggestions
- **Track** - Document which suggestions you implement
- **Review** - Revisit suggestions periodically

---

## Reference

**Project State:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/status-and-next-steps.md`
- Project-wide: `docs/maintainers/planning/status-and-next-steps.md` (if exists)
- Fix tracking: `docs/maintainers/planning/features/[feature-name]/fix/README.md` (if exists)

**Recent Work:**

- `git log --since="7 days ago"`
- `gh pr list --state merged`

**Learnings:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/learnings/` (if exists)
- Project-wide: `docs/maintainers/planning/notes/learnings/` (if exists)
- Opportunities: `docs/maintainers/planning/opportunities/internal/` (if exists)
- Feature-grouped phase learnings: `admin/planning/opportunities/internal/[project]/learnings/[feature-name]/phase-N-learnings.md` (new format)
- Legacy phase learnings: `admin/planning/opportunities/internal/[project]/learnings/[feature-name]-phase-N-learnings.md` (legacy format)

**Related Commands:**

- `/int-opp` - Capture learnings (complementary to reflect, if available)
- `/fix-review` - Review deferred issues (if available)
- `/reflection-artifacts` - Extract planning artifacts from reflection (if available)

---

**Last Updated:** 2025-12-07  
**Status:** ✅ Active  
**Next:** Use after development cycles for fresh perspective and actionable suggestions (supports feature-specific and project-wide structures)
