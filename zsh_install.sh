#!/bin/bash

# Install Git and Zsh
echo "Installing Git and Zsh..."
sudo apt-get update || { echo "Failed to update packages. Please check your network connection and try again." >&2; exit 1; }
sudo apt-get install -y git zsh || { echo "Failed to install Git and Zsh. Please check your network connection and try again." >&2; exit 1; }

# Clone Prezto if ~/.zprezto doesn't exist
if [ ! -d ~/.zprezto ]; then
    echo "Cloning Prezto..."
    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto || { echo "Failed to clone Prezto. Please check your network connection and try again." >&2; exit 1; }
fi

# Backup zsh config if it exists
if [ -f ~/.zshrc ]; then
    echo "Backing up existing ~/.zshrc file..."
    mv ~/.zshrc ~/.zshrc.backup || { echo "Failed to backup ~/.zshrc file. Please check your file permissions and try again." >&2; exit 1; }
fi

# Create links to zsh config files
echo "Creating links to zsh config files..."
ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin || { echo "Failed to create link for ~/.zlogin file. Please check your file permissions and try again." >&2; exit 1; }
ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout || { echo "Failed to create link for ~/.zlogout file. Please check your file permissions and try again." >&2; exit 1; }
ln -s ~/.zprezto/runcoms/zpreztorc ~/.zpreztorc || { echo "Failed to create link for ~/.zpreztorc file. Please check your file permissions and try again." >&2; exit 1; }
ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile || { echo "Failed to create link for ~/.zprofile file. Please check your file permissions and try again." >&2; exit 1; }
ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv || { echo "Failed to create link for ~/.zshenv file. Please check your file permissions and try again." >&2; exit 1; }
ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc || { echo "Failed to create link for ~/.zshrc file. Please check your file permissions and try again." >&2; exit 1; }

# Source the updated zsh configuration
echo "Sourcing the updated zsh configuration..."
source ~/.zshrc || { echo "Failed to source the updated zsh configuration. Please check your file permissions and try again." >&2; exit 1; }

echo "oh-my-zsh with Prezto theme and plugins has been installed successfully!"
echo "You may need to restart your terminal or run 'source ~/.zshrc' to see the changes."
