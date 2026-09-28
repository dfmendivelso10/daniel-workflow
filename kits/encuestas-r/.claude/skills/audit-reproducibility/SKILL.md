---
name: audit-reproducibility
description: Enforce the replication-protocol.md rule by cross-checking numeric claims in a manuscript against the actual R / Stata / Python outputs. Report PASS/FAIL per claim against tolerance thresholds. Use before submission and before releasing a replication package.
argument-hint: "[manuscript path] [outputs-dir] (outputs-dir defaults to output/)"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Bash", "Task", "Monitor"]
effort: high
---

# Audit Reproducibility

Compare numeric claims in a manuscript (point estimates, standard errors, p-values, counts) against the actual outputs produced by the analysis pipeline. Report PASS / FAIL per claim against the tolerance thresholds defined in [`.claude/rules/replication-protocol.md`](../../rules/replication-protocol.md).

**Core principle:** If the paper says `OR = 1.558 (0.21)` and the code produces `1.561 (0.20)`, we verify — **numerically** — that the difference is within the documented tolerance. No more "looks close enough" eyeballing.

## When to use

- **Before submission.** Catches the "I updated the analysis but forgot to update Table 2" bug.
- **Before releasing a replication package.** Verifies the code actually reproduces the paper.
- **After a major revision.** Ensures the paper still matches the latest code.
- **Quality-gate in `/commit`.** Pair with a pre-commit invocation on manuscript + analysis changes.

## Inputs

- `$0` — path to the manuscript (`.tex`, `.qmd`, `.md`, `.docx`, `.pdf`). Required.
- `$1` — path to the outputs directory. Defaults to `output/`. In this project the final tables live under `output/tables/` (`.xlsx`) and figures under `output/figures/`.

## Workflow

### Phase 0: Pre-flight

1. Read [`replication-protocol.md`](../../rules/replication-protocol.md) for the tolerance thresholds currently in effect.
2. Verify the outputs directory exists and is non-empty. If empty or stale (older than the manuscript), prompt the user to re-run the relevant pipeline scripts (`Rscript scripts/...`) before auditing.
3. Ensure a `sessionInfo.txt` or equivalent environment capture exists (run [`/capture-environment`](../capture-environment/SKILL.md) if missing).

### Phase 1: Extract claims from the manuscript

Parse the manuscript for numeric claims. Patterns to match:

- **Point-estimate + SE**: `OR = 1.558 (0.21)`, `$\beta = 0.392$ (0.09)`, `hat{\tau} = 1.28**` with starred significance
- **Table cells**: `& 1.558$^{***}$ & 0.21 &` in LaTeX table environments; cell values in `.xlsx` FINAL tables
- **Counts**: `our sample of 346 participants`, `$N = 153$` (a subsample) — the expected N is in CLAUDE.md
- **Summary stats**: `mean = 0.423`, `SD = 0.087`
- **P-values**: `p < 0.01`, `$p = 0.003$`

Record each claim as a tuple:

```
{
  claim_id: "Table2_col3_OR",
  location: "Table 2, Column 3, row 'PEARLS>=3'",
  kind: "point_estimate" | "standard_error" | "p_value" | "count" | "percentage",
  reported_value: 1.558,
  uncertainty: 0.21,
  significance_stars: 3,
  raw_context: "the transmission OR of 1.558 (0.21) indicates..."
}
```

Write the extracted claims to `quality_reports/reproducibility_claims_[manuscript-name].json` so the user can review the extraction before audit.

### Phase 2: Extract results from outputs

Scan `$1` for corresponding values. Priority order:

1. **`.xlsx` FINAL tables** — parse cells via `openxlsx::read.xlsx()` or `readxl`; match on sheet + column headers + row labels. (The primary output format in this workflow.)
2. **`.rds` files** — `readRDS(path)$coef[["treatment"]]` style lookups.
3. **`.tex` tables** — parse LaTeX table cells directly; match on column headers + row labels.
4. **`.csv` summary files** — readr parse, key-value lookup.
5. **`.out` / `.log` files** (Stata, regress output) — regex extraction.
6. **`.json`** — direct key lookup.

Record each extracted result:

```
{
  source: "output/tables/02_BNCT/ordinal/FINAL_Logit_Ordinal_BNCT.xlsx",
  lookup_key: "sheet 'Orientacion', col M3, row 'dummy_pearls_3'",
  value: 1.561,
  uncertainty: 0.20,
  p_value: 0.005
}
```

### Phase 3: Match claims to results

Use fuzzy heuristics when exact labels don't match:

- Name similarity (`"transmission effect"` ~ `"PEARLS>=3"` ~ `"dummy_pearls_3"`)
- Magnitude similarity (if two candidates have values within 10% of the reported, prefer the one with closer SE)
- Context hints from the claim's `raw_context` field (table number, row label, description)

For every claim, produce a match candidate with a confidence score. Claims below 0.7 confidence get flagged as "UNMATCHED — manual review needed" rather than silently passing.

### Phase 4: Tolerance check

For each matched claim, apply the thresholds from `replication-protocol.md`:

| Kind | Tolerance | Example |
|---|---|---|
| Integers (N, counts) | Exact | 153 must equal 153 |
| Point estimates | `abs(reported - computed)` < 0.01 | 1.558 vs 1.561 → diff = 0.003 → PASS |
| Standard errors | `abs(reported - computed)` < 0.05 | 0.21 vs 0.20 → diff = 0.01 → PASS |
| P-values | Same significance level | p<0.01 and p<0.01 → PASS; p<0.01 and p=0.03 → FAIL |
| Percentages | ±0.1pp | 42.3% vs 42.35% → PASS |

Respect any **tolerance overrides** the user has written into `replication-protocol.md`.

### Phase 4b: Disposition — PASS / FAIL / EXPLAINED / UNMATCHED

A tolerance check resolves to one of four dispositions:

- **PASS** — within tolerance.
- **FAIL** — outside tolerance, with no defensible alternative recorded. **Blocks** (exit 1).
- **EXPLAINED** — outside tolerance, **but** the author has recorded a *concrete, named alternative specification* that accounts for the gap (see the downgrade rule). Surfaced in the report; does **not** block.
- **UNMATCHED** — no computed counterpart found (Phase 3 confidence < 0.7). Never auto-downgradable.

**A mismatch is not automatically a failure.** In applied work the most common out-of-tolerance result is a *defensible alternative spec*, not a bug — a different SE type, a threshold choice (PEARLS≥3 vs ≥1), Firth vs plain logit, a different seed, or display rounding. The skill's job is to *stage the disagreement* for a human auditor, not to pronounce the code right and the paper wrong.

**The manuscript is not the oracle.** When the computed value disagrees with the manuscript, do not presume the code is correct and the paper stale — nor the reverse. A refactor may have broken a previously-correct table, or the paper may carry an old number. The computed value is a **challenger**, not ground truth. Report a mismatch as "one of {paper, code} must change — isolate which," never "revert the code to match the paper."

#### Downgrade rule: FAIL → EXPLAINED

A FAIL may be downgraded to EXPLAINED **only** when a *specific named alternative* is recorded for that exact claim in the audit report's author-note column. Example of a valid note:

> "PEARLS≥1 threshold vs ≥3; under ≥3 the published OR is 1.56, within rounding of the script's 1.561. CODE-CORRECTED pending."

The author is the **auditor**: the skill stages the two-sided comparison (reported value *and* computed value, both shown); the human writes the one-line named alternative; the skill records it and thereafter respects it. Tag the resolution `PAPER-CORRECTED`, `CODE-CORRECTED`, or `DEFENSIBLE-ALTERNATIVE`.

**Hard floor — never downgradable to EXPLAINED:**
- A blank note, "unclear", "looks fine", or any note that does not *name a concrete alternative spec*.
- An **UNMATCHED** claim (no computed counterpart to compare against).
- A flat numerical contradiction with no alternative offered.

### Phase 5: Report

Write `quality_reports/reproducibility_audit_[manuscript-name].md`:

```markdown
# Reproducibility Audit: [Manuscript Title]

**Date:** [YYYY-MM-DD]
**Manuscript:** [path]
**Outputs directory:** [path]
**Tolerance source:** .claude/rules/replication-protocol.md

## Summary

| Status | Count |
|---|---|
| PASS | N |
| FAIL (diff > tolerance, no named alternative) | M |
| EXPLAINED (out of tolerance, named alternative recorded) | E |
| UNMATCHED (manual review) | K |
| **Overall verdict** | **PASS / FAIL** (FAIL iff M > 0; EXPLAINED does not fail the audit) |

## PASS (all within tolerance)
| Claim | Reported | Computed | Diff | Tolerance |
|---|---|---|---|---|

## FAIL (outside tolerance — BLOCKER)
| Claim | Reported | Computed | Diff | Tolerance | Location in paper | Author note (name a concrete alternative to downgrade → EXPLAINED) |
|---|---|---|---|---|---|---|

## EXPLAINED (out of tolerance; defensible named alternative recorded — non-blocking)
| Claim | Reported | Computed | Named alternative (why the gap is defensible) | Resolution |
|---|---|---|---|---|

## UNMATCHED (manual review)
| Claim | Raw context | Candidate sources |
|---|---|---|

## Environment
[sessionInfo excerpt]

## Next steps
1. Resolve each FAIL row — correct the manuscript, rerun the analysis, or record a concrete named alternative to downgrade to EXPLAINED.
2. Review UNMATCHED rows — add explicit lookup keys or widen the search scope.
3. After zero FAILs (EXPLAINED rows allowed), the paper is replication-ready.
```

## Exit behavior

- **All PASS (or PASS + EXPLAINED):** exit 0, summary printed.
- **Any FAIL:** exit 1, summary printed to stderr. This makes the skill usable as a `/commit` pre-commit gate. **EXPLAINED rows do NOT count as FAIL** — they are surfaced, not blocking.
- **UNMATCHED > 0 (with 0 FAIL):** exit 0 with warning — user must manually review.

## Source-language coverage

The skill compares manuscript claims against outputs in three source-language ecosystems:

| Source | Default outputs dir | Read-output via | Common claim sources |
|---|---|---|---|
| **R** (default) | `output/` | `openxlsx::read.xlsx()`, `readRDS()`, `readr::read_csv()` | `.xlsx` FINAL tables / `.rds` / `.csv` |
| **Stata** | `_outputs/` (if a `.do` pipeline exists) | `haven::read_dta()` from R | `.dta` / `esttab` `.tex` / `.smcl` log values |
| **Python** | `output/` (or a `_outputs/` sibling) | `pandas.read_*`, `pickle.load` | `.parquet` / `.pickle` / `.csv` |

**Stata-specific note:** clustering df adjustments can differ between `reghdfe` and base `reg, cluster()`. If a SE mismatches at the 2nd decimal, the tolerance in `replication-protocol.md` covers it; if at the 1st decimal, investigate the df adjustment.

## Cross-references

- [`.claude/rules/replication-protocol.md`](../../rules/replication-protocol.md) — the tolerance contract.
- [`.claude/skills/review-r/SKILL.md`](../review-r/SKILL.md) — catches code-style issues; this skill catches NUMERICAL reproducibility.
- [`.claude/skills/diagnose/SKILL.md`](../diagnose/SKILL.md) — when a claim resolves to **FAIL** and you need to localize *which* pipeline step produced the out-of-tolerance value, hand off to `/diagnose`.
- [`.claude/skills/capture-environment/SKILL.md`](../capture-environment/SKILL.md) — environment capture (produces the `sessionInfo.txt` this skill looks for).

## What this skill does NOT do

- **Re-run your analysis.** The skill compares CURRENT outputs against manuscript claims. If the outputs are stale, re-run your pipeline first (the pre-flight phase will warn).
- **Catch wrong specifications.** A regression that produces a reproducible `1.558` is reproducible. Whether `1.558` is the RIGHT estimand is a domain-reviewer question.
- **Check external package versions.** The `sessionInfo.txt` capture lets a reviewer see the env; pinning versions is on the user (via `renv.lock`).

## Long batch reruns: use the Monitor tool

When asked to verify *all* numeric claims, the safest approach is to re-run the relevant pipeline scripts and compare the regenerated outputs to the manuscript values. For pipelines that take more than a couple of minutes, background-launch the rerun and use the **Monitor tool** to stream stdout, so the audit can react to errors mid-stream.
