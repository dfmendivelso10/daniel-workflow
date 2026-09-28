---
paths:
  - "**/*.tex"
  - "**/*.qmd"
  - "**/*.md"
  - "**/*.Rmd"
---

# Escribir con IA: qué hace que la prosa se lea como humana

Dos problemas distintos se confunden, y confundirlos gasta esfuerzo en el equivocado.

| Problema | Qué es | Qué lo arregla |
|---|---|---|
| **Legibilidad** | la prosa es difícil de seguir, llena de rodeos, relleno o genérica | editar; vale la pena sin importar quién la escribió |
| **Procedencia** | la prosa se lee como *generada por máquina* para un detector o un lector suspicaz | **solo reescritura humana genuina**, más declaración |

Un detector (`/ai-detect`) mide lo segundo. Ninguna skill de reescritura lo resuelve, y esta
regla existe para que nadie crea lo contrario.

---

## El hallazgo medido que da forma a esta regla

Un artículo pasó por varias rondas de "des-IA" superficial: menos guiones largos, sin
"delve", transiciones variadas, longitudes de oración mezcladas. Enviado a **Pangram**, un
detector neuronal de texto de IA, volvió como **100 % escrito por IA**.

**Por qué.** Detectores como Pangram no buscan guiones largos ni un léxico de clichés. Son
clasificadores neuronales entrenados en la **estadística a nivel de token de la generación
por LLM**: patrones de probabilidad de elección de palabras que persisten a través de
*cualquier* transformación que el modelo aplique, porque **cada transformación sigue siendo
texto generado por un LLM**.

> **Un modelo no puede hacer que su propia salida deje de leerse como salida de modelo.**
> Pedirle a Claude que "lo haga sonar más humano" produce texto distintamente-LLM, no
> menos-LLM. Lo único que cambia la estadística subyacente es **un humano escribiendo las
> oraciones.**

Es el mismo problema estructural que un revisor calificando su propio trabajo, un nivel más
abajo.

---

## Qué hacer en cambio

### 1. Decidir qué es el documento

- **Interno:** notas, session logs, planes, andamiaje de análisis. Redactado por IA está
  bien. Optimizar precisión y velocidad; nadie lo lee por la voz.
- **De cara afuera:** un paper, un informe de arbitraje, una propuesta, un correo a un
  coautor o editor. **Sujeto al estándar de abajo.**

Todo manuscrito, y cualquier cosa con tu nombre que va a otra persona, es de cara afuera.

### 2. En lo de cara afuera, el autor escribe la prosa que carga el argumento

Usar el modelo para estructura, para una primera pasada de secciones mecánicas, para
atrapar lo que faltó — y luego **escribir uno mismo las oraciones que sostienen el
argumento.** El resumen, la introducción, el párrafo de contribución y la interpretación de
resultados son donde un lector decide si confiar. También son los sitios más baratos para
escribir con voz propia, porque uno ya sabe qué quiere decir.

### 3. Medir con un detector real; el autor es el oráculo

Si la procedencia importa —una revista con política de uso de IA, un artefacto público,
cualquier cosa donde ser marcado cueste— **correr el detector real e iterar contra el
puntaje.**

- El detector es una **herramienta que se corre**, no algo que un agente pueda simular.
  Claude no puede estimar un puntaje de detector; una adivinanza es peor que ninguna
  medición porque se siente como una.
- Iterar **página por página contra mediciones**, no contra la impresión de un modelo sobre
  qué suena humano.
- Reportar puntaje, herramienta y versión: una medición sin su instrumento es una anécdota.

> **No usar esto para evadir la declaración.** El objetivo es prosa en la que el lector
> confía y una voz que es tuya, no derrotar a un clasificador. Si la revista exige una
> declaración de uso de IA, hacerla.

### 4. Las marcas superficiales son necesarias, no suficientes

Quitar transiciones de relleno, léxico de cliché, pilas de rodeos, párrafos simétricos y
tricolones mejora la legibilidad de verdad — un párrafo está mejor sin *"Es importante
señalar que"* lo haya escrito quien lo haya escrito. Pero un texto limpio de marcas se lee
**bien**. No por eso se lee **humano**. Son afirmaciones distintas, y la segunda requiere
una medición.

**Solo detección, por diseño.** Reescribir automáticamente degrada calidad, introduce marcas
nuevas y —por el hallazgo de arriba— no cambia lo que ve un detector neuronal. El autor
edita. Ese paso manual es el precio de una voz.

---

## El estándar de lectura humana para documentos de cara afuera

1. **Un lector puede enunciar la contribución tras un párrafo.** Si no, la apertura hace
   ceremonia en vez de trabajo.
2. **Las oraciones cargan información, no carraspeo.** Cortar toda oración que sobrevive a
   ser borrada.
3. **Los rodeos cargan peso o no están.** *"Podría potencialmente sugerir"* es un rodeo de
   más; elegir el que se quiere decir.
4. **Las afirmaciones igualan la evidencia en fuerza.** Puntual no es uniforme; ilustrado no
   es validado; impuesto no es derivado. Es la disciplina de `credible-claims` aplicada a la
   prosa.
5. **La sección de resultados imprime lo que va en contra** con la misma prominencia que lo
   favorable.
6. **Alguien que no eres tú puede leerlo en voz alta sin tropezar.** Leerlo en voz alta;
   las oraciones que no se pueden decir son las que hay que reescribir.

---

## Referencias cruzadas

- `/ai-detect` — detector real calibrado en prosa académica (una señal, no un veredicto).
- `credible-claims` — nunca subir el lenguaje por encima de la evidencia.
