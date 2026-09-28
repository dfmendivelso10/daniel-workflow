# daniel-workflow

Workflow personal de Claude Code para economía aplicada.

> **Estado 2026-09-28.** Este repo es el **filtro** entre el repo de Sant'Anna y mis
> proyectos. El espejo de Sant'Anna vive en `~/repos/claude-code-my-workflow` (v2.6.0,
> solo `git pull`); este filtro en `~/repos/daniel-workflow` (GitHub privado). El registro
> de qué se evaluó, adoptó o descartó de cada versión está en **`ADOPCION.md`**; ahí
> también está el diseño por capas (`base/` + `kits/`) y lo pendiente. Ojo: el `.claude/`
> que describe la sección "Estructura" de abajo todavía **no existe en este repo** — los
> archivos propios que lista viven hoy en `~/.claude/` y en `Paces/.claude/`; poblarlo es
> el pendiente 4.1 de `ADOPCION.md`.

Base: [pedro-hcgs/claude-code-my-workflow](https://github.com/pedrohcgs/claude-code-my-workflow) (Sant'Anna).
Extensiones propias: econometría macro-fiscal, tablas AER, Beamer, medición de impacto.

---

## Estructura

```
.claude/
├── agents/          revisores especializados (econometría, R, proofreading, etc.)
├── hooks/           automatizaciones de sesión
├── references/      perfiles de journals y referencias
├── rules/           estándares de código, tablas, redacción, DiD
├── skills/          rutinas reutilizables (DiD, compile-latex, commit, etc.)
└── settings.json    configuración de Claude Code
```

---

## Cómo usar

Copia `.claude/` a la raíz de cualquier proyecto de economía aplicada. Claude Code
lo detecta automáticamente y carga las reglas, agentes y skills.

---

## Cómo actualizar desde Sant'Anna

Cuando Sant'Anna publique cambios en su repo (el ciclo completo, con el registro
de decisiones, está en `ADOPCION.md`):

```bash
# 0. Actualizar el espejo y ver solo lo nuevo desde la última revisión
cd ~/repos/claude-code-my-workflow && gh repo sync dfmendivelso10/claude-code-my-workflow && git pull
git diff --stat <último sha evaluado en ADOPCION.md> HEAD -- .claude/

# 1. Ver qué cambió (alternativa desde este repo)
git fetch upstream
git diff main upstream/main -- .claude/

# 2. Revisar archivo por archivo
git diff main upstream/main -- .claude/rules/orchestrator-protocol.md

# 3. Adoptar un archivo específico que te interese
git checkout upstream/main -- .claude/rules/orchestrator-protocol.md

# 4. Adoptar todos los cambios de un directorio (revisar antes)
git diff main upstream/main -- .claude/agents/
git checkout upstream/main -- .claude/agents/verifier.md

# 5. Commit de lo que adoptaste
git add .claude/
git commit -m "sync: adoptar [descripción] de sant'anna upstream"
```

**Regla:** nunca `git merge upstream/main` directo — eso sobreescribiría tus
archivos propios. Siempre cherry-pick archivo por archivo.

---

## Archivos propios (no tocar al sincronizar)

Estos son tuyos — no vienen de Sant'Anna y no deben sobreescribirse:

| Archivo | Qué hace |
|---|---|
| `rules/resultados-formato.md` | Formato de redacción de resultados (Calibri 11, notación estadística) |
| `rules/econometrics-conventions.md` | SE clustered, DiD 2×2, bad controls, pre-registro |
| `rules/inference-robustness.md` | Leave-one-out, Romano-Wolf, grados de libertad |
| `rules/table-standards.md` | Tablas AER en openxlsx |
| `rules/beamer-slide-conventions.md` | Convenciones del deck Beamer |
| `rules/code-conventions.md` | Estilo R/Python para economía aplicada |
| `agents/code-reviewer.md` | Revisor de scripts R/Python econométricos |
| `agents/econometrics-researcher.md` | Validador de estrategia de identificación |
| `skills/did-event-study/` | DiD escalonado (Callaway-Sant'Anna) |
| `skills/explore-data/` | EDA rápido |
| `skills/run-analysis/` | Pipeline completo de análisis |

---

## Remotes

```
origin    → tu repo en GitHub (push aquí)
upstream  → https://github.com/pedrohcgs/claude-code-my-workflow.git (solo fetch)
```
