---
name: context-status
description: Check session health — active plan, session log status, and context preservation. Use when working on long tasks to ensure important state is saved to disk.
disable-model-invocation: true
argument-hint: ""
---

# Context Status Dashboard

Check the current session's health and ensure important state is preserved.

## Steps

1. **Check active plan:**
   - Look for the most recent file in `quality_reports/plans/`
   - Report its status (DRAFT / APPROVED / IN PROGRESS / COMPLETED)
   - If no plan exists, report "No active plan"

2. **Check session log:**
   - Look for today's session log in `quality_reports/session_logs/`
   - If it exists, report when it was last modified
   - If it doesn't exist and there's an active plan, warn that a session log should be created

3. **Check MEMORY.md:**
   - Verify MEMORY.md exists and report its line count
   - Flag if it's approaching 200 lines (truncation risk)

4. **Check uncommitted work:**
   - Run `git status --short` to see pending changes
   - Run `git diff --stat` to see scope of changes
   - Warn if there are many uncommitted changes (risk of loss)

5. **Present dashboard:**

```
## Session Status

| Item | Status |
|------|--------|
| Active plan | [name] — [status] |
| Session log | [exists/missing] — last updated [time] |
| MEMORY.md | [N] lines (limit: 200) |
| Uncommitted files | [N] files changed |

### Recommendations
- [Any actions needed to preserve context]
```

## Important

- This is a read-only diagnostic — do not modify any files
- If MEMORY.md is near 200 lines, recommend moving detailed content to topic files
- If there are many uncommitted changes, recommend a commit checkpoint
