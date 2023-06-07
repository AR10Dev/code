#!/bin/bash

sudo apt update
apt show code
if [ $? -eq 100 ]; then
    sudo apt install -y \
    nala \
    bat \
    exa \
    rtx \
    code
fi

# Drop privileges (when asked to) if root, otherwise run as current user
if [ "$(id -u)" == "0" ] && [ "${PUID}" != "0" ]; then
  su-exec ${PUID}:${PGID} "$@"
else
  exec "$@"
fi