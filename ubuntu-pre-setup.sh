#!/bin/bash
# only applies to Ubuntu
if ! grep -qi '^ID=ubuntu' /etc/os-release 2>/dev/null; then
  echo "not Ubuntu, skipping ubuntu-pre-setup"
  exit 0
fi

installed() { dpkg -s "$1" &>/dev/null; }

sudo apt update && sudo apt upgrade -y
sudo apt install -y gnupg software-properties-common libatomic1 # deps that are likely present
sudo apt install -y curl zsh git fonts-font-awesome # desired applications

[[ "$SHELL" == *zsh ]] || chsh -s "$(which zsh)" # switches to zsh shell

# 1Password
if ! installed 1password || ! installed 1password-cli; then
  # Add the key for 1Password to the repository
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/1password-archive-keyring.gpg
  # Add 1Password app repository
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
  # Add the debsig-verify policy
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --yes --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

  # Install 1Password
  sudo apt update && sudo apt install -y 1password 1password-cli
fi

# Ungoogled chromium; https://linuxcapable.com/how-to-install-ungoogled-chromium-on-ubuntu-linux/
if ! installed ungoogled-chromium; then
  sudo add-apt-repository ppa:xtradeb/apps -y

  printf '%s\n' \
  'Package: *' \
  'Pin: release o=LP-PPA-xtradeb-apps' \
  'Pin-Priority: 100' \
  '' \
  'Package: ungoogled-chromium*' \
  'Pin: release o=LP-PPA-xtradeb-apps' \
  'Pin-Priority: 700' \
  | sudo tee /etc/apt/preferences.d/ungoogled-chromium-pin

  sudo apt update && sudo apt install -y ungoogled-chromium
fi

# Signal
# NOTE: These instructions only work for 64-bit Debian-based
# Linux distributions such as Ubuntu, Mint etc.
if ! installed signal-desktop; then
  # 1. Install our official public software signing key:
  curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
  cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

  # 2. Add our repository to your list of repositories:
  curl -o signal-desktop.sources https://updates.signal.org/static/desktop/apt/signal-desktop.sources
  cat signal-desktop.sources | sudo tee /etc/apt/sources.list.d/signal-desktop.sources > /dev/null

  # 3. Update your package database and install Signal:
  sudo apt update && sudo apt install -y signal-desktop
fi
