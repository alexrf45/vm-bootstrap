#!/bin/bash

echo -e "Installing base packages..."

sudo cp pacman.conf /etc/pacman.conf

sleep 5

sudo pacman -S lightdm lightdm-gtk-greeter \
	lxappearance-gtk3 i3-wm i3blocks \
	i3lock i3status dmenu feh man-pages \
	man-db flameshot gtk-theme-elementary \
	gtkmm3 arc-gtk-theme network-manager-applet \
	networkmanager-openvpn openvpn open-vm-tools \
	papirus-icon-theme picom rofi xterm xsel \
	speech-dispatcher base-devel nvidia nvidia-utils \
	intel-media-driver gvfs pass pipewire-pulse \
	pacman-contrib ttf-jetbrains-mono-nerd \
	ttf-firacode-nerd \
	ttf-nerd-fonts-symbols-common noto-fonts-emoji

sudo pacman -S \
	dust direnv fzf just lazygit links rsync \
	tealdeer upx watchexec wget tmux tmuxp \
	unzip gzip p7zip lolcat btop cowsay \
	figlet rng-tools dust exa miniserve

sudo pacman -S aws-vault docker \
	docker-compose docker-buildx jq kubectl \
	k9s neovim npm obsidian \
	proxychains-ng pulumi python python-pip \
	python-requests python-virtualenv \
	python-pipx remmina terminator \
	terraform wireshark-qt

mkdir -p $HOME/.local/bin

# echo ".cfg" >>~/.gitignore
#
# git clone --bare https://github.com/alexrf45/dotfiles.git $HOME/.cfg
#
# alias sec='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
#
# git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no
#
# git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
#
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

install_go() {
	wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz &&
		rm -rf /usr/local/go &&
		tar -C $HOME/.local/bin -xzf go1.21.5.linux-amd64.tar.gz &&
		rm go1.21.5.linux-amd64.tar.gz
}

aws-install

install_go

sudo systemctl start vmtoolsd.service vmware-vmblock-fuse.service &&
	sudo systemctl enable vmtoolsd.service vmware-vmblock-fuse.service

sudo systemctl start docker && sudo systemctl enable docker

cp -r .config/i3blocks ~/.config/ && chmod +x ~/.config/i3blocks/*

sudo cp lightdm-gtk-greeter-2.conf /etc/lightdm/lightdm-gtk-greeter.conf

sudo cp nice.jpg /usr/share/pixmaps/.

cp -r .config/i3 $HOME/.config/.

mkdir -p $HOME/.config/pictures

cp nice.jpg $HOME/.config/pictures/.

mkdir -p $HOME/.config/terminator/plugins

wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

cd $HOME && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si && sudo rm -r $HOME/yay-git

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

#mv ~/.config/nvim ~/.config/nvim.bak

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

yay -S rate-mirrors

yay -S terraform-ls

yay -S brave-bin

sudo systemctl enable lightdm && sudo systemctl start lightdm
