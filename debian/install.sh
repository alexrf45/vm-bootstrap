#!/bin/bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
TARGET_USER="fr3d"

echo "============================================"
echo "[$(date)] First-boot setup starting..."
echo "============================================"

base_desktop_install() {
  sudo apt install lightdm lightdm-gtk-greeter i3-wm i3blocks \
    i3lock i3blocks i3status dmenu feh man-db flameshot \
    curl wget papirus-icon-theme picom \
    rofi rtkit alsa-utils thermald fonts-anonymous-pro \
    pipewire-audio powerline network-manager-applet xterm xsel speech-dispatcher \
    gvfs openvpn open-vm-tools pavucontrol zsh gnupg2 \
    pass paprefs inotify-tools notification-daemon bluez \
    lazygit links ffmpeg rsync upx wget tmux tmuxp unzip \
    gzip p7zip rng-tools bash-completion zathura zathura-pdf-poppler poppler-data \
    ueberzug thunar sqlitebrowser sqlite3 python3 python3-pip \
    python3-requests python3-virtualenv pipx remmina \
    terminator alacritty yq ripgrep jq age neovim

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

mkdir -p ~/.local/share/fonts/

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip

unzip Iosevka.zip -d ~/.local/share/fonts/
unzip JetBrainsMono.zip -d ~/.local/share/fonts/

fc-cache -fv

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

base_desktop_install
directory_setup
#dotfiles_install
miniplug_install
#scripts_setup
aws_install
#kube_install
tf_install
neovim_install
op_install

echo "[*] Installing Docker Engine..."

if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sh /tmp/get-docker.sh
  rm -f /tmp/get-docker.sh
  sudo usermod -aG docker "$TARGET_USER"

  systemctl enable docker
  systemctl restart docker
  echo "[+] Docker installed and hardened."
else
  echo "[=] Docker already installed, skipping."
fi

echo "[*] Installing Lazygit..."
if ! command -v lazygit &>/dev/null; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin/lazygit
  rm -f /tmp/lazygit /tmp/lazygit.tar.gz
  echo "[+] Lazygit ${LAZYGIT_VERSION} installed."
else
  echo "[=] Lazygit already installed, skipping."
fi

echo "[*] Installing SOPS..."
if ! command -v sops &>/dev/null; then
  SOPS_VERSION=$(curl -s "https://api.github.com/repos/getsops/sops/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  curl -Lo /usr/local/bin/sops "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64"
  sudo chmod +x /usr/local/bin/sops
  echo "[+] SOPS ${SOPS_VERSION} installed."
else
  echo "[=] SOPS already installed, skipping."
fi

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

curl -fsS https://dl.brave.com/install.sh | sh

sudo cp lightdm-gtk-greeter.conf /etc/lightdm/.

sudo cp skull.jpg /usr/share/pixmaps/skull.jpg

sudo systemctl enable lightdm && sudo systemctl start lightdm
