---
id: adr_01m4m4bztae32vpea0s1nh4d81
name: 0007_pyproject_y_toolchain_fijada
title: "pyproject.toml, toolchain fijada y contenedor de desarrollo"
file_path: docs/adr/0007-pyproject-y-toolchain-fijada.md
category: architecture
tags: [adr, dependencias, versiones, docker, toolchain]
description: "Adopta pyproject.toml como estándar de dependencias de Python, un registro único de versiones de la toolchain y una imagen contenedor reproducible que sustituye a requirements.txt."
status: accepted
updated_at: 2026-10-11T00:03:58Z
---

# 0007 — pyproject.toml, toolchain fijada y contenedor de desarrollo

## Contexto y planteamiento del problema

Los [ADR 0003](0003-scripting-languages.md) y [0006](0006-entorno-wsl-ubuntu-bash.md)
prescriben `python -m pip install -r requirements.txt`, pero la plantilla no
declaraba ese archivo: la instrucción fallaba en todo clon nuevo. Además, ninguna
parte registraba las versiones de shellcheck, markdownlint-cli2, yamllint o
lychee, y en un mismo entorno convivían dos `yamllint` distintos (uno del sistema
y otro de `.venv/`), de modo que el resultado del chequeo dependía de la terminal
usada. Hay que decidir cómo declarar e instalar la toolchain para que la plantilla
se monte desde cero de forma repetible y sin fallos por versión.

## Factores de decisión

- El chequeo debe dar el mismo resultado en cualquier máquina y sesión.
- La plantilla sigue siendo agnóstica del lenguaje del proyecto final.
- Un único mantenedor: la instalación debe resolverse con un comando.
- Ubuntu (WSL) es el entorno canónico y Docker la vía de estandarización.

## Opciones consideradas

- `requirements.txt` con las dependencias de Python fijadas.
- `pyproject.toml` (PEP 621) para Python, `config/toolchain.env` como registro
  único de versiones y una imagen contenedor que las reproduce.
- Gestores de herramientas externos (asdf, mise) o un `package.json` por
  herramienta instalada de forma local.

## Resultado de la decisión

Opción elegida: «`pyproject.toml` más registro de versiones y contenedor»,
porque concentra las dependencias de Python en el estándar del ecosistema, fija
todas las versiones en un solo archivo legible por scripts y permite reconstruir
el entorno completo sin instalar gestores adicionales.

- `pyproject.toml` sustituye a `requirements.txt` en todas las referencias. La
  instalación es `python -m pip install .` con `.venv/` activo; el proyecto no
  distribuye código hasta elegir el stack.
- `config/toolchain.env` declara las versiones conocidas buenas: exactas para los
  linters, porque cada versión añade o cambia reglas; informativas para Python,
  Node y git.
- `scripts/setup.sh` monta el entorno desde cero de forma idempotente y
  `scripts/checks/toolchain.sh` avisa de la deriva de versiones.
- El `Dockerfile` fija la toolchain con sumas de verificación descargadas de los
  orígenes oficiales (verificadas para x86_64 al adoptar la decisión) y sirve
  también para el contenedor de desarrollo y la integración continua.

### Consecuencias

- Positivo: la instrucción de instalación es ejecutable y el entorno se reproduce
  con una imagen o con un comando.
- Positivo: la deriva de versiones se detecta como `AVISO` antes de que cambie
  los resultados del chequeo.
- Negativo: `pyproject.toml` sin paquetes de código es poco habitual y exige
  mantener actualizado el registro de versiones a mano.
- Negativo: la imagen está verificada para x86_64; otras arquitecturas requieren
  ajustar la URL y la suma de cada binario.

### Confirmación

- `sh scripts/setup.sh` en un clon limpio termina con código 0.
- `scripts/checks/toolchain.sh` informa de cada versión instalada y avisa de la
  diferencia frente a `config/toolchain.env`.
- `docker build` construye la imagen y `sh scripts/check.sh` pasa dentro de ella.
- `sh tests/sandbox.sh` sigue en verde con la selección de archivos ampliada.

## Más información

- [docs/setup.md](../setup.md): puesta en marcha desde cero por entorno.
- [config/toolchain.env](../../config/toolchain.env): registro de versiones.
- [Dockerfile](../../Dockerfile): imagen de desarrollo y verificación.
- [ADR-0003](0003-scripting-languages.md) y [ADR-0006](0006-entorno-wsl-ubuntu-bash.md):
  comandos de entorno virtual actualizados a este estándar.
