#!/bin/bash

sudo apt update
dpkg -l code
if [ $? -eq 1 ]; then
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