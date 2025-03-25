ARG BUILD_FROM
FROM $BUILD_FROM

# Copia el script de ejecución
COPY run.sh /run.sh

# Establece los permisos de ejecución
RUN chmod +x /run.sh

# Define el punto de entrada
CMD ["/run.sh"]
