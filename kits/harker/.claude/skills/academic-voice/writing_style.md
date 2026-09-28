# Style Guide — Voz de redacción académica (grupo Harker et al.)

**Alcance: TONO, REGISTRO Y PROSA ÚNICAMENTE.**

Esta guía dice cómo suenan las frases de este grupo. No dice qué debe contener
una sección, qué hipótesis enunciar, ni con qué literatura compararse. Esa
decision es del autor y depende de lo que su paper tenga, no de lo que estos
tres papers tuvieran.

Toda regla lleva cita textual y pagina. Lo no verificable esta en §8.

Reconstruida el 2026-08-26. La version anterior (`writing_style_v1_ARCHIVO.md`)
mezclaba tono con arquitectura de argumento y contenia cuatro afirmaciones que
la medicion desmiente; ver §4 y §2.5. La §5 recoge errores mecanicos observados en la practica.

---

## 1. Fuentes

| # | Documento | Publicacion | Idioma |
|---|---|---|---|
| **D1** | Molano, Harker & Cristancho (2018), *Effects of Indirect Exposure to Homicide Events on Children's Mental Health* | Journal of Youth and Adolescence | Ingles |
| **D2** | Garcia, Harker & Cuartas (2019), *Building dreams* | International Journal of Educational Development | Ingles |
| **D3** | Harker, Taboada, Villalba & Castellani (2017), *Evaluacion de Impacto — Madres Adolescentes* | Nota Tecnica BID IDB-TN-1300 | Espanol |

Metricas sobre cuerpo de prosa (sin referencias ni tablas): D1 ~8.200 palabras,
D2 ~9.000, D3 ~17.500.

---

## 2. Reglas de tono CONFIRMADAS

### 2.1 Cadencia media-larga, con remate corto

| Documento | Mediana | <=12 palabras | >=35 palabras |
|---|---|---|---|
| D1 | 30 | 6% | 37% |
| D2 | 22 | 23% | 24% |
| D3 | 23 | 23% | 22% |

La mediana vive entre 22 y 30 palabras. La frase corta existe y sirve para
**cerrar** lo que la larga construyo:

> "What was important about these violence shocks is their occurrence days
> before the test." — D1, p. 9

> "Increasing aspirations is not enough to increase access to higher education.
> The pathway to higher education entails more than building dreams." — D2, p. 9

### 2.2 Conectores

Conteo sobre D1+D2 (~17.200 palabras):

| Conector | n | | Conector | n |
|---|---|---|---|---|
| While | 11 | | Therefore | 6 |
| Additionally | 9 | | Moreover | 5 |
| **Nonetheless** | **7** | | Although | 4 |
| Similarly | 7 | | **However** | **4** |
| Finally | 7 | | **Furthermore** | **1** |

- **"Nonetheless" supera a "However".** Es la marca mas distintiva del corpus.
- **"Furthermore" aparece 1 vez en 17.200 palabras.**
- **"While" (11) sobre "Although" (4)** para la concesiva.
- Cierres de bloque escasos y por eso pesados: "Taken together" (3), "As such"
  (2), "In other words" (2).
- "It is worth noting" 1 vez; "It is important to note" 0.

Espanol (D3): "En particular" (20), "Ademas" (13), "Adicionalmente" (10),
"Sin embargo" (8), "No obstante" (4).

### 2.3 Voz y persona

Ingles (D1+D2): "we" 39 · "our" 27 · "this article" 22 · "this study" 5.
Espanol (D3): primera persona **0**. Impersonal con "se" ("se observa" 11,
"se presenta" 14, "se encuentra" 15).

> "This article implements a variation of these analytical strategies" — D1, p. 2
> "Se destaca que en casi todas las variables existe balance" — D3, p. 29

La pasiva inglesa domina en Metodos, donde el actor no importa.

### 2.4 Verbos

suggest **34** · indicate **14** · find **10** · show **5** · attest **4** ·
**prove (verbo) 0**.

Las 8 coincidencias de "prove" son `improve`, `approved`, `proven`.
"Demonstrate" y "proven" existen pero **solo aplicados a literatura ajena**,
nunca a resultados propios.

> "Main findings suggest important negative effects" — D1, p. 10
> "the similarities in the signs and magnitudes ... attest to the robustness" — D1, p. 9

Hedges: may 28 · could 10 · plausible 6 · might 5 · perhaps 4.

### 2.5 Como se acompana un numero

Orden fijo: **sujeto sustantivo -> verbo direccional -> outcome -> (coeficiente,
IC) -> "on average"**. El numero nunca abre la oracion ni queda solo.

> "shocks of violence ... generate lower standardized levels of Emotional
> Regulation (b1 = -0.106, [-0.203, -0.008]) and Empathy (b1 = -0.114,
> [-0.22, -0.009]) on average." — D1, p. 6

IC al 95% en corchetes, sin la etiqueta "95% CI" y **sin p-value en prosa**.

**Re-expresion relativa: es un cierre, no un habito.** Aparece **una sola vez
en todo D2**, en la conclusion:

> "These effects amount to 27 per cent and 61 per cent, respectively, compared
> to baseline levels." — D2, p. 8

> CORRIGE la guia v1, que afirmaba que D2 "SIEMPRE" re-expresa el punto
> porcentual. El punto porcentual aparece crudo en abstract, introduccion y
> resultados; solo al concluir se traduce.

**Rangos** cuando varios coeficientes apuntan al mismo lado:

> "differences ... that range from 0.103 to 0.114 points in a standardized
> metric" — D1, p. 8

**Nulos sin eufemismo ni disculpa:**

> "results do not support statistically significant effects" — D1, pp. 6-7
> "We do not find evidence that effects ... varied by the sex or age" — D2, p. 8

Espanol: cifra con cuantificador de intensidad delante ("tan solo" 9, "apenas"
7) y glosa a escala intuitiva tras "esto es":

> "se ganan $88,590 pesos colombianos mensuales ..., esto es, aproximadamente,
> un dolar por dia" — D3, p. 7

### 2.6 Registro de las salvedades

Se nombra el defecto concreto, su mecanismo y la direccion del sesgo:

> "the measure of Aggressive Behavior includes a single item, and thus may be
> prone to an important amount of measurement error." — D1, p. 7

> "Therefore, reported effects of this article should be regarded as
> underestimated." — D1, p. 11

La salvedad llega **junto al hallazgo que limita**, no apartada. Lo arbitrario
de una decision propia se admite sin defenderla:

> "This evidence also highlights the arbitrariness involved in selecting seven
> days before the test as our temporal window." — D1, p. 9

Lo que no se puede saber se dice que no se puede saber:

> "from the available data, it is impossible to identify the children that in
> fact learned about these events." — D1, p. 11

El R2 pequeno se reporta e interpreta, sin inflarlo ni pedir perdon:

> "ranges from 2.8% ... to 7.3%. This small proportion of explained variability
> suggests the existence of other unmeasured variables" — D1, p. 8

Un resultado raro se llama raro y se ofrecen dos explicaciones sin elegir.

### 2.7 Puntuacion

Por 1.000 palabras:

| Signo | D1 | D2 | D3 |
|---|---|---|---|
| Parentesis | 28,6 | 36,1 | 14,2 |
| Dos puntos | 2,9 | 5,9 | **12,3** |
| Punto y coma | 1,0 | **6,8** | 0,8 |
| Raya larga | 0,24 | **0** | **0** |

- **La raya no se usa en prosa.** Dos apariciones en 17.200 palabras inglesas,
  ambas en nota de tabla. El inciso va entre parentesis.
- **El parentesis es el signo dominante:** cita, glosa `(i.e., ...)`, estadistico.
- **Los dos puntos son rasgo del espanol** (x3 sobre el ingles).
- **El punto y coma es de D2, no del grupo** (6,8 vs 1,0 y 0,8).
- Cursivas solo para nombres de programas e instrumentos, nunca para enfatizar.
- Comillas solo para cita literal o termino tecnico importado.

---

## 3. Lo que este grupo NO hace

Conteo sobre D1+D2. Todo **0** salvo lo indicado:

| Palabra / giro | n |
|---|---|
| delve, tapestry, realm, landscape, paradigm, holistic | 0 |
| crucial, pivotal, vital, critical (enfatico) | 0 |
| nuanced, multifaceted, intricate, myriad, plethora | 0 |
| underscore, shed light, testament | 0 |
| profound, compelling, groundbreaking | 0 |
| "prove"/"proves" como verbo | 0 |
| "It is important to note" | 0 |
| "Importantly", "Specifically" (inicio) | 0 |
| "Furthermore" | 1 |

1. Cero metaforas y cero adorno retorico.
2. Ningun adjetivo enfatico vacio: si algo importa, se dice por que.
3. Nunca se afirma haber probado nada.
4. Ningun cierre grandilocuente: si hay implicacion de politica, se nombra la
   politica concreta y su limite.
5. No se esconde el resultado incomodo — el abstract de D1 anuncia el nulo en
   la misma frase que el hallazgo positivo.
6. Cero primera persona en espanol.
7. Sin vinetas en prosa argumentativa inglesa.

---

## 4. Registro ingles vs. espanol

| Dimension | Ingles | Espanol |
|---|---|---|
| Persona | "we" (39) + "this article" (22) | impersonal "se"; primera persona **0** |
| Mediana de oracion | 22-30 | 23 — **practicamente igual** |
| Dos puntos | 2,9-5,9 / 1.000 | **12,3** / 1.000 |
| Cifras | punto porcentual, coef + IC | "tan solo"/"apenas"; glosa "esto es" |
| Adversativo | Nonetheless (7) > However (4) | "Sin embargo" (8) ~ "No obstante" (4) |

> CORRIGE la guia v1, que decia que el espanol usa oraciones mas cortas. La
> medicion lo desmiente: la mediana espanola (23) esta entre las dos inglesas
> (22 y 30). Lo que cambia es la persona, la densidad de dos puntos y el
> envoltorio de las cifras — registro, no longitud.

---

## 5. Verificacion mecanica (ANTES del checklist de estilo)

Esta seccion no es de voz: es de correccion. Se aplica primero, porque un
error de concordancia o un termino tecnico usado al reves invalida el parrafo
por bien que suene. Cada punto corresponde a un error cometido en la practica
sobre este manuscrito.

### 5.1 Concordancia sujeto-verbo

Vigilar especialmente los cuantificadores negativos y las frases nominales
largas, donde el nucleo queda lejos del verbo.

- `no fit statistic adjudicate` -> `no fit statistic adjudicates`
  (`no X` en singular exige verbo singular; con modal, `no X can adjudicate`
  es correcto y por eso el error aparece al quitar el modal)
- `neither of the models are` -> `neither of the models is`
- `the range of estimates suggest` -> `the range ... suggests`
  (el nucleo es `range`, no `estimates`)

### 5.2 Referente de pronombre unico

Todo `it`, `this`, `these`, `them` debe tener un antecedente inequivoco. Si la
oracion anterior menciona dos entidades, el pronombre es ambiguo por defecto.

- `Table 9 estimates it` cuando antes se hablo de dos especificaciones
  -> nombrar el objeto: `Table 9 reports the reverse ordering`
- `This suggests...` al inicio de parrafo -> `This pattern suggests...`

### 5.3 Terminos tecnicos en su sentido correcto

El error mas costoso: la frase suena bien y dice lo contrario de lo que el
termino significa. Un referee lo lee como falta de comprension del metodo.

- **`complementary` para modelos observacionalmente equivalentes.** No son
  complementarios: cuentan historias opuestas y los datos no permiten elegir.
  Decir que se complementan sugiere que se apoyan.
- **`beta` para un coeficiente no estandarizado.** En convencion SEM `beta`
  implica estandarizado; usarlo sobre puntos crudos declara una escala que el
  numero no tiene.
- **`robust` sobre una mediacion transversal.** Reportar la magnitud de
  confusion necesaria no es lo mismo que demostrar robustez.
- **`partial mediation`** cuando el paper declara seguir a Ledermann et al.
  (2025), que desaconsejan esa clasificacion. Contradiccion interna.
- **`representative`** cuando los pesos son post-estratificacion sobre celdas
  y no probabilidades inversas de un diseno documentado.

### 5.4 Consistencia de tiempo verbal

Pasado para procedimientos ejecutados (`were estimated`, `we excluded`),
presente para lo que el articulo o el modelo hace (`the model yields`,
`Table 8 reports`). No alternar dentro del mismo parrafo.

### 5.5 Consistencia de notacion

Si se adopta un simbolo, se adopta en todas sus apariciones. Mezclar
`beta = -0.271` con numeros sueltos en la misma oracion obliga al lector a
preguntarse si la escala cambio.

### 5.6 Cifras heredadas

Toda cifra citada en prosa debe rastrearse al output vigente, no a una version
anterior del texto ni a un comentario del codigo. Errores reales de esta clase
en este manuscrito:

- `39%` de inflacion por Jensen, heredado de cuando el logit controlaba por el
  mediador; el valor con la especificacion vigente es 29.5%
- `alfa = 0.62` en config.R frente a KR-20 = 0.63 medido
- prevalencias de PCE (71.3 / 73.5 / 77.1) que no existian en ninguna tabla

### 5.7 Coherencia entre secciones

El mismo hecho debe decirse igual en abstract, metodos, resultados, notas de
tabla y limitaciones. Contradicciones detectadas en este manuscrito:

- abstract `partial mediation` vs. nota de tabla `not classified as partial or
  complete`
- texto `K10 >= 14` vs. titulo de tabla `K10 >= 20`
- §2.3 `ACE predicts PCE` vs. §4.5 `positive experiences predict adversity`
- metodos `controlling for socioeconomic stratum` vs. tabla sin estrato

### 5.8 Afirmaciones sobre lo que hace el pipeline

No declarar un metodo que el codigo no ejecuta. Casos reales:

- `Bonferroni correction where indicated` — no se aplica en ningun script
- `srvyr` — no aparece en el codigo
- `margins package` — se usa svyglm
- `Model fit was assessed using CFI and RMSEA` — no se calculan

---

## 6. Checklist — solo prosa

1. Mediana de oracion entre 22 y 30? Hay frase corta de remate al cerrar?
2. "Furthermore"/"Moreover"/"It is important to note" mas de una vez? Reducir.
3. Algun verbo dice que los resultados propios prueban algo? Cambiar a
   suggest / indicate / attest to.
4. Adjetivo enfatico sin razon adjunta? Borrar o sustituir por la razon.
5. Cada cifra tiene sujeto y direccion ANTES del numero, estadistico DESPUES?
   Ninguna oracion abre con un numero?
6. Las salvedades nombran defecto concreto, mecanismo y direccion del sesgo?
7. Hay raya larga en prosa? Cambiar a parentesis.
8. Los nulos estan dichos como nulos, sin eufemismo?
9. En espanol: queda primera persona? Las cifras bajas llevan "tan solo"/
   "apenas"? Hay glosa donde la unidad no es intuitiva?
10. Alguna metafora, o cierre de relevancia generica sin nombrar la politica?

---

## 7. OBSERVADO EN EL CORPUS, NO PRESCRIPTIVO

**Describe lo que estos tres papers hacen. NO son reglas.** Cada una depende de
que el paper tenga algo que estos tenian. Un paper sin eso no esta peor escrito
por no hacerlo; estaria peor escrito por forzarlo.

- **D1 enumera hipotesis ordinales ancladas al Social Cognitive Model de Dodge**
  (p. 3), cuyo marco descompone en (a)(b)(c) (p. 2). Es posible porque existe un
  modelo previo que predice esos tres canales. **Un paper sin marco asi no debe
  inventarse uno para poder numerar hipotesis.**
- **D2 enumera cuatro mecanismos** (pp. 3-4) porque el diseno operativo del
  programa los distingue. No es requisito de estilo tener cuatro mecanismos.
- **D1 compara su magnitud con Sharkey et al. y McCoy et al.** (p. 8) porque los
  tres miden en metrica estandarizada comparable. **Sin comparador en la misma
  metrica, esa comparacion no debe fabricarse.**
- **D1, D2 y D3 anuncian hoja de ruta del documento.** Es convencion de revista.
- **Patron de apertura:** consenso -> "Nonetheless" -> vacio -> lo que el estudio
  hace. Presupone un consenso previo identificable que matizar.

---

## 8. Huecos

1. **Ningun documento es de autoria individual de Daniel.** Harker es el unico
   autor comun. El punto y coma (6,8/1.000 en D2 vs ~1 en D1 y D3) es rasgo de
   D2, no del grupo. **Tratar como voz del grupo solo lo que aparece en los tres,
   o en dos de distinta autoria.**
2. **Ningun paper del corpus usa SEM ni mediacion.** Como redacta este grupo un
   efecto indirecto, un efecto total o un IC bootstrap **no esta verificado**.
   Las reglas de §2.5 estan medidas sobre MCO y diferencias en diferencias.
3. **Ninguna seccion de Limitaciones formalmente titulada.** En D1 las salvedades
   viven en la Discusion; en D2 en la Conclusion; en D3 en resultados.
4. **Abstract poco muestreado** (3, ninguno en espanol).
5. **No se midio longitud de parrafo** — la extraccion de PDF no preserva saltos
   de forma fiable. Las reglas de §2.1 son de oracion.
6. **Frecuencias contadas por subcadena.** Los ordenes de magnitud son solidos;
   el digito exacto puede variar en +/-1.
