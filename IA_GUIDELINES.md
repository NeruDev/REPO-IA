# IA_GUIDELINES.md: Directrices de Desarrollo para Agentes de IA

Este documento establece un estándar de diseño y comportamiento para agentes autónomos de IA que operan en este repositorio. Dado que este proyecto está compuesto principalmente por **archivos Markdown** y **scripts de Python**, las directrices se enfocan en la concisión, la prevención del código redundante agéntico, la robustez sistémica y el uso eficiente de la ventana de contexto.

---

## Filosofía del Proyecto

* **Simplicidad sobre Abstracción:** Es preferible un script de Python de 50 líneas fácil de leer que una arquitectura compleja de clases y fábricas para una tarea simple.
* **Mantenibilidad Pragmática:** Escribir código y documentación que cualquier otro agente (o humano) pueda entender y modificar sin tener que leer 15 archivos de contexto.
* **Eficiencia de Tokens:** Evitar explicaciones redundantes y comentarios filosóficos en el código o la documentación. Las instrucciones deben ser cortas, específicas y observables.

---

## 1. Principios de Diseño Agéntico Fundamentales

Para evitar interpretaciones ambiguas por parte de la IA, cada principio clásico y universal se desglosa en su interpretación específica, una regla accionable y ejemplos claros basados en la automatización y documentación del repositorio.

### 1.1. YAGNI (You Aren't Gonna Need It)
* **Interpretación específica para el repositorio:**
  No implementes funciones de automatización hipotéticas en Python ni generes secciones de documentación vacías o especulativas en Markdown para "futuras fases" del proyecto.
* **Regla accionable:**
  Resuelve únicamente el requerimiento solicitado en el prompt actual. No agregues parámetros opcionales sin uso inmediato en los scripts ni estructures clases complejas pensando en futuras extensiones. Trabaja mediante micro-entregas guiadas.
* **Ejemplos:**
  * **Correcto:** Un script en Python que procesa y limpia un archivo CSV específico solicitado por el usuario.
  * **Incorrecto:** Diseñar una clase base abstracta de importación con soporte para CSV, JSON y bases de datos SQL cuando el usuario solo tiene un archivo CSV.

---

### 1.2. DRY (Don't Repeat Yourself)
* **Interpretación específica para el repositorio:**
  Evita la duplicación de funciones de utilidad en scripts de Python (p. ej., formateadores de texto, parseadores de Markdown) y no copies ni pegues la misma información o tablas explicativas en múltiples archivos Markdown.
* **Regla accionable:**
  Antes de escribir una nueva función en Python, inspecciona el repositorio en busca de módulos comunes o de utilidad (como `src/utils/`). En archivos Markdown, si la misma información es necesaria en varios lugares, centralízala en un solo documento de referencia y enlázala en lugar de duplicar el texto.
* **Ejemplos:**
  * **Correcto:** Importar una función de validación de rutas desde un archivo de utilidades común (`src/utils/paths.py`).
  * **Incorrecto:** Copiar y pegar un bloque de código regex de extracción de enlaces Markdown en tres scripts de automatización individuales.

---

### 1.3. SRP (Single Responsibility Principle)
* **Interpretación específica para el repositorio:**
  Cada script de Python debe resolver un único paso del flujo de datos o automatización. Cada archivo Markdown debe documentar un único tema o aspecto bien delimitado del sistema.
* **Regla accionable:**
  Si un script de Python comienza a realizar múltiples tareas independientes (como extraer datos de una API, generar un gráfico y enviar un reporte), divide la lógica en scripts dedicados o funciones con responsabilidades claras. Divide la documentación extensa en archivos Markdown separados por temas en lugar de tener un único archivo gigante.
* **Ejemplos:**
  * **Correcto:** Tener `fetch_api.py` para la extracción de datos y `generate_report.py` para crear el reporte Markdown.
  * **Incorrecto:** Un único script `main.py` de 600 líneas que gestiona la API, limpia los datos, genera reportes e intenta estructurar directorios.

---

### 1.4. Alta Cohesión y Bajo Acoplamiento
* **Interpretación específica para el repositorio:**
  Los scripts deben tener funciones hiper-especializadas y autocontenidas que no requieran conocer los detalles internos de otros scripts. Los archivos Markdown deben agrupar conceptos afines sin generar dependencias que obliguen a actualizar múltiples archivos ante un solo cambio de criterio (evitando el efecto dominó).
* **Regla accionable:**
  Diseña scripts con interfaces de entrada/salida simples y estándares (p. ej., diccionarios nativos o JSON). Si una modificación en un script de Python o en un documento Markdown requiere alterar más de un archivo externo para evitar fallas, detén el desarrollo y refactoriza la estructura.
* **Ejemplos:**
  * **Correcto:** Un script analizador de Markdown que recibe texto como entrada y devuelve una lista de diccionarios, abstrayendo de dónde proviene o cómo se almacena el archivo.
  * **Incorrecto:** Un analizador de Markdown que escribe directamente en un formato de archivo propietario y llama a funciones de una clase de base de datos específica, acoplando el análisis con el almacenamiento.

---

### 1.5. KISS (Keep It Simple, Stupid)
* **Interpretación específica para el repositorio:**
  Resuelve las tareas de automatización con el menor número de dependencias externas y abstracciones de código posibles. Prioriza scripts secuenciales, sencillos y directos sobre patrones de diseño abstractos que compliquen la legibilidad para otros desarrolladores o agentes de IA.
* **Regla accionable:**
  Utiliza preferiblemente la librería estándar de Python. Evita la creación de jerarquías de clases complejas, metaclases o decoradores avanzados si una simple función estructurada resuelve el problema de forma óptima.
* **Ejemplos:**
  * **Correcto:** Leer un archivo JSON de configuración con `json.load()` y un bucle secuencial simple para procesar sus elementos.
  * **Incorrecto:** Implementar un patrón Singleton para un gestor de configuración `AppConfigManager` junto a un sistema de observadores asíncronos para leer un JSON estático de 10 líneas.

---

### 1.6. La Regla del Boy Scout
* **Interpretación específica para el repositorio:**
  Limpia y mejora pequeños detalles del archivo que estás modificando (como formato, tipografía o comentarios erróneos) para evitar el deterioro del código, pero hazlo estrictamente dentro del ámbito de tu tarea para evitar el "Diff Bloat" (historiales de cambio gigantescos e incomprensibles).
* **Regla accionable:**
  Si encuentras un error tipográfico, un comentario obsoleto o una variable confusa *dentro del mismo bloque de código o sección de archivo en el que estás trabajando*, corrígelo de inmediato. No realices refactorizaciones estéticas en archivos externos a menos que sea una tarea específica solicitada por el usuario.
* **Ejemplos:**
  * **Correcto:** Corregir una falta de ortografía o un enlace roto en el párrafo contiguo del archivo Markdown que estás editando.
  * **Incorrecto:** Reordenar e indentar de forma diferente todo el archivo y renombrar 15 variables globales en tres módulos independientes mientras estabas corrigiendo un bug de una sola línea.

---

### 1.7. Separación de Intereses (SoC - Separation of Concerns)
* **Interpretación específica para el repositorio:**
  Separa la lógica del código de su documentación, y las configuraciones dinámicas de la lógica de ejecución del script. No incrustes configuraciones dinámicas dentro de las funciones ni mantengas documentación duplicada.
* **Regla accionable:**
  Divide el repositorio en carpetas claras: utilidades en `src/utils/`, scripts en la raíz o carpetas dedicadas, y guías en Markdown claramente nombradas en la raíz. Las credenciales o rutas locales dinámicas deben leerse desde variables de entorno o archivos de configuración locales como `.env` o `config.json`.
* **Ejemplos:**
  * **Correcto:** Un script `src/analytics.py` que lee los nombres de las carpetas a analizar desde un archivo JSON local de configuración.
  * **Incorrecto:** Hardcodear rutas locales absolutas de Windows (como `C:/Users/jesus/Desktop/...`) dentro del cuerpo de la función principal en el archivo de lógica.

---

### 1.8. Principio de la Menor Sorpresa (POLA - Principle of Least Astonishment)
* **Interpretación específica para el repositorio:**
  Cada función, script o sección de documentación debe comportarse exactamente de la forma más predecible e intuitiva para un desarrollador o agente de IA que lo examine por primera vez, eliminando cualquier comportamiento oculto o efectos secundarios.
* **Regla accionable:**
  Escribe nombres autoexplicativos y precisos. Si una función se llama `validate_markdown_headers()`, solo debe comprobar la sintaxis de las cabeceras; no debe formatear el archivo, ni alterar enlaces, ni borrar archivos temporales sin el conocimiento explícito del llamador.
* **Ejemplos:**
  * **Correcto:** Una función `get_file_size()` que calcula los bytes de un archivo y devuelve un entero.
  * **Incorrecto:** Una función `get_file_size()` que, además de calcular los bytes, comprime el archivo y borra el original si supera los 10 MB.

---

### 1.9. Evitar la Optimización Prematura
* **Interpretación específica para el repositorio:**
  No compliques el código de los scripts de automatización con micro-optimizaciones algorítmicas avanzadas a costa de la legibilidad, a menos que se demuestre con métricas un cuello de botella real de rendimiento en el flujo de trabajo.
* **Regla accionable:**
  Escribe código descriptivo, secuencial y limpio. Solo utiliza estructuras complejas o concurrencia asíncrona si hay un informe de perfilado (*profiling*) o una justificación de rendimiento que demuestre que el script actual ralentiza severamente el pipeline de desarrollo.
* **Ejemplos:**
  * **Correcto:** Usar un bucle simple `for` para leer consecutivamente 50 archivos Markdown y procesar sus líneas.
  * **Incorrecto:** Implementar procesamiento en paralelo con `multiprocessing` u optimizar a nivel de bytes el procesado de caracteres para leer esos mismos 50 archivos.

---

### 1.10. Convención sobre Configuración (CoC)
* **Interpretación específica para el repositorio:**
  Reduce las decisiones de estructuración adoptando convenciones consistentes del repositorio. Esto proporciona una estructura predecible que permite a los agentes de IA navegar por la base de código de forma matemática sin perder tiempo analizando archivos de configuración personalizados complejos.
* **Regla accionable:**
  Adhiérete estrictamente a las convenciones ya establecidas en el repositorio: codificación UTF-8, uso de `snake_case` para archivos y directorios, y la ubicación predeterminada para el código en `src/` o los documentos temáticos en la raíz.
* **Ejemplos:**
  * **Correcto:** Crear un script de ayuda para exportaciones en `src/utils/export_helper.py`.
  * **Incorrecto:** Crear una carpeta llamada `src/Helper-Export-Scripts/` y alojar allí un archivo `helper.py.txt` para esquivar la estructura convencional.

---

### 1.11. Principio de Fallo Rápido (Fail-Fast)
* **Interpretación específica para el repositorio:**
  Los scripts y automatizaciones deben fallar inmediatamente lanzando excepciones legibles ante cualquier anomalía o estado inconsistente. Si un script oculta silenciosamente un error (como capturar excepciones sin relanzarlas o retornar valores nulos por defecto), el agente de IA continuará la ejecución asumiendo que todo fue exitoso, escribiendo código incorrecto sobre bases erróneas y desperdiciando valiosos tokens de contexto.
* **Regla accionable:**
  Valida las condiciones de entrada y dependencias críticas (como la presencia de archivos obligatorios) al inicio de cada función o script. No captures excepciones globales con bloques `try-except` genéricos que traguen el error; propaga excepciones específicas y detén el proceso al instante si ocurre una falla técnica.
* **Ejemplos:**
  * **Correcto:**
    ```python
    if not os.path.exists(config_path):
        raise FileNotFoundError(f"Archivo de configuración crítico no encontrado: {config_path}")
    ```
  * **Incorrecto:**
    ```python
    try:
        with open(config_path) as f:
            data = json.load(f)
    except:
        data = {}  # Falla silenciosa que provoca errores lógicos en pasos posteriores
    ```

---

## 2. Principios Contextuales y de Arquitectura Agéntico-SOLID

Estos principios avanzados guían la arquitectura estructural de las herramientas y la documentación, garantizando que el repositorio escale sin sobrecargar de contexto a los agentes autónomos de IA.

### 2.1. Principio de Abierto/Cerrado (OCP)
* **Interpretación específica para el repositorio:**
  La lógica de automatización del repositorio debe diseñarse de modo que los nuevos requisitos se implementen añadiendo nuevo código (funciones de extensión o nuevos módulos) en lugar de modificar constantemente la lógica interna central ya probada y operativa.
* **Regla accionable:**
  Evita meter condicionales `if-else` masivos en tus scripts principales para manejar nuevos casos. En su lugar, diseña el script central para que sea parametrizable o acepte funciones externas que inyecten el comportamiento.
* **Ejemplos:**
  * **Correcto:** Un script de formateo que itera sobre una lista de validadores registrados y los ejecuta secuencialmente. Para añadir una nueva regla, solo creas un archivo con el validador y lo registras.
  * **Incorrecto:** Un script central con un bloque `if-else` de 200 líneas que analiza qué tipo de archivo se procesa, teniendo que modificar ese archivo central cada vez que se soporta una nueva extensión.

---

### 2.2. Principio de Sustitución de Liskov (LSP)
* **Interpretación específica para el repositorio:**
  Toda extensión o subclase de un componente de automatización debe mantener intacto el comportamiento y las expectativas del componente original. Las desviaciones semánticas causan fallos catastróficos ya que la IA asume con fe ciega el cumplimiento del contrato original.
* **Regla accionable:**
  Utiliza de forma obligatoria anotaciones de tipos de Python (*Type Hints*) para forzar la coincidencia exacta de parámetros de entrada y tipos de retorno. Una subclase o función de extensión nunca debe cambiar un tipo de retorno esperado ni lanzar excepciones fuera de las documentadas en la clase base.
* **Ejemplos:**
  * **Correcto:** Una subclase `JSONExporter` que hereda de `BaseExporter` y cuyo método `save(data: dict) -> bool` retorna un booleano tal como requiere el padre.
  * **Incorrecto:** Modificar `JSONExporter.save()` para que retorne la ruta del archivo como `str`, rompiendo los scripts de orquestación que esperaban evaluar un resultado booleano.

---

### 2.3. Principio de Segregación de Interfaces (ISP)
* **Interpretación específica para el repositorio:**
  Es preferible estructurar múltiples interfaces o módulos pequeños y específicos en lugar de un único módulo monolítico y gigantesco. En el desarrollo agéntico, las interfaces gigantescas causan "Prompt Bloat" (ruido en la ventana de contexto) saturando la atención de la IA y provocando alucinaciones.
* **Regla accionable:**
  Divide el código de soporte en pequeños módulos independientes. Si una clase o script requiere interactuar con el sistema de archivos, el formateo de texto y la red, no concentres todo en un archivo. Divide la lógica en módulos atómicos para que la IA solo cargue el contexto del módulo específico que requiere usar.
* **Ejemplos:**
  * **Correcto:** Un módulo `src/utils/file_io.py` para lectura/escritura y `src/utils/text_formatter.py` para dar formato.
  * **Incorrecto:** Un único módulo masivo `src/utils/helper.py` de 2000 líneas que contiene métodos para formateo de texto, llamadas de red, parsing de Markdown y encriptación.

---

### 2.4. Principio de Inversión de Dependencias (DIP)
* **Interpretación específica para el repositorio:**
  Los scripts de automatización de alto nivel no deben depender de herramientas específicas de bajo nivel, sino de abstracciones e interfaces claras. Esto permite a la IA escribir y ejecutar de forma autónoma pruebas unitarias simuladas (*mocks*), garantizando la estabilidad antes de su despliegue.
* **Regla accionable:**
  Inyecta las dependencias externas (como gestores de rutas, sockets o conectores) a través de los argumentos de las funciones o constructores en lugar de instanciarlas de forma fija dentro del script de automatización.
* **Ejemplos:**
  * **Correcto:**
    ```python
    def read_metadata(file_system_service, path):
        return file_system_service.read(path)
    ```
  * **Incorrecto:**
    ```python
    def read_metadata(path):
        # Acopla el código directamente al sistema de archivos real de la máquina local
        with open(path) as f:
            return f.read()
    ```

---

### 2.5. Ley de Demeter (LoD)
* **Interpretación específica para el repositorio:**
  Un script o función solo debe interactuar con sus componentes o parámetros inmediatos, evitando largas cadenas de llamadas de navegación interna (como `objeto.get_a().get_b().get_c()`). Del mismo modo, a nivel sistémico, a cada agente de IA se le debe acotar el conjunto de herramientas (*tools*) a un número mínimo indispensable (3 a 5 herramientas) para su tarea, evitando la fatiga de contexto y la parálisis por análisis.
* **Regla accionable:**
  Diseña fachadas limpias que consoliden las interacciones complejas. No expongas llamadas encadenadas al llamador. Si necesitas realizar una acción que requiere múltiples saltos, encapsula la navegación en una única función cohesiva.
* **Ejemplos:**
  * **Correcto:** `reporte.obtener_autor()`
  * **Incorrecto:** `reporte.get_metadata().get_header().get_author_info().get_name()`

---

### 2.6. Única Fuente de Verdad (SSOT - Single Source of Truth)
* **Interpretación específica para el repositorio:**
  Toda regla de desarrollo, esquema de configuración, especificación técnica o directriz de estilo debe existir en un único lugar autorizado del repositorio. Si la información se duplica o fragmenta en múltiples ubicaciones, el agente de IA leerá inevitablemente datos contradictorios o desactualizados, lo que resulta en alucinaciones severas y comportamiento inconsistente del software.
* **Regla accionable:**
  No copies bloques de texto instructivo, tablas de configuración ni guías operativas en múltiples archivos. Si un archivo Markdown necesita hacer referencia a estándares del proyecto, añade enlaces relativos directos a `IA_GUIDELINES.md` o `AGENTS.md`. Si varios scripts de Python requieren la misma configuración (como constantes o rutas de carpetas), centralízalas en un archivo JSON o TOML único en lugar de hardcodearlas en el código.
* **Ejemplos:**
  * **Correcto:** Un enlace en `README.md` que apunta directamente a la sección de "Filosofía del Proyecto" en `IA_GUIDELINES.md` de la siguiente forma: `[Filosofía](file:///G:/REPOSITORIOS%20GITHUB/REPO%20IA/IA_GUIDELINES.md#filosofia-del-proyecto)`.
  * **Incorrecto:** Copiar el texto completo de las directrices y las reglas en `README.md`, `ESTANDARES.md` y `AGENTS.md` a la vez, creando pesadillas de desincronización cada vez que se actualice una directriz.

---

## Reglas para el Comportamiento de Agentes IA

Cuando realices modificaciones en este repositorio, debes cumplir estrictamente con las siguientes reglas de operación:

1. **Hacer cambios mínimos y precisos:** No alteres líneas de código o documentación que no estén directamente relacionadas con la tarea asignada.
2. **Preservar el estilo existente:** Mantén la codificación en **UTF-8**, usa nomenclatura **snake_case** para nuevos archivos y directorios, y sigue la estructura de diseño ya definida.
3. **No reestructurar carpetas sin necesidad:** Evita mover archivos de lugar o cambiar el diseño de la arquitectura del repositorio a menos que se te pida explícitamente.
4. **Preservar comentarios y documentación:** No borres explicaciones o docstrings existentes en scripts de Python si son ajenos al cambio que estás realizando.
5. **Idioma del contenido:** Toda la documentación en Markdown y los comentarios en los scripts de Python deben redactarse en **español**, a menos que el contexto técnico (como palabras clave de programación o APIs estándar) exija términos en inglés.
