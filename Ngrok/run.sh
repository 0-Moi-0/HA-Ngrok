#!/bin/sh

CONFIG_PATH=/data/options.json

# Leer opciones del complemento
authtoken=$(jq --raw-output '.authtoken' $CONFIG_PATH)
domain=$(jq --raw-output '.domain' $CONFIG_PATH)

# Instalar Ngrok si no está presente
if [ ! -f "/usr/local/bin/ngrok" ]; then
    curl -s https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-arm.zip -o ngrok.zip
    unzip ngrok.zip -d /usr/local/bin/
    rm ngrok.zip
fi

# Autenticar y lanzar el túnel
/usr/local/bin/ngrok authtoken "$authtoken"
/usr/local/bin/ngrok http 8123 --hostname="$domain"
