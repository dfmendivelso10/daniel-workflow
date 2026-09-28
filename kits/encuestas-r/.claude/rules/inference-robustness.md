---
paths:
  - "scripts/**/*.R"
  - "scripts/**/*.do"
  - "scripts/**/*.py"
---

# Inferencia y robustez (pruebas múltiples y grados de libertad del investigador)

Estándares para las decisiones de inferencia que deciden si un resultado sobrevive a un
árbitro exigente, consolidados para que no vivan solo como una objeción de una línea.
Aplica a scripts de análisis empírico; el chequeo del lado del manuscrito está en
`/review-paper` (dimensión 3).

## Pruebas de hipótesis múltiples

Cuando un paper prueba **muchas hipótesis** (varios outcomes, subgrupos, brazos de
tratamiento o especificaciones), los valores p sin ajustar exageran la significancia.
Decidir la corrección **según lo que se controla, y prerregistrar la familia**:

- **Tasa de error por familia (FWER):** controlar la probabilidad de *cualquier* rechazo
  falso. Usar cuando incluso un falso positivo es costoso (la afirmación principal).
  - **Romano–Wolf** stepdown (remuestreo, explota la dependencia entre ecuaciones; mucho
    menos conservador que Bonferroni; R `wildrwolf`, Stata `rwolf`/`rwolf2`) es el default
    moderno para una familia pequeña.
  - Holm–Bonferroni como alternativa libre de distribución; Bonferroni simple solo para una
    familia diminuta.
- **Tasa de falsos descubrimientos (FDR):** controlar la *proporción esperada* de rechazos
  falsos entre los rechazos. Usar con **muchas** hipótesis donde algunos falsos positivos
  son aceptables (tamizaje, barridos de heterogeneidad).
  - Benjamini–Hochberg; los **q-values afinados en dos etapas de Anderson (2008)** son el
    estándar en micro aplicada (Stata `qvalue`/`sharpenedq`).
- **Prerregistrar la familia y la corrección** (la unidad de corrección es un grado de
  libertad del investigador). Reportar ajustados y sin ajustar; nunca elegir la familia que
  hace sobrevivir el resultado.

## Grados de libertad del investigador y robustez de especificación

Una sola especificación es un punto en un jardín de senderos que se bifurcan. Hacer
explícita la robustez:

- **Mostrar que la especificación no fue escogida a dedo:** una curva de especificaciones o
  multiverso (barrer los conjuntos de covariables defendibles, restricciones de muestra,
  formas funcionales; reportar la distribución de estimaciones, no una).
- **Leave-one-out / observaciones influyentes:** confirmar que el resultado no lo mueven
  unas pocas unidades o un solo conglomerado.
- **Robustez de la inferencia:** niveles alternativos de clustering, wild-cluster bootstrap
  con pocos clusters (`fwildclusterboot`/`boottest`), inferencia por aleatorización donde el
  diseño lo permita.

## Reporte

- Enunciar la **familia** y el **método de corrección** al inicio; reportar valores p
  sin ajustar *y* ajustados o q-values.
- Un chequeo de robustez que solo confirma la afirmación principal es teatro: reportar la
  especificación donde el resultado *se debilita*, e interpretarla.

## Referencias cruzadas

- `/review-paper` (dimensión 3, inferencia).
