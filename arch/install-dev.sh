#!/bin/bash

echo -e "Installing base packages..."

sudo pacman -S lightdm lightdm-gtk-greeter \
	lxappearance-gtk3 i3-wm i3blocks i3lock i3status dmenu \
	feh man-pages man-db flameshot gtk-theme-elementary \
	gtkmm3 arc-gtk-theme network-manager-applet \
	networkmanager-qt networkmanager-openvpn openvpn open-vm-tools \
	papirus-icon-theme picom rofi xterm xsel \
	speech-dispatcher base-devel intel-media-driver gvfs \
	pass pipewire-pulse pacman-contrib \
	tmux tmuxp terminator zsh lazygit lsd neovim \
	watchexec just direnv vim gzip btop unzip sysstat wget cowsay \
	rsync lolcat figlet links fzf rng-tools jq yq remmina p7zip \
	proxychains-ng upx tealdeer docker docker-compose \
	docker-buildx python python-pip python-virtualenv python-requests \
	aws-vault wireshark-qt npm terraform pulumi kubectl k9s obsidian \
	ttf-firacode-nerd ttf-nerd-fonts-symbols-common noto-fonts-emoji

mkdir -p $HOME/.local/bin

zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

echo ".cfg" >>~/.gitignore

git clone --bare https://github.com/alexrf45/dotfiles.git $HOME/.cfg

alias sec='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no

git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

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

sudo systemctl start vmtoolsd.service vmware-vmblock-fuse.service &&
	sudo systemctl enable vmtoolsd.service vmware-vmblock-fuse.service

sudo systemctl start docker && sudo systemctl enable docker

cp -r .config/i3blocks ~/.config/ && chmod +x ~/.config/i3blocks/*

sudo cp lightdm-gtk-greeter.conf /etc/lightdm/.

sudo cp .config/pastel-window.jpg /usr/share/pixmaps/.

mkdir -p $HOME/.config/terminator/plugins

wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

cp .config/terminator/config ~/.config/terminator/.

cd $HOME && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si && sudo rm -r $HOME/yay-git

cd $HOME

wget https://releases.hashicorp.com/terraform-ls/0.32.2/terraform-ls_0.32.2_linux_amd64.zip \
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

mkdir ~/.logs

mkdir ~/projects &&
	cd projects &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/bloodhound-dev.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

sudo usermod -aG docker $USER

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

curl -sS https://starship.rs/install.sh | sh

chsh $USER -s /usr/bin/zsh

sudo systemctl enable lightdm && sudo systemctl start lightdm
