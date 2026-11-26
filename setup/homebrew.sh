#!/bin/zsh
source "${0:A:h}/lib.sh"

# install Homebrew
if [[ ! -x "$HOMEBREW_PATH/bin/brew" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

SHELLENV="eval \"\$($HOMEBREW_PATH/bin/brew shellenv zsh)\""
grep -qxF "$SHELLENV" "$HOME"/$PROFILE || echo "$SHELLENV" >> "$HOME"/$PROFILE
eval "$("$HOMEBREW_PATH"/bin/brew shellenv zsh)"

# install apps
# integration needs to be enabled in 1Password app (developer settings)
# casks are macOS-only; on Ubuntu 1password-cli comes from apt (ubuntu-pre-setup.sh)
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew list --cask 1password-cli &>/dev/null || brew install --cask 1password-cli
fi
