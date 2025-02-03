#!/bin/bash
set -e  # exit if any command fails

FLAG_FILE="$HOME/.oh_my_zsh_installed"

# If installation has been completed already, exit immediately.
if [ -f "$FLAG_FILE" ]; then
  echo "Oh My Zsh is already installed. Exiting."
  exit 0
fi

# -- Install prerequisites: Git and Zsh --
echo "Checking for Git and Zsh..."
if ! command -v git >/dev/null 2>&1; then
  echo "Git not found; installing Git..."
  sudo apt-get update && sudo apt-get install -y git
else
  echo "Git is already installed."
fi

if ! command -v zsh >/dev/null 2>&1; then
  echo "Zsh not found; installing Zsh..."
  sudo apt-get update && sudo apt-get install -y zsh
else
  echo "Zsh is already installed."
fi

# -- Clone Prezto if not already present --
if [ ! -d "$HOME/.zprezto" ]; then
  echo "Cloning Prezto..."
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
else
  echo "Prezto is already cloned."
fi

# -- Create symlinks for Prezto runcom files --
echo "Creating symlinks for zsh configuration files..."
for rcfile in zlogin zlogout zprofile zshenv zshrc; do
  SRC="$HOME/.zprezto/runcoms/$rcfile"
  DEST="$HOME/.$rcfile"
  if [ -e "$DEST" ] && [ "$(readlink "$DEST")" != "$SRC" ]; then
    echo "Backing up existing $DEST..."
    mv "$DEST" "${DEST}.bak"
  fi
  ln -sf "$SRC" "$DEST"
done

# -- Write out your custom .zpreztorc --
echo "Installing custom .zpreztorc..."
cat > "$HOME/.zpreztorc" << 'EOF'
#
# Sets Prezto options.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# General
#
zstyle ':prezto:*:*' color 'yes'

# Set the Prezto modules to load (order matters)
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'syntax-highlighting' \
  'history' \
  'history-substring-search' \
  'autosuggestions' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'prompt' \
  'git' \
  'spectrum' \
  'docker'  \
  'ssh'

#
# Editor
#
zstyle ':prezto:module:editor' key-bindings 'emacs'

#
# Prompt
#
zstyle ':prezto:module:prompt' theme 'steeef'

#
# Python
#
zstyle ':prezto:module:python:virtualenv' auto-switch 'yes'

#
# SSH
#
zstyle ':prezto:module:ssh:load' identities 'id_rsa' 'id_rsa_puppet' 'id_rsa_itadmin'

#
# Syntax Highlighting
#
zstyle ':prezto:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'line' \
  'cursor' \
  'root'

zstyle ':prezto:module:syntax-highlighting' pattern \
  'rm*-rf*' 'fg=white,bold,bg=red'

#
# Terminal
#
zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'
zstyle ':prezto:module:terminal:tab-title' format '%m: %s'
EOF

# -- Create the installation flag file so we don't reinstall each session --
touch "$FLAG_FILE"
echo "Oh My Zsh (with Prezto) has been installed successfully."
echo "Your .zshrc now simply sources Prezto. (To see your new setup, open a new terminal.)"
echo "If needed, change your default shell with: chsh -s $(which zsh)"
