#!/usr/bin/env bash
# daniel-workflow/nuevo-proyecto.sh — crea un proyecto desde cero con base/ + kits
#
# Uso:  bash nuevo-proyecto.sh <ruta_nueva> [kit ...] [--numerado]
#
#   --numerado   usa el layout de Paces (00_code/ 01_data/ 02_outputs/ 03_quality_reports/)
#                en vez del plano (scripts/ data/ output/ quality_reports/)
#
# Kits disponibles: ls kits/

set -euo pipefail
FILTRO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUTA=""; KITS=(); NUM=0
for a in "$@"; do
  case "$a" in
    --numerado) NUM=1 ;;
    *) if [ -z "$RUTA" ]; then RUTA="$a"; else KITS+=("$a"); fi ;;
  esac
done
[ -n "$RUTA" ] || { echo "uso: $0 <ruta_nueva> [kit ...] [--numerado]" >&2; exit 1; }
[ -e "$RUTA" ] && { echo "ya existe: $RUTA" >&2; exit 1; }

if [ "$NUM" = 1 ]; then CODE=00_code; DATA=01_data; OUT=02_outputs; QR=03_quality_reports
else CODE=scripts; DATA=data; OUT=output; QR=quality_reports; fi

mkdir -p "$RUTA"/{$CODE,$DATA/raw,$DATA/cleaned,$OUT/tables,$OUT/figures,$QR/plans,$QR/session_logs,$QR/checkpoints,logs}
cp "$FILTRO/project-template/.gitignore" "$RUTA/.gitignore" 2>/dev/null || printf '.DS_Store\n.Rhistory\n.RData\n.Rproj.user\nlogs/\n.claude/settings.local.json\nrenv/library/\n' > "$RUTA/.gitignore"
touch "$RUTA/.here"
sed -e "s|\[CODE\]|$CODE|g; s|\[DATA\]|$DATA|g; s|\[OUT\]|$OUT|g; s|\[QR\]|$QR|g" \
    "$FILTRO/project-template/CLAUDE.md" > "$RUTA/CLAUDE.md" 2>/dev/null || \
    printf '# %s — Contexto del proyecto\n\n[Rellenar: población, N esperado, instrumentos, specs, errores frecuentes]\n\nDatos: viven en `%s/` (decisión sobre git: [gitignore | repo privado], fecha).\n' "$(basename "$RUTA")" "$DATA" > "$RUTA/CLAUDE.md"
printf '# MEMORY.md — memoria institucional\n\nFormato: `[LEARN:categoria] Asuncion incorrecta -> hecho correcto`\n' > "$RUTA/MEMORY.md"

( cd "$RUTA" && git init -q && git checkout -q -b main )
bash "$FILTRO/aplicar.sh" "$RUTA" "${KITS[@]}" --qr "$QR" --code "$CODE" --out "$OUT" --data "$DATA"
echo "== proyecto creado en $RUTA (kits: ${KITS[*]:-ninguno}). Siguiente: rellenar CLAUDE.md y crear el repo privado en GitHub."
