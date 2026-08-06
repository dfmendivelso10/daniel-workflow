###############################################################
# config.R — Configuración central del proyecto
# Autor: Daniel Mendivelso
#
# Carga al inicio de cada script:
#   source(here::here("code/config.R"))
###############################################################

suppressMessages({
  library(here)
  library(tidyverse)
  library(readxl)
  library(writexl)
  library(openxlsx)
})

# Semilla única
set.seed(42)

# Rutas
PATH <- list(
  raw       = here("data", "raw"),
  processed = here("data", "processed"),
  fig       = here("outputs", "figures"),
  tab       = here("outputs", "tables"),
  logs      = here("quality_reports")
)

# Crear carpetas de output si no existen
for (p in PATH) dir.create(p, recursive = TRUE, showWarnings = FALSE)

# Parámetros del modelo [AJUSTAR]
YEAR_SHOCK <- [YEAR]   # año del tratamiento
YEARS_OBS  <- [START]:[END]

# Paleta de figuras (colorblind-safe)
PAL <- c(
  tratamiento = "#E69F00",
  control     = "#56B4E9",
  acento      = "#D55E00",
  neutro      = "#999999"
)
