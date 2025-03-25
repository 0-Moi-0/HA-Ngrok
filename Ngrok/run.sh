#!/bin/sh

CONFIG_PATH=/config/options.json  # Verifica esta ruta

# Leer opciones del complemento
authtoken=$(jq --raw-output '.authtoken' $CONFIG_PATH)
domain=$(jq --raw-output '.domain' $CONFIG_PATH)

# Autenticar y lanzar el túnel
/usr/local/bin/ngrok authtoken "$authtoken"
if [ $? -ne 0 ]; then
    echo "Error: Failed to authenticate with ngrok"
    exit 1
fi

/usr/local/bin/ngrok tcp 8123 --hostname="$domain" --region=auto
if [ $? -ne 0 ]; then
    echo "Error: Failed to start ngrok tunnel"
    exit 1
fi

echo "Ngrok tunnel started successfully"
