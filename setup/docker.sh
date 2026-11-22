#!/bin/zsh
# Docker Desktop. Accept the license on first launch (open the app once).
# Ubuntu: https://docs.docker.com/desktop/setup/install/linux/ubuntu/ (needs x86-64, Ubuntu 24.04/26.04)
# macOS: Homebrew cask (not covered by docs.docker.com, which documents the DMG)
source "${0:A:h}/lib.sh"

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$("$HOMEBREW_PATH"/bin/brew shellenv zsh)"
  brew list --cask docker-desktop &>/dev/null || brew install --cask docker-desktop
elif grep -qi '^ID=ubuntu' /etc/os-release 2>/dev/null; then
  dpkg -s docker-desktop &>/dev/null && { echo "docker-desktop already installed"; exit 0; }

  # Docker's apt repository
  sudo apt update
  sudo apt install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
  sudo apt update

  # Docker Desktop package (apt may warn about "unsandboxed" download as root; safe to ignore)
  DEB="$(mktemp -d)/docker-desktop-amd64.deb"
  curl -fsSL -o "$DEB" https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb
  sudo apt install -y "$DEB"

  # start on sign-in
  systemctl --user enable docker-desktop
else
  echo "not macOS or Ubuntu, skipping docker"
fi
