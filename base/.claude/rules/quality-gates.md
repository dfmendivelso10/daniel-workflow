---
paths:
  - "scripts/**/*.R"
  - "output/**"
---

# Quality Gates & Scoring Rubrics

**Purpose:** Define objective quality thresholds for committing R scripts and outputs.

---

## Scoring System

- **80/100 = Commit threshold** — Good enough to save progress
- **90/100 = Production threshold** — Publication-ready quality
- **95/100 = Excellence** — Aspirational target

---

## R Scripts (.R files)

### Critical (Must Pass for Commit)
| Issue | Deduction |
|-------|-----------|
| Script fails to execute | -100 (auto-fail) |
| Wrong N (does not match CLAUDE.md) | -100 (auto-fail) |
| Wrong variable used (see CLAUDE.md pitfalls) | -30 |
| Missing project config source | -20 |
| Hardcoded absolute paths | -20 |
| Wrong threshold or cutoff applied | -20 |

### Major (Should Pass for Production)
| Issue | Deduction |
|-------|-----------|
| Wrong SE type for estimator (see CLAUDE.md conventions) | -15 |
| No NA/missing data handling documented | -10 |
| Model spec deviates from config without justification | -10 |
| Known collinearity violation (see CLAUDE.md) | -10 |

### Minor (Nice-to-Have)
| Issue | Deduction |
|-------|-----------|
| Missing script header | -3 |
| Inconsistent naming convention | -2 |
| cat()/print() used for status | -1 |
| Lines > 100 characters | -1 |

---

## Output Tables

### Critical
| Issue | Deduction |
|-------|-----------|
| Wrong N reported | -100 (auto-fail) |
| Significance notation wrong (check CLAUDE.md) | -15 |
| Missing confidence intervals | -10 |

### Major
| Issue | Deduction |
|-------|-----------|
| Format deviates from table-standards.md | -5 |
| Missing footnotes | -3 |

---

## Output Figures

### Critical
| Issue | Deduction |
|-------|-----------|
| Figure not generated | -100 (auto-fail) |
| Wrong data plotted | -30 |

### Major
| Issue | Deduction |
|-------|-----------|
| Wrong device/dimensions (check CLAUDE.md) | -5 |
| Missing caption/source | -3 |

---

## Quality Gate Enforcement

### Commit Gate (score < 80)
Block commit. List blocking issues with required actions.

### Production Gate (score < 90)
Allow commit but warn. List issues with recommendations.

### User can override with justification when needed.
