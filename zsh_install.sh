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

# Create symlinks for Prezto runcom files
echo "Creating symlinks for zsh configuration files..."
for rcfile in zlogin zlogout zprofile zshenv zshrc; do
  create_link "$HOME/.zprezto/runcoms/$rcfile" "$HOME/.$rcfile"
done

# Overwrite .zpreztorc with a safe configuration file
echo "Installing safe .zpreztorc configuration..."
cat > "$HOME/.zpreztorc" << 'EOF'
# ~/.zpreztorc - Prezto configuration file

# Prevent re-loading if already sourced
if [[ -n "$OH_MY_ZSH_LOADED" ]]; then
  return
fi
export OH_MY_ZSH_LOADED=1

# Set the location of the Prezto installation
export ZPREZTODIR="$HOME/.zprezto"

# Source Prezto if available
if [ -s "$ZPREZTODIR/init.zsh" ]; then
  source "$ZPREZTODIR/init.zsh"
else
  echo "Prezto not found in $ZPREZTODIR" >&2
fi
EOF

# Prompt (interactively) to change the default shell to zsh
if [ "$(ps -p $$ -o comm=)" = "zsh" ]; then
  echo "Already running in zsh."
else
  if [ -t 0 ]; then
    read -p "Do you want to change your default shell to zsh? [Y/n] " response
    response=${response:-Y}
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "Changing the default shell to zsh..."
      if chsh -s "$(which zsh)"; then
        echo "Default shell changed to zsh. Please log out and log back in for the change to take effect."
      else
        echo "chsh command failed. You might need to change your shell manually."
      fi
    else
      echo "Skipping default shell change. You can run 'chsh -s $(which zsh)' later if desired."
    fi
  else
    echo "Non-interactive shell detected; skipping default shell change. Run 'chsh -s $(which zsh)' manually when ready."
  fi
fi

echo "Prezto has been installed successfully!"
echo "You may need to restart your terminal or log out and log back in to see the changes."

# Create a flag file to indicate setup completion
touch "$FLAG_FILE"
