#!/bin/bash

# Install Git and Zsh
sudo apt-get update && sudo apt-get install -y git zsh

# Clone Prezto if ~/.zprezto doesn't exist
if [ ! -d ~/.zprezto ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
fi

# Backup and link zsh config files
link_file() {
    file=$1
    if [ -e ~/$file ]; then
        if [ ! -L ~/$file ]; then
            mv ~/$file ~/$file.backup
        else
            unlink ~/$file
        fi
    fi
    ln -s ~/.zprezto/runcoms/$file ~/$file
}

# Link zsh config files
link_file zlogin
link_file zlogout
link_file zpreztorc
link_file zprofile
link_file zshenv
link_file zshrc

# Update zpreztorc with custom configuration
curl -o ~/.zprezto/runcoms/zpreztorc https://raw.githubusercontent.com/Dan70402/zprezto/master/.zpreztorc

# Update source line in ~/.zshrc to source the new zpreztorc file
sed -i 's/source $ZPREZTODIR\/runcoms\/zpreztorc/source ~\/.zprezto\/runcoms\/zpreztorc/g' ~/.zshrc

# Source the updated .zshrc file
source ~/.zshrc
