#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

FLAG_FILE="$HOME/.setup_completed_flag"

# Check if the setup has already been completed
if [ -f "$FLAG_FILE" ]; then
  echo "Setup already completed, skipping..."
  exit 0
fi

# Install Git and Zsh if they are not already installed
echo "Checking for Git and Zsh..."

if ! command -v git &> /dev/null; then
  echo "Git not found, installing Git..."
  sudo apt-get update
  sudo apt-get install -y git
else
  echo "Git is already installed."
fi

if ! command -v zsh &> /dev/null; then
  echo "Zsh not found, installing Zsh..."
  sudo apt-get update
  sudo apt-get install -y zsh
else
  echo "Zsh is already installed."
fi

# Clone Prezto if it hasn't been cloned yet
if [ ! -d "$HOME/.zprezto" ]; then
  echo "Cloning Prezto..."
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
else
  echo "Prezto is already cloned."
fi

# Function to create symbolic links safely (idempotent version)
create_link() {
  local src="$1"
  local dest="$2"
  [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ] && { echo "Link $dest exists and is correct, skipping."; return; }
  [ -e "$dest" ] && { echo "Backing up existing $dest..."; mv "$dest" "${dest}.bak"; }
  ln -s "$src" "$dest"
}

# Create symlinks for runcom files
echo "Creating symlinks for zsh configuration files..."
for rcfile in zlogin zlogout zprofile zshenv zshrc; do
  create_link "$HOME/.zprezto/runcoms/$rcfile" "$HOME/.$rcfile"
done

# Fetch the updated .zpreztorc from GitHub
echo "Fetching updated .zpreztorc from GitHub..."
updated_zpreztorc_url="https://raw.githubusercontent.com/NetworkBuild3r/oh_my_zsh/main/.zpreztorc"
local_zpreztorc="$HOME/.zpreztorc"

if [ -f "$local_zpreztorc" ]; then
  if ! curl -fsSL "$updated_zpreztorc_url" | cmp -s - "$local_zpreztorc"; then
    echo "Updating .zpreztorc..."
    mv "$local_zpreztorc" "$local_zpreztorc.bak"
    curl -fsSL "$updated_zpreztorc_url" -o "$local_zpreztorc"
  else
    echo ".zpreztorc is up to date."
  fi
else
  echo "Downloading .zpreztorc..."
  curl -fsSL "$updated_zpreztorc_url" -o "$local_zpreztorc"
fi

# Improved shell check using the active process name
[ "$(ps -p $$ -o comm=)" = "zsh" ] && echo "Already running in zsh." || {
  echo "Changing the default shell to zsh..."
  chsh -s "$(which zsh)"
  echo "Default shell changed to zsh. Please log out and log back in for the change to take effect."
}

echo "Prezto has been installed successfully!"
echo "You may need to restart your terminal or log out and log back in to see the changes."

# Create a flag file to indicate setup completion
touch "$FLAG_FILE"
