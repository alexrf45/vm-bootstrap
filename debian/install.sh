#!/bin/bash

set -e

echo -e "Installing base packages..."

base_desktop_install() {
  sudo apt install lightdm lightdm-gtk-greeter i3-wm i3blocks \
    i3lock i3blocks i3status dmenu feh man-db flameshot curl wget papirus-icon-theme picom rofi rtkit alsa-utils \
    thermald fonts-anonymous-pro fonts-jetbrains-mono \
    powerline network-manager-applet xterm xsel speech-dispatcher \
    gvfs openvpn open-vm-tools pavucontrol zsh gnupg2 \
    pass paprefs inotify-tools notification-daemon bluez \
    just lazygit links ffmpeg rsync upx wget tmux tmuxp unzip \
    gzip p7zip lolcat btop cowsay figlet rng-tools bash-completion zathura zathura-pdf-poppler poppler-data \
    ueberzug thunar sqlitebrowser sqlite3 syncthing python3 python3-pip python3-requests python3-virtualenv pipx remmina \
    terminator alacritty yq ripgrep rng-tools jq starship age neovim

}

directory_setup() {
  mkdir -p "$HOME/.config/alacritty/"

  mkdir -p "$HOME/.local/bin"

  mkdir -p "$HOME/.config/pictures"

  mkdir -p "$HOME/.config/i3"

  mkdir -p "$HOME/.config/rofi"

  mkdir -p "$HOME/.ssh"

  mkdir -p "$HOME/.miniplug/plugins"

  mkdir -p "$HOME/projects"

  mkdir -p "$HOME/.docker"

  mkdir -p "$HOME/.logs"
  
  mkdir -p "$HOME/.downloads"

}

dotfiles_install() {
  rm "$HOME/.bashrc" "$HOME/.profile"
  echo ".cfg" >>"$HOME/.gitignore" &&
    git clone https://github.com/alexrf45/dotfiles.git "$HOME/.cfg" &&
    /usr/bin/git --git-dir="$HOME/.cfg/.git" --work-tree="$HOME" config --local status.showUntrackedFiles no &&
    /usr/bin/git --git-dir="$HOME/.cfg/.git" --work-tree="$HOME" checkout
}

miniplug_install() {
  curl \
    -sL --create-dirs \
    https://raw.githubusercontent.com/YerinAlexey/miniplug/refs/heads/master/miniplug.zsh \
    -o "$HOME/.miniplug/plugins/miniplug.zsh"

}
scripts_setup() {
  cp -r ../arch/scripts/ "$HOME/.config/"
}

kube_install() {

  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

  sudo apt-get update

  sudo apt-get install -y kubectl
}

tf_install() {

  wget -O- https://apt.releases.hashicorp.com/gpg |
    gpg --dearmor |
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com bookworm main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

  sudo apt update

  sudo apt-get install terraform
}

neovim_install() {
  mv ~/.config/nvim ~/.config/nvim.bak
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

}

op_install() {
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list &&
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ &&
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol &&
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 &&
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg &&
    sudo apt update && sudo apt install 1password-cli

}

aws_install() {
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install && rm -r aws/
}

#base_desktop_install
#directory_setup
#dotfiles_install
#miniplug_install
#scripts_setup
#aws_install
#kube_install
#tf_install
neovim_install
op_install

docker_install() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
}

docker_install

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

curl -fsS https://dl.brave.com/install.sh | sh

sudo usermod -aG docker "$USER"

#sudo systemctl enable lightdm && sudo systemctl start lightdm
