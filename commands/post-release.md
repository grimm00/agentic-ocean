# Post Release Command

Handles post-release tasks including merging main back to develop, updating historical tracking, archiving release documents, and optionally creating a release retrospective.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Dev-Infra Structure (default):**
   - Releases: `admin/planning/releases/[version]/`
   - Scripts: `scripts/`
   - Historical: `admin/planning/releases/history/` (if exists)

2. **Template Structure (for generated projects):**
   - Releases: `docs/maintainers/planning/releases/[version]/`

**Version Detection:**

- Use version argument (required)
- Format: `v0.4.0` or `0.4.0` (normalized to `vX.Y.Z`)

---

## Workflow Overview

**When to use:**

- After release is merged to main (tag created automatically)
- After GitHub release is published
- To clean up and prepare for next development cycle

**Key principle:** Complete the release cycle and prepare for the next iteration.

**Note:** As of v0.5.0, tags are automatically created when release PRs are merged to `main` via `.github/workflows/create-release-tag.yml`.

**Workflow Position:**

```
/pr --release
         │
         ▼
   Merge to main
         │
         ▼
   Tag auto-created (v0.4.0)  ◄── Automated by GitHub Actions
         │
         ▼
   GitHub release published
         │
         ▼
┌─────────────────────────────────────┐
│   /post-release v0.4.0              │  ◄── This command
│                                     │
│   1. Merge main to develop          │
│   2. Update historical tracking     │
│   3. Archive release documents      │
│   4. Clean up release branch        │
│   5. Create retrospective (opt)     │
└─────────────────────────────────────┘
         │
         ▼
   Ready for next development cycle
```

---

## Usage

**Command:** `/post-release [version] [options]`

**Examples:**

- `/post-release v0.4.0` - Full post-release workflow
- `/post-release v0.4.0 --dry-run` - Preview changes
- `/post-release v0.4.0 --skip-retrospective` - Skip retrospective creation
- `/post-release v0.4.0 --keep-branch` - Don't delete release branch

**Options:**

- `--dry-run` - Show what would be done without executing
- `--skip-retrospective` - Skip retrospective document creation
- `--keep-branch` - Keep release branch (don't delete)
- `--skip-archive` - Skip archiving release documents
- `--force` - Continue even with warnings

---

## Step-by-Step Process

### 1. Validate Release Complete

**Verify release is complete:**

```bash
# Check tag exists
git tag -l "v0.4.0"

# Check tag is on main
git branch -a --contains v0.4.0 | grep main
```

**Check GitHub release (auto-created by CI):**

```bash
gh release view v0.4.0
```

**Note:** As of v0.10.0, GitHub Releases are created automatically by the `create-release-tag.yml` workflow when the release PR merges to main. The workflow uses curated `RELEASE-NOTES.md` when available. If the release doesn't exist, it may indicate a CI issue.

**Checklist:**

- [ ] Tag v0.4.0 exists
- [ ] Tag is on main branch
- [ ] GitHub release exists (auto-created by CI)
- [ ] Release distribution workflow completed

---

### 2. Merge Main to Develop

**Purpose:** Ensure develop has all release changes and any hotfixes.

**Process:**

```bash
# Switch to develop
git checkout develop
git pull origin develop

# Merge main
git merge main --no-edit

# Push
git push origin develop
```

**Handle conflicts (if any):**

- Release-specific changes may conflict
- Prefer main branch versions for release files
- Document any manual conflict resolution

**Checklist:**

- [ ] Develop branch checkout
- [ ] Main merged to develop
- [ ] Conflicts resolved (if any)
- [ ] Develop pushed

---

### 3. Update Historical Tracking

**Run historical analysis:**

**Dev-Infra (with script):**
```bash
./scripts/analyze-releases.sh --last 5
```

**Output example:**

```
Release History Analysis
========================

Recent Releases:
  v0.4.0 (2025-12-11) - Score: 85%, Status: READY
  v0.3.0 (2025-11-18) - Score: 90%, Status: READY
  v0.2.0 (2025-11-12) - Score: 88%, Status: READY

Trends:
  Average Readiness Score: 87.7%
  Trend: Stable
```

**Update historical index (if exists):**

**File:** `admin/planning/releases/history/index.md` (create if needed)

```markdown
# Release History

| Version | Date | Score | PRs | Highlights |
|---------|------|-------|-----|------------|
| v0.4.0 | 2025-12-11 | 85% | 22 | Release Readiness Feature |
| v0.3.0 | 2025-11-18 | 90% | 8 | Multi-Environment Testing |
| v0.2.0 | 2025-11-12 | 88% | 5 | Directory Selection |
```

**Checklist:**

- [ ] Historical analysis run
- [ ] Index updated (if exists)
- [ ] Trends documented

---

### 4. Archive Release Documents

**Purpose:** Mark release documents as complete and archived.

**Update document statuses:**

**RELEASE-READINESS.md:**
```markdown
# Before
**Status:** 🟢 READY FOR RELEASE

# After
**Status:** ✅ RELEASED (v0.4.0 - 2025-12-11)
```

**RELEASE-NOTES.md:**
```markdown
# Before  
**Status:** ✅ Final

# After
**Status:** ✅ Published (GitHub Release)
```

**Move to archive (optional):**

If using archive structure:
```bash
mkdir -p admin/planning/releases/archived/v0.4.0/
mv admin/planning/releases/v0.4.0/* admin/planning/releases/archived/v0.4.0/
```

**Alternative:** Keep in place with updated status (recommended for easy reference).

**Checklist:**

- [ ] Document statuses updated
- [ ] Documents archived (if using archive structure)
- [ ] Links still work

---

### 5. Clean Up Release Branch

**Delete release branch (unless `--keep-branch`):**

```bash
# Delete local branch
git branch -d release/v0.4.0

# Delete remote branch
git push origin --delete release/v0.4.0
```

**Verify cleanup:**

```bash
git branch -a | grep release/v0.4.0
# Should return nothing
```

**Checklist:**

- [ ] Local branch deleted
- [ ] Remote branch deleted
- [ ] No orphaned branches

---

### 6. Create Release Retrospective (Optional)

**Skip if `--skip-retrospective` specified.**

**Create retrospective document:**

**File:** `admin/planning/releases/v0.4.0/retrospective.md`

```markdown
# Release Retrospective - v0.4.0

**Version:** v0.4.0  
**Release Date:** 2025-12-11  
**Created:** 2025-12-11

---

## 📊 Release Summary

| Metric | Value |
|--------|-------|
| PRs Merged | 22 |
| Development Duration | ~3 weeks |
| Preparation Duration | 1 day |
| Readiness Score | 85% |

---

## ✅ What Went Well

- [To be filled by team]
- Release preparation workflow (new `/release-prep` command)
- CHANGELOG draft generation
- Historical tracking

---

## 🟡 What Could Be Improved

- [To be filled by team]
- Missing v0.3.0 tag (discovered during prep)
- Manual CHANGELOG merge step

---

## 💡 Action Items for Next Release

- [ ] [Action item 1]
- [ ] [Action item 2]
- [ ] Consider automating CHANGELOG merge

---

## 📝 Notes

[Any additional notes or observations]

---

**Last Updated:** 2025-12-11
```

**Checklist:**

- [ ] Retrospective created
- [ ] Template sections filled (or marked for team input)
- [ ] Linked from release directory

---

### 7. Update Project State

**Update cursor rules (if version referenced):**

**File:** `.cursor/rules/main.mdc`

```markdown
# Before
**Version:** v0.3.0 → v0.4.0 (pending release)

# After
**Version:** v0.4.0 (released 2025-12-11)
**Next:** v0.5.0 planning
```

**Update README.md (if version badge exists):**

Check for version references and update.

**Checklist:**

- [ ] Cursor rules updated
- [ ] README updated (if applicable)
- [ ] Any version badges updated

---

### 8. Generate Summary Report

**Present to user:**

```markdown
## ✅ Post-Release Complete

**Version:** v0.4.0
**Released:** 2025-12-11

### Actions Completed

| Action | Status |
|--------|--------|
| Main merged to develop | ✅ Done |
| Historical tracking updated | ✅ Done |
| Release documents archived | ✅ Done |
| Release branch cleaned up | ✅ Done |
| Retrospective created | ✅ Done |
| Project state updated | ✅ Done |

### Release Statistics

| Metric | Value |
|--------|-------|
| PRs Included | 22 |
| Readiness Score | 85% |
| Time from prep to release | X hours |

### Next Steps

1. Review retrospective with team
2. Start planning v0.5.0 features
3. Address deferred issues (22 tasks)
4. Run `/reflect` for post-release learnings

### Commands for Next Cycle

- `/explore [topic]` - Start new exploration
- `/transition-plan` - Plan new feature
- `/task-phase` - Implement features
```

---

## Common Scenarios

### Scenario 1: Standard Post-Release

**Situation:** Release v0.4.0 just published

**Action:**
```bash
/post-release v0.4.0
```

**Result:**
- All post-release tasks completed
- Ready for next development cycle

---

### Scenario 2: Quick Cleanup

**Situation:** Just need branch cleanup, no retrospective

**Action:**
```bash
/post-release v0.4.0 --skip-retrospective
```

**Result:**
- Branch cleanup and merge only
- No retrospective created

---

### Scenario 3: Dry Run

**Situation:** Preview post-release actions

**Action:**
```bash
/post-release v0.4.0 --dry-run
```

**Result:**
- Shows all actions that would be taken
- No changes made

---

### Scenario 4: Keep Branch

**Situation:** Need to keep release branch for reference

**Action:**
```bash
/post-release v0.4.0 --keep-branch
```

**Result:**
- All other tasks completed
- Release branch preserved

---

## Integration with Other Commands

### Complete Release Workflow

```
Feature Development
         │
         ▼
/release-prep v0.4.0
         │
         ▼
(Manual Review)
         │
         ▼
/release-finalize v0.4.0
         │
         ▼
/pr --release
         │
         ▼
(Merge & Tag)
         │
         ▼
/post-release v0.4.0    ◄── This command
         │
         ▼
Ready for v0.5.0
```

---

## Tips

### Before Running

- Verify release tag exists
- Verify GitHub release is published (if applicable)
- Ensure release distribution workflow completed

### During Post-Release

- Review historical analysis output
- Check for any missed documentation updates
- Verify develop branch is up to date

### After Post-Release

- Share retrospective with team
- Plan next release features
- Address high-priority deferred issues

---

## Reference

**Input:**

- Release tag (verified on main)
- Release documents in `admin/planning/releases/[version]/`

**Output:**

- Merged develop branch
- Updated historical tracking
- Archived/updated release documents
- Retrospective document (optional)
- Cleaned up release branch

**Scripts:**

- `scripts/analyze-releases.sh` - Historical analysis

**Related Commands:**

- `/release-prep` - Prepare release documents
- `/release-finalize` - Finalize release documents
- `/pr --release` - Create release PR
- `/reflect` - Post-release reflection

---

**Last Updated:** 2025-12-11  
**Status:** ✅ Active  
**Next:** Use after release is published to complete the release cycle

