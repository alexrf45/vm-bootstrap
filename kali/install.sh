#!/bin/bash

sudo apt-get update && sudo apt upgrade -y

echo -e "Installing base packages..."

sudo apt-get install -y docker.io curl tmux tmuxp pass \
	flameshot feh i3 i3-wm i3blocks i3status i3lock-fancy arc-theme \
	jq terminator zsh nano remmina rsync lxappearance fonts-noto-mono fonts-noto-color-emoji \
	cowsay btop curl fzf rofi rng-tools-debian xpdf papirus-icon-theme \
	imagemagick libxcb-shape0-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
	xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev \
	libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev \
	libxcb-xrm0 libxcb-xrm-dev autoconf meson libxcb-render-util0-dev libxcb-shape0-dev libxcb-xfixes0-dev

sudo systemctl enable docker --now

sudo usermod -aG docker $USER

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

mkdir -p ~/.local/share/fonts/

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip

unzip Iosevka.zip -d ~/.local/share/fonts/
unzip RobotoMono.zip -d ~/.local/share/fonts/
unzip FiraCode.zip -d ~/.local/share/fonts/

fc-cache -fv

mkdir -p $HOME/.config/terminator/plugins

wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

wget https://releases.hashicorp.com/terraform-ls/0.32.2/terraform-ls_0.32.2_linux_amd64.zip \
	-O terraform-ls.zip && unzip terraform-ls.zip && chmod +x terraform-ls &&
	mv terraform-ls $HOME/.local/bin/. && rm terraform-ls.zip

wget https://github.com/docker/docker-credential-helpers/releases/download/v0.8.0/docker-credential-pass-v0.8.0.linux-amd64 &&
	mv docker-credential-pass-v0.8.0.linux-amd64 docker-credential-pass &&
	chmod a+x docker-credential-pass &&
	sudo mv docker-credential-pass /usr/local/bin

mkdir $HOME/.docker

echo '{"experimental":"enabled"}' >$HOME/.docker/config.json

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

chmod u+x nvim.appimage && mv nvim.appimage $HOME/.local/nvim

#mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/LazyVim/starter $HOME/.config/nvim

rm -rf $HOME/.config/nvim/.git

mkdir -p $HOME/.logs

mkdir -p $HOME/projects

mkdir -p $HOME/tools &&
	cd $HOME/tools &&
	wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/bloodhound-dev.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo ".cfg" >>~/.gitignore

git clone --bare https://github.com/alexrf45/debian-dotfiles.git $HOME/.cfg

alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no

git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip -O terraform.zip &&
	unzip terraform.zip && chmod +x terraform && mv terraform $HOME/.local/bin/terraform

sudo apt-get update -y

base() {
	sudo apt-get install -y wget curl man git zsh \
		tmux ruby ruby-dev vim nano p7zip-full kali-themes \
		djvulibre-bin python3-pip python3-virtualenv libpcap-dev jq \
		firefox-esr xpdf tmuxp man-db exploitdb
}

# network() {
# 	sudo apt-get install -y netcat-traditional socat rlwrap nmap \
# 		netdiscover masscan dnsutils onesixtyone braa tcpdump \
# 		ftp telnet swaks snmpcheck snmpcheck snmp-mibs-downloader \
# 		iputils-ping iproute2 proxychains sendmail ltrace
# }
#
# active_directory_1() {
# 	sudo apt-get install -y \
# 		smbclient smbmap evil-winrm bloodhound responder \
# 		powershell ldap-utils
# }

base
network
active_directory_1

# web() {
# 	sudo apt-get install -y whatweb ffuf sqlmap \
# 		exiftool default-mysql-client hurl postgresql arjun \
# 		burpsuite
# }
#
# password() {
# 	sudo apt-get install -y seclists crunch
# }

install_go() {
	wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz &&
		rm -rf /usr/local/go &&
		sudo tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz &&
		rm go1.21.1.linux-amd64.tar.gz
}

#make sure dependency for go works
install_go

# httpx_install() {
# 	wget -q https://github.com/projectdiscovery/httpx/releases/download/v1.3.5/httpx_1.3.5_linux_amd64.zip &&
# 		unzip httpx_1.3.5_linux_amd64.zip -d ./httpx &&
# 		rm httpx_1.3.5_linux_amd64.zip &&
# 		mv httpx/httpx /home/kali/.local/http-x &&
# 		rm -r httpx/
#
# }

# payload() {
# 	cd $HOME/tools/ &&
# 		wget -q -O nc.exe \
# 			"https://github.com/ShutdownRepo/Exegol-resources/raw/main/windows/nc.exe" &&
# 		wget -q -O nc \
# 			"https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/ncat"
# }
#
# active_directory() {
# 	cd $HOME/tools/ &&
# 		wget -q -O rubeus.exe \
# 			"https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Rubeus.exe" &&
# 		wget -q -O certify.exe \
# 			"https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Certify.exe" &&
# 		wget -q -O cme.zip \
# 			"https://github.com/Porchetta-Industries/CrackMapExec/releases/download/v5.4.0/cme-ubuntu-latest-3.11.zip" &&
# 		unzip cme.zip && chmod +x cme && sudo mv cme /home/kali/.local/cme && rm cme.zip &&
# 		wget "https://github.com/fortra/impacket/releases/download/impacket_0_11_0/impacket-0.11.0.tar.gz" &&
# 		gunzip impacket-0.11.0.tar.gz && tar -xvf impacket-0.11.0.tar &&
# 		mv impacket-0.11.0/ /home/kali/.local/ && rm impacket-0.11.0.tar &&
# 		wget -q -O sharp.ps1 \
# 			"https://github.com/BloodHoundAD/BloodHound/raw/master/Collectors/SharpHound.ps1" &&
# 		wget -q -O SharpHound.exe \
# 			"https://raw.githubusercontent.com/BloodHoundAD/BloodHound/master/Collectors/SharpHound.exe"
# }
#
# pivot() {
# 	cd $HOME/tools/ &&
# 		wget -q -O chisel.gz \
# 			"https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz" &&
# 		gunzip chisel.gz &&
# 		wget -q -O win-chisel.gz \
# 			"https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_windows_amd64.gz" &&
# 		gunzip win-chisel.gz
# }
#
# privesc() {
# 	cd $HOME/tools/ &&
# 		wget -q -O linpeas.sh \
# 			"https://github.com/carlospolop/PEASS-ng/releases/download/20230910-ae32193f/linpeas_linux_amd64" &&
# 		wget -q -O winpeas.exe \
# 			"https://github.com/carlospolop/PEASS-ng/releases/download/20230910-ae32193f/winPEASany.exe" &&
# 		wget -q -O pspys \
# 			"https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64s" &&
# 		wget -q -O pspy \
# 			"https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64"
# }
#
# echo -e "Installing tools..."
# web
# password
# payload
# active_directory
# pivot
# privesc
# httpx_install
#
# httprobe_install() {
# 	wget -q https://github.com/tomnomnom/httprobe/releases/download/v0.2/httprobe-linux-amd64-0.2.tgz -O httprobe.tgz &&
# 		tar -xzf httprobe.tgz && chmod +x httprobe && mv httprobe $HOME/.local/httprobe && rm httprobe.tgz
# }
#
# go-dorks_install() {
# 	wget -q https://github.com/dwisiswant0/go-dork/releases/download/v1.0.2/go-dork_1.0.2_linux_amd64 -O go-dork &&
# 		mv go-dork $HOME/.local/go-dork &&
# 		chmod +x $HOME/.local/go-dork
# }
#
# rush_install() {
# 	wget https://github.com/shenwei356/rush/releases/download/v0.5.2/rush_linux_amd64.tar.gz -O rush.tar.gz &&
# 		gunzip rush.tar.gz && tar -xf rush.tar && rm rush.tar && mv rush $HOME/.local/rush && chmod +x $HOME/.local/rush
# }
#
# katana_install() {
# 	wget https://github.com/projectdiscovery/katana/releases/download/v1.0.3/katana_1.0.3_linux_amd64.zip -O katana.zip &&
# 		unzip katana.zip && chmod +x katana && mv katana $HOME/.local/. && rm katana.zip
# }
#
# chaos_install() {
# 	wget https://github.com/projectdiscovery/chaos-client/releases/download/v0.5.1/chaos-client_0.5.1_linux_amd64.zip \
# 		-O chaos.zip && unzip chaos.zip chaos-client && chmod +x chaos-client && mv chaos-client $HOME/.local/chaos &&
# 		rm chaos.zip
# }
#
# dnsx_install() {
# 	wget https://github.com/projectdiscovery/dnsx/releases/download/v1.1.4/dnsx_1.1.4_linux_amd64.zip -O dnsx.zip &&
# 		unzip dnsx.zip dnsx && chmod +x dnsx && mv dnsx $HOME/.local/dnsx && rm dnsx.zip
# }
#
# waybackurls_install() {
# 	wget -q -O waybackurls.tgz https://github.com/tomnomnom/waybackurls/releases/download/v0.1.0/waybackurls-linux-amd64-0.1.0.tgz &&
# 		gunzip waybackurls.tgz &&
# 		tar -C $HOME/.local -xf waybackurls.tar &&
# 		chmod +x $HOME/.local/waybackurls &&
# 		rm $HOME/waybackurls.tar
# }
#
# unfurl_install() {
# 	wget https://github.com/tomnomnom/unfurl/releases/download/v0.4.3/unfurl-linux-amd64-0.4.3.tgz \
# 		-O unfurl.tgz && tar -xzf unfurl.tgz && mv unfurl $HOME/.local/unfurl && rm unfurl.tgz
# }
#
# subfinder_install() {
# 	wget https://github.com/projectdiscovery/subfinder/releases/download/v2.6.3/subfinder_2.6.3_linux_amd64.zip \
# 		-O subfinder.zip && unzip subfinder.zip && chmod +x subfinder && mv subfinder $HOME/.local/subfinder && rm subfinder.zip
# }
#
# notify_install() {
# 	wget https://github.com/projectdiscovery/notify/releases/download/v1.0.5/notify_1.0.5_linux_amd64.zip \
# 		-O notify.zip && unzip -o notify && mv notify $HOME/.local/notify && rm notify.zip && rm LICENSE.md README.md
# }
#
# sudo apt-get install amass -y
#
# httprobe_install
# go-dorks_install
# rush_install
# katana_install
# chaos_install
# dnsx_install
# waybackurls_install
# unfurl_install
# subfinder_install
# notify_install
