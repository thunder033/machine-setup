#!/bin/zsh

PROFILE=.zshrc
EMAIL=$1

# Oh My Zsh!
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

 # Install Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
# Add plugins to .zshrc
# including nvm, which installs the latest version of nvm
PLUGINS="git zsh-autosuggestions zsh-syntax-highlighting nvm 1password"
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac requires the extra quotes argument: https://stackoverflow.com/questions/26081375/bsd-sed-extra-characters-at-the-end-of-d-command
  sed -i '' "s/^plugins=(git)$/plugins=($PLUGINS)/" "$HOME"/$PROFILE
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sed -i "s/^plugins=(git)$/plugins=($PLUGINS)/" "$HOME"/$PROFILE
fi

source "$HOME"/$PROFILE

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ "$OSTYPE" == "darwin"* ]]; then
    HOMEBREW_PATH="/opt/homebrew"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    HOMEBREW_PATH="/home/linuxbrew/.linuxbrew"
fi

echo "eval \"$("$HOMEBREW_PATH"/bin/brew shellenv zsh)\"" >> "$HOME"/$PROFILE
eval "$("$HOMEBREW_PATH"/bin/brew shellenv zsh)"

# install apps
brew install --cask ungoogled-chromium
brew install --cask signal
brew install --cask phpstorm
brew install --cask visual-studio-code

brew install polkit # needed for 1Password CLI integration

# SSH Key
ssh-keygen -t ed25519 -C "$EMAIL"

# start ssh agent
eval "$(ssh-agent -s)"

# add key to the agent
if [[ "$OSTYPE" == "darwin"* ]]; then
  touch ~/.ssh/config
  echo "
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
" >> ~/.ssh/config
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  ssh-add ~/.ssh/id_ed25519
fi

# dev tooling
mkdir ~/project/

# NVM / Node.JS
nvm install --lts
