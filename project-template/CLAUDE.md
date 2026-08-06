# [Nombre del proyecto] — Instrucciones para Claude

## Proyecto
[Descripción breve: qué pregunta responde, para quién, con qué datos.]

- **Candidato/Autor:** Daniel Mendivelso (df.mendivelso10@gmail.com)
- **Fecha límite:** [VERIFICAR]
- **Período de análisis:** [rango de años]
- **Cobertura:** [países / regiones / unidades]

---

## Fuentes de Datos

| Fuente | Uso | Estado |
|--------|-----|--------|
| [Fuente principal] | Variable dependiente | [PENDIENTE] |
| [Fuente 2] | Variable de tratamiento | [PENDIENTE] |

---

## Reglas de Trabajo

### Datos
- **NUNCA** modificar archivos en `data/raw/` sin confirmación explícita.
- Datos limpios van en `data/processed/`.
- Todo output reproducible desde `data/raw/`.

### Código
- R: `source(here::here("code/config.R"))` al inicio de cada script.
- `config.R` define: rutas, semilla (`set.seed(42)`), paleta, parámetros.
- Scripts numerados en `code/`. Tablas → `outputs/tables/`, figuras → `outputs/figures/`.

### Verificación
Antes de reportar "completado":
1. Script ejecuta sin errores.
2. Output existe en la ruta esperada.
3. N de observaciones coincide con lo esperado.

---

## Estructura

```
code/
├── config.R
├── limpieza/        descarga y procesamiento
├── descriptivas/    tablas y figuras descriptivas
└── explorations/    análisis exploratorio (no publicable)

data/
├── raw/             fuentes crudas (NO tocar)
└── processed/       paneles limpios

outputs/
├── figures/
└── tables/

docs/                comunicación final
quality_reports/     planes, logs, auditorías
ai_logs/             prompts y decisiones de IA
```

---

## Estrategia de Identificación
[Llenar antes de estimar — forward engineering.]

---

## Hallazgos Clave
[Llenar conforme avanza el proyecto.]
