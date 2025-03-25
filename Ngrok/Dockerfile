ARG BUILD_FROM
FROM $BUILD_FROM

ARG TEMPIO_VERSION BUILD_ARCH
RUN \
    curl -sSLf -o /usr/bin/tempio \
    "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}"

# Instala bashio
 apk add --no-cache bash

# Copia el script de ejecución
COPY run.sh /run.sh

# Establece los permisos de ejecución
 chmod +x /run.sh

# Define el punto de entrada
CMD ["/run.sh"]
