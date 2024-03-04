#!/bin/bash

echo -e "Installing base packages..."

sleep 2

base_install() {
	sudo pacman -S lightdm lightdm-gtk-greeter lxappearance-gtk3 i3-wm i3blocks \
		i3lock i3status dmenu feh man-pages man-db flameshot gtk-theme-elementary \
		gtkmm3 arc-gtk-theme network-manager-applet networkmanager-openvpn \
		openvpn open-vm-tools papirus-icon-theme picom rofi xterm xsel speech-dispatcher \
		base-devel intel-media-driver gvfs pass pipewire-pulse pacman-contrib \
		ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-nerd-fonts-symbols-common noto-fonts-emoji
}

base_2_install() {
	sudo pacman -S \
		dust direnv fzf just lazygit links rsync tealdeer upx watchexec wget tmux tmuxp unzip \
		gzip p7zip lolcat btop cowsay figlet rng-tools miniserve
}

base_3_install() {

	sudo pacman -S aws-vault docker \
		docker-compose docker-buildx jq neovim npm obsidian proxychains-ng pulumi \
		python python-pip python-requests python-virtualenv python-pipx remmina \
		terminator wireshark-qt alacritty terraform aws-cli-v2
}

directory_setup() {
	mkdir -p ~/.config/alacritty/themes

	mkdir -p $HOME/.local/bin

	mkdir -p $HOME/.config/pictures

	mkdir -p $HOME/.config/terminator/plugins

	mkdir $HOME/.ssh

	mkdir $HOME/.logs

}

ssh_setup() {
	ssh-keygen -t ed25519 -N '' -C "f0nzy" -f $HOME/.ssh/fr3d

	eval "$(ssh-agent -s)"

	ssh-add ~/.ssh/fr3d

}

dotfiles_install() {
	echo ".cfg" >>~/.gitignore

	git clone --bare https://github.com/alexrf45/dot.git $HOME/.cfg

	alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

	git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no

	git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
}

install_go() {
	wget -q https://go.dev/dl/go1.22.0.linux-amd64.tar.gz &&
		rm -rf /usr/local/go &&
		tar -C $HOME/.local/bin -xzf go1.22.0.linux-amd64.tar.gz &&
		rm go1.22.0.linux-amd64.tar.gz
}

neovim_install() {
	mv ~/.config/nvim ~/.config/nvim.bak

	git clone https://github.com/LazyVim/starter ~/.config/nvim

	rm -rf ~/.config/nvim/.git

}

base_install
base_2_install
base_3_install
directory_setup
ssh_setup
install_go
dotfiles_install
neovim_install

sudo systemctl start vmtoolsd.service vmware-vmblock-fuse.service &&
	sudo systemctl enable vmtoolsd.service vmware-vmblock-fuse.service

sudo systemctl start docker && sudo systemctl enable docker

sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

sudo cp images/gruvbear.jpeg /usr/share/pixmaps/.

wget -q https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

cd $HOME && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si && sudo rm -r $HOME/yay-git

cd $HOME

mkdir ~/projects &&
	cd projects &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/Bloodhound-Docker.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

sudo usermod -aG docker $USER

sudo systemctl enable lightdm && sudo systemctl start lightdm
