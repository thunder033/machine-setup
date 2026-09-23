USER=greg

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> /Users/$USER/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> /Users/$USER/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# install apps
brew install --cask ungoogled-chromium
brew install --cask signal
brew install --cask phpstorm

# SSH Key
ssh-keygen  -t ed25519

# dev tooling
mkdir ~/project/

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash

source ~/.bashrc