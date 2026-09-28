---
name: sync-workflow
description: Revisa qué publicó Pedro Sant'Anna en claude-code-my-workflow desde el último sha evaluado en ADOPCION.md, lee cada pieza nueva en el espejo y propone adoptar / adaptar / descartar. No escribe en base/ ni kits/ sin aprobación. Usar dentro de ~/repos/daniel-workflow cuando el usuario diga "sync workflow", "qué hay nuevo en el repo de Pedro", "revisar upstream".
argument-hint: "[--since <sha>] [--apply]"
disable-model-invocation: true
allowed-tools: ["Read", "Grep", "Glob", "Bash", "Write", "Edit", "AskUserQuestion", "Agent"]
---

# /sync-workflow — novedades de upstream, una decisión por archivo

Corre **dentro del filtro** (`~/repos/daniel-workflow`). El estado vive en `ADOPCION.md`
("Último upstream evaluado"); el material se lee en el **espejo**
`~/repos/claude-code-my-workflow`, nunca por la API ni desde un proyecto.

## Procedimiento

### 1. Actualizar el espejo y medir el delta

```bash
gh repo sync dfmendivelso10/claude-code-my-workflow
git -C ~/repos/claude-code-my-workflow pull --ff-only
DESDE=$(grep -m1 'Último upstream evaluado' ADOPCION.md | grep -oE '`[0-9a-f]{7}`' | tr -d '`')
git -C ~/repos/claude-code-my-workflow log --oneline ${DESDE}..HEAD | wc -l
git -C ~/repos/claude-code-my-workflow diff --stat ${DESDE}..HEAD -- .claude/ scripts/ templates/
git -C ~/repos/claude-code-my-workflow tag --contains ${DESDE} | tail -3
```

Si el delta es 0: decirlo y terminar. No inventar trabajo.

### 2. Leer las notas de la versión antes que los archivos

`CHANGELOG.md` del espejo (sección de la versión nueva) explica el *por qué*; los commits
de Pedro son frases largas, no etiquetas. Leerlo completo para la versión nueva.

### 3. Una ficha por archivo nuevo o modificado

Para cada ruta del `diff --stat` bajo `.claude/` (y `scripts/` si es un checker o un hook
battery): qué hace en 2-3 frases, líneas, de qué depende (skills/agents/hooks/scripts que
invoca), rutas de layout que asume (`output/`, `scripts/`, `quality_reports/` son
genéricas y `aplicar.sh` las sustituye; `_outputs/`, `master_supporting_docs/`, `Slides/`
no), si es R o genérico, y qué lo haría inaplicable (inglés en detectores de prosa,
docencia, Stata, template-only). Con más de ~10 archivos, delegar las fichas a un agente
`Explore` y quedarse con las decisiones.

Para un archivo que **ya está** en `base/` o en un kit: comparar el diff conceptual con
la versión del filtro (`diff <(espejo) <(filtro)`), no sobrescribir. Lo del filtro es una
adaptación (traducción, rutas, decisiones de Daniel).

### 4. Clasificar con el criterio de `ADOPCION.md`

- **adoptar** → `base/` si sirve a todo proyecto; a un kit si es de dominio.
- **adaptar** → igual, anotando qué cambia (traducción, rutas, gates del template que se
  quitan, referencias a skills no adoptadas).
- **descartar** → con motivo de una línea (docencia/LaTeX/Stata/paquetes R/simulación/
  Issues/Oracle/template-only, o duplica algo del filtro).
- **pendiente** → solo si hace falta una decisión de Daniel; formular la pregunta.

### 5. Presentar y preguntar

Tabla por capa (base / kit / descartar), y `AskUserQuestion` solo por lo que cambie
comportamiento (un hook nuevo, un `/commit` distinto, una deny rule). Sin `--apply`, aquí
termina.

### 6. Con `--apply` y aprobación

1. Copiar del espejo a `base/` o `kits/<kit>/`, con rutas genéricas
   (`quality_reports/`, `scripts/`, `output/`, `data/`).
2. Traducir reglas y skills cortas; las largas y procedimentales quedan en inglés con
   rutas genéricas.
3. Probar: `python3 -m py_compile` de hooks nuevos; `bash aplicar.sh <copia-en-scratchpad>
   ... --dry-run` y una aplicación real sobre una copia del `.claude/` de Paces.
4. `ADOPCION.md`: una línea por archivo en la tabla que corresponda; actualizar
   "Último upstream evaluado" al sha y fecha nuevos.
5. Commit en el filtro; push. Propagar a los proyectos con `aplicar.sh` y su commit
   `chore(claude): actualizar desde daniel-workflow <sha>`.

## Qué NO hace

- No lee upstream por la API de GitHub: el espejo es la fuente y se actualiza primero.
- No toca los proyectos (Paces, TRIADA): eso es `aplicar.sh`, en su sesión.
- No sobrescribe una adaptación del filtro con la copia cruda de upstream.
- No modifica `MEMORY.md` de ningún proyecto.

## Frecuencia

Pedro publica cada 1-3 meses. Al empezar una fase nueva, o cuando Daniel lo pida.
