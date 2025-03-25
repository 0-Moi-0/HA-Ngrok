#!/bin/sh

CONFIG_PATH=/data/options.json

# Leer opciones del complemento
authtoken=$(jq --raw-output '.authtoken' "$CONFIG_PATH")
domain=$(jq --raw-output '.domain' "$CONFIG_PATH")

# Authenticate
if [ -n "$authtoken" ]; then
  /usr/local/bin/ngrok authtoken "$authtoken"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to authenticate with ngrok using authtoken.  Check your authtoken."
    exit 1
  fi
else
  echo "Error: No authtoken provided.  Please configure the addon."
  exit 1
fi

# Start tunnel
if [ -n "$domain" ]; then
  /usr/local/bin/ngrok tcp 8123 --hostname="$domain" --region=auto
else
  /usr/local/bin/ngrok tcp 8123 --region=auto
fi

if [ $? -ne 0 ]; then
  echo "Error: Failed to start ngrok tunnel. Check your ngrok configuration or account."
  exit 1
fi

echo "Ngrok tunnel started successfully"

while true; do
    sleep 3600 # Mantener el script en ejecución
done
