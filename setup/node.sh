#!/bin/zsh
source "${0:A:h}/lib.sh"

# dev tooling
mkdir -p "$HOME"/project/

# NVM / Node.JS (nvm comes from the zsh-nvm plugin, loaded by the profile)
source "$HOME"/$PROFILE
nvm install --lts
