# oh_my_zsh installation script

This script installs oh-my-zsh with the Prezto theme and additional plugins on Ubuntu.

## Installation

To install oh-my-zsh, run the following command in your terminal:

curl https://raw.githubusercontent.com/NetworkBuild3r/oh_my_zsh/main/zsh_install.sh | bash


The script will prompt you for your sudo password to install Git and Zsh, clone the Prezto theme, and update your zsh configuration.

Once the installation is complete, the script will automatically source your updated `~/.zshrc` file so you can start using oh-my-zsh right away.

## Customization

You can customize your oh-my-zsh configuration by editing the `~/.zpreztorc` file. The installation script includes a custom `zpreztorc` file that adds a few aliases and environment variables, but you can modify it to suit your needs.

You can also add or remove plugins by editing the `plugins` array in the `~/.zshrc` file. The installation script includes the `git` and `python` plugins by default, but you can add other plugins from the [oh-my-zsh repository](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins) or create your own custom plugins.

## Uninstallation

To uninstall oh-my-zsh and restore your original zsh configuration, run the following command in your terminal:

curl https://raw.githubusercontent.com/NetworkBuild3r/oh_my_zsh/main/zsh_uninstall.sh | bash


The script will prompt you for your sudo password to remove the `~/.zprezto` directory and restore your original `~/.zshrc` file.
