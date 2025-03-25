ARG BUILD_FROM
FROM $BUILD_FROM

FROM ghcr.io/hassio-addons/base:14.0.0

# Instala dependencias necesarias
RUN apk add --no-cache curl jq

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
