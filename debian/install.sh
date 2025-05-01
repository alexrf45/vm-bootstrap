#!/bin/bash

set -e

echo -e "Installing base packages..."

base_desktop_install() {
  sudo apt install lightdm lightdm-gtk-greeter xorg-xhost lxappearance-gtk3 i3-wm i3blocks \
    i3lock i3status dmenu feh man-pages man-db flameshot gtk-theme-elementary \
    gtkmm3 arc-gtk-theme papirus-icon-theme picom rofi rtkit alsa-utils \
    materia-gtk-theme gtk-engine-murrine pipewire xf86-video-intel thermald sof-firmware
}

base_packages_install() {
  sudo apt install network-manager-applet networkmanager-openvpn xterm xsel speech-dispatcher \
    gvfs openvpn open-vm-tools pavucontrol \
    pass paprefs inotify-tools notification-daemon bluez-utils bluez xfce4-notifyd

}

base_font_install() {
  sudo apt install \
    ttf-anonymous-pro ttf-nerd-fonts-symbols-common \
    noto-fonts-emoji ttf-ubuntu-font-family ttf-jetbrains-mono \
    ttf-nerd-fonts-symbols powerline-fonts powerline-common powerline
}

base_tools_install() {
  sudo apt install \
    just lazygit links ffmpeg rsync upx wget tmux tmuxp unzip \
    gzip p7zip lolcat btop cowsay figlet rng-tools bash-completion zathura zathura-pdf-poppler poppler-data \
    python-pynvim ueberzug thunar sqlitebrowser sqlite3 yazi syncthing python python-pip python-requests python-virtualenv python-pipx remmina \
    terminator wireshark-qt alacritty yq ripgrep rng-tools jq
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

  mkdir -p "$HOME/.downloads"

  sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

  sudo cp ./images/gruvbear.jpeg /usr/share/pixmaps/.

}

dotfiles_install() {
  echo ".cfg" >>.gitignore &&
    git clone https://github.com/alexrf45/dotfiles.git "$HOME/.cfg" &&
    /usr/bin/git --git-dir="$HOME/.cfg/.git" --work-tree="$HOME" config --local status.showUntrackedFiles no &&
    /usr/bin/git --git-dir="$HOME/.cfg/.git" --work-tree="$HOME" checkout
}

miniplug_install() {
  curl \
    -sL --create-dirs \
    https://git.sr.ht/~yerinalexey/miniplug/blob/master/miniplug.zsh \
    -o "$HOME/.miniplug/plugins/miniplug.zsh"

}
scripts_setup() {
  cp -r scripts/ "$HOME/.config/"
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

base_desktop_install
base_packages_install
base_font_install
base_tools_install
directory_setup
dotfiles_install
miniplug_install
scripts_setup
neovim_install
aws_install

docker_install() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
}

docker_install

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

curl -fsS https://dl.brave.com/install.sh | sh

sudo usermod -aG docker "$USER"

#sudo systemctl start thermald.service && sudo systemctl enable thermald.service

#sudo systemctl start bluetooth.servive && sudo systemctl enable bluetooth.service

sudo systemctl enable lightdm && sudo systemctl start lightdm
