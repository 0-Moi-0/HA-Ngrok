ARG BUILD_FROM
FROM $BUILD_FROM

# Copy root filesystem
#COPY rootfs /

# Setup requirements
ARG BUILD_ARCH
RUN set -x \
 && apk add --no-cache curl \
 && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
 && curl -Lo /ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-${ARCH}.zip \
 && unzip -o /ngrok.zip -d /bin \
 && rm -f /ngrok.zip

# Initialize ngrok
#RUN  ngrok --version

# Instala dependencias necesarias
RUN apk add --no-cache curl jq

# Copia el script de ejecución
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Define el comando de inicio
CMD ["/run.sh"]
