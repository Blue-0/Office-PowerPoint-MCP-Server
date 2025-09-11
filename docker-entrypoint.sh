#!/bin/sh
set -e

# Ports (modifiable via variables d'env si besoin)
PPT_INTERNAL_PORT="${PPT_INTERNAL_PORT:-8000}"   # port local sur lequel le serveur bind (127.0.0.1)
PPT_PROXY_PORT="${PPT_PROXY_PORT:-8000}"       # port exposé/public

# Démarrer socat pour forwarder 0.0.0.0:PPT_PROXY_PORT -> 127.0.0.1:PPT_INTERNAL_PORT
# On lance en background pour ne pas bloquer le processus principal
socat TCP-LISTEN:${PPT_PROXY_PORT},reuseaddr,fork TCP:127.0.0.1:${PPT_INTERNAL_PORT} >/dev/null 2>&1 &

# Exec le serveur (transmet tous les arguments passés au container)
exec python ppt_mcp_server.py "$@"
