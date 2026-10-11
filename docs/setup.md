---
id: doc_01m4m4bzshejj8gwgtscew72wg
name: setup
title: "Puesta en marcha del repositorio desde cero"
file_path: docs/setup.md
category: guides
tags: [setup, entorno, instalacion, docker, toolchain]
description: "Cómo montar el entorno desde cero en cada plataforma: requisitos, entorno virtual de Python, herramientas fijadas, contenedor de desarrollo, verificación y problemas conocidos."
status: active
updated_at: 2026-10-11T00:03:58Z
---

# Puesta en marcha del repositorio desde cero

Describe cómo instalar dependencias, herramientas y ajustes en cada entorno de
trabajo, de forma repetible y sin fallos de versión. El resumen operativo para
agentes está en [AGENTS.md](../AGENTS.md); el porqué de cada decisión, en los
[ADR](adr/README.md) (en especial el [0007](adr/0007-pyproject-y-toolchain-fijada.md)).

## Requisitos

| Componente | Para qué | Ubuntu (WSL), entorno canónico | Windows nativo, secundario |
| --- | --- | --- | --- |
| Git | Repositorio, hooks y `sh` de la autoevaluación | Paquete del sistema | Git para Windows (aporta `sh`) |
| Python 3 | Entorno virtual, `yamllint` e identificadores | `sudo apt install python3 python3-venv` | Instalador oficial |
| Node.js | `markdownlint-cli2` | Binario o gestor de versiones | Instalador oficial |
| shellcheck | Linter de shell | `sudo apt install shellcheck` | Scoop |
| lychee | Enlaces externos | Binario de releases | Scoop |

Python 3 es necesario para la toolchain de verificación y para generar los
identificadores de los documentos; el proyecto final puede no usar Python. Sin
los linters opcionales, la autoevaluación degrada a `AVISO` y sigue funcionando.

## Instalación canónica en Ubuntu (WSL)

1. Copiar la plantilla en la carpeta del proyecto e inicializar git:
   `git init -b main`.
2. Ejecutar `sh scripts/setup.sh`. Es idempotente y hace todo lo demás: crea
   `.venv/`, instala las dependencias de
   [pyproject.toml](../pyproject.toml), informa de la toolchain frente a
   [config/toolchain.env](../config/toolchain.env), activa el hook pre-commit y
   ejecuta la autoevaluación sin red.
3. Instalar los linters que no vienen de Python, con la versión declarada en
   `config/toolchain.env`: `sudo apt install shellcheck`,
   `npm install -g markdownlint-cli2@0.23.3` y el binario de lychee desde su
   página de [releases](https://github.com/lycheeverse/lychee/releases).
4. Ejecutar `sh scripts/check.sh`. Debe terminar con código 0.

### Entorno virtual de Python

Si se prefiere el flujo manual frente a `sh scripts/setup.sh`:

| Comando | Uso |
| --- | --- |
| `python3 -m venv .venv` | Crear el entorno, una vez por clon. |
| `source .venv/bin/activate` | Activarlo en cada terminal de Bash. |
| `python -m pip install .` | Instalar las dependencias declaradas en `pyproject.toml`. |
| `deactivate` | Salir del entorno. |

Con el entorno activo se usan `python` y `pip` del propio `.venv/`. Nunca
instalar paquetes de Python fuera de `.venv/`. En PowerShell la activación es
`.\.venv\Scripts\Activate.ps1`, solo para el entorno secundario de Windows.

## Contenedor de desarrollo

El [Dockerfile](../Dockerfile) fija la toolchain completa (versiones y sumas de
verificación) y elimina las diferencias entre máquinas. Verificado para x86_64.

```bash
docker build -t plantilla-base .
docker run --rm -v "$PWD:/repo" -w /repo plantilla-base sh scripts/check.sh
```

La imagen ya acepta el propietario del volumen montado y fija `TZ=UTC` y un
locale UTF-8. Para trabajar dentro del contenedor con VS Code, abrir el
repositorio con la configuración de
[.devcontainer/devcontainer.json](../.devcontainer/devcontainer.json)
(«Dev Containers: Reopen in Container»); las tareas de `.vscode/tasks.json`
funcionan dentro. La integración continua
([.github/workflows/check.yml](../.github/workflows/check.yml)) construye la
misma imagen y ejecuta la autoevaluación y las regresiones en ella.

- La autoevaluación necesita el repositorio git completo: montar la carpeta del
  clon, incluido `.git/`.
- `lychee` necesita red saliente. Sin red, `CHECK_NO_NETWORK=1 sh scripts/check.sh`.
- Para correr el contenedor con otro usuario, añadir
  `--user "$(id -u):$(id -g)" -e HOME=/tmp`.

## Versiones fijadas

[config/toolchain.env](../config/toolchain.env) es la fuente única de versiones
conocidas buenas. Los linters se fijan exactos porque cada versión añade o
cambia reglas y el resultado del chequeo debe ser determinista; Python, Node y
git son informativos. `scripts/checks/toolchain.sh` avisa cuando la versión
instalada difiere de la declarada. Para actualizar una herramienta: cambiar la
versión en ese archivo y en los comandos de este documento, comprobar que
`sh scripts/check.sh` sigue en verde y dejar constancia en el commit.

## Verificación

| Comando | Cuándo |
| --- | --- |
| `sh scripts/check.sh` | Tras cada cambio; debe terminar con código 0. |
| `sh -c 'CHECK_NO_NETWORK=1 sh scripts/check.sh'` | Sin red; es lo que ejecuta el hook. |
| `sh tests/sandbox.sh` | Al modificar el aislamiento, el hook o la selección de archivos. |

Un `AVISO` informa pero no bloquea; un `ERROR` exige corrección. Las tareas de
VS Code *check: completo*, *check: sin red* y *tests: aislamiento* ejecutan lo
mismo desde el editor.

## Problemas conocidos

- «yamllint no está instalado; se omite»: activar `.venv/` o ejecutar
  `sh scripts/setup.sh`.
- Dos `yamllint` instalados a la vez (sistema y `.venv/`): la autoevaluación
  prioriza `.venv/`. La copia del sistema sobra; retirarla con
  `sudo apt remove yamllint`.
- «hook pre-commit inactivo»: ejecutar `sh scripts/setup.sh` o
  `chmod +x .githooks/pre-commit && git config core.hooksPath .githooks`.
- lychee falla o se queda sin red: usar `CHECK_NO_NETWORK=1`; la comprobación de
  URLs es la única que necesita red.
- `docker` responde que falta la integración de WSL: activarla en la
  configuración de Docker Desktop para esta distribución.
- git rechaza el directorio con «dubious ownership»: dentro de la imagen ya está
  resuelto; fuera, `git config --global --add safe.directory <ruta>`.
- Falta `python3` al generar identificadores: instalarlo según la tabla de
  requisitos y usar [scripts/new-id.sh](../scripts/new-id.sh).

## Al instanciar la plantilla

Elegir licencia y añadir `LICENSE`, reescribir el
[README.md](../README.md), cambiar el `name` de `pyproject.toml` al nombre del
proyecto y registrar el stack elegido en un ADR nuevo según
[CONTRIBUTING.md](../CONTRIBUTING.md).
