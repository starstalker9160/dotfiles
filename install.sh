#!/bin/bash

# TODO
# - backup current config
# - copy over new configs to the right places
# - option to also install neovim configs
# 	- clear the ~/.local/share/nvim folder if exists
# - move over the ./bin into ~/.local/bin

CWD=$(pwd)
CONFIG_DIR="$HOME/.config/"
BACKUP_DIR="$HOME/.config/backups/$(date +%s)"

#mkdir -p "$BACKUP_DIR"

echo "$CWD"
echo "$CONFIG_DIR"
echo "$BACKUP_DIR"
