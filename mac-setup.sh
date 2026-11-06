#!/bin/zsh

brew install bluesnooze # turns off Bluetooth during sleep
brew install --cask 1password
brew install --cask ungoogled-chromium
brew install --cask phpstorm
brew install --cask visual-studio-code
brew install --cask signal
brew install --cask fork

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
