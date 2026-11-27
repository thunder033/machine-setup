#!/bin/zsh
# Proton Mail Bridge. Sign in once in the app after install.
# Ubuntu: https://proton.me/mail/bridge/linux (amd64 .deb, checked with Proton's detached GPG signature)
source "${0:A:h}/lib.sh"

BRIDGE_VERSION=3.27.2 # latest as of 2026-11-26; bump to upgrade
BRIDGE_URL=https://proton.me/download/bridge

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$("$HOMEBREW_PATH"/bin/brew shellenv zsh)"
  brew list --cask proton-mail-bridge &>/dev/null || brew install --cask proton-mail-bridge
elif grep -qi '^ID=ubuntu' /etc/os-release 2>/dev/null; then
  [[ "$(dpkg-query -W -f='${Version}' protonmail-bridge 2>/dev/null)" == "$BRIDGE_VERSION"* ]] \
    && { echo "protonmail-bridge $BRIDGE_VERSION already installed"; exit 0; }
  [[ "$(dpkg --print-architecture)" == amd64 ]] || { echo "protonmail-bridge .deb is amd64 only, skipping"; exit 0; }

  sudo apt install -y curl gnupg

  WORK="$(mktemp -d)"
  DEB="$WORK/protonmail-bridge_${BRIDGE_VERSION}-1_amd64.deb"
  curl -fsSL -o "$DEB" "$BRIDGE_URL/$(basename "$DEB")"
  curl -fsSL -o "$DEB.sig" "$BRIDGE_URL/$(basename "$DEB").sig"
  curl -fsSL -o "$WORK/bridge_pubkey.gpg" "$BRIDGE_URL/bridge_pubkey.gpg"

  # shortcut: the key comes from the same host as the .deb, so this catches corruption and a tampered
  # .deb but not a compromised proton.me; pin the key fingerprint here if that matters
  export GNUPGHOME="$WORK/gnupg"
  mkdir -m 700 "$GNUPGHOME"
  gpg --batch --import "$WORK/bridge_pubkey.gpg"
  gpg --batch --verify "$DEB.sig" "$DEB" || { echo "protonmail-bridge signature check FAILED"; exit 1; }

  chmod a+rx "$WORK" && chmod a+r "$DEB" # lets apt's _apt user read the .deb (no sandbox warning)
  sudo apt install -y "$DEB"
  rm -rf "$WORK"
else
  echo "not macOS or Ubuntu, skipping protonmail-bridge"
fi
