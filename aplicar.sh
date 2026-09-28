#!/usr/bin/env bash
# daniel-workflow/aplicar.sh — propaga base/ + kits al .claude/ de un proyecto
#
# Uso:
#   bash aplicar.sh <dir_proyecto> [kit ...]
#     [--qr DIR] [--code DIR] [--out DIR] [--data DIR] [--dry-run]
#
# Ejemplos:
#   bash aplicar.sh ~/Documents/RA_IMAGINA/Paces encuestas-r paper \
#        --qr 03_quality_reports --code 00_code --out 02_outputs --data 01_data
#   bash aplicar.sh ~/repos/nuevo encuestas-r          # layout por defecto (quality_reports/, scripts/, output/, data/)
#
# Qué hace:
#   1. Copia base/.claude/ y luego kits/<kit>/.claude/ (los kits pueden sobrescribir base).
#   2. Sustituye los tokens de layout en TODO lo copiado (skills, rules, hooks .py/.sh):
#        quality_reports/ -> --qr,  scripts/ -> --code,  output/ -> --out,  data/ -> --data
#   3. Fusiona settings.json: base + fragmentos de los kits + lo que el proyecto ya tenía
#      (allow del proyecto se conserva; deny y hooks se unen sin duplicar).
#   4. NO borra nada que el proyecto tenga y el filtro no: lo lista al final para revisarlo.
#
# Los archivos propios del proyecto que NO deben sobrescribirse se declaran en
# <proyecto>/.claude/PROPIOS.txt, una ruta relativa a .claude/ por línea.

set -euo pipefail

FILTRO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROY=""; KITS=(); QR="quality_reports"; CODE="scripts"; OUT="output"; DATA="data"; DRY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --qr) QR="$2"; shift 2 ;;
    --code) CODE="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --data) DATA="$2"; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    -*) echo "opcion desconocida: $1" >&2; exit 1 ;;
    *) if [ -z "$PROY" ]; then PROY="$1"; else KITS+=("$1"); fi; shift ;;
  esac
done
[ -n "$PROY" ] || { echo "falta <dir_proyecto>" >&2; exit 1; }
PROY="$(cd "$PROY" && pwd)"
DEST="$PROY/.claude"
for k in "${KITS[@]}"; do [ -d "$FILTRO/kits/$k/.claude" ] || { echo "kit no existe: $k" >&2; exit 1; }; done

# Se arma en un directorio temporal y solo al final se copia, para que un fallo a mitad
# no deje el .claude/ del proyecto a medias.
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/.claude"
cp -R "$FILTRO/base/.claude/." "$TMP/.claude/"
for k in "${KITS[@]}"; do cp -R "$FILTRO/kits/$k/.claude/." "$TMP/.claude/"; done

# Sustitución de tokens de layout (solo si difieren del default).
# El lookbehind (?<![\w/]) evita tocar '03_quality_reports' ya sustituido, '_outputs/',
# 'metadata/' o '.claude/scripts/' (precedido por '/').
sust() { # $1 token, $2 valor
  [ "$1" = "$2" ] && return 0
  grep -rl --exclude='settings*.json' -- "$1" "$TMP/.claude" 2>/dev/null \
    | while IFS= read -r f; do
        python3 - "$f" "$1" "$2" <<'PY'
import sys,re
p,tok,val=sys.argv[1:]
# surrogateescape: un archivo con bytes no UTF-8 (p. ej. latin-1 heredado) se reescribe
# byte a byte igual, en vez de abortar toda la aplicacion.
s=open(p,encoding='utf-8',errors='surrogateescape').read()
# (?<!\w) evita '03_quality_reports' ya sustituido y 'metadata/'; (?<!\.claude/) protege
# '.claude/scripts/' (rutas del propio .claude, no del proyecto).
s2=re.sub(r'(?<!\w)(?<!\.claude/)'+re.escape(tok),val,s)
if s2!=s: open(p,'w',encoding='utf-8',errors='surrogateescape').write(s2)
PY
      done
}
sust "quality_reports" "$QR"   # token sin barra: aparece como "quality_reports/..." y como "quality_reports" en Python
sust "scripts/" "$CODE/"
sust "output/" "$OUT/"
sust "data/" "$DATA/"

# settings.json: base + fragmentos + existente del proyecto
python3 - "$TMP/.claude" "$DEST" "$QR" "$DATA" "${KITS[@]}" <<'PY'
import json,sys,os,copy
tmp,dest,qr,data,*kits=sys.argv[1:]
# La plantilla se llama settings.template.json para que no la bloqueen hooks que protegen
# settings.json; aqui se convierte en el settings.json del proyecto.
tpl=os.path.join(tmp,'settings.template.json')
base=json.load(open(tpl)); os.remove(tpl)
def merge_hooks(a,b):
    for ev,entries in b.get('hooks',{}).items():
        cur=a.setdefault('hooks',{}).setdefault(ev,[])
        for e in entries:
            if e not in cur: cur.append(e)
def merge_perm(a,b,key):
    cur=a.setdefault('permissions',{}).setdefault(key,[])
    for x in b.get('permissions',{}).get(key,[]):
        if x not in cur: cur.append(x)
frag=os.path.join(tmp,'settings.fragment.json')
if os.path.exists(frag):
    f=json.load(open(frag)); merge_hooks(base,f); merge_perm(base,f,'allow'); merge_perm(base,f,'deny')
    os.remove(frag)
# layout
base['plansDirectory']=f'{qr}/plans'
base['permissions']['deny']=[d.replace('data/**',f'{data}/**') for d in base['permissions']['deny']]
# lo que el proyecto ya tenia: conserva su allow y additionalDirectories; une deny y hooks
old_p=os.path.join(dest,'settings.json')
if os.path.exists(old_p):
    old=json.load(open(old_p))
    merge_perm(base,old,'allow')
    for k in ('additionalDirectories',):
        if k in old.get('permissions',{}): base['permissions'][k]=old['permissions'][k]
    # hooks del proyecto que el filtro no trae (p.ej. Stop -> log-reminder) se conservan
    for ev,entries in old.get('hooks',{}).items():
        if ev not in base['hooks']: base['hooks'][ev]=entries
json.dump(base,open(os.path.join(tmp,'settings.json'),'w'),indent=2,ensure_ascii=False)
PY

# Archivos propios del proyecto: no se sobrescriben
PROPIOS="$DEST/PROPIOS.txt"
if [ -f "$PROPIOS" ]; then
  while IFS= read -r rel; do
    [ -z "$rel" ] && continue; case "$rel" in \#*) continue ;; esac
    rm -rf "$TMP/.claude/$rel"
  done < "$PROPIOS"
fi

echo "== aplicar.sh -> $DEST  (kits: ${KITS[*]:-ninguno}; qr=$QR code=$CODE out=$OUT data=$DATA)"
if [ "$DRY" = 1 ]; then
  echo "-- dry-run: archivos que se escribirian"; (cd "$TMP/.claude" && find . -type f | sort)
  exit 0
fi
mkdir -p "$DEST"
cp -R "$TMP/.claude/." "$DEST/"
chmod +x "$DEST"/hooks/*.sh 2>/dev/null || true
echo "-- escrito. Archivos del proyecto que el filtro NO trae (revisar si siguen vigentes):"
( cd "$DEST" && find . -type f ! -name PROPIOS.txt ! -name 'settings.local.json' | sort ) > "$TMP/dest.txt"
( cd "$TMP/.claude" && find . -type f | sort ) > "$TMP/src.txt"
comm -23 "$TMP/dest.txt" "$TMP/src.txt" | sed 's/^/   /'
echo "-- hecho. Registrar en ADOPCION.md y commitear en el proyecto:"
echo "   chore(claude): actualizar desde daniel-workflow $(git -C "$FILTRO" rev-parse --short HEAD 2>/dev/null || echo '<sha>')"
