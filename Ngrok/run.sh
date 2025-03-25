#!/usr/bin/with-contenv bashio

set -x  # Habilita el modo de depuración
set -e

# Variables de configuración
AUTHTOKEN=$(bashio::config 'authtoken')
DOMAIN=$(bashio::config 'domain')
LOG_FILE="/share/ngrok.log"

# Función para iniciar el túnel Ngrok
start_ngrok() {
  echo "Iniciando túnel Ngrok..."
  /usr/bin/ngrok tcp --authtoken="$AUTHTOKEN" --domain="$DOMAIN" 8123 >> "$LOG_FILE" 2>&1 &
  echo "Túnel Ngrok iniciado en segundo plano. Logs en $LOG_FILE"
  echo "Estado del último comando: $?" # Imprime el código de salida
}

# Función para detener instancias anteriores de Ngrok
stop_ngrok() {
  echo "Deteniendo instancias anteriores de Ngrok..."
  pkill ngrok
  wait
  echo "Instancias de Ngrok detenidas."
  echo "Estado del último comando: $?" # Imprime el código de salida
}

# Instalación de Ngrok
install_ngrok() {
  echo "Instalando Ngrok..."
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
  tar -xvzf ngrok-v3-stable-linux-arm64.tgz
  mv ngrok /usr/bin/
  rm ngrok-v3-stable-linux-arm64.tgz
  echo "Ngrok instalado."
  echo "Estado del último comando: $?" # Imprime el código de salida
}

# Comprobar si ya está instalado
if ! command -v ngrok &> /dev/null; then
  install_ngrok
fi

# Main loop
while true; do
  # Detener cualquier instancia anterior de Ngrok
  stop_ngrok

  # Iniciar el túnel Ngrok
  start_ngrok

  # Esperar (por ejemplo, 24 horas) antes de reiniciar el túnel
  # Esto es opcional, pero puede ayudar a mantener la conexión estable
  sleep 86400 # 24 horas

  echo "Reiniciando el túnel Ngrok..."
done
