# Plan Review — {{FEATURE_NAME}}

**Feature:** {{FEATURE_NAME}}  
**Planning root:** {{PLANNING_ROOT_RELATIVE_PATH}}  
**Status:** 🔴 Not Ready / 🟡 Needs Work / ✅ Ready  
**Reviewed:** {{YYYY-MM-DD}}  
**Scope:** Full plan / Group {{N}} only  

---

## 📋 Plan Structure

- [ ] Implementation plan found and parseable
- [ ] YAML frontmatter valid (`task_count`, `groups`, `tasks_files`)
- [ ] Every referenced task group file exists on disk
- [ ] Checkbox census matches `task_count`
- [ ] No orphan global task IDs

---

## 📝 Task Group Review

### Group {{N}}: {{GROUP_NAME}} (Tasks {{FROM}}–{{TO}})

- **Header status:** 🔴 / 🟠 / ✅  
- **Task count:** {{COUNT}} (warn if below 2 or above 8)  
- **Descriptions:** Adequate / Needs detail  
- **Dependencies section:** Present / Issues  

*(repeat per reviewed group)*

---

## 🔗 Dependency Validation

- [ ] No circular dependencies
- [ ] Cross-group references point strictly to earlier groups
- [ ] External prerequisites documented or flagged
- [ ] Prerequisite groups complete before downstream execution

---

## 🔄 Consistency Check

- [ ] Plan ↔ Status progress counts align
- [ ] Plan ↔ Task titles align (no phantom tasks)
- [ ] Frontmatter `groups[].tasks` matches markdown numbering inside files

---

## 🎓 Prior-stage learning carry-forward

*(Skip section when planning root is `planning/` first stage OR no earlier `planning-stage{prev}/` exists.)*

- [ ] Prior `status-and-next-steps.md` scanned for unresolved narratives / deferred scope
- [ ] Prior `implementation-plan.md` scanned for unchecked items affecting this stage
- [ ] Spike / artifact docs explicitly referenced when status mentions them — acknowledged or waived in THIS plan

---

## 🔴 Blockers

*(none)*

---

## 🟡 Warnings

*(none)*

---

## 💡 Recommendations

*(none)*

---

## ✅ Readiness Assessment

**Overall:** Not Ready / Needs Work / Ready  

**Action Items:**

- [ ] {{ACTION_ONE}}

---

**Last Updated:** {{YYYY-MM-DD}}
