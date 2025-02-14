FROM ghcr.io/hassio-addons/base:14.0.0

# Instala dependencias necesarias
RUN apk add --no-cache curl jq

# Copia el script de ejecución
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Define el comando de inicio
CMD ["/run.sh"]