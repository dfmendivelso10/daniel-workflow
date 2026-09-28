---
paths:
  - "explorations/**"
---

# Exploration Fast-Track Protocol

**For experimental/exploratory analysis with a lower quality bar.**

---

## When to Use

- "What if we try PEARLS >= 2?"
- "Can you check if X correlates with Y?"
- "Run a quick model with these variables"
- Any analysis where the goal is learning, not publication

## When NOT to Use

- Final models for the paper
- Tables or figures for publication
- Data cleaning or pipeline changes
- Anything that modifies `data/` files

---

## Quality Threshold

**60/100** (vs. 80 for production work)

What 60/100 means:
- Script runs without errors: YES (non-negotiable)
- N is correct: YES (non-negotiable)
- Results are reasonable: YES (non-negotiable)
- Script header: optional
- Code style/polish: skip
- Output formatting: minimal
- Documentation: brief inline comments only

---

## Workflow

1. **Value check** — Will this exploration answer a meaningful question? If unclear, ask.
2. **Implement** — Write the script directly. No plan-mode required.
3. **Execute & verify** — Script runs, N correct, results make sense.
4. **Report** — Present findings to user with interpretation.
5. **Decide next step:**
   - **Continue exploring** — refine the analysis
   - **Graduate to production** — promote to a proper script with full quality standards
   - **Archive** — document what was tried and why it was abandoned

---

## Where Explorations Live

Exploratory scripts can live in:
- `explorations/` directory (if created)
- Temporary scripts that get deleted after discussion
- Inline R code in conversation (for quick checks)

If an exploration graduates to production, it moves to the appropriate `code/` subfolder and gets the full quality treatment.

---

## Kill Switch

Explorations can be abandoned at any time. No guilt, no cleanup required beyond a brief note of what was tried. Uncertainty is inherent to exploratory work.
