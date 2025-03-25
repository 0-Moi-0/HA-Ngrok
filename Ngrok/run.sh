#!/usr/bin/with-contenv bashio

# Función para manejar el cierre del add-on
shutdown() {
  bashio::log.info "Cerrando el túnel Ngrok..."
  killall ngrok
  exit 0
}

# Registrar la función de cierre
trap shutdown SIGTERM SIGINT

# Bucle principal
while true; do
  bashio::log.info "Iniciando Ngrok..."

  # Matar instancias existentes de Ngrok
  killall ngrok

  # Construir el comando Ngrok
  NGROK_COMMAND="/usr/local/bin/ngrok tcp 22" # tunel SSH, se puede cambiar
  #NGROK_COMMAND="/usr/local/bin/ngrok http 8123" # tunel WEB

  if [ -n "$BASHIO_CONFIG_AUTHTOKEN" ]; then
    NGROK_COMMAND="$NGROK_COMMAND --authtoken=$BASHIO_CONFIG_AUTHTOKEN"
  fi

  if [ -n "$BASHIO_CONFIG_SUBDOMAIN" ]; then
    NGROK_COMMAND="$NGROK_COMMAND --hostname=$BASHIO_CONFIG_SUBDOMAIN"
  fi

  # Iniciar Ngrok en segundo plano
  bashio::log.info "Ejecutando: $NGROK_COMMAND"
  $NGROK_COMMAND &

  # Esperar a que el proceso se complete (o falle)
  wait

  # Log del error (si lo hay)
  if [ $? -ne 0 ]; then
    bashio::log.error "Ngrok ha fallado. Reiniciando en 60 segundos..."
  else
    bashio::log.info "Ngrok se ha detenido. Reiniciando en 60 segundos..."
  fi

  # Esperar antes de reiniciar
  sleep 60
done
