# [Nombre del proyecto]

[Descripción de una línea.]

## Pregunta

[La pregunta de investigación o análisis.]

## Fuentes de datos

- **[Fuente principal]**: [qué mide, URL]
- **[Fuente 2]**: [qué mide, URL]

## Estructura

```
code/            config.R + scripts numerados
code/limpieza/   descarga y procesamiento
code/descriptivas/ tablas y figuras descriptivas
data/raw/        fuentes crudas sin modificar
data/processed/  paneles limpios
outputs/         figures/ y tables/
docs/            comunicación final
quality_reports/ planes y logs
```

## Reproducir

```bash
# Dependencias R
Rscript -e 'install.packages(c("here","tidyverse","readxl","writexl","openxlsx","fixest"))'

# Pipeline
Rscript code/01_limpiar.R
Rscript code/02_descriptivas.R
Rscript code/03_modelo.R
```

## Uso de inteligencia artificial

Para la elaboración de este proyecto se utilizó **Claude Code (Anthropic)** como asistente
de apoyo en: validación de datos, producción de tablas y figuras, y construcción de
reportes. Las decisiones metodológicas fueron tomadas bajo criterio del autor.
