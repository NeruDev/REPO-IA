#!/bin/sh
# Puesta en marcha idempotente del entorno de trabajo. Detalle en docs/setup.md.
# Uso: sh scripts/setup.sh
#   1. crea .venv/ si falta e instala las dependencias declaradas en pyproject.toml
#   2. informa de la toolchain instalada frente a config/toolchain.env
#   3. activa el hook pre-commit si esta carpeta es la raíz de un repositorio git
#   4. ejecuta la autoevaluación sin red
set -u
cd "$(dirname "$0")/.." || exit 2
# shellcheck source=scripts/lib/common.sh
. scripts/lib/common.sh
root=$(pwd -P)

if ! command -v python3 >/dev/null 2>&1; then
  printf 'ERROR  python3 no está instalado; ver docs/setup.md\n' >&2
  exit 2
fi

if [ ! -x .venv/bin/python ]; then
  python3 -m venv .venv || exit 2
  info 'creado el entorno virtual .venv/'
fi
info 'instalando dependencias de pyproject.toml en .venv/'
.venv/bin/python -m pip install . || exit 2

sh scripts/checks/toolchain.sh

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  top=$(git rev-parse --show-toplevel 2>/dev/null) || top=
  top=$(CDPATH='' cd -P "$top" 2>/dev/null && pwd -P) || top=
  if [ "$top" = "$root" ]; then
    chmod +x .githooks/pre-commit || exit 2
    git config core.hooksPath .githooks || exit 2
    info 'hook pre-commit activo'
  else
    warn 'la plantilla no es la raíz del repositorio git; no se toca la configuración del git contenedor'
  fi
else
  warn 'no es un repositorio git; hook sin activar'
fi

printf '\n== Autoevaluación sin red\n'
CHECK_NO_NETWORK=1 sh scripts/check.sh
