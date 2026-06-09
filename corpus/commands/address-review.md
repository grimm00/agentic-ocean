# Address Review Command

Use this command to address gaps identified in a pre-phase review document. Updates phase documents with recommended changes without starting implementation.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Feature-Specific Structure (default):**
   - Phase documents: `docs/maintainers/planning/features/[feature-name]/phase-N.md`
   - Review documents: `docs/maintainers/planning/features/[feature-name]/phase-N-review.md`

2. **Project-Wide Structure:**
   - Phase documents: `docs/maintainers/planning/phases/phase-N.md`
   - Review documents: `docs/maintainers/planning/phases/phase-N-review.md`

**Feature Detection:**

- Use `--feature` option if provided
- Otherwise, auto-detect from review document path or context

---

## Workflow Overview

**When to use:**

- After `/pre-phase-review` identifies gaps
- Before starting implementation with `/task-phase`
- To update phase documents with missing details
- To resolve blockers identified in review

**Key principle:** Separate planning/documentation updates from implementation. Address gaps first, then implement.

**Workflow Sequence:**

```
1. /pre-phase-review [N]     → Identifies gaps, creates review doc
2. /address-review [path]    → Addresses gaps, updates phase doc  ← This command
3. /task-phase [N] [task]    → Implements the work
```

---

## Usage

**Command:** `/address-review [review-path] [options]`

**Examples:**

- `/address-review phase-5-review.md` - Address gaps from Phase 5 review
- `/address-review admin/services/[service]/features/release-readiness/phase-5-review.md` - Full path
- `/address-review --phase 5 --feature release-readiness` - Auto-detect review path
- `/address-review phase-5-review.md --dry-run` - Show changes without applying

**Options:**

- `--phase NUMBER` - Phase number (used with --feature to auto-detect review path)
- `--feature [name]` - Feature name (overrides auto-detection)
- `--dry-run` - Show what would be changed without applying
- `--skip [items]` - Skip specific action items (comma-separated)
- `--interactive` - Prompt for each action item

---

## Step-by-Step Process

### 1. Load Review Document

**Locate review document:**

```bash
# From path argument
cat [review-path]

# Or auto-detect from --phase and --feature
# Feature-specific: docs/maintainers/planning/features/[feature]/phase-N-review.md
# Project-wide: docs/maintainers/planning/phases/phase-N-review.md
```

**Verify review exists:**

- [ ] Review document found
- [ ] Review document is readable
- [ ] Review status is not "✅ Ready" (already addressed)

**If review already addressed:**

```
ℹ️  Review already marked as addressed (Status: ✅ Ready)
    
    Options:
    1. Run /task-phase to start implementation
    2. Use --force to re-process review
```

**Checklist:**

- [ ] Review document found
- [ ] Review document readable
- [ ] Review needs addressing (not already done)

---

### 2. Parse Review Findings

**Extract from review document:**

1. **Blockers Section:**
   - Items marked as blockers
   - Must be resolved before implementation
   - Parse checkbox status (addressed or not)

2. **Action Items Section:**
   - Checklist items to address
   - Parse checkbox status
   - Extract item descriptions

3. **Recommendations Section:**
   - Before Implementation recommendations
   - Suggested content to add
   - Code snippets/examples

4. **Recommended Phase Document Updates:**
   - Specific content to add
   - Pre-formatted markdown sections
   - Implementation details

**Example parsing:**

```markdown
## Blockers:
- [ ] Metadata schema must be defined before Task 1
- [ ] Effort estimates should be added to phase document

## Action Items:
- [ ] Add effort estimates to phase-5.md
- [ ] Define YAML metadata schema
```

**Checklist:**

- [ ] Blockers extracted
- [ ] Action items extracted
- [ ] Recommendations extracted
- [ ] Recommended updates extracted

---

### 3. Display Findings Summary

**Present to user:**

```markdown
## Review Findings Summary

**Review:** [review-path]
**Status:** 🟡 Needs Work

### Blockers (2)
1. [ ] Metadata schema must be defined before Task 1
2. [ ] Effort estimates should be added to phase document

### Action Items (6)
1. [ ] Add effort estimates to phase-5.md
2. [ ] Define YAML metadata schema
3. [ ] Specify analysis script language and output format
4. [ ] Define storage location convention
5. [ ] Create test data requirements
6. [ ] Update phase document with implementation details

### Recommended Updates
- Implementation Details section (metadata schema, storage location, etc.)

**Proceed with addressing these items? (Y/n)**
```

**If `--dry-run`:**

- Show findings summary
- Show what would be changed
- Do not apply changes
- Exit

**Checklist:**

- [ ] Findings displayed
- [ ] User confirmation received (if not --dry-run)

---

### 4. Load Phase Document

**Locate phase document:**

- Parse from review document (usually in same directory)
- Or use `--phase` and `--feature` options
- Feature-specific: `docs/maintainers/planning/features/[feature]/phase-N.md`
- Project-wide: `docs/maintainers/planning/phases/phase-N.md`

**Read phase document:**

- Parse existing content
- Identify sections to update
- Prepare for modifications

**Checklist:**

- [ ] Phase document found
- [ ] Phase document readable
- [ ] Ready for updates

---

### 5. Apply Recommended Updates

**For each action item:**

1. **Effort Estimates:**
   - Add/update effort estimates in task headers
   - Add total estimate to phase header
   - Format: `(~X hours)` or `(~X min)`

2. **Implementation Details:**
   - Add new "📋 Implementation Details" section if missing
   - Include metadata schema, storage location, script details, etc.
   - Use content from "Recommended Phase Document Updates"

3. **Prerequisites Update:**
   - Update prerequisites status (e.g., "Phase 4 Complete ✅")

4. **Deliverables Update:**
   - Add specific deliverables based on recommendations

5. **Task Details:**
   - Add technical details to task descriptions
   - Clarify TDD approach

**Apply order:**

1. Header fields (status, estimates, dates)
2. Tasks section (effort estimates, details)
3. Implementation Details section (new or update)
4. Deliverables section
5. Last Updated field

**Checklist:**

- [ ] Effort estimates added
- [ ] Implementation details added
- [ ] Prerequisites updated
- [ ] Deliverables updated
- [ ] Last Updated refreshed

---

### 6. Update Review Document

**Mark items as addressed:**

```markdown
## Blockers:
- [x] Metadata schema must be defined before Task 1 ✅ Addressed 2025-12-10
- [x] Effort estimates should be added to phase document ✅ Addressed 2025-12-10

## Action Items:
- [x] Add effort estimates to phase-5.md ✅ Addressed 2025-12-10
- [x] Define YAML metadata schema ✅ Addressed 2025-12-10
```

**Update review status:**

```markdown
**Status:** ✅ Ready
**Reviewed:** 2025-12-10
**Gaps Addressed:** 2025-12-10
```

**Add addressed note:**

```markdown
**Addressed via:** `/address-review` command
**Ready to Start:** ✅ Yes - all blockers resolved
```

**Checklist:**

- [ ] Blockers marked as addressed
- [ ] Action items marked as addressed
- [ ] Review status updated to Ready
- [ ] Addressed date added

---

### 7. Commit Changes

**Create docs branch:**

```bash
git checkout -b docs/address-review-phase-N
```

**Stage and commit:**

```bash
git add [phase-document] [review-document]
git commit -m "docs(phase-N): address pre-phase review gaps

Addressed action items from phase-N-review.md:
- Added effort estimates (~X hours total)
- Defined implementation details (metadata schema, storage, etc.)
- Updated prerequisites and deliverables
- Marked review status as Ready

Ready for implementation via /task-phase.

Related: Phase N - [Feature Name]"
```

**Merge to develop:**

```bash
git checkout develop
git merge docs/address-review-phase-N --no-edit
git push origin develop
git branch -d docs/address-review-phase-N
```

**Checklist:**

- [ ] Docs branch created
- [ ] Changes committed
- [ ] Merged to develop
- [ ] Branch cleaned up

---

### 8. Summary Report

**Present to user:**

```markdown
## Review Gaps Addressed

**Phase:** Phase N - [Phase Name]
**Review:** [review-path]

### Items Addressed (N)

| # | Item | Status |
|---|------|--------|
| 1 | Add effort estimates | ✅ Addressed |
| 2 | Define metadata schema | ✅ Addressed |
| ... | ... | ... |

### Changes Made

- **phase-N.md:** Added Implementation Details section, effort estimates
- **phase-N-review.md:** Updated status to Ready

### Review Status

- **Before:** 🟡 Needs Work
- **After:** ✅ Ready

### Next Steps

1. Run `/task-phase [N] 1` to start implementation
2. Or review changes before proceeding
```

---

## Common Issues

### Issue: Review Already Addressed

**Solution:**

```bash
# Check review status
grep "Status:" [review-path]

# If already Ready, proceed to /task-phase
/task-phase [N] 1

# Or force re-process
/address-review [review-path] --force
```

### Issue: Missing Recommended Updates Section

**Solution:**

- Review may not have specific recommendations
- Apply generic updates (effort estimates, dates)
- Ask user for details if needed

### Issue: Phase Document Not Found

**Solution:**

- Verify phase number matches review
- Check directory structure
- Use `--phase N --feature [name]` to specify explicitly

---

## Tips

### Before Running

- Ensure `/pre-phase-review` has been run first
- Review the findings summary before applying
- Use `--dry-run` to preview changes

### During Updates

- Apply all recommendations from review
- Keep phase document formatting consistent
- Update dates accurately

### After Updates

- Verify changes in phase document
- Run `/task-phase` to start implementation
- Or run additional review if needed

---

## Integration with Other Commands

### Command Sequence

**Complete workflow:**

```
1. /pre-phase-review [N]      → Creates review document with findings
2. /address-review [path]     → Addresses gaps in phase document  ← This command
3. /task-phase [N] [task]     → Implements the work
4. /pr --phase [N]            → Creates PR for completed phase
5. /post-pr [N]               → Updates docs after merge
```

### Related Commands

- **`/pre-phase-review`** - Create review document (run first)
- **`/task-phase`** - Implement phase tasks (run after)
- **`/pr --phase [N]`** - Create PR for completed phase

---

## Reference

**Review Documents:**

- Feature-specific: `docs/maintainers/planning/features/[feature]/phase-N-review.md`
- Project-wide: `docs/maintainers/planning/phases/phase-N-review.md`

**Phase Documents:**

- Feature-specific: `docs/maintainers/planning/features/[feature]/phase-N.md`
- Project-wide: `docs/maintainers/planning/phases/phase-N.md`

---

**Last Updated:** 2025-12-10  
**Status:** ✅ Active  
**Next:** Use to address pre-phase review gaps before implementation (keeps planning separate from coding)

