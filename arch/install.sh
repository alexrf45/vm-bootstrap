#!/bin/bash

echo -e "Installing base packages..."

sleep 2

base_install() {
	sudo pacman -S lightdm lightdm-gtk-greeter xorg-xhost lxappearance-gtk3 i3-wm i3blocks \
		i3lock i3status dmenu feh man-pages man-db flameshot gtk-theme-elementary \
		gtkmm3 arc-gtk-theme network-manager-applet networkmanager-openvpn \
		openvpn open-vm-tools papirus-icon-theme picom rofi xterm xsel speech-dispatcher \
		base-devel intel-media-driver gvfs pass pulseaudia-alsa pulseaudio-equalizer pacman-contrib materia-gtk-theme \
		ttf-anonymous-pro ttf-hack ttf-nerd-fonts-symbols-common noto-fonts-emoji ttf-iosevka-nerd \
		inotify-tools notification-daemon bluez-libs bluez-utils bluez gtk-engine-murrine pinentry
}

base_2_install() {
	sudo pacman -S \
		dust fzf just lazygit links rsync tealdeer upx watchexec wget tmux tmuxp unzip \
		gzip p7zip lolcat btop cowsay figlet rng-tools miniserve bash-completion zathura zathura-pdf-poppler poppler-data \
		python-pynvim ueberzug thunar sqlitebrowser sqlite3
}

base_3_install() {

	sudo pacman -S aws-vault docker \
		docker-compose docker-buildx jq neovim npm obsidian \
		python python-pip python-requests python-virtualenv python-pipx remmina \
		terminator wireshark-qt alacritty task
}

directory_setup() {
	mkdir -p ~/.config/alacritty/themes

	mkdir -p $HOME/.local/bin

	mkdir -p $HOME/.config/pictures

	mkdir $HOME/.ssh

	mkdir $HOME/.logs

}

ssh_setup() {
	ssh-keygen -t ed25519 -N '' -C "fr3d" -f $HOME/.ssh/fr3d

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
dotfiles_install
neovim_install

sudo systemctl start vmtoolsd.service vmware-vmblock-fuse.service &&
	sudo systemctl enable vmtoolsd.service vmware-vmblock-fuse.service

sudo systemctl start docker && sudo systemctl enable docker

sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

sudo cp images/skull.jpg /usr/share/pixmaps/.

cd $HOME && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si && sudo rm -r $HOME/yay-git

paru_install() {
	git clone https://aur.archlinux.org/paru.git &&
		cd paru && makepkg -si && sudo rm -r $HOME/paru
}

paru_install

cd $HOME

mkdir ~/projects &&
	cd projects &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/Bloodhound-Docker.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

wget -q "https://raw.github.com/xwmx/nb/master/nb" -O $HOME/.local/bin/nb && chmod +x $HOME/.local/bin/nb

wget -q "https://github.com/rwxrob/pomo/releases/download/v0.2.3/pomo-linux-amd64" -O $HOME/.local/bin/pomo && chmod +x $HOME/.loca/bin/pomo

sudo usermod -aG docker $USER

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

sudo systemctl enable lightdm && sudo systemctl start lightdm
