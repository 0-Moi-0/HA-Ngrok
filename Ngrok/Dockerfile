ARG BUILD_FROM
FROM $BUILD_FROM

# Instalar dependencias del sistema
RUN apk add --no-cache bash curl

# Descargar y extraer Ngrok
RUN curl -s -o /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/${NGROK_VERSION}/ngrok_${NGROK_PLATFORM}.zip \
    && unzip /tmp/ngrok.zip -d /usr/local/bin/ \
    && rm /tmp/ngrok.zip

# Hacer ejecutable
RUN chmod +x /usr/local/bin/ngrok

# Copiar script de ejecución
COPY run.sh /run.sh

# Establecer permisos
RUN chmod a+x /run.sh

# Iniciar script al iniciar el contenedor
CMD [ "/run.sh" ]
