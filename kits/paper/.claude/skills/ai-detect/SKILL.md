---
name: ai-detect
description: Pasa un manuscrito o una seccion por econ-ai-detector (Goldsmith-Pinkham 2026), un detector abierto de texto generado por IA calibrado en prosa de working papers de economia. Usalo antes de circular un borrador para saber si alguna seccion dispara el detector, y para decidir que parrafos reescribir a mano. Devuelve un veredicto a nivel de documento y los scores por ventana de 250 palabras. Es una senal, no un veredicto: un flag es evidencia fuerte, un no-flag es evidencia debil.
---

# Detector de texto IA — econ-ai-detector

Entorno: `.venv-aidetect/` en la raiz del proyecto (gitignored). Si no
existe, instalar con:

```bash
python3 -m venv .venv-aidetect
.venv-aidetect/bin/pip install "git+https://github.com/paulgp/econ-ai-detector"
```

La primera corrida descarga 330 MB de pesos desde Hugging Face.

**Defecto de empaquetado (verificado sep 2026):** `pip` no instala la carpeta
`models/` porque esta fuera del modulo. Hay que copiarla a mano desde el
repositorio clonado al sitio donde el detector la busca:

```bash
git clone --depth 1 https://github.com/paulgp/econ-ai-detector /tmp/ead
cp -r /tmp/ead/models .venv-aidetect/lib/python3.13/site-packages/
```
Sin eso falla con `FileNotFoundError: .../site-packages/models/lr_v3.joblib`.

## Uso

**1. Extraer la prosa del .docx.** El detector acepta .txt o .pdf; el
manuscrito esta en Word con control de cambios. El extractor conserva las
inserciones, descarta lo tachado, y quita tablas, notas, referencias y
encabezados:

```bash
python3 .claude/skills/ai-detect/docx_to_prose.py "Temporales/PACES ... .docx" > /tmp/prosa.txt
# solo unas secciones:
python3 .claude/skills/ai-detect/docx_to_prose.py manuscrito.docx --seccion "3." "4." > /tmp/prosa.txt
```

**2. Correr el detector.**

```bash
.venv-aidetect/bin/econ-ai-detect /tmp/prosa.txt --no-gate          # veredicto
.venv-aidetect/bin/econ-ai-detect /tmp/prosa.txt --no-gate --json   # scores por ventana
```

`--no-gate` porque la prosa ya viene limpia. Sin ese flag el detector
intenta filtrar tablas y ecuaciones, y en texto ya limpio elimina ventanas
validas.

**3. Ubicar los parrafos.** El JSON trae scores pero no texto. Este script
reconstruye las ventanas con la misma funcion del paquete y muestra las que
superan algun umbral:

```bash
.venv-aidetect/bin/econ-ai-detect /tmp/prosa.txt --no-gate --json > /tmp/scores.json
python3 .claude/skills/ai-detect/windows_report.py /tmp/prosa.txt /tmp/scores.json
```

Regla de decision: el documento se marca si la **segunda** ventana mas alta
supera ambos umbrales (LR >= 0.335 y margen NN >= 7.48 al 0.1 % de falsos
positivos). Una ventana sola por encima no marca el documento.

**Linea base en este proyecto (sep 2026):** v2, v3 y v4 del manuscrito
marcan las tres, con dos ventanas cada una, siempre en Introduccion y
Discusion. Metodos y Resultados no superan ningun umbral en ninguna
version. Como la v2 es anterior a cualquier intervencion de esta sesion, el
flag en Intro/Discusion no distingue entre registro academico formulaico y
texto asistido; es la razon para reescribir esas secciones con `paces-voice`,
no una prueba de nada.

## Lo que hay que saber antes de creer el numero

- **Registro distinto.** Calibrado en working papers de economia (NBER,
  pre-2020). Este proyecto es salud publica y psicologia, con coautores no
  nativos. La tasa de falsos positivos en este registro es desconocida.
  Antes de reportar una cifra, correrlo sobre un texto del grupo que se sepa
  escrito a mano (por ejemplo, la v2 del manuscrito) para tener linea base.
- **Ventanas de 250 palabras.** Una seccion corta no puede disparar la regla
  k = 2. Correrlo sobre secciones enteras, no sobre parrafos.
- **Es un piso.** Entrenado con espejos de un modelo abierto de 2026; la
  edicion ligera con IA le resulta invisible. Un no-flag no certifica nada.
- **Los digitos se enmascaran.** No distingue por cifras ni por anio.
- **Para que sirve aqui.** Para saber que secciones suenan a maquina y
  reescribirlas con la voz del grupo (`paces-voice`), no para evadir un
  detector. La declaracion de uso de IA al enviar el paper sigue siendo
  necesaria con o sin flag.

## Salida esperada

```
no AI text detected  (rule: 2nd-highest window LR prob 0.212 vs 0.335; NN margin 3.10 vs 7.48; 41 of 41 windows scored)
windows above both thresholds: 0
```

Cita: Goldsmith-Pinkham, P. (2026). *The Missing AI Paper Boom*. Repositorio
`paulgp/econ-ai-detector`, MIT.
