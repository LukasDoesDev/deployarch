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


# font stuff
echo "Setting up Noto Emoji font..."
sudo pacman --noconfirm -Sy noto-fonts-emoji --needed
echo '<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
 <alias>
   <family>sans-serif</family>
   <prefer>
     <family>Noto Sans</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
     <family>DejaVu Sans</family>
   </prefer> 
 </alias>

 <alias>
   <family>serif</family>
   <prefer>
     <family>Noto Serif</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
     <family>DejaVu Serif</family>
   </prefer>
 </alias>

 <alias>
  <family>monospace</family>
  <prefer>
    <family>Noto Mono</family>
    <family>Noto Color Emoji</family>
    <family>Noto Emoji</family>
    <family>DejaVu Sans Mono</family>
   </prefer>
 </alias>
</fontconfig>

' > /etc/fonts/local.conf
fc-cache

# enable color font support
paru --noconfirm -S libxft-bgra

# Install packages needed for runtime
sudo pacman --noconfirm -Sy xorg libx11 libxinerama libxft webkit2gtk dunst feh picom flameshot xorg-xinit sxiv

# Install other software
sudo pacman --noconfirm -Sy firefox nemo xdg-utils xdg-user-dirs nano wget unzip neovim grep highlight youtube-dl rsync man-db tree jq
paru --noconfirm -S vscodium-bin cava icdiff

# Add colors to pacman
sed -i 's/#Color/Color/g' /etc/pacman.conf

# Get dotfiles
curl -fsSL https://raw.githubusercontent.com/LukasDoesDev/dotfiles/master/setup.sh | bash

# Install neovim plugins
echo ':PlugInstall' >> /tmp/plugInstall.txt
echo ':wq' >> /tmp/plugInstall.txt
echo ':wq' >> /tmp/plugInstall.txt
nvim -s /tmp/plugInstall.txt

# Configure Nemo to be default file manager
xdg-mime default nemo.desktop inode/directory

echo '"source .bashrc" to apply bash aliases, etc.f'
echo 'startx command to start dwm'
echo ''
echo 'terminal : Alt+Shift+Enter'
echo 'exit     : Alt+Shift+Q'
echo 'firefox   : Alt+Shift+F'
