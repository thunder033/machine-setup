#!/bin/zsh

PROFILE=.zshrc
EMAIL=$1 # for SSH key/development
# pass --1password-agent as 2nd arg to use the 1Password SSH agent instead of a local key
USE_1P_AGENT=$([[ "$2" == "--1password-agent" ]] && echo 1)

# Oh My Zsh!
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
# This plugin also install nvm
git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-nvm"

# Add plugins to .zshrc
PLUGINS="git zsh-autosuggestions zsh-syntax-highlighting nvm zsh-nvm 1password"
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
# integration needs to be enabled in 1Password app (developer settings)
brew install --cask 1password-cli

# SSH
if [[ -n "$USE_1P_AGENT" ]]; then
  # SSH agent must be enabled in the 1Password app (developer settings)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    AGENT_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  else
    AGENT_SOCK="$HOME/.1password/agent.sock"
  fi
  mkdir -p "$HOME"/.ssh
  echo "
Host *
  IdentityAgent \"$AGENT_SOCK\"
" >> "$HOME"/.ssh/config
else
# SSH Key
ssh-keygen -t ed25519 -C "$EMAIL"

# start ssh agent
eval "$(ssh-agent -s)"

# add key to the agent
if [[ "$OSTYPE" == "darwin"* ]]; then
  touch "$HOME"/.ssh/config
  echo "
Host *
  AddKeysToAgent yes
  UseKeychain yes
" >> "$HOME"/.ssh/config
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  ssh-add "$HOME"/.ssh/id_ed25519
fi
fi

# switch this repo's remote from https to ssh now that the key is set up
git -C "${0:A:h}" remote set-url origin git@github.com:thunder033/machine-setup.git

# dev tooling
mkdir "$HOME"/project/

# NVM / Node.JS
nvm install --lts
