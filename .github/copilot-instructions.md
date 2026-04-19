# Instrucciones de Contexto para GitHub Copilot

Este documento define las convenciones de programación, estilo de código y formato de interacción exclusivas para GitHub Copilot (autocompletado y chat). Copilot debe asumir que las reglas operativas y de entorno ya están cubiertas en `AGENTS.md`.

## 1. Comportamiento en el Chat del IDE
* **Respuestas Concisas:** Omite los saludos, despedidas y explicaciones filosóficas largas. Ve directo al código o a la solución técnica.
* **Fragmentos (Snippets) Precisos:** Si se solicita modificar una función en un archivo grande, devuelve **solo** la función modificada y su contexto inmediato. No imprimas el archivo completo a menos que se solicite explícitamente.
* **Proactividad en Refactorización:** Si el código seleccionado en el editor viola principios SOLID, sugiere una refactorización de forma proactiva antes de añadir nueva lógica.

## 2. Convenciones de Código y Arquitectura (Independiente del Lenguaje)
* **Tipado Estricto:** Siempre que el lenguaje lo soporte (ej. Type Hints en Python, TypeScript, etc.), infiere y declara explícitamente los tipos de entrada y salida de variables y funciones.
* **Retornos Tempranos (Early Returns):** Evita la anidación profunda de condicionales (Deep Nesting / Arrow Code). Valida los errores o casos base al inicio de la función y retorna inmediatamente (patrón *Guard Clauses*).
* **Inmutabilidad por Defecto:** Prefiere estructuras de datos inmutables y funciones puras que no alteren el estado global, a menos que el paradigma del script exija lo contrario.
* **Evitar "Magic Numbers" o Cadenas Sueltas:** Extrae valores constantes, URLs o multiplicadores matemáticos a variables o enumeradores con nombres descriptivos en la parte superior del archivo o módulo.

## 3. Documentación y Comentarios
* **Documentar el "Por qué", no el "Qué":** El código limpio se explica a sí mismo. Los comentarios dentro de las funciones solo deben existir para explicar decisiones de diseño complejas, algoritmos oscuros o mitigaciones de bugs.
* **Docstrings Estándar:** Toda clase o función pública debe tener un bloque de documentación (ej. estilo Google en Python, JSDoc en JS/TS) que describa los parámetros, el retorno y posibles excepciones.

## 4. Generación de Pruebas (Testing)
* **Patrón AAA:** Toda prueba unitaria generada debe estructurarse visual o lógicamente en tres bloques: *Arrange* (preparación), *Act* (ejecución) y *Assert* (verificación).
* **Casos Límite:** Al generar pruebas para una función, Copilot debe incluir de manera predeterminada aserciones para valores nulos, colecciones vacías y tipos de datos inesperados.

## 5. Integración con Git (Generación de Commits y PRs)
Cuando se solicite generar mensajes de commit basados en diferencias de código:
* Usa el formato *Conventional Commits* (ej. `feat:`, `fix:`, `refactor:`, `docs:`).
* Redacta el mensaje en español (según el estándar del repositorio), manteniendo el imperativo en la descripción corta (ej. `feat: agregar validación de nulos`).