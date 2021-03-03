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
sudo pacman --noconfirm -Sy firefox nemo xdg-utils xdg-user-dirs nano wget unzip neovim grep highlight youtube-dl rsync
paru --noconfirm -S vscodium-bin cava icdiff

# Get dotfiles
curl -fsSL https://raw.githubusercontent.com/LukasDoesDev/dotfiles/master/setup.sh | bash

# Configure Nemo to be default file manager
xdg-mime default nemo.desktop inode/directory

echo "Now you can run \"source .bashrc\" and use the \"startx\" command to start DWM"
echo "terminal hotkey in dwm is Alt+Shift+Enter"
echo "exit hotkey in dwm is Alt+Shift+Q"
echo "firefox hotkey in dwm is Alt+Shift+F"
