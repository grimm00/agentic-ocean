# Implement Command

Thin entry point for the **implement** skill.

**Skill:** `~/.cursor/skills/implement/SKILL.md` — **read and follow that file**.

| Invocation | Behavior |
|------------|----------|
| `/implement` | **Run all** remaining plan tasks (pause on operator gates) |
| `/implement next` | One task, then stop |
| `/implement N` | Task N only |
| `/implement --status` | Progress only |
| `/task …` | Legacy alias — same skill |

**Hard rules:** no auto-commit; operator steps pause the run; human owns commit/apply.
