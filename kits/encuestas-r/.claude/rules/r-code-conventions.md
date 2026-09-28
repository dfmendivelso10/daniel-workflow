---
paths:
  - "scripts/**/*.R"
  - "config.R"
---

# R Code Standards

**Standard:** Publication-quality R code for quantitative research.

These standards apply to all R scripts in the project.

---

## 1. Project Configuration

Every script MUST begin by sourcing the project configuration file. This file should define:
- Library imports
- Path constants
- Clinical/analytical thresholds
- Model specifications
- Random seed
- Helper functions

Read `CLAUDE.md` to identify the project's configuration file and data loading function.

## 2. Script Structure

Every script should have a header block:
```r
###############################################################
# [PROYECTO] - [Titulo descriptivo]
# Autor: Daniel Mendivelso
# Fecha: [YYYY-MM-DD]
#
# Descripcion:
#   [1-3 lineas de que hace el script]
#
# Input:  [archivo(s) de entrada]
# Output: [archivo(s) de salida]
###############################################################
```

Logical flow: setup -> data loading -> computation -> output / export.

## 3. Reproducibility

- Random seed should be set ONCE in the project config (not in individual scripts)
- All packages loaded at top via `library()` (not `require()`)
- All paths relative to project root (use `here()` or config constants)
- `dir.create(..., recursive = TRUE, showWarnings = FALSE)` for output directories
- No hardcoded absolute paths
- Script must run cleanly via `Rscript` on a fresh clone

## 4. Missing Data

- Document the project's missing data conventions (see `CLAUDE.md`)
- Always report N per variable before regressions
- Document and justify any `na.rm` choices — default behavior varies by instrument
- Never impute or alter structural missing values without explicit justification

## 5. Model Specifications

- Use the project's centralized model specs from the config file
- If a script deviates from standard specs, document WHY in a comment
- Read `CLAUDE.md` for project-specific estimation conventions (SE type, reporting format)

## 6. Figure Standards

- Read `CLAUDE.md` for the project's figure conventions (device, dimensions, font, palette)
- Be consistent across all scripts — use the project's theme function if defined in config

## 7. Table Standards

- Read `.claude/rules/table-standards.md` for formatting conventions
- Use the project's standard export function if defined in config

## 8. Console Output

- Use `message()` for progress milestones only
- No `cat()`, `print()`, or `sprintf()` for status output
- Use logging functions from config if available

## 9. Code Quality Checklist

```
[ ] Project config sourced at top
[ ] Data loaded via project's standard function
[ ] N verified against CLAUDE.md expected sample sizes
[ ] Model specs from config (or deviation documented)
[ ] SE type matches project convention (see CLAUDE.md)
[ ] Output exists at expected path
[ ] No absolute paths
[ ] No cat()/print() for status
```

## 10. Known Pitfalls

Read `CLAUDE.md` "Variables: Errores Frecuentes" and `MEMORY.md` `[LEARN]` entries for project-specific pitfalls. These are the most common sources of silent bugs.
