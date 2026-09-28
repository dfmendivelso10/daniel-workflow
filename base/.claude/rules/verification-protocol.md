---
paths:
  - "scripts/**/*.R"
  - "output/**"
---

# Task Completion Verification Protocol

**At the end of EVERY task, Claude MUST verify the output works correctly.** This is non-negotiable.

---

## For R Scripts:

1. Execute the script via `Rscript` and check for errors
2. Verify output files were created with non-zero size
3. Verify N observations matches the project's expected sample sizes (see `CLAUDE.md`)
4. Spot-check estimates for reasonable magnitude:
   - Coefficients: sign and magnitude consistent with prior models
   - Effect sizes: plausible given the literature and outcome scale
   - Flag extreme values (e.g., OR > 100, R-squared > 0.50 in cross-sectional social science)

## For Output Tables:

1. File exists at expected path
2. Headers match expected columns
3. N matches expected sample size
4. No empty rows/columns where data should be
5. Significance notation follows project convention (see `CLAUDE.md`)

## For Output Figures:

1. File exists at expected path
2. Non-zero file size
3. If possible, verify visual content

## Common Pitfalls:

- **Assuming success**: Always verify output files exist AND contain correct content
- **Wrong N**: If N does not match project expectation, investigate immediately
- **Missing config**: Script may fail silently if project config is not sourced
- **Stale outputs**: Verify the file was recently modified, not a leftover from a prior run

## Verification Checklist:

```
[ ] Script executes without errors
[ ] Output file created at expected path
[ ] Output file has non-zero size
[ ] N observations correct (check against CLAUDE.md)
[ ] Estimates are reasonable in magnitude
[ ] Reported results to user
```
