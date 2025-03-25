FROM homeassistant/amd64-base:latest

# Copia el script de ejecución
COPY run.sh /run.sh

# Establece los permisos de ejecución
RUN chmod +x /run.sh

# Define el punto de entrada
CMD ["/run.sh"]
