---
name: differential-audit
description: Comparar dos implementaciones de lo mismo — un port (R↔Python↔Stata), una reimplementación, un paquete de replicación, un refactor, o una versión nueva contra la vieja — de modo que la coincidencia signifique algo. Congelar insumos primero, inventariar cada salida esperada, probar el comparador mismo, comparar cada canal (no solo la cifra principal), y dar a cada divergencia un ID estable y un testigo mínimo. Usar para paridad entre lenguajes, replicación, puertas de regresión al actualizar, o siempre que "los números coinciden" esté a punto de sostener una afirmación.
allowed-tools: ["Read", "Grep", "Glob", "Bash", "Write"]
metadata:
  protocol: implementation-fidelity
---

# Que la coincidencia signifique algo

Que dos implementaciones coincidan prueba que satisfacen un **contrato preespecificado**.
No prueba que alguna sea correcta, y nunca valida el método ni sus supuestos. Ambas pueden
estar mal de la misma forma — sobre todo cuando una se escribió leyendo la otra. Diseñar la
comparación para que la coincidencia informe y la discrepancia sea legible.

**Regla: congelar antes de comparar; probar el comparador antes de confiar en él.**

## 1. Enunciar la afirmación y la referencia

Escribir: qué se compara, cuál lado es la referencia y **qué establecería y qué no
establecería la coincidencia**. "Coincide con el paquete de R" es una afirmación de
conformidad, no de corrección. Decirlo explícitamente para que nadie lea paridad como
validación.

## 2. Congelar los insumos antes de mirar nada

Registrar y fijar: versiones o hashes de datos, versiones de código y paquetes, semillas o
particiones realizadas, opciones y defaults, las salidas a comparar y los umbrales de
aceptación. Congelar *después* de una primera mirada invita a que la tolerancia derive
hacia lo que la corrida produjo.

**No** comparar defaults entre sistemas como si solo cambiara el lenguaje. Mapear las
decisiones explícitamente: un "default" es una decisión de modelado sustantiva que suele
diferir entre implementaciones.

## 3. Declarar clases de tolerancia y hacerlas vinculantes

No cargar un solo épsilon difuso. Clasificar cada salida:

- **EXACTA:** nombres, orden, máscaras de muestra, conteos, estados, códigos de error,
  clases de advertencia, defaults. Iguales byte a byte tras una normalización documentada.
- **Escalar numérica:** estimaciones deterministas, errores estándar, valores p, valores
  críticos. Tolerancias absoluta y relativa declaradas, con justificación.
- **Matriz / vector:** matrices de covarianza, vectores de pesos, datos de gráficos.
- **Estocástica:** debe cumplir un criterio de tasa de error preespecificado con su
  incertidumbre reportada.

Una tolerancia más laxa se usa **solo** mediante una divergencia aprobada y registrada, con
razón. Ensanchar en silencio es la forma más común en que una puerta de paridad deja de
probar algo.

## 4. Crosswalk e inventario de salidas

Escribir el mapeo entre las dos implementaciones, más un inventario de cada salida esperada
con conteos esperados de filas y celdas. Cada objeto declarado debe tener **una comparación
viva o una razón explícita de fuera de alcance**. Sin inventario, ambos lados pueden omitir
en silencio el mismo resultado y la comparación reporta éxito.

## 5. Construir casos que aíslen mecanismos

No solo la ruta feliz:

- casos con solución analítica o verdad conocida;
- problemas de datos relevantes (faltantes, desbalance, casi colinealidad, pesos extremos
  pero válidos, filas en otro orden, empates);
- casos **compuestos** que combinen varios problemas;
- ejemplos publicados;
- diseños válidos aleatorizados sobre la superficie soportada, no un puñado de fixtures.

Los fixtures fijos son necesarios pero no suficientes: prueban lo que el autor ya pensó.

## 6. Probar el comparador mismo

Antes de confiar en un verde, alimentar la comparación con un valor incorrecto, un resultado
faltante, una fila desalineada y un resultado vacío. **Debe fallar, no saltar.** Un
comparador que pasa en silencio sobre lo que no puede reconciliar convierte cada verde
posterior en ruido.

## 7. Comparar cada canal declarado

No solo el coeficiente principal: estimaciones, medidas de incertidumbre, conteos de
muestra, etiquetas y orden, diagnósticos, advertencias y estados de falla. Advertencias
divergentes y comportamiento de error distinto son defectos reales: cambian lo que el
usuario hace después.

## 8. Dar a cada divergencia un ID y un testigo mínimo

Para cada diferencia: un identificador estable, el caso reproducible más pequeño y una
clasificación — **defecto / diferencia intencional / limitación de la referencia / sin
resolver**. Lo no resuelto queda en rojo; no se promedia ni se exime. Una corrección debe
poner en verde su testigo **y** sobrevivir a una nueva corrida de toda la auditoría.

## 9. Ampliación adversarial por alguien más

Los fixtures escritos por quien implementó prueban su propio modelo mental. Que un revisor
independiente añada diseños **no compartidos de antemano**, y conservar como fixtures
permanentes los que revelen fallas o amplíen cobertura.

## 10. Cerrar con revisiones separadas y un alcance honesto

Terminar con firmas científica e implementacional distintas, registrando: chequeos
corridos, hallazgos abiertos, diferencias aceptadas, no-afirmaciones explícitas y quién
aprobó. Decir claramente que la auditoría establece conformidad con el contrato congelado,
no la verdad del método.

## Lista mínima

1. Nombrar la referencia; decir qué establecería y qué no la coincidencia.
2. Congelar versiones, hashes, semillas, opciones, salidas, tolerancias.
3. Declarar clases de tolerancia vinculantes; registrar divergencias aprobadas.
4. Crosswalk + inventario de salidas con conteos.
5. Casos de verdad conocida, sucios, compuestos y aleatorizados.
6. Sembrar fallas en el comparador: debe fallar, no saltar.
7. Comparar todos los canales, incluidas advertencias y fallas.
8. ID estable + testigo mínimo + clasificación por divergencia; lo no resuelto queda rojo.
9. Revisor independiente añade diseños no vistos.
10. Firmas separadas; enunciar las no-afirmaciones.

## Caso de este flujo

`04_scripts/comparar_outputs_con_git.R` de Paces es un comparador de este tipo (xlsx por
celdas, PDF por texto, PNG por píxeles, `.rds` por `identical`). El paso 6 aplica: antes de
confiar en sus PASS, alimentarlo con un xlsx alterado y confirmar que reporta DIFF.
