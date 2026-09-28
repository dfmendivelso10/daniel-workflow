---
name: capture-environment
description: Snapshot the computational environment for a replication package — detects the analysis stack (R / Python / Stata) and emits the right lockfiles (renv.lock + sessionInfo.txt, requirements.txt / environment.yml / uv.lock, Stata version + ado package list), records seeds and RNG kind, optionally writes a pinning Dockerfile, and produces a paste-ready "Computational requirements" block. Use when the user says "capture the environment", "snapshot my dependencies", "pin the versions", "make a renv.lock / requirements.txt", "make this byte-reproducible", or before releasing a replication package.
argument-hint: "[project-dir] [--docker] [--no-verify] (project-dir defaults to repo root)"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Bash"]
effort: medium
---

# `/capture-environment` — snapshot the computational environment

A replication package that runs on the author's laptop in 2026 and nowhere else in 2029 is not reproducible. This skill captures the *exact* computational environment — language versions, package versions, seeds, RNG kind, and (optionally) the OS layer — so a referee or future-you can reconstruct it. It detects which stack the project uses and emits the artifacts that stack's ecosystem expects, then verifies the lockfile installs clean. These projects are primarily R (`renv`-managed), sometimes with a Python `.venv` for a few extraction/diagnostic scripts; Stata support is kept for future collaborators.

**Core principle:** Pin everything a result depends on. Display rounding aside, a re-run on a pinned environment should reproduce the paper to the [`replication-protocol.md`](../../rules/replication-protocol.md) tolerances — *byte-identical* when the optional Dockerfile is used.

## When to use

- **Before releasing a replication package** to a journal archive / openICPSR — the standard expects a documented, version-pinned environment.
- **Before submission**, alongside [`/audit-reproducibility`](../audit-reproducibility/SKILL.md) — that skill checks the *numbers*; this one captures the *environment* those numbers were produced in (its `sessionInfo.txt` requirement is satisfied by this skill).
- **After adding or upgrading a package** mid-project — re-snapshot so the lockfile doesn't drift from what the code actually loads.
- **When handing the project to a co-author or RA** who needs to reconstruct the stack.

## Inputs

- `$0` — project directory. Defaults to the repo root. The skill looks under `scripts/` (R and Python scripts live here) and, if present, any `.do` files.
- `--docker` — also emit a `Dockerfile` pinning OS + language version + system libraries for byte-identical reproduction.
- `--no-verify` — skip Phase 3 (the best-effort clean-install check).

## Workflow

### Phase 0: Detect the stack

Glob for stack signals and decide which capture paths to run (a project may be multi-language — most analysis in R, a couple of extraction/diagnostic scripts in Python):

| Signal | Stack | Capture path |
|---|---|---|
| `scripts/**/*.R`, `DESCRIPTION`, `renv/`, `*.Rproj`, `renv.lock` | **R** | renv + sessionInfo |
| `scripts/**/*.py`, `*.ipynb`, `.venv/`, `pyproject.toml`, `requirements.txt`, `environment.yml`, `uv.lock` | **Python** | pip / conda / uv |
| `**/*.do` | **Stata** | version + ado list |

If no signal is found, report and stop — there is no environment to capture.

### Phase 1: Capture per language

**R** — emit two artifacts:
- `renv.lock` via `renv::snapshot()` (run `renv::init(bare = TRUE)` first if the project isn't renv-managed; snapshot records every package + version + source/remote and the R version). Honors the seed conventions in [`r-code-conventions.md`](../../rules/r-code-conventions.md).
- `sessionInfo.txt` via `Rscript -e "writeLines(capture.output(sessionInfo()), 'output/sessionInfo.txt')"` — the human-readable companion `/audit-reproducibility` looks for.

**Python** — emit whichever matches the project's existing tooling (do not invent a new one):
- `uv.lock` (preferred when `pyproject.toml` + `uv` present — fully-resolved, hashed, cross-platform): `uv lock` / `uv export --format requirements-txt > requirements.txt`.
- `requirements.txt` via `pip freeze` (from the project `.venv`; `python -m pip freeze`) for a venv/pip project — pin `==` exactly.
- `environment.yml` via `conda env export --no-builds` for a conda project.
Always also record the interpreter version (`python --version`) in the report.

**Stata** — Stata has no lockfile, so capture the closest equivalents:
- The pinned `version` line each `.do` file declares (e.g. `version 18`) — grep `**/*.do` and report the version actually pinned.
- An ado/plus package inventory: a small `.do` that runs `which` on the user-installed commands the pipeline uses (`reghdfe`, `ivreg2`, `estout`/`esttab`, `rdrobust`, `csdid`, …) plus `ado dir` and `about`, logged to a `_outputs/sessionInfo.txt`.
- A note that Stata version pinning is *semantic* (`version 18` fixes command behavior), not a binary pin — record the exact Stata version + flavor (SE/MP/IC) + update level in the report so a replicator can match it.

### Phase 1b: Record seeds and RNG

Grep the analysis scripts for the master seed and RNG kind so the "Computational requirements" block can state them:
- **R**: `set.seed(...)` (in this workflow the seed lives in `config.R`), and `RNGkind()` — flag `"L'Ecuyer-CMRG"` if parallel/bootstrap work is present.
- **Python**: `numpy.random.default_rng(seed)` / `random.seed()` / framework seeds.
- **Stata**: `set seed` and `set sortseed`.

If the pipeline does randomized work (bootstrap, MC, permutation inference) and **no** seed is found, surface it as a WARNING — an unseeded random result is not reproducible.

### Phase 2: Dockerfile (only with `--docker`)

Emit a `Dockerfile` that pins the OS + language version + system libraries for byte-identical reproduction:
- **R** → `FROM rocker/r-ver:<X.Y.Z>`, `COPY renv.lock`, `RUN R -e "renv::restore()"`, plus `apt-get install` for system libs the packages need (e.g. `libcurl4-openssl-dev`).
- **Python** → `FROM python:<X.Y.Z>-slim`, `COPY requirements.txt` / `uv.lock`, `RUN pip install -r requirements.txt` (or `uv sync --frozen`).
- **Stata** → cannot pin the licensed binary; emit a `Dockerfile` stub that documents the expected Stata version + flavor and leaves the install/license step to the replicator.

Pin a digest where possible (`FROM image@sha256:…`) so the base image can't drift.

### Phase 3: Verify the lockfile installs clean (best-effort; skip with `--no-verify`)

Attempt a clean restore in a throwaway location and report PASS / FAIL — never overwrite the working environment:
- **R**: `renv::restore()` into a temp library, or `Rscript -e "renv::status()"` for a dry check.
- **Python**: `uv sync --frozen` / `pip install --dry-run -r requirements.txt` into a fresh venv.
- **Docker** (if `--docker`): `docker build` the image.

A FAIL means the lockfile references a version that can't be resolved; report it, do not auto-edit the lockfile.

### Phase 4: Report

Print a paste-ready block and write it to `output/computational_requirements.md`:

```markdown
## Computational requirements

**Software:** R 4.4.x (and: Python 3.13.x; Stata 18.0 SE if used)
**OS used:** macOS (arm64) — Dockerfile pins Ubuntu for portability
**Key packages:** [top packages] (full list in renv.lock / requirements.txt)
**Random seeds:** set.seed(...) from config.R
**Approx. runtime:** [author confirms]
**Lockfiles in package:** renv.lock, output/sessionInfo.txt[, requirements.txt, Dockerfile]
```

Pre-fill software/package/seed lines from the captured artifacts; leave runtime for the author to confirm.

## Output / artifacts

| Stack | Files written |
|---|---|
| R | `renv.lock`, `output/sessionInfo.txt` |
| Python | `requirements.txt` *or* `environment.yml` *or* `uv.lock` (matching project tooling) |
| Stata | `_outputs/sessionInfo.txt` (version + ado list) |
| Any (`--docker`) | `Dockerfile` |
| Always | `output/computational_requirements.md` (the paste-ready block) |

## Exit behavior

- **All captures succeeded, verify PASS (or `--no-verify`):** exit 0, requirements block printed.
- **Missing-seed WARNING on a randomized pipeline:** exit 0 with the warning surfaced.
- **Verify FAIL (lockfile won't resolve):** exit 1, so the skill can gate a pre-release `/commit`.
- **No stack detected in Phase 0:** exit 1 with the directories searched.

## Cross-references

- [`.claude/rules/replication-protocol.md`](../../rules/replication-protocol.md) — the tolerance contract a pinned environment is meant to reproduce.
- [`.claude/rules/r-code-conventions.md`](../../rules/r-code-conventions.md) — R seeding + output-path conventions this skill reads.
- [`/audit-reproducibility`](../audit-reproducibility/SKILL.md) — consumes the `sessionInfo.txt` this skill produces; run it after.
- [`/data-analysis`](../data-analysis/SKILL.md) — the pipeline whose environment this snapshots.
- [AEA Data Editor checklist](https://aeadataeditor.github.io/) / [openICPSR](https://www.openicpsr.org/) — the external standards this skill targets.

## What this skill does NOT do

- **Re-run your analysis or check your numbers.** It captures the environment; [`/audit-reproducibility`](../audit-reproducibility/SKILL.md) verifies the manuscript's numeric claims against the outputs.
- **Package or de-identify data.** Lockfiles describe software, not data.
- **Upgrade or "fix" your dependencies.** It records what the code currently uses.
- **Pin a Stata binary.** Stata is licensed and not redistributable; the skill records the exact version/flavor/update so a replicator can match it.
