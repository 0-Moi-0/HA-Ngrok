ARG BUILD_FROM
FROM $BUILD_FROM

# Instala dependencias necesarias
RUN apk add --no-cache curl jq

# Copia el script de ejecución
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Define el comando de inicio
CMD ["/run.sh"]
