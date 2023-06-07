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