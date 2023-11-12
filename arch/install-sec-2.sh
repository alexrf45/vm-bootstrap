#!/bin/bash

echo -e "Installing base packages..."

sudo pacman -S gdm lxappearance-gtk3 i3-wm i3blocks i3lock i3status dmenu \
	feh man-pages man-db firefox flameshot gtk-theme-elementary \
	gtkmm3 arc-gtk-theme network-manager-applet \
	networkmanager-qt networkmanager-openvpn openvpn open-vm-tools \
	papirus-icon-theme picom rofi thunar xterm xsel gvfs \
	speech-dispatcher base-devel intel-media-driver \
	pass pipewire-pulse pacman-contrib \
	tmux tmuxp terminator zsh lazygit \
	neovim gzip btop unzip sysstat wget cowsay \
	rsync lolcat figlet fzf rng-tools jq nano neofetch remmina p7zip \
	proxychains-ng upx tealdeer docker docker-compose \
	docker-buildx python python-pip python-virtualenv python-requests \
	aws-vault wireshark-qt npm terraform pulumi kubectl k9s obsidian \
	ttf-firacode-nerd ttf-nerd-fonts-symbols-common noto-fonts-emoji \
	nmap netcat tcpdump rlwrap sqlmap

#directories
mkdir $HOME/.ssh
mkdir -p $HOME/.config/terminator/plugins
mkdir -p $HOME/.config/rofi
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/tools
mkdir ~/.docker
mkdir ~/.logs
mkdir ~/projects

wget https://github.com/w8ste/Tokyonight-rofi-theme/raw/main/tokyonight.rasi -O $HOME/.config/rofi/tokyonight.rasi

wget https://github.com/alexrf45/kali-sec/raw/main/resources/tmux.conf -O $HOME/.tmux.conf

wget https://github.com/alexrf45/kali-sec/blob/main/resources/mozilla.tar.bz2 -O $HOME/mozilla.tar.bz2 &&
  tar -xvf $HOME/mozilla.tar.bz2 -C $HOME

echo ".cfg" >>~/.gitignore

git clone --bare https://github.com/alexrf45/security_dot_files.git $HOME/.cfg

alias sec='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no

git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

curl \
	-sL --create-dirs \
	https://git.sr.ht/~yerinalexey/miniplug/blob/master/miniplug.zsh \
	-o $HOME/.zsh/plugins/miniplug.zsh

ssh-keygen -t ed25519 -N '' -C "f0nzy" -f $HOME/.ssh/f0nzy
ssh-keygen -t ed25519 -N '' -C "jump" -f $HOME/.ssh/jump
ssh-keygen -t ed25519 -N '' -C "homelab" -f $HOME/.ssh/home

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/f0nzy
ssh-add ~/.ssh/jump
ssh-add ~/.ssh/home

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

wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

cp .config/terminator/config ~/.config/terminator/.

cd $HOME && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si && sudo rm -r yay-git

cd $HOME

wget https://releases.hashicorp.com/terraform-ls/0.32.2/terraform-ls_0.32.2_linux_amd64.zip \
	-O terraform-ls.zip && unzip terraform-ls.zip && chmod +x terraform-ls &&
	mv terraform-ls ~/.local/bin/. && rm terraform-ls.zip

wget https://github.com/docker/docker-credential-helpers/releases/download/v0.8.0/docker-credential-pass-v0.8.0.linux-amd64 &&
	mv docker-credential-pass-v0.8.0.linux-amd64 docker-credential-pass &&
	chmod a+x docker-credential-pass &&
	sudo mv docker-credential-pass /usr/local/bin

echo '{"experimental":"enabled"}' >.docker/config.json

mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

cd $HOME/.local/tools &&
	wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/bloodhound-dev.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

sudo usermod -aG docker $USER

#install golang
install_go() {
	wget https://go.dev/dl/go1.21.3.linux-amd64.tar.gz &&
		rm -rf /usr/local/go &&
		tar -C $HOME/.local/bin -xzf go1.21.3.linux-amd64.tar.gz &&
		rm go1.21.3.linux-amd64.tar.gz
}

install_go

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

curl -sS https://starship.rs/install.sh | sh

yay -s burpsuite

yay -s ffuf

yay -s smbmap

yay -s evil-winrm

yay -s bloodhound

yay -s responder

yay -s crackmapexec

yay -s powershell

snyk-cli() {
	curl --compressed https://static.snyk.io/cli/latest/snyk-linux -o snyk &&
		chmod +x ./snyk && mv ./snyk $HOME/.local/bin
}

payload() {
	cd $HOME/.local/tools/ &&
		}

tools_install() {
	cd $HOME/.local/tools/ &&
		wget -q -O nc.exe \
			"https://github.com/ShutdownRepo/Exegol-resources/raw/main/windows/nc.exe" &&
		wget -q -O nc \
			"https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/ncat" &&
    wget -q -O rubeus.exe \
			"https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Rubeus.exe" &&
		wget -q -O certify.exe \
			"https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Certify.exe" &&
		wget "https://github.com/fortra/impacket/releases/download/impacket_0_11_0/impacket-0.11.0.tar.gz" &&
		gunzip impacket-0.11.0.tar.gz && tar -xvf impacket-0.11.0.tar &&
		mv impacket-0.11.0/ && rm impacket-0.11.0.tar &&
		wget -q -O sharp.ps1 \
			"https://github.com/BloodHoundAD/BloodHound/raw/master/Collectors/SharpHound.ps1" &&
		wget -q -O SharpHound.exe \
			"https://raw.githubusercontent.com/BloodHoundAD/BloodHound/master/Collectors/SharpHound.exe" &&
		wget -q -O netexec \
			"https://github.com/Pennyw0rth/NetExec/releases/download/v1.0.0/nxc-ubuntu-latest" &&
		chmod +x netexec && sudo mv netexec $HOME/.local/bin/netexec &&
		wget -q -O chisel.gz \
			"https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz" &&
		gunzip chisel.gz &&
		wget -q -O win-chisel.gz \
			"https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_windows_amd64.gz" &&
		gunzip win-chisel.gz &&
    wget -q -O linpeas \
			"https://github.com/carlospolop/PEASS-ng/releases/download/20231029-83b8fbe1/linpeas_linux_amd64" &&
		wget -q -O winpeas.exe \
			"https://github.com/carlospolop/PEASS-ng/releases/download/20231029-83b8fbe1/winPEASany.exe" &&
		wget -q -O pspys \
			"https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64s" &&
		wget -q -O pspy \
			"https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64"
}


snyk-cli

tools_install

sudo cp pacman.conf /etc/pacman.conf

chsh $USER -s /usr/bin/zsh

sudo systemctl enable gdm && sudo systemctl start gdm
