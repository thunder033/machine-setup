#!/bin/zsh
# shared vars, sourced by the other setup/*.sh scripts

PROFILE=.zshrc
REPO_DIR="${0:A:h:h}" # repo root (parent of setup/)

if [[ "$OSTYPE" == "darwin"* ]]; then
  HOMEBREW_PATH="/opt/homebrew"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  HOMEBREW_PATH="/home/linuxbrew/.linuxbrew"
fi
