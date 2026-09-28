#!/bin/bash
# Block accidental edits to protected files/directories
# Protege la carpeta de datos (crudos, limpios, procesados) y config critico
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name')
FILE=""

if [ "$TOOL" = "Edit" ] || [ "$TOOL" = "Write" ]; then
  FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
fi

if [ -z "$FILE" ]; then
  exit 0
fi

# Proteger la carpeta de datos crudos (nunca tocar): data/raw/, data/00_raw/, etc.
if [[ "$FILE" == */data/*raw*/* ]]; then
  echo "BLOQUEADO: los datos crudos (data/*raw*/) son intocables." >&2
  exit 2
fi

# Cualquier otra cosa dentro de data/ (limpios, procesados) requiere confirmacion
if [[ "$FILE" == */data/* ]]; then
  echo "BLOQUEADO: No modificar archivos en data/ sin confirmacion explicita del usuario." >&2
  exit 2
fi

# Proteger settings.json
BASENAME=$(basename "$FILE")
if [[ "$BASENAME" == "settings.json" ]]; then
  echo "BLOQUEADO: settings.json es protegido. Editar manualmente." >&2
  exit 2
fi

exit 0
