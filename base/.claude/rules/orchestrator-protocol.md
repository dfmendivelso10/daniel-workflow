# Orchestrator Protocol: Contractor Mode

**After a plan is approved, the orchestrator takes over.** It implements, verifies, reviews, fixes, and scores autonomously — presenting results only when the work meets quality standards or fix rounds are exhausted.

The plan-first workflow handles *what and why*. The orchestrator handles *how*, autonomously.

---

## When the Orchestrator Activates

The orchestrator kicks in under these conditions:

1. **After plan approval** — the standard trigger. Plan-first workflow step 7 hands off to the orchestrator.
2. **"Just do it" mode** — when the user says "just do it", "you decide", or "handle it", skip the final presentation gate.
3. **Skill delegation** — when a skill like `/data-analysis` or `/review-r` reaches its implementation phase, the orchestrator loop governs execution.

The orchestrator does NOT activate for:

- Single-file trivial edits (typo fix, add a comment)
- Purely informational questions
- Running a standalone skill like `/compile-latex`

---

## The Orchestrator Loop
```
Plan approved → orchestrator activates
  │
  Step 1: IMPLEMENT — Execute plan steps, create/modify files
  │         If plan has independent subtasks → spawn parallel agents (max 3)
  │
  Step 2: VERIFY — Run verifier (execute scripts, check outputs exist, check logs for errors)
  │         If verification fails → fix errors → re-verify
  │
  Step 3: REVIEW — Select and run review agents (see Agent Selection)
  │
  Step 4: FIX — Apply fixes from reviews (Critical → Major → Minor)
  │
  Step 5: RE-VERIFY — Re-execute scripts to confirm fixes are clean
  │
  Step 6: SCORE — Apply quality-gates rubric
  │
  └── Score >= threshold?
        YES → Present summary to user
        NO  → Loop back to Step 3 (max 5 review-fix rounds)
              After max rounds → present summary with remaining issues
```

### Agent Selection

Select review agents based on **file types touched during implementation**:

| Files Modified | Agents to Run | Execution Order |
|---------------|---------------|-----------------|
| `.R` scripts (cleaning, EDA, figures) | r-reviewer | Standalone |
| `.R` scripts (regression, causal analysis) | r-reviewer, econometrics-researcher | r-reviewer first, then econometrics-researcher |
| `.csv`, `.rds`, `.dta` (data files) | r-reviewer (verify data pipeline integrity) | Standalone |
| Domain-critical content | domain-reviewer (if configured) | Parallel with others |

**How to determine script type:** Read the script and check for regression/estimation functions (`lm`, `feols`, `ivreg`, `fixest`, `plm`, `rdrobust`, `did`, etc.). If present, it is a regression/causal script. Otherwise, treat as cleaning/EDA/figures.

### Parallel Implementation

During **Step 1 (IMPLEMENT)**, if the plan contains independent subtasks, spawn parallel agents rather than working sequentially:

- **Processing independent datasets** — one agent per data slice
- **Generating independent figures** — one agent per plot or simulation
- **Running independent analyses** — one agent per specification or estimator

**Limits:** Max 3 parallel agents. Only for tasks with no dependencies between them. If task B needs task A's output, they must run sequentially.

---

## Fix Priority and Loop Limits

Within each fix round, apply fixes in strict order:

1. **Critical** — script failures, wrong estimators, broken data pipelines, hard gate violations
2. **Major** — missing robust SE, no NA handling, hardcoded paths, missing diagnostics
3. **Minor** — naming conventions, comment quality, code style

### Limits

- **Main loop:** max 5 review-fix rounds
- **Verification retries:** max 2 attempts per verification step
- After max rounds, present what remains. Never loop indefinitely.

---

## The Summary

When the loop completes (score >= threshold or max rounds), present a structured summary:
```
## Orchestrator Summary

**Task:** [from the plan]
**Quality Score:** [N]/100 (threshold: [80/90])
**Review Rounds:** [N]

### Files Created/Modified
- `path/to/file` — [what changed]

### Issues Found and Fixed
- [N] critical, [N] major, [N] minor resolved

### Remaining Issues (if any)
- [List with severity]

### Recommended Next Steps
- [e.g., "Run /data-analysis all for full pipeline audit"]
```

Append the summary to the session log (Rule 5b of plan-first-workflow).

---

## "Just Do It" Mode

When the user signals blanket approval ("just do it", "you decide", "handle it"):

1. Skip the final presentation gate — do not pause for approval after the summary
2. Auto-commit if score >= 80 with a descriptive commit message
3. Still run the full verify-review-fix loop (quality is non-negotiable)
4. Still log everything to the session log
5. Still present the summary (the user should see what was done), but do not wait for approval to continue

"Just do it" does NOT skip the orchestrator loop itself — verification and review still happen. It only skips the approval pause at the end.