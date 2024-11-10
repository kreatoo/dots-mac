# Dotfiles for macOS
This repository contains my dotfiles for macOS. It includes configurations for my shell, editor, and other tools I use on a daily basis. It is managed using nix-darwin and home-manager. It is the configuration for my MacBook Pro.


## Installation
* First, install Nix by using the instructions at [nix.dev](https://nix.dev)
* Clone this repository to ~/.config/nix-darwin
* Cd into the directory and run `nix run nix-darwin -- switch --flake .#akiri`
