#!/bin/sh
# Emite la fecha del reloj del sistema en los formatos del repositorio y, con
# «stamp», actualiza updated_at del frontmatter de los .md indicados. Es la
# única utilidad del repo que lee la hora: evita calcular fechas a mano o
# recurrir a una búsqueda web al editar documentación.
#
# Uso:       sh scripts/now.sh [updated-at|date|compact|stamp RUTA ...]
#            updated-at (por defecto)  AAAA-MM-DDTHH:MM:SSZ para updated_at
#            date                      AAAA-MM-DD para la memoria y CHECK_TODAY
#            compact                   AAAAMMDD para nombres de carpeta con fecha
#            stamp RUTA ...            escribe updated_at en cada .md con frontmatter
# Fuente:    reloj del sistema en UTC (date -u), sin red.
# Salida:    0 éxito; 1 en «stamp», algún archivo no admite updated_at;
#            2 error de uso o de entorno.
set -u
cd "$(dirname "$0")/.." || exit 2
# shellcheck source=scripts/lib/common.sh
. scripts/lib/common.sh

work=$(mktemp -d) || exit 2
trap 'rm -rf "$work"' 0
trap 'exit 2' HUP INT TERM

usage() {
  printf 'uso: sh scripts/now.sh [updated-at|date|compact|stamp RUTA ...]\n'
  printf '  updated-at  AAAA-MM-DDTHH:MM:SSZ para updated_at (por defecto)\n'
  printf '  date        AAAA-MM-DD para la memoria y CHECK_TODAY\n'
  printf '  compact     AAAAMMDD para nombres de carpeta con fecha\n'
  printf '  stamp RUTA  escribe updated_at en el frontmatter de cada .md\n'
}

# mark FORMATO: marca UTC del reloj del sistema con el formato de date(1).
mark() {
  m=$(date -u "$1") || {
    err 'scripts/now.sh: no se pudo leer el reloj del sistema con date(1)'
    exit 2
  }
  printf '%s\n' "$m"
}

# stamp_file ARCHIVO: sustituye updated_at del frontmatter por la marca actual.
# Exige frontmatter de ADR-0002; no aplica a adaptadores ni a *.instructions.md.
stamp_file() {
  f=$1
  if [ ! -f "$f" ]; then
    err "$f: no existe o no es un archivo regular"
    return
  fi
  case "$f" in
    *.md) ;;
    *)
      err "$f: solo se actualiza el frontmatter de archivos .md"
      return
      ;;
  esac
  if [ "$(sed -n '1p' "$f")" != "---" ]; then
    err "$f: falta el frontmatter YAML (debe empezar con \"---\" en la línea 1)"
    return
  fi
  if [ "$(awk 'NR > 1 && $0 == "---" { print 1; exit }' "$f")" != 1 ]; then
    err "$f: frontmatter sin delimitador de cierre \"---\""
    return
  fi
  n=$(awk 'NR > 1 && $0 == "---" { exit } /^updated_at:/ { n++ } END { print n + 0 }' "$f")
  case "$n" in
    0)
      err "$f: sin updated_at en el frontmatter (no aplica a adaptadores ni a *.instructions.md)"
      return
      ;;
    1) ;;
    *)
      err "$f: updated_at repetido en el frontmatter"
      return
      ;;
  esac
  if ! awk -v now="$marca" '
    NR == 1 { print; next }
    !cerrado && $0 == "---" { cerrado = 1; print; next }
    !cerrado && /^updated_at:/ { print "updated_at: " now; next }
    { print }
  ' "$f" >"$work/tmp"; then
    err "$f: no se pudo generar el contenido actualizado"
    return
  fi
  if ! cat "$work/tmp" >"$f"; then
    err "$f: no se pudo escribir el contenido actualizado"
    return
  fi
  info "$f: updated_at=$marca"
}

modo=${1:-updated-at}
case "$modo" in
  updated-at | date | compact)
    [ "$#" -le 1 ] || {
      usage
      exit 2
    }
    case "$modo" in
      updated-at) mark +%Y-%m-%dT%H:%M:%SZ ;;
      date) mark +%Y-%m-%d ;;
      compact) mark +%Y%m%d ;;
    esac
    ;;
  stamp)
    shift
    [ "$#" -ge 1 ] || {
      usage
      exit 2
    }
    marca=$(mark +%Y-%m-%dT%H:%M:%SZ)
    for f in "$@"; do
      stamp_file "$f"
    done
    finish
    ;;
  -h | --help | help)
    usage
    ;;
  *)
    err "modo desconocido: $modo"
    usage
    exit 2
    ;;
esac
