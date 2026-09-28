---
name: review-r
description: Run the R code review protocol on the project's R scripts. Checks code quality, reproducibility, domain correctness, and the project's own standards (CLAUDE.md, r-code-conventions.md). Produces a report without editing files.
disable-model-invocation: true
argument-hint: "[filename or 'all' or 'cleaning' or 'descriptives' or 'regression']"
---

# Review R Scripts

Run the comprehensive R code review protocol.

## Steps

1. **Identify scripts to review:**
   - If `$ARGUMENTS` is a specific `.R` filename: review that file only
   - If `$ARGUMENTS` is `cleaning`: review all R scripts in `code/00_cleaning/`
   - If `$ARGUMENTS` is `descriptives`: review all R scripts in `code/01_descriptives/`
   - If `$ARGUMENTS` is `regression`: review all R scripts in `code/02_regression/`
   - If `$ARGUMENTS` is `all`: review all R scripts in `code/**/*.R`

2. **For each script, launch the `r-reviewer` agent** with instructions to:
   - Follow the full protocol in the agent instructions
   - Read `.claude/rules/r-code-conventions.md` for the project's standards
   - Read `config.R` for project constants and specs
   - Save report to `quality_reports/[script_name]_r_review.md`

3. **After all reviews complete**, present a summary:
   - Total issues found per script
   - Breakdown by severity (Critical / High / Medium / Low)
   - Top 3 most critical issues

4. **IMPORTANT: Do NOT edit any R source files.**
   Only produce reports. Fixes are applied after user review.
