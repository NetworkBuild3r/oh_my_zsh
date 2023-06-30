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

# Remove existing .zpreztorc from Prezto repository if it doesn't match the updated one
prezto_zpreztorc_path=~/.zprezto/runcoms/zpreztorc
updated_zpreztorc_url="https://raw.githubusercontent.com/NetworkBuild3r/oh_my_zsh/main/.zpreztorc"
if [ -e $prezto_zpreztorc_path ]; then
    if ! cmp -s $prezto_zpreztorc_path <(curl -fsSL $updated_zpreztorc_url); then
        echo "Removing existing .zpreztorc..."
        rm $prezto_zpreztorc_path || { echo "Failed to remove existing .zpreztorc file. Please check your file permissions and try again." >&2; exit 1; }
    fi
fi

# Create links to zsh config files
echo "Creating links to zsh config files..."
create_link() {
    local src=$1 dest=$2
    if [ -e $dest ] && [ ! -L $dest ]; then
        if [ "$(readlink -f $dest)" == "$src" ]; then
            echo "Link $dest already exists, skipping."
            return
        fi
        rm $dest || { echo "Failed to remove existing $dest file. Please check your file permissions and try again." >&2; exit 1; }
    fi
    ln -s $src $dest || { echo "Failed to create link for $dest file. Please check your file permissions and try again." >&2; exit 1; }
}

create_link ~/.zprezto/runcoms/zlogin ~/.zlogin
create_link ~/.zprezto/runcoms/zlogout ~/.zlogout
create_link ~/.zprezto/runcoms/zprofile ~/.zprofile
create_link ~/.zprezto/runcoms/zshenv ~/.zshenv
create_link ~/.zprezto/runcoms/zshrc ~/.zshrc

# Fetch .zpreztorc from the GitHub repo
echo "Fetching .zpreztorc from GitHub..."
curl -fsSL $updated_zpreztorc_url -o $prezto_zpreztorc_path || { echo "Failed to fetch .zpreztorc. Please check your network connection and try again." >&2; exit 1; }
create_link $prezto_zpreztorc_path ~/.zpreztorc

# Check if already running in zsh
if [[ $SHELL == *"zsh" ]]; then
    echo "Already running in zsh."
else
    # Change the default shell to zsh
    echo "Changing the default shell to zsh..."
    chsh -s $(which zsh) || { echo "Failed to change the default shell to zsh. Please check your file permissions and try again." >&2; exit 1; }

    # Source the updated zsh configuration
    echo "Sourcing the updated zsh configuration..."
    source ~/.zshrc || { echo "Failed to source the updated zsh configuration. Please check your file permissions and try again." >&2; exit 1; }
fi

echo "oh-my-zsh with Prezto theme and plugins has been installed successfully!"
echo "You may need to restart your terminal or run 'source ~/.zshrc' to see the changes."
