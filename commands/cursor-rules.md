# Cursor Rules Command

Manages cursor rules files (`.mdc` files) for AI assistant configuration. Helps update rules based on learnings, create new rule files, and maintain rule documentation.

---

## Configuration

**Rules Path Detection:**

This command supports standard cursor rules structure:

- **Rules Directory:** `.cursor/rules/`
- **Main Rules:** `.cursor/rules/main.mdc`
- **Workflow Rules:** `.cursor/rules/workflow.mdc`
- **Template Rules:** `.cursor/rules/template.mdc`
- **Custom Rules:** `.cursor/rules/[custom-name].mdc`

**Rule File Format:**

- Markdown files with `.mdc` extension
- Frontmatter metadata (optional)
- Structured sections with clear organization
- Status indicators and last updated dates

---

## Workflow Overview

**When to use:**

- After capturing learnings from project work
- When updating project workflows or standards
- To create new rule files for specific domains
- To validate rule structure and completeness
- To update rule documentation

**Key principle:** Keep cursor rules aligned with project evolution, capturing learnings and best practices.

---

## Usage

**Command:** `/cursor-rules [action] [options]`

**Examples:**

- `/cursor-rules list` - List all available rules
- `/cursor-rules update main` - Update main rules based on learnings
- `/cursor-rules create workflow` - Create new workflow rules file
- `/cursor-rules validate` - Validate all rule files
- `/cursor-rules update-all` - Update all rules based on recent learnings

**Options:**

- `--rule NAME` - Specify rule file name (without .mdc extension)
- `--from-learning FILE` - Update rules from learning document
- `--dry-run` - Show changes without updating files
- `--validate-only` - Only validate, don't update

---

## Step-by-Step Process

### 1. List Available Rules

**Action:** `list`

**Process:**

1. Scan `.cursor/rules/` directory
2. List all `.mdc` files
3. Extract metadata from each file (if present)
4. Display rule status and last updated date

**Output:**

```markdown
## Available Cursor Rules

### Core Rules
- **main.mdc** - Main project rules (✅ Active, Last Updated: 2025-12-07)
- **workflow.mdc** - Workflow processes (✅ Active, Last Updated: 2025-12-07)
- **template.mdc** - Template standards (✅ Active, Last Updated: 2025-12-07)

### Custom Rules
- **[custom-name].mdc** - [Description] (✅ Active, Last Updated: YYYY-MM-DD)
```

**Checklist:**

- [ ] Rules directory scanned
- [ ] All rule files listed
- [ ] Metadata extracted
- [ ] Status displayed

---

### 2. Update Rules from Learnings

**Action:** `update [rule-name]`

**Process:**

1. **Identify Learning Source:**
   - Check for recent learning documents
   - Look for reflection documents
   - Check phase learnings (if applicable)
   - Use `--from-learning` if specified

2. **Parse Learnings:**
   - Extract key patterns
   - Identify best practices
   - Find workflow improvements
   - Note documentation updates

3. **Update Rule File:**
   - Add new sections if needed
   - Update existing sections
   - Add examples
   - Update last updated date
   - Maintain rule structure

4. **Validate Updates:**
   - Check rule file structure
   - Verify markdown formatting
   - Ensure consistency
   - Validate links

**Learning Sources:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/learnings/` (if exists)
- Project-wide: `docs/maintainers/planning/notes/learnings/` (if exists)
- Reflections: `docs/maintainers/planning/notes/reflections/reflection-*.md`
- Opportunities: `docs/maintainers/planning/opportunities/internal/` (if exists)

**Checklist:**

- [ ] Learning source identified
- [ ] Learnings parsed
- [ ] Rule file updated
- [ ] Updates validated
- [ ] Last updated date set

---

### 3. Create New Rule File

**Action:** `create [rule-name]`

**Process:**

1. **Check if Rule Exists:**
   - Verify rule file doesn't already exist
   - Check for similar rule names
   - Warn if overwriting

2. **Create Rule Template:**
   - Use standard rule template structure
   - Add frontmatter metadata
   - Include standard sections
   - Add placeholder content

3. **Rule Template Structure:**

```markdown
---
description: [Rule Description]
globs: [optional file patterns]
alwaysApply: [true/false]
---

# [Rule Name] - Cursor AI Rules

**Purpose:** [One-line description]  
**Last Updated:** [YYYY-MM-DD]  
**Status:** ✅ Active

---

## 📋 Quick Links

[Links to related rules or documentation]

---

## 🎯 Overview

[Overview of what this rule covers]

---

## [Section 1]

[Content]

---

## [Section 2]

[Content]

---

**Last Updated:** [YYYY-MM-DD]  
**Status:** ✅ Active  
**Next:** [Next action or milestone]
```

4. **Save Rule File:**
   - Save to `.cursor/rules/[rule-name].mdc`
   - Update main rules file to link to new rule (if applicable)
   - Document in rules README (if exists)

**Checklist:**

- [ ] Rule file created
- [ ] Template structure followed
- [ ] Metadata added
- [ ] Main rules updated (if applicable)
- [ ] Documentation updated

---

### 4. Validate Rule Files

**Action:** `validate`

**Process:**

1. **Check Each Rule File:**
   - Verify file exists and is readable
   - Check markdown formatting
   - Validate frontmatter (if present)
   - Check for required sections

2. **Validate Structure:**
   - Purpose statement present
   - Last updated date present
   - Status indicator present
   - Quick links section (if applicable)
   - Overview section present

3. **Check Links:**
   - Verify internal links work
   - Check external links (if any)
   - Validate file references

4. **Check Consistency:**
   - Consistent formatting
   - Consistent status indicators
   - Consistent date format
   - Consistent section structure

**Validation Report:**

```markdown
## Rule Validation Report

### ✅ Valid Rules
- **main.mdc** - All checks passed
- **workflow.mdc** - All checks passed
- **template.mdc** - All checks passed

### ⚠️ Issues Found
- **[rule-name].mdc** - Missing last updated date
- **[rule-name].mdc** - Broken link: [link]

### 📊 Summary
- Total rules: [N]
- Valid: [X]
- Issues: [Y]
```

**Checklist:**

- [ ] All rule files checked
- [ ] Structure validated
- [ ] Links verified
- [ ] Consistency checked
- [ ] Report generated

---

### 5. Update All Rules

**Action:** `update-all`

**Process:**

1. List all rule files
2. For each rule file:
   - Check for related learnings
   - Update if learnings found
   - Skip if no relevant learnings
3. Generate summary report

**Checklist:**

- [ ] All rules scanned
- [ ] Learnings matched to rules
- [ ] Updates applied
- [ ] Summary report generated

---

## Rule Update Examples

### Example 1: Update Workflow Rules

**Scenario:** New Git Flow pattern learned from recent work

**Action:**
```bash
/cursor-rules update workflow --from-learning docs/maintainers/planning/notes/learnings/git-flow-improvements.md
```

**Result:**
- Workflow rules updated with new Git Flow pattern
- Examples added
- Last updated date set

---

### Example 2: Create Template Rules

**Scenario:** Need rules for template-specific patterns

**Action:**
```bash
/cursor-rules create template
```

**Result:**
- New template.mdc file created
- Standard structure applied
- Ready for customization

---

### Example 3: Validate All Rules

**Scenario:** Before committing rule changes

**Action:**
```bash
/cursor-rules validate
```

**Result:**
- All rules validated
- Issues reported
- Ready for commit

---

## Common Issues

### Issue: Rule File Not Found

**Solution:**

- Check `.cursor/rules/` directory exists
- Verify rule file name (case-sensitive)
- Check file extension (.mdc)
- List available rules first

---

### Issue: Learning Source Not Found

**Solution:**

- Check learning document paths
- Verify document exists
- Use `--from-learning` to specify path
- Check alternative learning locations

---

### Issue: Rule Structure Invalid

**Solution:**

- Use rule template structure
- Validate markdown formatting
- Check frontmatter syntax
- Verify required sections present

---

## Tips

### When to Update Rules

- **After major workflow changes** - Capture new patterns
- **After learning capture** - Encode learnings into rules
- **After template updates** - Reflect template changes
- **Periodically** - Keep rules current

### Rule Maintenance

- **Keep rules focused** - One domain per rule file
- **Update regularly** - Don't let rules drift
- **Validate before commit** - Ensure structure is correct
- **Document changes** - Note what changed and why

### Best Practices

- **Use standard structure** - Follow template format
- **Include examples** - Show patterns in action
- **Link related rules** - Cross-reference when helpful
- **Keep updated** - Set last updated dates

---

## Reference

**Rules Directory:**

- `.cursor/rules/` - All rule files

**Rule Files:**

- `main.mdc` - Main project rules
- `workflow.mdc` - Workflow processes
- `template.mdc` - Template standards
- `[custom].mdc` - Custom domain rules

---

## 📊 Log Usage (Final Step)

**After successful command completion, update the usage tracker:**

1. **Update:** `admin/planning/commands/usage-tracker.md`
2. **Add entry to "Recent Usage" table:**
   ```markdown
   | YYYY-MM-DD | `/cursor-rules` | [Context] | ✅ Success | [Evidence] |
   ```
3. **Increment usage count** in summary table
4. **Commit with message:**
   ```
   docs(commands): update usage tracker - /cursor-rules
   ```

**Why:** Tracks command maturity for graduation decisions per [ADR-004](../admin/services/meta/features/dev-infra-identity-and-focus/decisions/adr-001-project-identity.md).

**Note:** This command needs ≥3 uses before graduation consideration. Current uses: 1.

**Learning Sources:**

- Feature-specific: `docs/maintainers/planning/features/[feature-name]/learnings/` (if exists)
- Project-wide: `docs/maintainers/planning/notes/learnings/` (if exists)
- Reflections: `docs/maintainers/planning/notes/reflections/reflection-*.md`
- Opportunities: `docs/maintainers/planning/opportunities/internal/` (if exists)

**Related Commands:**

- `/reflect` - Create reflection documents (may inform rule updates)
- `/int-opp` - Capture internal opportunities (may inform rule updates)

---

**Last Updated:** 2025-12-07  
**Status:** ✅ Active  
**Next:** Use to maintain cursor rules based on project learnings and evolution

