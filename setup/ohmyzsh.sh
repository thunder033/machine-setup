#!/bin/zsh
source "${0:A:h}/lib.sh"

# Oh My Zsh!
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  export RUNZSH=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Plugins (zsh-nvm also installs nvm)
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting lukechilds/zsh-nvm; do
  [[ -d "$PLUGIN_DIR/${repo:t}" ]] || git clone "https://github.com/$repo.git" "$PLUGIN_DIR/${repo:t}"
done

# Add plugins to .zshrc (the sed only matches the default line, so re-runs are no-ops)
PLUGINS="git zsh-autosuggestions zsh-syntax-highlighting nvm zsh-nvm 1password"
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac requires the extra quotes argument: https://stackoverflow.com/questions/26081375/bsd-sed-extra-characters-at-the-end-of-d-command
  sed -i '' "s/^plugins=(git)$/plugins=($PLUGINS)/" "$HOME"/$PROFILE
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sed -i "s/^plugins=(git)$/plugins=($PLUGINS)/" "$HOME"/$PROFILE
fi
