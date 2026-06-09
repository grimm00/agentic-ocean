# Release Prep Command

Orchestrates release preparation by generating assessments, creating documentation drafts, and optionally creating the release branch. Streamlines the pre-release workflow.

---

## Configuration

**Path Detection:**

This command supports multiple project organization patterns:

1. **Dev-Infra Structure (default):**
   - Releases: `admin/planning/releases/[version]/`
   - Scripts: `scripts/`
   - Transition plans: `admin/planning/releases/[version]/transition-plan.md`

2. **Template Structure (for generated projects):**
   - Releases: `docs/maintainers/planning/releases/[version]/`
   - Scripts: `scripts/` (if exists)

**Version Detection:**

- Use version argument (required)
- Format: `v0.4.0` or `0.4.0` (normalized to `vX.Y.Z`)

---

## Workflow Overview

**When to use:**

- When starting release preparation
- After feature development is complete
- To generate all release documentation
- Before creating the release branch

**Key principle:** Automate release preparation tasks to ensure consistency and completeness.

**Workflow Position:**

```
Feature Development Complete
         │
         ▼
┌─────────────────────────────────────┐
│   /release-prep v0.4.0              │  ◄── This command
│                                     │
│   1. Run readiness check            │
│   2. Generate assessment            │
│   3. Create CHANGELOG draft         │
│   4. Create release notes draft     │
│   5. Create release branch (opt)    │
└─────────────────────────────────────┘
         │
         ▼
   Manual review of drafts
         │
         ├─── Has implementation tasks in transition-plan.md?
         │         │
         │         ├── YES → /task-release v0.4.0
         │         │         (implement tasks with TDD)
         │         │              │
         │         └── NO ───────┤
         │                        │
         ▼                        ▼
   /release-finalize v0.4.0
   (merge drafts, update versions)
         │
         ▼
   /pr --release
   (create release PR)
```

### When to Use `/task-release`

**Use `/task-release` when:**
- The `transition-plan.md` has specific implementation tasks (scripts, tests, etc.)
- Release includes new features that need to be built during release prep
- Example: v0.4.0 (Release Readiness feature with 3 scripts)

**Skip `/task-release` when:**
- All features are already merged to develop via PRs
- Release is just bundling accumulated changes
- No additional implementation needed during release prep
- Example: v0.6.0 (all work done in PRs #47-52)

**Decision guide:** If your release just needs CHANGELOG and release notes merged, skip directly to `/release-finalize`. If you have a `transition-plan.md` with uncompleted implementation tasks, use `/task-release` first.

---

## Usage

**Command:** `/release-prep [version] [options]`

**Examples:**

- `/release-prep v0.4.0` - Full release preparation
- `/release-prep v0.4.0 --dry-run` - Show what would be done
- `/release-prep v0.4.0 --skip-branch` - Prepare but don't create branch
- `/release-prep v0.4.0 --assessment-only` - Only generate assessment
- `/release-prep v0.4.0 --force` - Continue despite blocking issues

**Options:**

- `--dry-run` - Show what would be done without executing
- `--skip-branch` - Skip release branch creation
- `--assessment-only` - Only run assessment, skip other steps
- `--force` - Continue even if readiness check has blocking issues
- `--verbose` - Show detailed output

---

## Step-by-Step Process

### 1. Validate Version Format

**Normalize version:**

```bash
# Accept v0.4.0 or 0.4.0
VERSION="v0.4.0"  # Normalize to vX.Y.Z format
```

**Verify version format:**

- Must match pattern: `v?[0-9]+\.[0-9]+\.[0-9]+`
- Normalize to `vX.Y.Z` format

**Check for existing release:**

```bash
# Check if release already exists
git tag -l "v0.4.0"
```

**Checklist:**

- [ ] Version format validated
- [ ] Version normalized to vX.Y.Z
- [ ] Checked if release already exists (warning if exists)

---

### 2. Create Release Directory

**Create directory structure:**

**Dev-Infra:**
```bash
mkdir -p admin/planning/releases/v0.4.0/
```

**Template Structure:**
```bash
mkdir -p docs/maintainers/planning/releases/v0.4.0/
```

**Checklist:**

- [ ] Release directory created (if not exists)
- [ ] Directory path determined based on project structure

---

### 3. Run Readiness Check

**Execute readiness check:**

**Dev-Infra (with script):**
```bash
./scripts/check-release-readiness.sh v0.4.0
```

**Template Structure (manual):**
```
Check:
- [ ] All tests passing
- [ ] No blocking issues
- [ ] Critical bugs fixed
- [ ] Documentation complete
```

**Evaluate results:**

| Status | Action |
|--------|--------|
| ✅ READY | Continue to next step |
| 🟡 REVIEW NEEDED | Show warnings, continue if `--force` |
| 🔴 NOT READY | Block unless `--force` |

**If blocking issues:**

```markdown
⚠️ **Release Not Ready**

Blocking Issues:
- [ ] CHANGELOG not updated
- [ ] Release notes missing

Options:
1. Fix blocking issues and re-run
2. Use `--force` to continue anyway
```

**Checklist:**

- [ ] Readiness check executed
- [ ] Results evaluated
- [ ] Blocking issues identified (if any)
- [ ] Decision made (continue or fix first)

---

### 4. Generate Assessment Document

**Generate assessment:**

**Dev-Infra (with script):**
```bash
./scripts/check-release-readiness.sh v0.4.0 --generate > admin/planning/releases/v0.4.0/RELEASE-READINESS.md
```

**Template Structure (manual):**
Create assessment document manually using template.

**Assessment content:**

```markdown
# Release Readiness Assessment - vX.Y.Z

---
version: vX.Y.Z
date: YYYY-MM-DD
readiness_score: [0-100]
blocking_failures: [N]
total_checks: [N]
passed_checks: [N]
warnings: [N]
status: [READY|REVIEW_NEEDED|NOT_READY]
---

## 📊 Summary

**Overall Readiness Status:** [Status]
**Readiness Score:** [Score]%
...
```

**Checklist:**

- [ ] Assessment generated
- [ ] YAML frontmatter included
- [ ] File saved to release directory
- [ ] Old assessment backed up (if exists)

---

### 5. Create CHANGELOG Draft

**Gather changes since last release:**

```bash
# Get commits since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Get merged PRs
gh pr list --state merged --limit 50 --json number,title,mergedAt
```

**Create CHANGELOG draft:**

**File:** `admin/planning/releases/v0.4.0/CHANGELOG-DRAFT.md`

```markdown
# CHANGELOG Draft - v0.4.0

**Draft Created:** YYYY-MM-DD  
**Status:** 🔴 Draft - Needs Review

---

## [0.4.0] - YYYY-MM-DD

### Added

- **[Feature Name]** - Description (PR #XX)
  - Detail 1
  - Detail 2

### Changed

- **[Change]** - Description (PR #XX)

### Fixed

- **[Fix]** - Description (PR #XX)

### Documentation

- **[Doc Update]** - Description

---

## PRs Included

| PR | Title | Merged |
|----|-------|--------|
| #XX | Title | YYYY-MM-DD |

---

## Review Checklist

- [ ] All PRs listed
- [ ] Categorization correct
- [ ] Descriptions accurate
- [ ] Breaking changes noted (if any)
- [ ] Ready to merge into CHANGELOG.md
```

**Checklist:**

- [ ] Commits gathered since last release
- [ ] PRs listed
- [ ] CHANGELOG draft created
- [ ] Categorization applied (Added/Changed/Fixed/etc.)

---

### 6. Create Release Notes Draft

**Create release notes:**

**File:** `admin/planning/releases/v0.4.0/RELEASE-NOTES.md`

```markdown
# Release Notes - v0.4.0

**Version:** v0.4.0  
**Release Date:** YYYY-MM-DD  
**Status:** 🔴 Draft - Needs Review

---

## 🎉 Highlights

[Executive summary of key features and improvements]

---

## ✨ New Features

### [Feature 1 Name]

[Description of feature with benefits]

**Example:**
```bash
[Usage example]
```

### [Feature 2 Name]

[Description]

---

## 🔧 Improvements

- [Improvement 1]
- [Improvement 2]

---

## 🐛 Bug Fixes

- [Fix 1] (PR #XX)
- [Fix 2] (PR #XX)

---

## 📚 Documentation

- [Doc update 1]
- [Doc update 2]

---

## ⚠️ Breaking Changes

None in this release.

---

## 🔄 Migration Guide

No migration required.

---

## 📊 Statistics

| Metric | Value |
|--------|-------|
| PRs Merged | XX |
| Tests Added | XX |
| Contributors | XX |

---

## 🙏 Acknowledgments

Thanks to all contributors!

---

**Full Changelog:** [v0.3.0...v0.4.0](https://github.com/[org]/[repo]/compare/v0.3.0...v0.4.0)
```

**Checklist:**

- [ ] Release notes draft created
- [ ] Highlights section filled
- [ ] Features documented
- [ ] Fixes listed
- [ ] Statistics calculated

---

### 7. Create Release Branch (Optional)

**Skip if `--skip-branch` specified.**

**Create release branch:**

**Dev-Infra (with script):**
```bash
./scripts/create-release-branch.sh v0.4.0
```

**Manual:**
```bash
git checkout develop
git pull origin develop
git checkout -b release/v0.4.0
```

**Initial commit:**

```bash
git add admin/planning/releases/v0.4.0/
git commit -m "docs(release): initialize v0.4.0 release preparation

Created release preparation documents:
- RELEASE-READINESS.md (generated assessment)
- CHANGELOG-DRAFT.md (changes since v0.3.0)
- RELEASE-NOTES.md (draft release notes)

Next: Review and finalize documents, then merge to main"
```

**Checklist:**

- [ ] Release branch created (or skipped)
- [ ] Initial documents committed
- [ ] Branch pushed to origin

---

### 8. Generate Summary Report

**Present to user:**

```markdown
## ✅ Release Preparation Complete

**Version:** v0.4.0
**Date:** YYYY-MM-DD

### Documents Created

| Document | Location | Status |
|----------|----------|--------|
| RELEASE-READINESS.md | `admin/planning/releases/v0.4.0/` | ✅ Generated |
| CHANGELOG-DRAFT.md | `admin/planning/releases/v0.4.0/` | 📝 Draft |
| RELEASE-NOTES.md | `admin/planning/releases/v0.4.0/` | 📝 Draft |

### Readiness Status

**Status:** [READY / REVIEW_NEEDED / NOT_READY]
**Score:** [X]%
**Blocking Issues:** [N]

### Release Branch

**Branch:** `release/v0.4.0` [Created / Skipped]
**Base:** `develop`

### Next Steps

1. Review CHANGELOG-DRAFT.md and merge into CHANGELOG.md
2. Review and finalize RELEASE-NOTES.md
3. Address any blocking issues in assessment
4. Use `/task-release v0.4.0` for remaining tasks
5. Use `/pr --release` to create PR to main
```

---

## Common Scenarios

### Scenario 1: Standard Release Preparation

**Situation:** Ready to start release preparation

**Action:**
```bash
/release-prep v0.4.0
```

**Result:**
- Assessment generated
- CHANGELOG draft created
- Release notes draft created
- Release branch created

---

### Scenario 2: Assessment Only

**Situation:** Want to check readiness without creating documents

**Action:**
```bash
/release-prep v0.4.0 --assessment-only
```

**Result:**
- Only assessment generated
- No other documents created
- No branch created

---

### Scenario 3: Dry Run

**Situation:** Want to see what would happen

**Action:**
```bash
/release-prep v0.4.0 --dry-run
```

**Result:**
- Shows all steps that would execute
- No files created or modified
- No branches created

---

### Scenario 4: Force Despite Issues

**Situation:** Need to proceed despite blocking issues

**Action:**
```bash
/release-prep v0.4.0 --force
```

**Result:**
- Continues even with blocking issues
- Issues documented in assessment
- Requires justification in commit message

---

## Integration with Other Commands

### Release Workflow

```
/release-prep v0.4.0
    │
    ├── Creates: RELEASE-READINESS.md
    ├── Creates: CHANGELOG-DRAFT.md
    ├── Creates: RELEASE-NOTES.md
    └── Creates: release/v0.4.0 branch
         │
         ▼
/task-release v0.4.0 [task]
    │
    ├── Implements remaining tasks
    ├── Updates checklist
    └── Finalizes documents
         │
         ▼
/pr --release
    │
    ├── Creates PR to main
    ├── Runs readiness validation
    └── Triggers external review
         │
         ▼
Merge & Tag
```

---

## Tips

### Before Running

- Ensure all feature work is merged to develop
- Check that tests are passing
- Review deferred issues (consider fixing first)

### During Preparation

- Review generated documents for accuracy
- Update CHANGELOG draft with human-readable descriptions
- Add context to release notes highlights

### After Preparation

- Use `/task-release` for remaining tasks
- Finalize documents on release branch
- Get external review before merging

---

## Reference

**Scripts:**

- `scripts/check-release-readiness.sh` - Assessment and validation
- `scripts/create-release-branch.sh` - Branch creation helper
- `scripts/analyze-releases.sh` - Historical analysis

**Release Directory:**

- `admin/planning/releases/vX.Y.Z/` (dev-infra)
- `docs/maintainers/planning/releases/vX.Y.Z/` (templates)

**Related Commands:**

- `/task-release` - Implement release tasks
- `/pr --release` - Create release PR
- `/transition-plan --type release` - Create transition plan

---

**Last Updated:** 2025-12-10  
**Status:** ✅ Active  
**Next:** Use to streamline release preparation workflow

