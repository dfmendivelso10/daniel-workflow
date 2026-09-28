---
name: credible-claims
description: Disciplina de "brief antes, registro de afirmaciones después" para trabajo de investigación delegado o asistido por IA. Usar al empezar cualquier tarea de investigación sustantiva o corrida autónoma larga (escribir el brief primero), y al reportar resultados que sostendrán una afirmación en un paper o una decisión (producir el registro). Evita confundir ejecución rápida con evidencia creíble.
allowed-tools: ["Read", "Grep", "Glob", "Write"]
metadata:
  protocol: bounded-delegation
---

# Afirmaciones creíbles: el brief antes, el registro después

Generar es cada vez más barato; validar sigue siendo escaso. La solución son dos artefactos
livianos: un **brief de investigación** que acota lo que el sistema puede hacer, y un
**registro de afirmaciones** que acota lo que puede reportarse. Aplica a agentes, flujos,
simulaciones, construcción de datos: cualquier cosa delegada.

## Tres reglas permanentes

1. **Delegar solo cuando insumos, límites y criterio de terminación están claros.** Nada de
   corridas abiertas tipo "mejóralo".
2. **Exigir evidencia, no conclusiones confiadas.** Toda tarea delegada devuelve evidencia
   inspeccionable: ubicaciones, diffs, diagnósticos, conteos, casos que fallan, logs. Nunca
   solo "listo / se ve bien".
3. **Escalar todo lo que cambie el objeto económico, los supuestos de identificación, el
   procedimiento inferencial o el lenguaje de reporte.** Esas decisiones vuelven al
   investigador (el usuario), siempre. Una decisión permanente del usuario cuenta como
   decisión devuelta; se registra.

## El brief (antes de ejecutar)

Un bloque corto, escrito antes de lanzar el trabajo:

- **Pregunta / objetivo:** qué exactamente se estima, prueba o construye.
- **Terminación:** qué cuenta como hecho; qué resultados *no* responderían la pregunta.
- **Sustituciones prohibidas:** qué no puede cambiar en silencio (estimando, muestra,
  supuestos, especificación de referencia).
- **Modos de falla conocidos:** qué suele salir mal aquí; los chequeos para cada uno.
- **Evidencia requerida:** qué debe volver (cifras, ubicaciones, diffs, diagnósticos).
- **Disparadores de escalamiento:** qué hallazgos o decisiones vuelven al usuario antes de
  seguir.
- **Ruta bloqueada:** una ruta que depende de datos no disponibles, un supuesto sin sustento
  o un resultado no probado se marca *bloqueada* — es un resultado científico, no una orden
  de buscar hasta que aparezca una respuesta favorable.

## El registro de afirmaciones (durante y después)

Para cada afirmación que el trabajo va a sostener:

- **Sustento:** qué datos, análisis o prueba la sostienen (con ubicaciones).
- **Cambios tras ver resultados:** todo lo modificado después de ver los resultados, y por
  qué (corrección disparada por un diagnóstico vs. cambio favorable — deben distinguirse).
- **Sin resolver:** chequeos que siguen abiertos y cómo acotan el lenguaje.
- **Decisión:** quién decidió qué se podía reportar (decisión del usuario vs. default del
  asistente).

Proporcionalidad: una tarea rutinaria necesita un párrafo; registros más pesados solo cuando
hay mucha ramificación, las salidas se reutilizan, los errores son costosos o corregir es
caro.

## Lenguaje de reporte

La decisión final nunca es "todos los chequeos en verde": es si la evidencia sostiene el
*lenguaje* propuesto. Las opciones son: reparar; **lenguaje más estrecho**; revisión
adicional; etiqueta *exploratorio/descriptivo*; o no reportar. Nunca subir el lenguaje por
encima de la evidencia (asociación ≠ causalidad; puntual ≠ uniforme; ilustrado ≠ validado;
impuesto ≠ derivado).

## Preguntas de credibilidad separadas

Reproducibilidad, corrección de la implementación, desempeño estadístico, validez de la
medición e identificación/alcance son preguntas distintas; la evidencia sobre una no responde
otra. Código reproducible puede implementar el estimador equivocado; simulaciones favorables
no establecen un supuesto; una estimación correcta puede responder la pregunta equivocada.

## Aprender hacia adelante

Cada falla diagnosticada se vuelve un artefacto durable: un test reutilizable, una advertencia
documentada o una entrada en `MEMORY.md` con la falla, su causa y el chequeo que ahora la
previene. Conservar los enfoques fallidos y la razón de la falla: una ruta bloqueada
reintentada sin un mecanismo nuevo es desperdicio.

## Referencias cruzadas

- [`orchestrator-protocol.md`](../../rules/orchestrator-protocol.md) — el brief de un
  fan-out de agentes.
