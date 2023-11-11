#!/bin/bash


sudo apt-get install -y kali-desktop-i3 pass flameshot jq terminator remmina btop fzf rofi xpdf

#aws cli install
aws-install() {
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	rm -r aws/
	rm awscliv2.zip
}

aws-install

#fonts
mkdir -p ~/.local/share/fonts/

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip

unzip Iosevka.zip -d ~/.local/share/fonts/

fc-cache -fv


#terminator themes
mkdir -p $HOME/.config/terminator/plugins

wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

#directories
mkdir -p $HOME/.local/bin

mkdir -p $HOME/.local/tools

mkdir -p $HOME/.logs



#install golang
install_go() {
	wget https://go.dev/dl/go1.21.3.linux-amd64.tar.gz &&
		rm -rf /usr/local/go &&
		tar -C $HOME/.local/bin -xzf go1.21.3.linux-amd64.tar.gz &&
		rm go1.21.3.linux-amd64.tar.gz
}

#make sure dependency for go works
install_go


#install cargo/rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

#terraform
wget https://releases.hashicorp.com/terraform/1.6.3/terraform_1.6.3_linux_amd64.zip -O terraform.zip &&
	unzip terraform.zip && chmod +x terraform && mv terraform $HOME/.local/bin/terraform

#some tools
cd $HOME/.local/tools &&
	wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/bloodhound-dev.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

cd $HOME


sublime_install(){
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null && \
		echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list && \
		sudo apt-get update && sudo apt-get install sublime-text

}

sublime_install

wget https://github.com/99designs/aws-vault/releases/download/v7.2.0/aws-vault-linux-amd64 -O aws-vault && \
	chmod +x aws-vault && mv aws-vault $HOME/.local/bin/.
