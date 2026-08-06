# Formato de Redacción — Sección Resultados (Genérico)

## Documento Word
- Fuente: Calibri 11 pt, espacio sencillo, márgenes 2.5 cm
- Guardar en: `Outputs/Resultados_Draft.docx`

## Estructura General
1. Estadística descriptiva (medias, DE, rangos por grupo)
2. Verificación de supuestos (normalidad, homocedasticidad)
3. Variable(s) continua(s): estadístico principal → interacción/efectos → post-hoc
4. Variable(s) categórica(s): Chi² / Fisher + distribución por grupo

## Notación Estadística

| Estadístico | Formato |
|-------------|---------|
| F | F(df_efecto, df_error) = X.XX |
| p-value | p = .XXX  /  p < .001 |
| Eta parcial | η²p = .XX |
| Hedges g / Cohen d | g = X.XX  /  d = X.XX |
| Media ± DE | X.XX ± X.XX [unidad] |
| IC 95% | IC 95% [X.XX, X.XX] |
| Chi-cuadrado | χ²(df, N = XX) = X.XX |
| Shapiro-Wilk | W = X.XXX |
| Levene | F(df1, df2) = X.XX |
| Referencias | (Tabla X) / (Figura X) |

## Lenguaje Académico
- **No:** "no hay diferencia" → **Sí:** "no se encontró evidencia de diferencia"
- **No:** "se demostró" → **Sí:** "se observó" / "se encontró"
- Sin primera persona. Sin contracciones. Sin lenguaje informal.
- Valores no encontrados → `[VERIFICAR: descripción]`

## Frases Prohibidas (huella de IA)
- "evidenciado por", "evidenciada por" → describir directo
- "considerablemente", "marcadamente", "notablemente" → cuantificar o eliminar
- "se exploró mediante", "se llevó a cabo mediante" → "se aplicó"
- "lo que motivó el empleo de" → "por lo que se aplicó"
- "deben interpretarse de manera condicional" → "se interpretan sobre la interacción"
- "Estos resultados indican que..." al cierre → cortar; los datos ya hablaron
- "umbral de significación estadística" → "α = .05" o "significativo"
- Repetir definición completa de grupos/factores → definir una vez, después abreviar

## Profundidad de Análisis
- Si Shapiro-Wilk rechaza normalidad o media ≠ mediana, reportar mediana + IQR junto a media ± DE.
- Cuantificar caídas/ganancias en % cuando aporte interpretación (ej: "LCD perdió 36% con termociclado").
- Comparar η²p entre efectos cuando exista jerarquía clara.
- Nombrar el patrón sustantivo, no solo describir números (ej: "el termociclado invirtió el modo de falla").
- Definir α una sola vez (al inicio de Verificación de supuestos); no repetir en cada test.
- Estructura plana: una subsección por variable; evitar 3.1/3.2/3.3 cuando 3 párrafos bastan.
