---
id: adr_01m4kxrankefvsc6npbwmxk691
name: 0006_entorno_wsl_ubuntu_bash
title: "Entorno por defecto: Ubuntu (WSL) sobre Windows 11 y Bash como shell base"
file_path: docs/adr/0006-entorno-wsl-ubuntu-bash.md
category: architecture
tags: [adr, entorno, wsl, ubuntu, bash, venv]
description: "Fija Ubuntu (WSL) sobre Windows 11 como entorno de desarrollo, Bash como shell base y adapta la configuración del entorno virtual. Sustituye el tema Entorno de ADR-0001 y actualiza ADR-0003."
status: accepted
updated_at: 2026-10-10T22:30:00Z
---

# 0006 — Entorno por defecto: Ubuntu (WSL) sobre Windows 11 y Bash como shell base

## Contexto y planteamiento del problema

El [ADR-0001](0001-foundational-decisions.md) adoptó Windows nativo con PowerShell como shell interactiva y descartó Linux o WSL como requisito. El [ADR-0003](0003-scripting-languages.md) mantuvo esa premisa al habilitar PowerShell 7 y Python en `.venv/` para utilidades.

En la práctica, el desarrollo del mantenedor se realiza en una distribución Ubuntu sobre WSL (Windows Subsystem for Linux) dentro de Windows 11 como anfitrión. Mantener instrucciones y ejemplos de PowerShell y rutas de Windows en el contrato causa desalineación con las sesiones de trabajo en WSL y confusión en los agentes de IA, quienes requieren herramientas Linux dentro de Ubuntu y no deben mezclar entornos ni paquetes entre plataformas.

## Factores de decisión

- Coherencia operativa: el entorno declarado en el contrato debe coincidir con el entorno de trabajo real.
- Estabilidad de la autoevaluación: la suite de verificación en POSIX `sh` debe seguir ejecutándose limpiamente sin dependencias obligatorias.
- Aislamiento de paquetes: el entorno virtual de Python debe operar con la estructura de Linux (`.venv/bin/activate`) dentro de Ubuntu sin interferir con el sistema anfitrión.

## Opciones consideradas

- Mantener Windows nativo y PowerShell 7 como entorno principal.
- Soporte dual obligatorio (probar y mantener documentación idéntica para PowerShell y Bash).
- Adoptar Ubuntu (WSL) sobre Windows 11 como entorno por defecto, con Bash como shell base interactiva y POSIX `sh` para autoevaluación.

## Resultado de la decisión

Opción elegida: «Ubuntu (WSL) sobre Windows 11 como entorno por defecto, con Bash como shell base interactiva y POSIX `sh` para autoevaluación».

| Ámbito | Configuración elegida |
| --- | --- |
| Sistema anfitrión | Windows 11 |
| Entorno de ejecución | Ubuntu (WSL) |
| Shell interactiva | Bash |
| Autoevaluación (`scripts/check.sh`, `scripts/checks/`, `.githooks/`) | POSIX `sh` |
| Entorno virtual de Python (`.venv/`) | Linux (`python3 -m venv .venv`, `source .venv/bin/activate`) |

Comandos del entorno virtual en Bash:

| Comando | Uso |
| --- | --- |
| `python3 -m venv .venv` | Crear el entorno, una vez por clon. |
| `source .venv/bin/activate` | Activarlo en cada sesión de terminal. |
| `python -m pip install -r requirements.txt` | Instalar las dependencias declaradas, con el entorno activo. |
| `deactivate` | Salir del entorno. |

Este ADR sustituye el tema «Entorno» del [ADR-0001](0001-foundational-decisions.md) y actualiza el [ADR-0003](0003-scripting-languages.md) en cuanto a la shell interactiva por defecto y comandos de activación de `.venv/`. El resto de las decisiones de ambos ADRs permanece vigente.

### Consecuencias

- Positivo: los agentes de IA interactúan directamente con el entorno de ejecución Linux sin confusiones de rutas de Windows ni comandos de PowerShell.
- Positivo: la autoevaluación en POSIX `sh` se ejecuta nativamente en el entorno Linux.
- Positivo: la integración con VS Code mediante Remote - WSL funciona de manera uniforme.
- Negativo: las instrucciones y scripts de utilidades asumen herramientas Linux en el WSL de Ubuntu; si se requiere ejecutar fuera de WSL en Windows puro, se necesitan comandos específicos de esa plataforma.

### Confirmación

- `scripts/check.sh` se ejecuta con código 0 bajo POSIX `sh` en Ubuntu (WSL).
- `AGENTS.md`, `README.md` y `CONTRIBUTING.md` reflejan Ubuntu (WSL), Bash y la activación de `.venv` con `source`.

## Más información

- [ADR-0001](0001-foundational-decisions.md): Decisiones fundacionales de la plantilla.
- [ADR-0003](0003-scripting-languages.md): Lenguajes de script.
