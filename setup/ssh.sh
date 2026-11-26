#!/bin/zsh
source "${0:A:h}/lib.sh"

EMAIL=$1 # for SSH key/development
# pass --1password-agent as 2nd arg to use the 1Password SSH agent instead of a local key
USE_1P_AGENT=$([[ "$2" == "--1password-agent" ]] && echo 1)

SSH_CONFIG="$HOME"/.ssh/config
mkdir -p "$HOME"/.ssh
touch "$SSH_CONFIG"

# append a "Host *" block to the ssh config unless $1 (a marker line) is already there
add_ssh_config() {
  grep -qF "$1" "$SSH_CONFIG" || printf '\nHost *\n%s\n' "$2" >> "$SSH_CONFIG"
}

# SSH
if [[ -n "$USE_1P_AGENT" ]]; then
  # SSH agent must be enabled in the 1Password app (developer settings)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    AGENT_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  else
    AGENT_SOCK="$HOME/.1password/agent.sock"
  fi
  add_ssh_config IdentityAgent "  IdentityAgent \"$AGENT_SOCK\""
else
  # SSH Key
  [[ -f "$HOME"/.ssh/id_ed25519 ]] || ssh-keygen -t ed25519 -C "$EMAIL"

  # start ssh agent
  eval "$(ssh-agent -s)"

  # add key to the agent
  if [[ "$OSTYPE" == "darwin"* ]]; then
    add_ssh_config UseKeychain "  AddKeysToAgent yes
  UseKeychain yes"
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ssh-add "$HOME"/.ssh/id_ed25519
  fi
fi

# switch this repo's remote from https to ssh now that the key is set up
git -C "$REPO_DIR" remote set-url origin git@github.com:thunder033/machine-setup.git
