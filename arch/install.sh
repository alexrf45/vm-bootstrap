#!/bin/bash

echo -e "Installing base packages..."

sleep 2

base_desktop_install() {
  sudo pacman -S lightdm lightdm-gtk-greeter xorg-xhost lxappearance-gtk3 i3-wm i3blocks \
    i3lock i3status dmenu feh man-pages man-db flameshot gtk-theme-elementary \
    gtkmm3 arc-gtk-theme papirus-icon-theme picom rofi \
    materia-gtk-theme gtk-engine-murrine
}

base_packages_install() {
  sudo pacman -S network-manager-applet networkmanager-openvpn xterm xsel speech-dispatcher \
    base-devel intel-media-driver gvfs openvpn open-vm-tools \
    pass pulseaudia-alsa pulseaudio-equalizer pacman-contrib pciutils \
    inotify-tools notification-daemon bluez-libs bluez-utils bluez pinentry xfce4-notifyd

}

base_font_install() {
  sudo pacman -S ttf-anonymous-pro ttf-hack ttf-nerd-fonts-symbols-common \
    noto-fonts-emoji ttf-iosevka-nerd ttf-agave-nerd ttf-jetbrains-mono \
    ttf-nerd-fonts-symbols ttf-meslo-nerd powerline-fonts powerline-common powerline
}

base_tools_install() {
  sudo pacman -S \
    dust fzf just lazygit links ffmpeg rsync tealdeer upx wget tmux tmuxp unzip \
    gzip p7zip lolcat btop cowsay figlet rng-tools miniserve bash-completion zathura zathura-pdf-poppler poppler-data \
    python-pynvim ueberzug thunar sqlitebrowser sqlite3 yazi
}

base_tools_1_install() {

  sudo pacman -S aws-vault docker \
    docker-compose docker-buildx jq neovim npm obsidian \
    python python-pip python-requests python-virtualenv python-pipx remmina \
    terminator wireshark-qt alacritty yq terraform kubectl ansible ripgrep rng-tools \
    mkcert k9s helm fzf argon2
}

directory_setup() {
  mkdir -p $HOME/.config/alacritty/

  mkdir -p $HOME/.local/bin

  mkdir -p $HOME/.config/pictures

  mkdir $HOME/.ssh

  mkdir $HOME/.logs

  mkdir $HOME/projects

  mkdir $HOME/.docker

  mkdir $HOME/.downloads

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

aws_install() {

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

  unzip awscliv2.zip

  sudo ./aws/install && rm -r aws/
}
paru_install() {
  git clone https://aur.archlinux.org/paru.git &&
    cd paru && makepkg -si && sudo rm -r $HOME/paru
}

base_desktop_install
base_packages_install
base_font_install
base_tools_install
base_tools_1_install
directory_setup
ssh_setup
dotfiles_install
neovim_install
aws_install
paru_install

sudo systemctl start vmtoolsd.service vmware-vmblock-fuse.service &&
  sudo systemctl enable vmtoolsd.service vmware-vmblock-fuse.service

sudo systemctl start docker && sudo systemctl enable docker

sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

sudo cp ./images/gruvbear.jpeg /usr/share/pixmaps/.

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

wget -q "https://raw.github.com/xwmx/nb/master/nb" -O $HOME/.local/bin/nb && chmod +x $HOME/.local/bin/nb

sudo usermod -aG docker $USER

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

sudo systemctl enable lightdm && sudo systemctl start lightdm
