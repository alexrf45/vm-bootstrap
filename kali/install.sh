#!/bin/bash

sudo apt-get update -y

echo -e "Installing base packages..."

sudo apt-get install -y curl tmux tmuxp pass \
	flameshot feh i3 i3blocks i3status i3lock-fancy \
	jq terminator zsh nano remmina rsync lxappearance fonts-noto-mono fonts-noto-color-emoji \
	cowsay btop curl fzf rofi rng-tools-debian xpdf papirus-icon-theme \
	imagemagick libxcb-shape0-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
	xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev \
	libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev \
	libxcb-xrm0 libxcb-xrm-dev autoconf meson libxcb-render-util0-dev libxcb-shape0-dev libxcb-xfixes0-dev

curl -fsSL https://get.docker.com -o get-docker.sh &&
	sh get-docker.sh

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

wget https://releases.hashicorp.com/terraform-ls/0.31.4/terraform-ls_0.31.4_linux_amd64.zip \
	-O $HOME/terraform-ls.zip && unzip $HOME/terraform-ls.zip && chmod +x $HOME/terraform-ls &&
	mv $HOME/terraform-ls ~/.local/bin/. && rm $HOME/terraform-ls.zip

wget https://github.com/docker/docker-credential-helpers/releases/download/v0.8.0/docker-credential-pass-v0.9.0.linux-amd64 &&
	mv docker-credential-pass-v0.8.0.linux-amd64 docker-credential-pass &&
	chmod a+x docker-credential-pass &&
	sudo mv docker-credential-pass /usr/local/bin

mkdir ~/.docker

echo '{"experimental":"enabled"}' >.docker/config.json

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

chmod u+x nvim.appimage && mv nvim.appimage ~/.local/nvim.appimage

#mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

export GOROOT=~/.local/go
export GOPATH=$HOME/.local/projects/go

chmod +x goinstall.sh && ./goinstall.sh

mkdir -p $HOME/.logs

mkdir -p $HOME/projects

mkdir -p $HOME/tools &&
	cd $HOME/tools &&
	wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/bloodhound-dev.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

sudo usermod -aG docker $USER

# TODO: set up repo for debian config
#
echo ".cfg" >>~/.gitignore

git clone --bare https://github.com/alexrf45/dotfiles.git $HOME/.cfg

alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no

git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

curl -fsSL https://get.pulumi.com | sh

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -O $HOME/terraform.zip &&
	unzip $HOME/terraform.zip && chmod +x $HOME/terraform && mv $HOME/terraform $HOME/.local/bin/terraform

#curl -SL https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

sudo apt-get update -y

base() {
	sudo apt-get install -y python3-pip python3-virtualenv libpcap-dev \
		djvulibre-bin
}

network() {
	sudo apt-get install -y netcat-traditional socat rlwrap nmap \
		netdiscover masscan dnsutils onesixtyone braa tcpdump \
		ftp telnet swaks snmpcheck snmpcheck snmp-mibs-downloader \
		iputils-ping iproute2 proxychains sendmail
}

active_directory() {
	sudo apt-get install -y \
		smbclient smbmap evil-winrm bloodhound responder \
		powershell ldap-utils
}

echo -e "Installing base packages"
base
echo -e "Installing network packages"
network
echo -e "Installing AD tools"
active_directory

web() {
	sudo apt-get install -y whatweb ffuf sqlmap \
		exiftool default-mysql-client hurl postgresql arjun \
		burpsuite
}

password() {
	sudo apt-get install -y seclists crunch
}

httpx_install() {
	wget -q https://github.com/projectdiscovery/httpx/releases/download/v1.3.4/httpx_1.3.4_linux_amd64.zip &&
		unzip httpx_1.3.4_linux_amd64.zip -d ./httpx &&
		rm httpx_1.3.4_linux_amd64.zip &&
		mv httpx/httpx /home/$USER/.local/http-x &&
		rm -r httpx/

}

payload() {
	cd /home/$USER/tools/ &&
		wget -q -O nc.exe \
			"https://github.com/ShutdownRepo/Exegol-resources/raw/main/windows/nc.exe" &&
		wget -q -O nc \
			"https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/ncat"
}

active_directory() {
	cd /home/$USER/tools/ &&
		wget -q -O rubeus.exe \
			"https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Rubeus.exe" &&
		wget -q -O certify.exe \
			"https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Certify.exe" &&
		wget -q -O cme.zip \
			"https://github.com/Porchetta-Industries/CrackMapExec/releases/download/v5.4.0/cme-ubuntu-latest-3.11.zip" &&
		unzip cme.zip && chmod +x cme && sudo mv cme /home/$USER/.local/cme && rm cme.zip &&
		wget "https://github.com/fortra/impacket/releases/download/impacket_0_11_0/impacket-0.11.0.tar.gz" &&
		gunzip impacket-0.11.0.tar.gz && tar -xvf impacket-0.11.0.tar &&
		mv impacket-0.11.0/ /home/$USER/.local/ && rm impacket-0.11.0.tar &&
		wget -q -O sharp.ps1 \
			"https://github.com/BloodHoundAD/BloodHound/raw/master/Collectors/SharpHound.ps1" &&
		wget -q -O SharpHound.exe \
			"https://raw.githubusercontent.com/BloodHoundAD/BloodHound/master/Collectors/SharpHound.exe"
}

pivot() {
	cd /home/$USER/tools/ &&
		wget -q -O chisel.gz \
			"https://github.com/jpillora/chisel/releases/download/v1.8.1/chisel_1.8.1_linux_amd64.gz" &&
		gunzip chisel.gz &&
		wget -q -O win-chisel.gz \
			"https://github.com/jpillora/chisel/releases/download/v1.8.1/chisel_1.8.1_windows_amd64.gz" &&
		gunzip win-chisel.gz
}

privesc() {
	cd /home/$USER/tools/ &&
		wget -q -O linpeas.sh \
			"https://github.com/carlospolop/PEASS-ng/releases/download/20230813-dc8384b3/linpeas_linux_amd64" &&
		wget -q -O winpeas.exe \
			"https://github.com/carlospolop/PEASS-ng/releases/download/20230813-dc8384b3/winPEASany.exe" &&
		wget -q -O pspy \
			"https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64s"
}

echo -e "Installing tools..."
web
password
payload
active_directory
pivot
privesc
httpx_install

httprobe_install() {
	wget -q https://github.com/tomnomnom/httprobe/releases/download/v0.2/httprobe-linux-amd64-0.2.tgz -O httprobe.tgz &&
		tar -xzf httprobe.tgz && chmod +x httprobe && mv httprobe $HOME/.local/httprobe && rm httprobe.tgz
}

go-dorks_install() {
	wget -q https://github.com/dwisiswant0/go-dork/releases/download/v1.0.2/go-dork_1.0.2_linux_amd64 -O go-dork &&
		mv go-dork $HOME/.local/go-dork &&
		chmod +x $HOME/.local/go-dork
}

rush_install() {
	wget https://github.com/shenwei356/rush/releases/download/v0.5.2/rush_linux_amd64.tar.gz -O rush.tar.gz &&
		gunzip rush.tar.gz && tar -xf rush.tar && rm rush.tar && mv rush $HOME/.local/rush && chmod +x $HOME/.local/rush
}

katana_install() {
	wget https://github.com/projectdiscovery/katana/releases/download/v1.0.3/katana_1.0.3_linux_amd64.zip -O katana.zip &&
		unzip katana.zip && chmod +x katana && mv katana $HOME/.local/. && rm katana.zip
}

chaos_install() {
	wget https://github.com/projectdiscovery/chaos-client/releases/download/v0.5.1/chaos-client_0.5.1_linux_amd64.zip \
		-O chaos.zip && unzip chaos.zip chaos-client && chmod +x chaos-client && mv chaos-client $HOME/.local/chaos &&
		rm chaos.zip
}

dnsx_install() {
	wget https://github.com/projectdiscovery/dnsx/releases/download/v1.1.4/dnsx_1.1.4_linux_amd64.zip -O dnsx.zip &&
		unzip dnsx.zip dnsx && chmod +x dnsx && mv dnsx $HOME/.local/dnsx && rm dnsx.zip
}

waybackurls_install() {
	wget -q -O waybackurls.tgz https://github.com/tomnomnom/waybackurls/releases/download/v0.1.0/waybackurls-linux-amd64-0.1.0.tgz &&
		gunzip waybackurls.tgz &&
		tar -C $HOME/.local -xf waybackurls.tar &&
		chmod +x $HOME/.local/waybackurls &&
		rm $HOME/waybackurls.tar
}

unfurl_install() {
	wget https://github.com/tomnomnom/unfurl/releases/download/v0.4.3/unfurl-linux-amd64-0.4.3.tgz \
		-O unfurl.tgz && tar -xzf unfurl.tgz && mv unfurl $HOME/.local/unfurl && rm unfurl.tgz
}

subfinder_install() {
	wget https://github.com/projectdiscovery/subfinder/releases/download/v2.6.2/subfinder_2.6.2_linux_amd64.zip \
		-O subfinder.zip && unzip subfinder.zip && chmod +x subfinder && mv subfinder $HOME/.local/subfinder && rm subfinder.zip
}

notify_install() {
	wget https://github.com/projectdiscovery/notify/releases/download/v1.0.5/notify_1.0.5_linux_amd64.zip \
		-O notify.zip && unzip -o notify && mv notify $HOME/.local/notify && rm notify.zip && rm LICENSE.md README.md
}

echo -e "Installing Bug Bounty Tools"
sudo apt-get install amass -y

httprobe_install
go-dorks_install
rush_install
katana_install
chaos_install
dnsx_install
waybackurls_install
unfurl_install
subfinder_install
notify_install

cp ./hakrawler $HOME/.local/.

cp ./jsleak $HOME/.local/.

chmod +x $HOME/.local/hakrawler && chmod +x $HOME/.local/jsleak

cp ./recon.sh $HOME/.local/. && chmod +x $HOME/.local/recon.sh
