# Imagen de desarrollo y verificación de la plantilla (ADR-0007).
# Construir:  docker build -t plantilla-base .
# Comprobar:  docker run --rm -v "$PWD:/repo" -w /repo plantilla-base sh scripts/check.sh
# Detalle y alternativas en docs/setup.md. Verificada para x86_64; en otras
# arquitecturas ajustar la URL y la suma de cada binario.
FROM ubuntu:24.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TZ=UTC DEBIAN_FRONTEND=noninteractive
# El volumen montado suele pertenecer a otro UID: se acepta cualquier directorio
# git para que la herramienta no lo rechace. Imagen de desarrollo, no de servicio.
ENV GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.directory GIT_CONFIG_VALUE_0=*

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git python3 python3-pip python3-venv xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Versiones y sumas verificadas frente a config/toolchain.env.
ARG SHELLCHECK_VERSION=0.10.0
ARG SHELLCHECK_SHA256=6c881ab0698e4e6ea235245f22832860544f17ba386442fe7e9d629f8cbedf87
ARG NODE_VERSION=24.21.0
ARG NODE_SHA256=fd8e59d5a511510f6a298afb548f18c7d2b1be404d8b4a27d94fbe49f56cb2d6
ARG LYCHEE_VERSION=0.24.2
ARG LYCHEE_SHA256=1f4e0ef7f6554a6ed33dd7ac144fb2e1bbed98598e7af973042fc5cd43951c9a
ARG MARKDOWNLINT_CLI2_VERSION=0.23.3

RUN curl -sL -o /tmp/shellcheck.tar.xz \
      "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" \
    && echo "${SHELLCHECK_SHA256}  /tmp/shellcheck.tar.xz" | sha256sum -c - \
    && tar -xJf /tmp/shellcheck.tar.xz -C /tmp \
    && install "/tmp/shellcheck-v${SHELLCHECK_VERSION}/shellcheck" /usr/local/bin/shellcheck \
    && rm -rf /tmp/shellcheck* \
    && curl -sL -o /tmp/node.tar.xz \
      "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" \
    && echo "${NODE_SHA256}  /tmp/node.tar.xz" | sha256sum -c - \
    && tar -xJf /tmp/node.tar.xz -C /usr/local --strip-components=1 \
    && rm /tmp/node.tar.xz \
    && curl -sL -o /tmp/lychee.tar.gz \
      "https://github.com/lycheeverse/lychee/releases/download/lychee-v${LYCHEE_VERSION}/lychee-x86_64-unknown-linux-gnu.tar.gz" \
    && echo "${LYCHEE_SHA256}  /tmp/lychee.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/lychee.tar.gz -C /tmp \
    && install "/tmp/lychee-x86_64-unknown-linux-gnu/lychee" /usr/local/bin/lychee \
    && rm -rf /tmp/lychee* \
    && npm install -g "markdownlint-cli2@${MARKDOWNLINT_CLI2_VERSION}" \
    && shellcheck --version && lychee --version && markdownlint-cli2 --version

# Dependencias de Python (yamllint) en un entorno virtual, según pyproject.toml.
COPY pyproject.toml /opt/plantilla/
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/python -m pip install --no-cache-dir /opt/plantilla \
    && /opt/venv/bin/yamllint --version
ENV PATH=/opt/venv/bin:$PATH

WORKDIR /repo
