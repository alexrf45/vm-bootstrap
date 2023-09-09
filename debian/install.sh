#!/bin/bash

sudo usermod -aG sudo f0nzy

su f0nzy

sudo apt-get update -y

echo -e "Installing base packages..."

sudo apt-get install -y tmux tmuxp pass \
	flameshot feh i3 i3blocks i3status i3lock-fancy \
	jq terminator zsh nano remmina proxychains rsync
