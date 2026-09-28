# ADOPCION.md — registro de lo evaluado de `pedrohcgs/claude-code-my-workflow`

**Último upstream evaluado por completo:** `6347d4f` (v1.5.0, 2026-04-14) — es la versión
de la que salió el `.claude/` de Paces.
**Upstream disponible en el espejo:** `ae72617` (v2.6.0, 2026-09-27).
**Pendiente:** triar el delta v1.5.0 → v2.6.0 (sección 3).

Espejo: `~/repos/claude-code-my-workflow` (solo `git pull`, nunca se edita).
Filtro: este repo (`~/repos/daniel-workflow`, GitHub privado `dfmendivelso10/daniel-workflow`).
Proyectos: reciben del filtro, nunca del espejo.

## Cómo se usa

1. `cd ~/repos/claude-code-my-workflow && git pull`
2. `git diff --stat <último sha evaluado> HEAD -- .claude/` → solo lo nuevo desde la última revisión
3. Una decisión por archivo: **adoptado** (tal cual o traducido) · **adaptado** (se anota qué cambió)
   · **descartado** (se anota por qué) · **pendiente**
4. Una línea por archivo en la tabla que corresponda; actualizar "Último upstream evaluado"
5. Propagar a los proyectos solo lo adoptado/adaptado, con commit
   `chore(claude): actualizar desde daniel-workflow <sha>`

Criterio de adopción: sirve a proyectos de datos observacionales en R con datos restringidos
(Paces, TRIADA), o a un kit futuro (docencia/LaTeX, Stata); no duplica lo que ya hay; no
carga contexto sin necesidad.

---

## 1. Estado inicial — lo que Paces ya tiene (origen v1.5.0, adaptado a mano)

Inventario tomado de `Paces/.claude/` el 2026-09-28. Es el punto de partida de `base/` y del
kit `encuestas-r/`; falta copiarlo aquí (ver sección 4).

| Componente | Decisión | Nota |
|---|---|---|
| skills/commit | adaptado | versión v1.5: hace commit → PR → merge en un paso. **Reemplazar** por la v2.6 (se detiene en el commit) |
| skills/context-status | adoptado | |
| skills/checkpoint | adoptado | v2.6 trae otra versión + `session-handoff.py`; comparar |
| skills/data-analysis | adaptado | rutas `00_code/`, `02_outputs/` |
| skills/diagnose | adoptado | |
| skills/review-r | adaptado | español, `CLAUDE.md §5` |
| skills/ai-detect | propio | econ-ai-detector; no viene de upstream |
| skills/paces-voice | propio de Paces | NO va al filtro (estilo del grupo Harker) |
| agents/r-reviewer, verifier, domain-reviewer, econometrics-researcher | adaptado | español; leen `CLAUDE.md` |
| hooks/protect-files.sh | propio | protege `01_data/`; candidato a `base/` |
| hooks/pre-compact.py, post-compact-restore.py, verify-reminder.py | adoptado | v2.6 corrige `post-compact-restore.py` (leía el estado del plan por palabras sueltas) |
| rules/plan-first-workflow, orchestrator-protocol, session-logging, quality-gates, verification-protocol, exploration-fast-track, orchestrator-research, r-code-conventions, table-standards, replication-protocol | adaptado | español, umbrales 80/90; `table-standards` y la parte AER son propias |

## 2. Reglas globales de usuario (`~/.claude/rules/`), también de v1.5

meta-governance, session-logging, orchestrator-protocol, cross-artifact-review,
plan-first-workflow, resultados-formato (propia). v2.6 hace `meta-governance` y
`orchestrator-protocol` *path-scoped* (deja de cargarlos en toda sesión): **revisar**.

## 3. Delta v1.5.0 → v2.6.0 — pendiente de triaje

Preselección (leer en detalle antes de decidir). Lo no listado como candidato se propone
**descartar** por ser de docencia/Beamer/Quarto/TikZ, Stata, paquetes de R, simulaciones,
grants, Issues de GitHub u Oracle externo — salvo que aparezca un kit que lo necesite.

### Candidatos para `base/`

| Componente | Estado | Por qué |
|---|---|---|
| rules/confidential-data.md | pendiente | datos de menores en `01_data/`; deny rules para `settings.json` |
| rules/repo-hygiene.md | pendiente | qué se commitea y dónde va cada tipo de archivo |
| rules/model-routing.md | pendiente | costo/efecto por modelo; pines de `effort` |
| rules/summary-parity.md | pendiente | lo que el agente resume debe coincidir con lo hecho |
| rules/post-flight-verification.md | pendiente | verificación de afirmaciones del agente |
| rules/prompt-shaping.md | pendiente | corta; ver si aporta |
| skills/commit (v2.6) | pendiente | se detiene en el commit; `--pr` explícito; nunca mergea |
| skills/checkpoint + compress-session + hooks/session-handoff.py | pendiente | traspaso entre sesiones (incidente 2026-09-25) |
| skills/permission-check | pendiente | diagnóstico de permisos |
| skills/promote-memory + agents/promote-memory-council.md | pendiente | gobierno de MEMORY.md con tope de 25 KB |
| hooks/git-guardrails.py | pendiente | evitar `git add -A`, push accidental |
| hooks/root-of-trust-guard.py | pendiente | leer qué protege |
| hooks/claim-reconcile.py | pendiente | va con verify-claims |

### Candidatos para kit `encuestas-r/`

| Componente | Estado | Por qué |
|---|---|---|
| skills/disclosure-check | pendiente | celdas pequeñas en tablas de menores; asume `output/` → adaptar a `02_outputs/` |
| skills/verify-claims + credible-claims + agents/claim-verifier.md | pendiente | cifras del paper vs outputs; complementa `audit-reproducibility` |
| skills/capture-environment | pendiente | regenerar `ENTORNO.md` |
| skills/replication-package | pendiente | comparar con `04_scripts/exportar_paquete_replicacion.sh` de Paces |
| skills/power-analysis | pendiente | potencia con pocos eventos (Paces: 15 eventos en NNA con K10 ≥ 25) |
| skills/blast-radius, differential-audit | pendiente | leer; pueden ser útiles al tocar `config.R` |
| rules/inference-robustness.md | pendiente | |

### Candidatos para kit `paper/`

| Componente | Estado | Por qué |
|---|---|---|
| rules/writing-with-ai.md | pendiente | prosa del manuscrito |
| skills/humanize, voice-profile + agents/humanize-auditor.md | pendiente | Paces ya tiene `ai-detect` y `paces-voice`; ver solapamiento |
| skills/preregister, submission-disclosures, coauthor-brief | pendiente | ciclo de sometimiento |
| skills/review-paper (v2.6), seven-pass-review, adjudicate-review | pendiente | Paces usa las versiones de usuario (`~/.claude/skills`); comparar |

### Propuestos a descartar (no leer salvo que aparezca un kit)

skills: syllabus, teach-from-paper, scaffold-exercises, grant-proposal, issues, oracle-review,
respond-to-eval, r-package-check, simulation-study, stata-replication, triage-inbox, vaccinate,
new-skill, data-management-plan, verify-artifact, challenge.
agents: r-package-reviewer, sim-reviewer.
hooks: issue-guard.py, open-issues.py.
rules: issue-ledger, r-package-conventions, simulation-conventions, stata-code-conventions,
agent-authored-code, content-invariants, progress-reports, review-fencing.

## 4. Pendientes del filtro mismo

- [ ] Poblar `base/.claude/` y `kits/encuestas-r/`, `kits/paper/` desde Paces (sección 1).
- [ ] `nuevo-proyecto.sh <nombre> [kits...]`: copia `base/` + kits y rellena `CLAUDE.md`.
- [ ] Triar la sección 3 y actualizar "Último upstream evaluado" a `ae72617`.
