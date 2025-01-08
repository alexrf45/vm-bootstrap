#!/bin/bash

set -e

echo -e "Installing base packages..."

base_desktop_install() {
  sudo pacman -S lightdm lightdm-gtk-greeter xorg-xhost lxappearance-gtk3 i3-wm i3blocks \
    i3lock i3status dmenu feh man-pages man-db flameshot gtk-theme-elementary \
    gtkmm3 arc-gtk-theme papirus-icon-theme picom rofi rtkit alsa-utils \
    materia-gtk-theme gtk-engine-murrine pipewire udisks2 udisks2-qt5
}

base_packages_install() {
  sudo pacman -S network-manager-applet networkmanager-openvpn xterm xsel speech-dispatcher \
    gvfs openvpn open-vm-tools pavucontrol \
    pass paprefs inotify-tools notification-daemon bluez-utils bluez xfce4-notifyd

}

base_font_install() {
  sudo pacman -S ttf-anonymous-pro ttf-hack ttf-nerd-fonts-symbols-common \
    noto-fonts-emoji ttf-iosevka-nerd ttf-agave-nerd ttf-jetbrains-mono \
    ttf-nerd-fonts-symbols ttf-meslo-nerd powerline-fonts powerline-common powerline
}

base_tools_install() {
  sudo pacman -S \
    fzf just lazygit links ffmpeg rsync tealdeer upx wget tmux tmuxp unzip \
    gzip p7zip lolcat btop cowsay figlet rng-tools miniserve bash-completion zathura zathura-pdf-poppler poppler-data \
    python-pynvim ueberzug thunar sqlitebrowser sqlite3 yazi
}

base_tools_1_install() {

  sudo pacman -S aws-vault docker \
    docker-compose docker-buildx jq neovim npm obsidian \
    python python-pip python-requests python-virtualenv python-pipx remmina \
    terminator wireshark-qt alacritty yq ripgrep rng-tools \
    mkcert k9s argon2 age direnv talosctl helm terraform kubectl
}

directory_setup() {
  mkdir -p $HOME/.config/alacritty/

  mkdir -p $HOME/.local/bin

  mkdir -p $HOME/.config/pictures

  mkdir -p $HOME/.config/i3

  mkdir -p $HOME/.config/rofi

  mkdir $HOME/.ssh

  #  mkdir -p $HOME/.miniplug/plugins

  mkdir $HOME/.logs

  mkdir $HOME/projects

  mkdir $HOME/.docker

  mkdir $HOME/.downloads

  cp ./config ~/.config/i3/.

  sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

  sudo cp ./images/gruvbear.jpeg /usr/share/pixmaps/.

  cp ./images/gruvbear.jpeg ~/.config/pictures/.

}

scripts_setup() {
  cp -r scripts/ $HOME/.config/
}

ssh_setup() {
  ssh-keygen -t ed25519 -N '' -C "fr3d" -f $HOME/.ssh/fr3d

  eval "$(ssh-agent -s)"

  ssh-add ~/.ssh/fr3d

}

neovim_install() {
  mv ~/.config/nvim ~/.config/nvim.bak

  git clone https://github.com/LazyVim/starter ~/.config/nvim

  rm -rf ~/.config/nvim/.git

}

aws_install() {

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

  unzip awscliv2.zip

  sudo ./aws/install && rm -r aws/
}

yay_install() {
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si
}

#base_desktop_install
#base_packages_install
#base_font_install
#base_tools_install
#base_tools_1_install
#directory_setup
#scripts_setup
#ssh_setup

#dotfiles_install
mkdir -p ~/.config/nvim
neovim_install
aws_install
yay_install

sudo systemctl start vmtoolsd.service vmware-vmblock-fuse.service &&
  sudo systemctl enable vmtoolsd.service vmware-vmblock-fuse.service

sudo systemctl start docker && sudo systemctl enable docker

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

sudo usermod -aG docker $USER

sudo systemctl enable lightdm && sudo systemctl start lightdm
