#!/bin/zsh
# only applies to macOS
if [[ "$OSTYPE" != darwin* ]]; then
  echo "not macOS, skipping mac-setup"
  exit 0
fi

source "${0:A:h}/setup/lib.sh"
eval "$("$HOMEBREW_PATH"/bin/brew shellenv zsh)"

brew list bluesnooze &>/dev/null || brew install bluesnooze # turns off Bluetooth during sleep
for cask in 1password ungoogled-chromium phpstorm visual-studio-code signal fork; do
  brew list --cask "$cask" &>/dev/null || brew install --cask "$cask"
done

# remap Home/End to move to the beginning/end of a line (takes effect in newly launched apps)
mkdir -p ~/Library/KeyBindings
cat > ~/Library/KeyBindings/DefaultKeyBinding.dict <<'DICT'
{
    "\UF729"  = "moveToBeginningOfLine:";
    "\UF72B"  = "moveToEndOfLine:";
    "$\UF729" = "moveToBeginningOfLineAndModifySelection:";
    "$\UF72B" = "moveToEndOfLineAndModifySelection:";
}
DICT
