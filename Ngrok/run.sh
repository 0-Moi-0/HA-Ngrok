#!/usr/bin/with-contenv bashio

# Función para determinar la arquitectura
get_architecture() {
  arch=$(uname -m)
  case "$arch" in
    armv7l)
      echo "armv7"
      ;;
    aarch64)
      echo "arm64"
      ;;
    arm64)
      echo "arm64"
      ;;
    x86_64)
      echo "amd64"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

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

  # Determinar la arquitectura
  ARCHITECTURE=$(get_architecture)

  # Verificar si la arquitectura es soportada
  if [ "$ARCHITECTURE" == "unknown" ]; then
    bashio::log.error "Arquitectura no soportada."
    exit 1
  fi

  # Configurar la URL de descarga de Ngrok
  NGROK_VERSION=3
  case "$ARCHITECTURE" in
    armv7)
      NGROK_PLATFORM="linux_armv7"
      ;;
    arm64)
      NGROK_PLATFORM="linux_arm64"
      ;;
    amd64)
      NGROK_PLATFORM="linux_amd64"
      ;;
    *)
      bashio::log.error "Plataforma no soportada: $ARCHITECTURE"
      exit 1
      ;;
  esac
  NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/${NGROK_VERSION}/ngrok_${NGROK_PLATFORM}.zip"

  # Descargar Ngrok
  bashio::log.info "Descargando Ngrok desde $NGROK_URL..."
  curl -s -o /tmp/ngrok.zip "$NGROK_URL"
  if [ $? -ne 0 ]; then
    bashio::log.error "Error al descargar Ngrok."
    exit 1
  fi

  # Descomprimir Ngrok
  bashio::log.info "Descomprimiendo Ngrok..."
  unzip /tmp/ngrok.zip -d /usr/local/bin/
  if [ $? -ne 0 ]; then
    bashio::log.error "Error al descomprimir Ngrok."
    exit 1
  fi

  # Limpiar
  rm /tmp/ngrok.zip

  # Hacer ejecutable
  chmod +x /usr/local/bin/ngrok

  # Construir el comando Ngrok
  NGROK_COMMAND="/usr/local/bin/ngrok tcp 22" # Tunel SSH, se puede cambiar

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
