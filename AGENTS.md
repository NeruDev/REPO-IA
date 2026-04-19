# AGENTS.md: Normas Generales para Modelos de IA

Este documento define las directrices técnicas y operativas para la interacción con modelos de lenguaje y agentes de IA en este repositorio. Aplica a herramientas como GitHub Copilot (GPT-Codex), Claude, Gemini CLI u otros agentes equivalentes.

El objetivo es garantizar consistencia, seguridad y reproducibilidad en la modificación de archivos y ejecución de comandos.

---

## 1. Alcance del Agente

Los agentes de IA que interactúan con este repositorio tienen las siguientes capacidades:

* **Modificación de Archivos:** Pueden crear, editar y eliminar archivos dentro del repositorio.
* **Ejecución de Comandos:** Pueden proponer y ejecutar comandos en la terminal.
* **Autonomía Operativa:** El agente puede actuar directamente o generar un plan de acción implícito antes de ejecutar cambios.

### Restricciones de Alcance

* El agente no debe asumir control total del sistema fuera del repositorio.
* Toda acción debe ser justificable en función del objetivo proporcionado por el usuario.

---

## 2. Estándares de Entorno y Formato

Para garantizar consistencia en el sistema y compatibilidad con los flujos de trabajo:

* **Sistema Operativo:** El entorno objetivo es **Windows**.
* **Terminal Principal:** `PowerShell` es la interfaz de comandos por defecto.
* **Compatibilidad:** En contextos no Windows (CI/CD, contenedores, sistemas Unix), se deberá usar el shell equivalente (`bash`, `zsh`) respetando la semántica del comando.
* **Codificación:** Todos los archivos de texto deben utilizar `UTF-8`.
* **Nomenclatura:** Archivos y directorios deben seguir `snake_case` y no contener acentos ni caracteres especiales.
* **Idioma:** El idioma principal es español. Se permite el uso de inglés cuando el contexto técnico lo requiera (logs, errores, documentación externa).

---

## 3. Manejo de Contexto

Para reducir errores y alucinaciones:

* **Evidencia Obligatoria:** El agente no debe asumir la estructura del repositorio, archivos existentes o dependencias sin evidencia explícita.
* **Exploración Controlada:** Se permite inspeccionar archivos del repositorio antes de actuar.
* **Claridad de Objetivo:** El usuario debe proporcionar contexto suficiente; en caso contrario, el agente debe inferir con cautela o limitar el alcance de la acción.

---

## 4. Instrucciones Generales de Operación

* **Independencia Operativa:** Cada modelo se utiliza de forma aislada. No se asume sincronización de contexto entre herramientas.
* **Validación de Sintaxis:** Todo código o comando debe ser compatible con:
  * `PowerShell` (en entorno Windows)
  * Versiones de lenguaje definidas en el proyecto (ver archivo de dependencias correspondiente)
* **No Invención:** El agente no debe inventar funciones, comandos, parámetros o herramientas no documentadas.

---

## 5. Seguridad y Restricciones Operativas

### A. Seguridad y Privacidad

* **Privilegios:** No se deben ejecutar comandos que requieran elevación de privilegios sin justificación técnica explícita y validación manual.
* **Datos Sensibles:** Está prohibido acceder, procesar o exponer credenciales, llaves API o información privada.

### B. Integridad del Sistema

* **Comandos Destructivos:** El agente debe evitar comandos potencialmente destructivos (`rm`, `del`, sobrescritura masiva, etc.) sin validación explícita del impacto.
* **Aislamiento:** Las operaciones deben limitarse al entorno del repositorio siempre que sea posible.

### C. Control de Errores

* **Fallas en Cascada:** Ante un error, el agente debe:
  1. Analizar el mensaje de error real.
  2. Proponer una corrección lógica basada en evidencia.
  3. Evitar soluciones aleatorias o iteraciones sin diagnóstico.
* **Herramientas Inexistentes:** Está prohibido asumir capacidades no disponibles en el entorno.

---

## 6. Calidad y Consistencia de Salida

* **Trazabilidad de Cambios:** El agente debe indicar qué archivos fueron modificados y bajo qué criterio lógico.
* **Consistencia de Estilo:** No se permite generar archivos que violen:
  * `snake_case` (salvo excepciones definidas en la sección 2).
  * Codificación `UTF-8`
* **Reproducibilidad:** Las acciones deben ser consistentes con el entorno definido y ejecutables bajo las mismas condiciones.

---

## 7. Flujo de Operación Estándar

1. **Definición de Tarea:** El usuario plantea el requerimiento mediante la interfaz elegida.
2. **Análisis:** El agente evalúa el contexto disponible sin asumir información no verificada.
3. **Planificación (Opcional):** El agente puede generar un plan antes de ejecutar acciones.
4. **Ejecución:** Se realizan modificaciones y/o comandos respetando las normas establecidas.
5. **Validación:** Se verifica que los cambios cumplen con el objetivo y las reglas del documento.

---