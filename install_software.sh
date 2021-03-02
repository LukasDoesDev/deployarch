#!/bin/bash

if [[ `id -u` -eq 0 ]] ; then echo "Please do not run as root, AUR packages will fail installing" ; exit 1 ; fi

# Install base development and git packages
sudo pacman --noconfirm -Sy --needed base-devel git

# Install paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# Install NerdFonts symbols and JetBrains Mono
paru --noconfirm -S ttf-nerd-fonts-symbols ttf-jetbrains-mono

# Create dev directory
cd ~
mkdir dev
cd dev

# Clone repos
git clone https://github.com/LukasDoesDev/st.git
git clone https://github.com/LukasDoesDev/dwm.git
git clone https://github.com/LukasDoesDev/dmenu.git

# compile st
cd st
sudo make clean install
cd ..

# compile dwm
cd dwm
sudo make clean install
cd ..

# compile dmenu
cd dmenu
sudo make clean install
cd ..


# Install packages needed for runtime
sudo pacman --noconfirm -Sy xorg libx11 libxinerama libxft webkit2gtk dunst feh picom flameshot xorg-xinit

# Install other software
sudo pacman --noconfirm -Sy firefox nemo xdg-utils xdg-user-dirs nano wget unzip neovim
paru --noconfirm -S vscodium-bin cava # vscodium is a fork of vscode without telemetry and cava is a terminal-based audio visualizer

# Get dotfiles
curl -fsSL https://raw.githubusercontent.com/LukasDoesDev/dotfiles/master/setup.sh | bash

# Configure Nemo to be default file manager
xdg-mime default nemo.desktop inode/directory
