ARG BUILD_FROM
FROM $BUILD_FROM

# Instalar dependencias básicas
RUN apk add --no-cache bash curl unzip

# Copiar script de ejecución
COPY run.sh /run.sh

# Establecer permisos
RUN chmod a+x /run.sh

# Iniciar script al iniciar el contenedor
CMD [ "/run.sh" ]
