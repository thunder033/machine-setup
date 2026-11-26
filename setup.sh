#!/bin/bash
# bash (not zsh) so this runs on a fresh Ubuntu box; the first step installs zsh for the rest.
# usage: setup.sh <email> [--1password-agent]
# Each step also runs on its own: zsh setup/<step>.sh (ssh.sh takes the same args)
# Every step is safe to re-run; ubuntu/mac steps skip themselves on other OSes.

D="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

bash "$D"/ubuntu-pre-setup.sh
zsh "$D"/setup/ohmyzsh.sh
zsh "$D"/setup/homebrew.sh
zsh "$D"/setup/ssh.sh "$@"
zsh "$D"/setup/claude.sh
zsh "$D"/setup/node.sh
zsh "$D"/setup/docker.sh
zsh "$D"/mac-setup.sh
