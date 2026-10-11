#!/bin/sh
# Invariante: la toolchain instalada coincide con la declarada en config/toolchain.env.
# Solo emite avisos: una versión distinta no bloquea el chequeo, pero puede cambiar
# sus resultados. La ausencia de una herramienta ya la informa scripts/check.sh;
# aquí no se repite. Referencia: ADR-0007.
set -u
cd "$(dirname "$0")/../.." || exit 2
# shellcheck source=scripts/lib/common.sh
. scripts/lib/common.sh

registry=config/toolchain.env
if [ ! -f "$registry" ]; then
  warn "$registry no existe; se omite la comprobación de versiones"
  finish
fi

# value CLAVE: valor declarado en el registro (vacío si no está).
value() { sed -n "s/^$1=//p" "$registry" | tail -n 1; }

# compare NOMBRE INSTALADA DECLARADA
compare() {
  [ -n "$3" ] || return 0
  if [ -z "$2" ]; then
    warn "$1: no se pudo leer la versión instalada (declarada $3)"
  elif [ "$2" != "$3" ]; then
    warn "$1 $2 instalado; declarado $3 en $registry"
  else
    info "$1 $2"
  fi
}

if command -v shellcheck >/dev/null 2>&1; then
  compare shellcheck "$(shellcheck --version | sed -n 's/^version: //p')" "$(value SHELLCHECK_VERSION)"
fi
if command -v markdownlint-cli2 >/dev/null 2>&1; then
  compare markdownlint-cli2 \
    "$(markdownlint-cli2 --version 2>/dev/null | sed -n 's/^markdownlint-cli2 v\([0-9.]*\).*/\1/p' | head -n 1)" \
    "$(value MARKDOWNLINT_CLI2_VERSION)"
fi
if command -v yamllint >/dev/null 2>&1; then
  compare yamllint "$(yamllint --version | awk '{ print $2 }')" "$(value YAMLLINT_VERSION)"
fi
if command -v lychee >/dev/null 2>&1; then
  compare lychee "$(lychee --version | awk '{ print $2 }')" "$(value LYCHEE_VERSION)"
fi

finish
