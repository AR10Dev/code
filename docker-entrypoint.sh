#!/bin/bash

sudo nala upgrade
apt show code
if [ $? -eq 100 ]; then
    sudo nala install -y \
    bat \
    exa \
    rtx \
    code
fi