#!/bin/bash

sudo usermod -aG sudo f0nzy

su f0nzy

sudo apt-get update -y

echo -e "Installing base packages..."

sudo apt-get install -y tmux tmuxp pass \
	flameshot feh i3 i3blocks i3status i3lock-fancy \
	jq terminator zsh nano remmina proxychains rsync \
	ttf-anonymous-pro fonts-noto-mono fonts-noto-color-emoji \
	cowsay btop curl fzf rofi polybar rng-tools-debian

curl -fsSL https://get.docker.com -o get-docker.sh &
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

mkdir -p $HOME/.config/terminator/plugins

wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

wget https://releases.hashicorp.com/terraform-ls/0.31.4/terraform-ls_0.31.4_linux_amd64.zip \
	-O terraform-ls.zip && unzip terraform-ls.zip && chmod +x terraform-ls &&
	mv terraform-ls ~/.local/bin/. && rm terraform-ls.zip

wget https://github.com/docker/docker-credential-helpers/releases/download/v0.7.0/docker-credential-pass-v0.7.0.linux-amd64 &&
	mv docker-credential-pass-v0.7.0.linux-amd64 docker-credential-pass &&
	chmod a+x docker-credential-pass &&
	sudo mv docker-credential-pass /usr/local/bin

mkdir ~/.docker

echo '{"experimental":"enabled"}' >.docker/config.json

#PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

chmod u+x nvim.appimage && mv nvim.appimage ~/.local/nvim.appimage

mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

mkdir ~/.logs

mkdir ~/projects

mkdir ~/tools &&
	cd tools &&
	wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt &&
	git clone https://github.com/alexrf45/reverse-ssh.git &&
	git clone https://github.com/alexrf45/bloodhound-dev.git &&
	git clone https://github.com/alexrf45/Prox-Tor.git

sudo usermod -aG docker $USER

# TODO: set up repo for debian config
#
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
#
#
curl -fsSL https://get.pulumi.com | sh

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform

curl -SL https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

reboot
