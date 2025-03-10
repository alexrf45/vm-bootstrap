#!/bin/bash
# install script for debian

set -e

sudo apt update && sudo apt install -y \
  i3 i3blocks i3status feh flameshot picom rofi pass wget curl git \
  arc-theme lxappearance python3-pip papirus-icon-theme lightdm terminator tmux cmake \
  pkg-config libfontconfig1-dev linux-headers-amd64 unzip

mkdir $HOME/.ssh

#ssh-keygen -t ed25519 -N '' -C "fr3d" -f $HOME/.ssh/fr3d

#eval "$(ssh-agent -s)"

#ssh-add ~/.ssh/fr3d

mkdir -p $HOME/.local/bin

mkdir -p $HOME/.logs

mkdir $HOME/.npm-global

mkdir -p ~/.local/share/fonts/

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Iosevka.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/NerdFontsSymbolsOnly.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip

unzip Iosevka.zip -d ~/.local/share/fonts/
unzip RobotoMono.zip -d ~/.local/share/fonts/
unzip NerdFontsSymbolsOnly -d ~/.local/share/fonts/
unzip JetBrainsMono.zip -d ~/.local/share/fonts/

fc-cache -fv

curl -fsSL https://get.docker.com -o get-docker.sh &&
  sh get-docker.sh

sudo usermod -aG docker $USER

aws-install() {
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -r aws/
  rm awscliv2.zip
}

aws_install

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage && mv nvim.appimage $HOME/.local/bin/nvim

wget https://releases.hashicorp.com/terraform-ls/0.32.7/terraform-ls_0.32.7_linux_amd64.zip \
  -O terraform-ls.zip && unzip terraform-ls.zip && chmod +x terraform-ls &&
  mv terraform-ls ~/.local/bin/. && rm terraform-ls.zip

git clone https://github.com/LazyVim/starter $HOME/.config/nvim

rm -rf $HOME/.config/nvim/.git

mkdir -p $HOME/.config/terminator/plugins

wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

. ~/.bashrc

npm config set prefix '~/.npm-global'

wget https://github.com/99designs/aws-vault/releases/download/v7.2.0/aws-vault-linux-amd64 -q -O $HOME/.local/bin/aws-vault && chmod +x $HOME/.local/bin/aws-vault

mkdir -p $HOME/projects

mkdir ~/tools &&
  cd tools &&
  #wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt &&
  git clone https://github.com/alexrf45/reverse-ssh.git &&
  git clone https://github.com/alexrf45/bloodhound-dev.git &&
  git clone https://github.com/alexrf45/Prox-Tor.git

sudo usermod -aG docker $USER

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

cp images/space.jpg $HOME/.config/pictures/space.jpg

sudo cp images/space.jpg /usr/share/pixmaps/space.jpg

sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

# has umet dependencies
#wget "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/obsidian_1.5.3_amd64.deb" -O obsidian.deb &&
#	sudo dpkg -i obsidian.deb
