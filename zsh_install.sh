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
    timestamp=$(date '+%Y%m%d%H%M%S')
    mv ~/.zshrc ~/.zshrc.backup.$timestamp || { echo "Failed to backup ~/.zshrc file. Please check your file permissions and try again." >&2; exit 1; }
fi

# Create links to zsh config files
echo "Creating links to zsh config files..."
create_link() {
    local src=$1 dest=$2
    if [ -e $dest ]; then
        echo "Link $dest already exists, skipping."
    else
        if [ -f $dest ]; then
            timestamp=$(date '+%Y%m%d%H%M%S')
            echo "Backing up existing $dest file..."
            mv $dest $dest.backup.$timestamp || { echo "Failed to backup $dest file. Please check your file permissions and try again." >&2; exit 1; }
        fi
        ln -s $src $dest || { echo "Failed to create link for $dest file. Please check your file permissions and try again." >&2; exit 1; }
    fi
}

create_link ~/.zprezto/runcoms/zlogin ~/.zlogin
create_link ~/.zprezto/runcoms/zlogout ~/.zlogout
create_link ~/.zprezto/runcoms/zpreztorc ~/.zpreztorc
create_link ~/.zprezto/runcoms/zprofile ~/.zprofile
create_link ~/.zprezto/runcoms/zshenv ~/.zshenv
create_link ~/.zprezto/runcoms/zshrc ~/.zshrc

# Change the default shell to zsh
echo "Changing the default shell to zsh..."
chsh -s $(which zsh) || { echo "Failed to change the default shell to zsh. Please check your file permissions and try again." >&2; exit 1; }

# Source the updated zsh configuration
echo "Sourcing the updated zsh configuration..."
source ~/.zshrc || { echo "Failed to source the updated zsh configuration. Please check your file permissions and try again." >&2; exit 1; }

echo "oh-my-zsh with Prezto theme and plugins has been installed successfully!"
echo "You may need to restart your terminal or run 'source ~/.zshrc' to see the changes."
