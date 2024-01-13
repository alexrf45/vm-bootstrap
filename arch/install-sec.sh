#!/bin/bash

echo -e "Installing base packages..."

sudo pacman -S lightdm lightdm-gtk-greeter \
	lxappearance-gtk3 i3-wm i3blocks \
	i3lock i3status dmenu feh man-pages \
	man-db flameshot gtk-theme-elementary \
	gtkmm3 arc-gtk-theme network-manager-applet \
	networkmanager-openvpn openvpn open-vm-tools \
	papirus-icon-theme picom rofi \
	thunar xterm xsel gvfs speech-dispatcher \
	base-devel intel-media-driver pass \
	pipewire-pulse pacman-contrib \
	ttf-jetbrains-mono-nerd \
	ttf-nerd-fonts-symbols-common ttf-iosevka-nerd \
	noto-fonts-emoji ttf-ubuntu-mono-nerd ttf-ubuntu-font-family

sudo pacman -S \
	zsh lazygit z just vim direnv just \
	gzip btop unzip wget cowsay \
	rsync lolcat figlet fzf \
	rng-tools jq nano neofetch p7zip \
	tealdeer upx watchexec tmux tmuxp

sudo pacman -S \
	terminator code \
	docker docker-compose docker-buildx \
	python python-pip \
	python-pipx python-virtualenv \
	python-requests aws-vault npm terraform pulumi \
	kubectl k9s obsidian

sudo pacman -S \
	nmap wireshark-qt remmina proxychains-ng cifs-utils

mkdir -p $HOME/.local/bin

echo ".cfg" >>~/.gitignore

git clone --bare https://github.com/alexrf45/security_dot_files.git $HOME/.cfg

alias sec='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no

git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

curl \
	-sL --create-dirs \
	https://git.sr.ht/~yerinalexey/miniplug/blob/master/miniplug.zsh \
	-o $HOME/.zsh/plugins/miniplug.zsh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir $HOME/.ssh

ssh-keygen -t ed25519 -N '' -C "f0nzy" -f $HOME/.ssh/f0nzy

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/f0nzy

aws-install() {
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	rm -r aws/
	rm awscliv2.zip
}

aws-install

mkdir -p $HOME/.config/rofi

wget https://github.com/w8ste/Tokyonight-rofi-theme/raw/main/tokyonight.rasi -O $HOME/.config/rofi/tokyonight.rasi

sudo systemctl start vmtoolsd.service vmware-vmblock-fuse.service &&
	sudo systemctl enable vmtoolsd.service vmware-vmblock-fuse.service

sudo systemctl start docker && sudo systemctl enable docker

cp -r .config/i3blocks ~/.config/ && chmod +x ~/.config/i3blocks/*

sudo cp lightdm-gtk-greeter.conf /etc/lightdm/.

sudo cp images/black-kali.jpg /usr/share/pixmaps/.

sudo cp proxychains.conf /etc/proxychains.conf

mkdir -p $HOME/.config/terminator/plugins

wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

sudo cp pacman.conf /etc/pacman.conf

curl -O https://blackarch.org/strap.sh

echo 3f121404fd02216a053f7394b8dab67f105228e3 strap.sh | sha1sum -c

chmod +x strap.sh

sudo ./strap.sh

sudo pacman -Syyu

cd $HOME && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si && sudo rm -r yay-git

cd $HOME

wget https://releases.hashicorp.com/terraform-ls/0.32.4/terraform-ls_0.32.4_linux_amd64.zip \
	-O terraform-ls.zip && unzip terraform-ls.zip && chmod +x terraform-ls &&
	mv terraform-ls ~/.local/bin/. && rm terraform-ls.zip

wget https://github.com/docker/docker-credential-helpers/releases/download/v0.8.0/docker-credential-pass-v0.8.0.linux-amd64 &&
	mv docker-credential-pass-v0.8.0.linux-amd64 docker-credential-pass &&
	chmod a+x docker-credential-pass &&
	sudo mv docker-credential-pass /usr/local/bin

mkdir ~/.docker

echo '{"experimental":"enabled"}' >.docker/config.json

mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

mkdir -p $HOME/.logs

mkdir -p $HOME/projects

mkdir ~/tools &&
	cd tools &&
	wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/bloodhound-dev.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

sudo usermod -aG docker $USER

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

yay -S burpsuite

yay -S brave-bin

yay -S rate-mirrors

yay -S kpcli

chsh $USER -s /usr/bin/zsh

sudo systemctl enable lightdm && sudo systemctl start lightdm
