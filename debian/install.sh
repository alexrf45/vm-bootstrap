#!/bin/bash
#

sudo apt update && sudo apt install -y \
	i3 i3blocks i3status feh flameshot picom rofi pass wget curl git ranger \
	arc-theme lxappearance python3-pip papirus-icon-theme alacritty

mkdir -p ~/.local/share/fonts/

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Iosevka.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/NerdFontsSymbolsOnly.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/UbuntuMono.zip

unzip Iosevka.zip -d ~/.local/share/fonts/
unzip RobotoMono.zip -d ~/.local/share/fonts/
unzip NerdFontsSymbolsOnly -d ~/.local/share/fonts/
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
unzip UbuntuMono.zip -d ~/.local/share/fonts/

fc-cache -fv

curl -fsSL https://get.docker.com -o get-docker.sh &&
	sh get-docker.sh

sudo usermod -aG docker $USER

wget "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/obsidian_1.5.3_amd64.deb -O obsidian.deb" &&
	sudo dpkg -i obsidian.deb

wget "https://github.com/Alex313031/thorium/releases/download/M120.0.6099.235/thorium-browser_120.0.6099.235_amd64.deb" -O thorium.deb &&
	sudo dpkg -i thorium.deb

wget "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz" -O nvim.tar.gz &&
	gunzip nvim.tar.gz && tar -xf nvim.tar && mv nvim-linux64 $HOME/.local/bin/. && chmod +x $HOME/.local/bin/nvim-linux64/bin/nvim

git clone https://github.com/LazyVim/starter $HOME/.config/nvim

rm -rf $HOME/.config/nvim/.git

#terraform via docker?
#
# kubectl via docker too
#docker run --rm --name kubectl -v /path/to/your/kube/config:/.kube/config bitnami/kubectl:latest
#
#
#
cp images/space.jpg $HOME/.config/pictures/space.jpg

sudo cp images/space.jpg /usr/share/pixmaps/space.jpg

sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
