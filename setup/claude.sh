#!/bin/zsh
source "${0:A:h}/lib.sh"

# Claude Code user-level instructions
mkdir -p "$HOME"/.claude
ln -sfn "$REPO_DIR"/claude/CLAUDE.md "$HOME"/.claude/CLAUDE.md
