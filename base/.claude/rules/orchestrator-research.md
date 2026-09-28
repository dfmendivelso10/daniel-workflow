---
paths:
  - "scripts/**/*.R"
  - "output/**"
---

# Orchestrator Protocol: Research (Simplified)

**A lightweight alternative to the full orchestrator for R-based analysis tasks.**

Use this protocol instead of the full orchestrator when the task is:
- A single R script (new or modified)
- An exploratory analysis
- A figure or table generation
- Any task that touches <= 2 files

For multi-file, multi-step tasks, use the full `orchestrator-protocol.md` instead.

---

## The Loop

```
Plan approved (or trivial task) -> simplified orchestrator activates
  |
  Step 1: IMPLEMENT -- Write or modify the R script(s)
  |
  Step 2: VERIFY -- Execute the script, check outputs exist, check N
  |         MANDATORY: run `Rscript path/to/script.R` and confirm:
  |           - Script exits without errors
  |           - Output file exists at expected path (outputs/tables/ or outputs/figures/)
  |           - Output file has non-zero size
  |           - N observations matches project expectation (346 total: NNA tipo_persona=1 + jovenes tipo_persona=2; ver CLAUDE.md §2)
  |         If fails -> fix -> re-verify (max 2 retries)
  |
  Step 3: SCORE -- Apply quality-gates rubric
  |
  +-- Score >= 80? -> Present summary to user
      Score < 80?  -> Fix blocking issues -> re-verify -> re-score
                      (max 3 rounds total, then present with remaining issues)
```

**VERIFY is non-negotiable.** Never report a script as "done" without executing it. Editing code without running it is not completing the task.

## What This Skips (vs. Full Orchestrator)

- No multi-agent review (no r-reviewer + econometrics-researcher in parallel)
- No 5-round adversarial loops
- No parallel agent spawning
- No formal quality report file

## When to Escalate to Full Orchestrator

- Script has regression/causal analysis (needs econometrics-researcher review)
- Task modifies > 2 files
- Task creates a new analysis pipeline
- User explicitly requests full review

## Summary Format

```
## Quick Summary

**Task:** [what was done]
**Score:** [N]/100
**Files:** [list]
**Verification:** PASS / FAIL
**Notes:** [any issues or caveats]
```
