# ADOPCION.md — registro de lo evaluado de `pedrohcgs/claude-code-my-workflow`

**Último upstream evaluado por completo:** `ae72617` (v2.6.0, 2026-09-27).
**Evaluación anterior:** `6347d4f` (v1.5.0, 2026-04-14), de la que salió el `.claude/` de Paces.

Espejo: `~/repos/claude-code-my-workflow` (solo `git pull`, nunca se edita).
Filtro: este repo (`~/repos/daniel-workflow`, GitHub privado `dfmendivelso10/daniel-workflow`).
Proyectos: reciben del filtro con `aplicar.sh`, nunca del espejo.

## Cómo se usa

1. `cd ~/repos/claude-code-my-workflow && gh repo sync dfmendivelso10/claude-code-my-workflow && git pull`
2. `git diff --stat <último sha evaluado> HEAD -- .claude/` → solo lo nuevo desde la última revisión
3. Una decisión por archivo: **adoptado** (tal cual o traducido) · **adaptado** (se anota qué cambió)
   · **descartado** (se anota por qué) · **pendiente**
4. Una línea por archivo en la tabla que corresponda; actualizar "Último upstream evaluado"
5. Propagar a los proyectos: `bash aplicar.sh <proyecto> <kits...> [--qr --code --out --data]`
   y commit en el proyecto `chore(claude): actualizar desde daniel-workflow <sha>`

Criterio: sirve a proyectos de datos observacionales en R con datos restringidos (Paces,
TRIADA) o a un kit futuro; no duplica lo que ya hay; no exige rutas de layout que no usamos
salvo que la adaptación sea trivial; no carga contexto sin uso. Lo adoptado se traduce al
español cuando es una regla o skill corta; las skills largas y procedimentales (`checkpoint`,
`compress-session`, `permission-check`) quedan en inglés con rutas adaptadas: son
instrucciones internas para Claude.

## Capas del filtro

| Capa | Contenido | Va a |
|---|---|---|
| `base/` | plan-first, orchestrator, quality-gates, verification, exploration-fast-track, prompt-shaping, **confidential-data**; hooks git-guardrails, root-of-trust-guard, session-handoff, pre/post-compact, verify-reminder; skills commit, checkpoint, compress-session, context-status, diagnose, permission-check, blast-radius, differential-audit, credible-claims; `settings.template.json` | todo proyecto |
| `kits/encuestas-r/` | data-analysis, review-r; agentes r-reviewer, verifier, domain-reviewer, econometrics-researcher; r-code-conventions, table-standards, inference-robustness; protect-files.sh; fragmento de settings | proyectos de datos en R |
| `kits/paper/` | ai-detect; writing-with-ai | proyectos con manuscrito |

Layout: el filtro usa `quality_reports/`, `scripts/`, `output/`, `data/`; `aplicar.sh` los
sustituye por los del proyecto (Paces: `03_quality_reports/`, `00_code/`, `02_outputs/`,
`01_data/`). Archivos propios de un proyecto (p. ej. `skills/paces-voice`) se declaran en
`<proyecto>/.claude/PROPIOS.txt` y no se sobrescriben.

---

## 1. Componentes de v1.5.0 ya en uso (origen Paces)

| Componente | Decisión | Nota |
|---|---|---|
| rules/plan-first-workflow, orchestrator-protocol, orchestrator-research, quality-gates, verification-protocol, exploration-fast-track | adaptado → `base/` | español; rutas genéricas |
| rules/r-code-conventions, table-standards | adaptado → `kits/encuestas-r/` | `table-standards` es propia (AER en xlsx) |
| skills/context-status, diagnose | adoptado → `base/` | |
| skills/data-analysis, review-r | adaptado → `kits/encuestas-r/` | |
| skills/checkpoint (v1.5) | **reemplazado** por la v2.6 | |
| skills/commit (proyecto, directo a main) | **reemplazado** por la v2.6 adaptada | decisión de Daniel 2026-09-28 |
| skills/ai-detect | propio → `kits/paper/` | econ-ai-detector |
| skills/paces-voice | propio de Paces, **no entra al filtro** | `PROPIOS.txt` |
| agents/r-reviewer, verifier, domain-reviewer, econometrics-researcher | adaptado → `kits/encuestas-r/` | `effort: medium` en verifier y domain-reviewer (v2.6) |
| hooks/protect-files.sh | propio → `kits/encuestas-r/` | reescrito 2026-09-28: `data/*raw*/` bloquea, resto de `data/` pide confirmación |
| hooks/pre-compact.py, post-compact-restore.py | **reemplazados** por la v2.6 → `base/` | v2.6 lee el campo Status del plan en vez de palabras sueltas |
| hooks/verify-reminder.py | propio → `base/` | |
| hooks/log-reminder.py (en `04_scripts/`) | propio de Paces, se conserva | `aplicar.sh` conserva hooks del proyecto que el filtro no trae |

## 2. Delta v1.5.0 → v2.6.0

### Adoptados / adaptados (ola 1, 2026-09-28)

| Componente | Decisión | Nota |
|---|---|---|
| rules/confidential-data.md | **adaptado** → `base/` | español; regla 1 admite datos en repo privado como decisión escrita del proyecto; añade "solo agregados en salidas de R"; deny rules en `settings.template.json`; sección de copias que guarda Claude Code; sin IRB en README |
| rules/prompt-shaping.md | adoptado (traducido) → `base/` | |
| rules/writing-with-ai.md | adaptado (traducido) → `kits/paper/` | `/humanize` → `/ai-detect` |
| rules/inference-robustness.md | adaptado (traducido) → `kits/encuestas-r/` | `paths:` `scripts/**` → se sustituye por `00_code/**` al aplicar |
| rules/meta-governance.md, orchestrator-protocol.md (nivel usuario) | adaptado | añadir `paths:` como v2.6 para que no carguen en toda sesión |
| skills/commit | **adaptado** (reescrito en español) → `base/` | sin Step 0 (`quality_score.py`), 0b (`backtest.sh` valida el template) ni 0c (passports); paso 0 propio: `parse()` de los `.R` cambiados + agente `verifier` si existe; rama si en main; add por archivo; `--pr`; nunca merge |
| skills/checkpoint, compress-session + hooks/session-handoff.py | adaptado → `base/` | rutas por token; hook en `SessionStart(startup)` y `UserPromptSubmit` |
| skills/permission-check, blast-radius, differential-audit, credible-claims | adoptado → `base/` (las tres últimas traducidas) | sin referencias a `references/` no adoptadas |
| hooks/git-guardrails.py, root-of-trust-guard.py | adoptado → `base/` | timeout 20 (fijo en el código); probado: deniega `git add -A` y `echo > .claude/settings.json` |
| model-routing.md → solo la idea | pines de `effort` | verifier, domain-reviewer `medium`; referees `high` |

### Ola 2 — pendientes con valor claro

| Componente | Estado | Qué falta |
|---|---|---|
| skills/disclosure-check | pendiente | `.xlsx` (readxl) en el glob; default `02_outputs/tables/`; perfil irb; umbral n<10; PII cédula/TI |
| skills/verify-claims + agents/claim-verifier.md + rules/post-flight-verification.md | pendiente | `paths:` a review-paper/respond-to-referees de usuario; costo Opus high |
| skills/capture-environment | pendiente | detección `scripts/**/*.R`; salida a `ENTORNO.md` |
| skills/coauthor-brief | pendiente | rutas |
| skills/submission-disclosures | pendiente | cuando haya revista objetivo |

### Descartados (con motivo)

| Componente | Motivo |
|---|---|
| rules/repo-hygiene.md + scripts/check-repo-hygiene.py | layout fijo (`output/`, `scripts/`, `Slides/`), allowlists en el código; lo útil ya está en README §3 y CLAUDE §7 de Paces |
| rules/model-routing.md | nombra 15 agentes que no existen aquí; se aplicó solo la idea de los pines |
| rules/summary-parity.md | para mantener un template, no un proyecto |
| skills/promote-memory + agents/promote-memory-council.md | criterio "¿sirve a un forker de otra disciplina?"; en un proyecto casi todo vota NO |
| skills/humanize, voice-profile + agents/humanize-auditor.md | léxico y calibración en inglés; ya hay `ai-detect` y `paces-voice` |
| skills/replication-package | asume LaTeX (`\input{}`) y `output/`; Paces tiene `exportar_paquete_replicacion.sh` + README WB |
| skills/power-analysis, preregister | solo ex-ante; kit futuro de diseño de estudios |
| hooks/claim-reconcile.py | sin passports no hace nada; regex fijo a `scripts/` y `output/` |
| Todo docencia/Beamer/Quarto/TikZ, Stata, paquetes de R, simulaciones, grants, Issues, Oracle | fuera de alcance; quedan en el espejo para un kit futuro |

## 3. Pendientes del filtro

- [ ] `project-template/CLAUDE.md` con placeholders `[CODE] [DATA] [OUT] [QR]` para `nuevo-proyecto.sh`.
- [ ] Kit `latex-docencia/` cuando haga falta (todo está en el espejo).
- [ ] Ola 2.
