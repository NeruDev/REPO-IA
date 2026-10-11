#!/bin/sh
# Genera un TypeID para el frontmatter de un documento nuevo.
# Uso: sh scripts/new-id.sh [doc|adr]  (por defecto: doc)
# Requiere Python 3. El algoritmo es el documentado en CONTRIBUTING.md.
set -u
cd "$(dirname "$0")/.." || exit 2
prefix=${1:-doc}
case "$prefix" in
  doc | adr) ;;
  *)
    printf 'uso: sh scripts/new-id.sh [doc|adr]\n' >&2
    exit 2
    ;;
esac
if ! command -v python3 >/dev/null 2>&1; then
  printf 'ERROR  python3 no está instalado; ver docs/setup.md\n' >&2
  exit 2
fi
ID_PREFIX="$prefix" python3 -c '
import os
import secrets
import time

alfabeto = "0123456789abcdefghjkmnpqrstvwxyz"
b = bytearray(secrets.token_bytes(16))
ms = int(time.time() * 1000)
for i in range(6):
    b[i] = (ms >> (8 * (5 - i))) & 0xFF
b[6] = 0x70 | (b[6] & 0x0F)
b[8] = 0x80 | (b[8] & 0x3F)
bits = "00" + "".join(f"{x:08b}" for x in b)
sufijo = "".join(alfabeto[int(bits[5 * i:5 * i + 5], 2)] for i in range(26))
print(os.environ["ID_PREFIX"] + "_" + sufijo)
'
