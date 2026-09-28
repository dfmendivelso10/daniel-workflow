# [Nombre del proyecto] — Contexto para Claude

**Autor:** Daniel Mendivelso (df.mendivelso10@gmail.com)
**Ultima actualizacion:** [YYYY-MM-DD]

Este archivo es la fuente de contexto del proyecto para el sistema `.claude/`. La
configuracion tecnica (rutas, librerias, parametros) vive en `[CODE]/config.R`.

---

## 1. Proyecto

[Que pregunta responde, para quien, con que datos. Tres lineas.]

- **Poblacion / unidad de analisis:** [...]
- **Periodo y cobertura:** [...]
- **N esperado:** [...] — todo script lo reporta antes de estimar; si difiere, investigar.

## 2. Datos

| Archivo (`[DATA]/raw/`) | Contenido | Uso |
|---|---|---|
| [fuente principal] | [...] | [...] |

**Decision sobre git (escribir aqui, con fecha):** [ (a) `[DATA]/` en `.gitignore`, copias en
disco + respaldo institucional  |  (b) en este repo privado, nunca publico ]. Fecha: [...].

**Sensibilidad:** [publicos / restringidos / datos de personas]. Si son de personas: Claude
no abre `[DATA]/` (deny rules en `settings.json`) y las salidas de los scripts solo
imprimen agregados. Regla completa en `.claude/rules/confidential-data.md`.

## 3. Variables y errores frecuentes

[Una entrada por pitfall descubierto: variable, que se asumia, que es cierto, donde se
corrige. Esta seccion la leen los agentes revisores.]

## 4. Especificaciones

[Modelos M1..Mk centralizados en `[CODE]/config.R`; desviaciones documentadas aqui.]

## 5. Convenciones tecnicas

- Semilla global en `config.R`; cada bootstrap fija la suya.
- Rutas con `here::here()`; ancla `.here` en la raiz. Nunca rutas absolutas.
- Tablas y figuras: `.claude/rules/table-standards.md` (si aplica).
- Logs: `iniciar_log()` / `cerrar_log()` de `config.R` → `logs/`.

## 6. Pipeline

```
Master_Script.R      → punto de entrada; un proceso por script; el primer fallo detiene
[CODE]/              → scripts numerados por fase (limpieza, descriptivas, figuras, modelos)
[CODE]/utils/        → funciones compartidas
[DATA]/raw/          → crudos (nunca se modifican)   [DATA]/cleaned/ → generados
[OUT]/tables/, [OUT]/figures/ → todo lo que vive aqui lo genera el Master
[QR]/plans/, [QR]/session_logs/, [QR]/checkpoints/ → planes, bitacoras, traspasos
```

## 7. Como usar este archivo

- Antes de escribir un script: leer §3 y §4.
- Cuando el usuario corrija un error: entrada `[LEARN:tag]` en `MEMORY.md` y, si aplica, §3.
