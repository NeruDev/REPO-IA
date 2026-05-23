# ESTANDARES.md: Estándares de Estructura y Gobernanza de Repositorios

Este documento define la estructura de directorios, nomenclatura y gobernanza estándar para la organización de proyectos de software en repositorios individuales. Se categorizan los archivos y directorios según su alcance mediante etiquetas claras: `[Universal]` para estándares multi-lenguaje y `[Específico: Ecosistema]` para tecnologías concretas.

---

## 1. Directorios Estándar Universales (Cross-Language)

Cualquier proyecto moderno medianamente serio organiza su raíz utilizando estos directorios comunes:

* **`src/` (Source) `[Universal]`**
  El código fuente principal de la aplicación. Aunque históricamente algunos lenguajes como Python colocaban los paquetes directamente en la raíz, hoy en día la comunidad promueve activamente el *src-layout* para evitar problemas de importación y simplificar las pruebas. Es el estándar por defecto en Rust, TypeScript, Java, C++, Go y PHP.
* **`tests/` o `test/` `[Universal]`**
  Destinado exclusivamente a las pruebas de integración, pruebas unitarias, de comportamiento o de extremo a extremo (E2E). Separarlo de `src/` asegura que las herramientas de empaquetado no incluyan código de prueba en la versión final de producción.
* **`docs/` `[Universal]`**
  Aloja la documentación técnica detallada del proyecto (archivos Markdown adicionales, diagramas de arquitectura, especificaciones de diseño o configuraciones para generadores de sitios estáticos como MkDocs, Sphinx o Astro).
* **`scripts/` o `bin/` `[Universal]`**
  Contiene scripts de automatización interna, tareas de mantenimiento, pipelines de integración local, utilidades de despliegue o, en el caso de lenguajes compilados, los ejecutables de soporte.
* **`config/` `[Universal]`**
  Archivos de configuración estática del proyecto (como archivos YAML, JSON, TOML o plantillas de entorno) que el software requiere para inicializarse en diferentes entornos (desarrollo, pruebas, producción).
* **`public/` o `assets/` `[Universal]`**
  Común en desarrollo web y videojuegos. Guarda archivos estáticos y recursos multimedia que no necesitan ser procesados ni compilados, como imágenes, fuentes, iconos, videos o archivos HTML base.
* **`dist/` o `build/` o `out/` `[Universal]`**
  Directorio temporal y efímero donde los compiladores y empaquetadores colocan el código procesado, optimizado y listo para producción. Este directorio **nunca** se sube al control de versiones (se ignora estrictamente en Git).

---

## 2. Archivos Estándar de Repositorio (Gobernanza y Plataformas)

Las plataformas de Git (GitHub, GitLab, Bitbucket) buscan e indexan automáticamente ciertos archivos en la raíz del repositorio para habilitar funciones de interfaz, integraciones y buenas prácticas comunitarias:

### Documentación y Comunidad

* **`README.md` `[Universal]`**
  La puerta de entrada al proyecto. Debe contener la descripción del proyecto, prerrequisitos, instrucciones paso a paso de instalación, ejemplos claros de uso, API básica y cómo ejecutar la suite de pruebas.
* **`LICENSE` o `LICENSE.md` `[Universal]`**
  El archivo legal que determina qué derechos de copia, modificación y distribución tienen otros desarrolladores sobre tu código (MIT, Apache 2.0, GPL v3, etc.). Un repositorio sin licencia se considera propiedad privada cerrada por defecto.
* **`CONTRIBUTING.md` `[Universal]`**
  Explica a los colaboradores externos los pasos y directrices para colaborar en el proyecto: cómo reportar bugs de forma reproducible, cómo proponer mejoras, el estilo de código requerido y la etiqueta para abrir un *Pull Request*.
* **`CHANGELOG.md` `[Universal]`**
  Registro cronológico y ordenado de las novedades, correcciones de errores y cambios importantes entre versiones del software (generalmente estructurado según las directrices de *Keep a Changelog* y Versionado Semántico).
* **`CODE_OF_CONDUCT.md` `[Universal]`**
  Establece las normas de comportamiento, inclusión y convivencia dentro de la comunidad, forzando un ambiente respetuoso y profesional en todos los canales de discusión del proyecto.
* **`SECURITY.md` `[Universal]`**
  Indica cómo reportar vulnerabilidades de seguridad de forma privada y responsable al equipo del repositorio, evitando la divulgación pública del fallo antes de que exista un parche correctivo.

### Herramientas y Configuración del Entorno

* **`.gitignore` `[Específico: Git]`**
  El estándar de control de versiones para decirle a Git qué archivos y carpetas debe ignorar (como carpetas de dependencias `node_modules/`, entornos virtuales `.venv/`, credenciales locales `.env` o carpetas de salida de compilación `dist/`).
* **`.gitattributes` `[Específico: Git]`**
  Define cómo Git debe tratar ciertos archivos en términos de finales de línea (`LF` vs `CRLF`), detección de archivos binarios y configuraciones del almacenamiento de archivos grandes (LFS). Evita problemas de espaciado al colaborar entre Windows y Linux.
* **`.editorconfig` `[Universal]`**
  Archivo estándar soportado por casi todos los editores e IDEs de la industria. Define reglas básicas de formato de texto (uso de espacios o tabulaciones, tamaño de sangría y tipo de codificación). Garantiza la uniformidad del formato sin importar el editor preferido de cada desarrollador.
* **`.env.example` `[Universal]`**
  Plantilla que lista todas las variables de entorno que el proyecto requiere para funcionar (llaves de API simuladas, puertos de escucha, credenciales de desarrollo). Sirve de guía para crear el archivo `.env` local sin arriesgarse a subir credenciales reales a producción.
* **`.mailmap` `[Específico: Git]`**
  Mapea nombres y direcciones de correo electrónico de autores en el historial de Git para consolidar contribuciones hechas bajo diferentes correos por la misma persona.
* **`markdownlint.json` `[Universal / Calidad]`**
  Archivo de configuración para linters de Markdown (como `markdownlint`), garantizando que la documentación mantenga un formato coherente, cabeceras estructuradas y espaciados correctos.

---

## 3. Directorios Ocultos Estándar de Herramientas

Directorios que empiezan con un punto (`.`) que sirven para configurar herramientas específicas y flujos de automatización integrados en el ecosistema:

* **`.github/` (o `.gitlab/`) `[Específico: Plataforma]`**
  Directorio de configuración para flujos de Integración y Despliegue Continuo (CI/CD) como GitHub Actions (en `.github/workflows/`), plantillas estructuradas de Issues y Pull Requests, y configuraciones de bots o políticas de repositorio.
* **`.vscode/` `[Específico: Editor VS Code]`**
  Almacena las configuraciones compartidas del editor Visual Studio Code, tales como extensiones recomendadas para el proyecto (`extensions.json`), perfiles de depuración (`launch.json`) y configuraciones de linters o formateadores (`settings.json`).
* **`.idea/` `[Específico: IDE JetBrains]`**
  Guarda la configuración del espacio de trabajo compartida para la suite de entornos de desarrollo de JetBrains (IntelliJ IDEA, PyCharm, WebStorm, CLion).

---

## 4. Estructuras Específicas por Ecosistema de Programación

Para repositorios individuales, cada lenguaje de programación define una jerarquía de archivos y directorios para su empaquetado, gestión de dependencias y compilación:

### 4.1. Ecosistema Python
* **`pyproject.toml` `[Específico: Python]`**
  El estándar moderno de empaquetado y configuración unificada para Python (PEP 518). Centraliza la configuración de dependencias, herramientas de construcción (como Poetry, Hatch, Flit) y linters/formateadores (Ruff, Black, Mypy).
* **`requirements.txt` `[Específico: Python]`**
  Lista tradicional de dependencias del proyecto instalables a través de `pip`. Comúnmente usado en conjunto con entornos virtuales tradicionales.
* **`setup.py` o `setup.cfg` `[Específico: Python]`**
  Archivos legados pero altamente recurrentes para la configuración y distribución de paquetes de Python en versiones antiguas.
* **`.venv/` o `venv/` `[Específico: Python]`**
  Directorio que contiene el entorno virtual local de Python, aislando las dependencias del proyecto del sistema global. **Debe estar en el `.gitignore`**.
* **`__pycache__/` `[Específico: Python]`**
  Directorio temporal autogenerado por el intérprete de Python que contiene el código objeto compilado (`.pyc`) para agilizar la importación de módulos.
* **`.pytest_cache/` / `.mypy_cache/` `[Específico: Python]`**
  Carpetas de caché generadas por las herramientas de testing (`pytest`) y tipado estático (`mypy`) para acelerar ejecuciones posteriores.

### 4.2. Ecosistema JavaScript / TypeScript (Node.js)
* **`package.json` `[Específico: Node.js]`**
  El archivo obligatorio para cualquier proyecto de Node.js. Define los metadatos del proyecto, dependencias de desarrollo y producción, y scripts de ejecución automatizados.
* **`package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` / `bun.lockb` `[Específico: Node.js]`**
  Archivos de bloqueo de dependencias generados respectivamente por npm, yarn, pnpm o bun. Garantizan que todas las instalaciones en diferentes máquinas instalen exactamente las mismas versiones de paquetes.
* **`tsconfig.json` `[Específico: TypeScript]`**
  Archivo de configuración del compilador de TypeScript (`tsc`). Define opciones de tipado estático, objetivos de compilación de JavaScript (ESNext, ES6, etc.) y resolución de rutas.
* **`node_modules/` `[Específico: Node.js]`**
  Directorio masivo donde se descargan todas las dependencias del proyecto y sus subdependencias. **Debe estar en el `.gitignore` bajo cualquier circunstancia**.
* **`eslint.config.js` / `.eslintrc.json` `[Específico: JavaScript / TypeScript]`**
  Archivos de configuración del linter ESLint para auditar la calidad, errores potenciales y estándares del código de JavaScript y TypeScript.
* **`.prettierrc` / `.prettierrc.json` `[Específico: Node.js / Web]`**
  Archivo de configuración para Prettier, el formateador de código estándar en el ecosistema web (JS, TS, HTML, CSS, JSON).

### 4.3. Ecosistema Rust
* **`Cargo.toml` `[Específico: Rust]`**
  El manifiesto de configuración para Cargo (el gestor de paquetes de Rust). Define metadatos del proyecto, dependencias (crates) y perfiles de optimización de compilación.
* **`Cargo.lock` `[Específico: Rust]`**
  El archivo de bloqueo generado automáticamente por Cargo que registra las versiones exactas de las dependencias utilizadas para compilar.
* **`target/` `[Específico: Rust]`**
  Directorio temporal autogenerado donde se almacena toda la salida de compilación (código binario compilado, dependencias compiladas intermedias). **Debe ser ignorado en Git**.

### 4.4. Ecosistema Go
* **`go.mod` `[Específico: Go]`**
  El archivo que define la ruta del módulo de Go y lista sus dependencias directas e indirectas con sus versiones respectivas.
* **`go.sum` `[Específico: Go]`**
  Contiene los hashes criptográficos de verificación de las dependencias listadas en `go.mod`, garantizando la integridad de los paquetes descargados.
* **`vendor/` `[Específico: Go]`**
  Directorio opcional donde se almacenan copias locales de todas las dependencias necesarias para compilar el módulo de Go, permitiendo construcciones totalmente offline (*offline builds*).

### 4.5. Ecosistema C / C++
* **`CMakeLists.txt` `[Específico: C / C++]`**
  El script de configuración para CMake, el sistema meta-build estándar de facto en C/C++ moderno para generar makefiles o proyectos de IDE de forma multiplataforma.
* **`Makefile` `[Específico: C / C++ / Automatización]`**
  Script tradicional utilizado por la herramienta `make` para automatizar la compilación de binarios en sistemas Unix/Linux. Aunque originario de C/C++, hoy se usa de forma universal para automatizar comandos rápidos de desarrollo en cualquier proyecto.
* **`include/` `[Específico: C / C++]`**
  Directorio destinado exclusivamente a guardar los archivos de cabecera (`.h`, `.hpp`, `.hxx`) que exponen las firmas públicas del código.
* **`lib/` `[Específico: C / C++]`**
  Guarda librerías de soporte externas de carácter binario (archivos estáticos `.a` / `.lib` o dinámicos `.so` / `.dll`).

### 4.6. Ecosistema Java / Kotlin
* **`pom.xml` `[Específico: Java / Maven]`**
  El Manifiesto de Modelo de Objetos de Proyecto (POM) utilizado por Apache Maven para gestionar dependencias, compilación y empaquetado del software de Java.
* **`build.gradle` o `build.gradle.kts` `[Específico: Java / Kotlin / Gradle]`**
  Script de construcción de Gradle para gestionar dependencias y tareas de compilación (escrito en Groovy o en Kotlin DSL respectivamente).
* **`settings.gradle` o `settings.gradle.kts` `[Específico: Java / Kotlin / Gradle]`**
  Define el nombre del proyecto y los submódulos que componen una compilación multi-proyecto en Gradle.
* **`gradlew` o `gradlew.bat` y carpeta `gradle/` `[Específico: Java / Kotlin / Gradle]`**
  El Gradle Wrapper. Scripts ejecutables que permiten ejecutar la compilación del proyecto descargando e inicializando automáticamente la versión exacta de Gradle requerida, garantizando que el build funcione en cualquier máquina sin instalaciones previas.
* **`.gradle/` `[Específico: Gradle]`**
  Directorio de caché temporal utilizado por Gradle para optimizar y acelerar las compilaciones. **Debe ignorarse en Git**.

### 4.7. Ecosistema PHP
* **`composer.json` `[Específico: PHP]`**
  Manifiesto del gestor de dependencias Composer. Lista los paquetes de PHP requeridos por el proyecto, así como las reglas de autocarga (PSR-4).
* **`composer.lock` `[Específico: PHP]`**
  Bloquea las versiones exactas de las dependencias instaladas por Composer.
* **`vendor/` `[Específico: PHP]`**
  Directorio donde Composer descarga todas las librerías dependientes y genera el script automático de autocarga (`vendor/autoload.php`). **Debe estar en el `.gitignore`**.

### 4.8. Ecosistema Ruby
* **`Gemfile` `[Específico: Ruby]`**
  Manifiesto utilizado por el gestor Bundler para listar las librerías de Ruby (gems) requeridas por la aplicación.
* **`Gemfile.lock` `[Específico: Ruby]`**
  Registra la firma y la versión exacta de cada gem y sus subdependencias instaladas por Bundler.
* **`Rakefile` `[Específico: Ruby]`**
  Define tareas personalizadas escritas en Ruby automatizables a través de la utilidad `rake` (compilaciones, migraciones, pruebas).

### 4.9. DevOps y Contenedores
* **`Dockerfile` `[Universal / DevOps]`**
  Script instructivo que define los pasos de compilación y empaquetado automatizado de la aplicación dentro de una imagen de contenedor Docker autocontenida.
* **`docker-compose.yml` `[Universal / DevOps]`**
  Archivo de configuración de Docker Compose para declarar, configurar y levantar múltiples contenedores locales intercomunicados de forma simultánea (p. ej., backend + base de datos + servidor web).
* **`.dockerignore` `[Universal / DevOps]`**
  Define qué archivos y carpetas locales (como dependencias masivas `node_modules/`, configuraciones locales `.env` o carpetas de build) deben excluirse del contexto enviado al motor de Docker, reduciendo drásticamente los tiempos de compilación de la imagen y mejorando la seguridad.
