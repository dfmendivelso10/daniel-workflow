---
name: data-analysis
description: Run the full econometric analysis pipeline. Validates data, executes R scripts, and audits statistical results for publication standards.
disable-model-invocation: false
argument-hint: "[filename | 'all' | 'regressions' | 'descriptives']"
---

# Econometric Data Analysis Pipeline

Run the comprehensive research validation protocol.

## Steps

1. **Validate Environment**:
   - Verify `Rscript` is available: `which Rscript || { echo "R not installed"; exit 1; }`
   - Verify critical packages are installed: `Rscript -e "stopifnot(requireNamespace('here'))"`
   - Verify that `config.R` (or equivalent project configuration file) exists.

2. **Identify Analysis Scope**:
   - If `$ARGUMENTS` is a specific `.R` file: analyze that file only.
   - If `$ARGUMENTS` is `descriptives`: find and run all scripts related to descriptive statistics (look for folders or files with `descriptive`, `eda`, or `01_` naming conventions).
   - If `$ARGUMENTS` is `regressions`: find and run all scripts related to regression analysis (look for folders or files with `regression`, `estimation`, or `02_` naming conventions).
   - If `$ARGUMENTS` is `all`: run the full pipeline by discovering and executing scripts in order.
   - If `$ARGUMENTS` does not match any of the above: stop and ask the user to clarify.
   - **Discovery method**: Use `find` or `Glob` to locate `.R` files. Respect numbering prefixes (e.g., `01_`, `02_`) for execution order.

3. **Execute and Monitor R Code**:
   - For each script in scope, execute via `Rscript` and capture all logs.
   - **Hard Requirement**: Verify that the project configuration file is sourced (e.g., `source(here::here("config.R"))`) to ensure reproducibility.
   - **If a script fails, stop the entire pipeline immediately.** Do not proceed to auditing. Report the specific R error.

4. **Audit results using the `econometrics-researcher` agent**:
   - Use the `Task` tool to launch `.claude/agents/econometrics-researcher.md`.
   - Pass it the script outputs and logs from step 3.
   - The agent will validate:
     - **Internal Consistency**: $N$ matches project constants.
     - **Econometric Rigor**: Robust/clustered SE, diagnostic tests (VIF, Breusch-Pagan).
     - **Domain Correctness**: Filters and thresholds applied correctly.
   - The agent owns the report format. Do not override its output structure.

5. **Review code quality using the `r-reviewer` agent**:
   - Use the `Task` tool to launch `.claude/agents/r-reviewer.md`.
   - The agent will check for hardcoded paths, data leakage, and naming conventions per `.claude/rules/r-code-conventions.md`.

6. **Final Output**:
   - The audit report from step 4 is saved by the `econometrics-researcher` agent to `quality_reports/`.
   - Summarize results to the user: pass/fail status of Hard Gates and any critical issues.

## Important
- **Do not modify R scripts** unless the user explicitly asks after reviewing the report.
- If step 3 fails, report the R error and stop. Do not run steps 4-5 on failed output.