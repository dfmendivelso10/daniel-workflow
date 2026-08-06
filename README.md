# daniel-workflow

Workflow personal de Claude Code para economía aplicada.

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

Cuando Sant'Anna publique cambios en su repo:

```bash
# 1. Ver qué cambió
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
