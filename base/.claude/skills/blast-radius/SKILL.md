---
name: blast-radius
description: Antes y después de cambiar algo compartido — el valor de retorno de una función, una firma, un esquema, un conjunto de etiquetas, un default de configuración, una constante, un formato de archivo — encontrar a todos los consumidores y correrlos de verdad. Atrapa el cambio que parece puramente aditivo pero rompe en silencio un contrato en un archivo que nunca abriste. Usar al editar código compartido (config.R, utils/), añadir un campo/columna/elemento de retorno, renombrar, cambiar unidades o defaults, o tocar un pipeline que produce cifras reportadas.
allowed-tools: ["Read", "Grep", "Glob", "Bash", "Write"]
metadata:
  protocol: bounded-delegation
---

# Conocer el radio de impacto antes de cambiar

El cambio peligroso no es el que parece arriesgado. Es el que **parece puramente aditivo**
—añadir un valor de retorno, una columna, una opción— y viola en silencio un contrato tres
archivos más allá que nadie releyó. Ni la compilación ni los chequeos de tipo atrapan un
contrato posicional o de longitud: se obtiene un error lejos de la edición o, peor, una
salida silenciosamente incorrecta.

**Regla: si cambias una interfaz compartida, corre a sus consumidores. Leerlos no es
correrlos.**

## 1. Enumerar los consumidores antes de editar

`grep` de cada llamada, `source`, import y referencia aguas abajo — incluidos tests,
notebooks, scripts, documentación y todo lo que regenere resultados reportados. Marcar
cuáles producen cifras que aparecen en un paper, un informe o una entrega: ahí el fallo
silencioso cuesta más.

Si un consumidor vive en otro repositorio, otro lenguaje o un artefacto generado, anotarlo
ahora; no lo recordarás al verificar.

## 2. Nombrar el contrato que vas a cambiar

Preguntar explícitamente qué tiene derecho a asumir el código aguas abajo:

- **Aridad / longitud:** ¿algo indexa por posición, empareja con una lista fija o
  prealoca una matriz de ancho conocido? *Añadir un elemento rompe los tres.*
- **Nombres y orden:** ¿algo empareja por nombre, por posición, o contra una lista
  paralela de etiquetas?
- **Tipos, unidades, escala:** pesos vs. miles, tasa vs. porcentaje, 0-indexado vs.
  1-indexado, `integer` vs. `double`.
- **NA y centinelas:** casos vacíos o `NA` nuevos que un consumidor no espera.
- **Defaults:** cambiar un default cambia en silencio a todo el que dependía de él.
- **Identidad y orden:** orden de filas, estabilidad del `sort`, unicidad de claves.

La falla clásica: un vector devuelto pasa de 6 a 7 elementos mientras un consumidor lo
empareja contra una lista fija de 6 etiquetas. Nada falla en el sitio de la edición; el
consumidor revienta lejos o, peor, recicla y etiqueta mal todas las filas.

## 3. Preferir cambios que no puedan romper un contrato

Aditivo-y-por-nombre gana a aditivo-y-posicional. Donde controlas el consumidor, empareja
por nombre. Donde no, versiona la interfaz en vez de ensancharla en el sitio.

**No** "arregles" un desajuste derivando etiquetas o configuración de los datos nuevos si
las etiquetas viejas eran deliberadamente distintas: el reetiquetado deliberado existe
(nombres de presentación distintos de los internos) y autoderivarlo cambia en silencio la
salida publicada.

## 4. Correr los consumidores, de punta a punta, con insumos reales

Un consumidor que solo carga no está ejercitado. Correr al menos una ruta completa por cada
patrón de consumidor distinto, y preferir la que regenera cifras reportadas.

Luego verificar **ambas** direcciones:

- Lo nuevo funciona.
- **Lo viejo no cambió.** Diff de las salidas reportadas antes; todo lo que se movió debe
  tener una razón que puedas enunciar. Si el cambio debía preservar el comportamiento, la
  evidencia es byte-idéntico o dentro de una tolerancia declarada — no "corrió".

## 5. Verde no informa nada si nada corrió

Confirmar que el chequeo se ejecutó de verdad y podía fallar: un test saltado, un caso
filtrado, una excepción tragada por un default o una tolerancia ensanchada después de
comparar son indistinguibles de un éxito en un log. Cuando el cambio importa, **sembrar un
defecto** y confirmar que el chequeo se pone en rojo: una comparación que no puede fallar
no es evidencia.

## 6. Registrar el cambio de contrato

Si la interfaz cambió de verdad, decirlo donde los consumidores mirarán: una entrada en el
CHANGELOG o en `MEMORY.md`, o un comentario en la definición que diga qué puede asumir el
código aguas abajo. Para todo lo que se reutilice, congelar insumos (versiones, hashes,
semillas) y tolerancias declaradas, para que la próxima comparación sea reproducible y no
renegociada.

## Lista mínima

1. `grep` de todos los consumidores, incluidos tests, scripts, docs, otros repos/lenguajes.
2. Escribir el contrato: aridad, nombres, orden, tipos, unidades, defaults, orden.
3. Hacer el cambio por nombre o versionado donde se pueda.
4. Correr al menos una ruta completa por patrón de consumidor.
5. Diff de salidas reportadas; explicar cualquier movimiento.
6. Sembrar un defecto para probar que el chequeo puede fallar.
7. Registrar el cambio de contrato donde los consumidores lo vean.

## Caso de este flujo

El caché del SEM de Paces (2026-09-23): se recodificó `sexo_mujer` en `00_helpers_logit.R`
sin correr a sus consumidores; los scripts de las Tablas 8-9 recargaron bootstraps viejos y
reportaron `VERIFICATION PASS` sobre cifras obsoletas. El paso 4 lo habría atrapado.
