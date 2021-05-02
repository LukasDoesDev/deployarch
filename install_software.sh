#!/bin/bash

if [[ `id -u` -eq 0 ]] ; then echo "Please do not run as root, AUR packages will fail installing" ; exit 1 ; fi

# Install base development and git packages
sudo pacman --noconfirm -Sy --needed base-devel git

# Create ~(dev directory
mkdir $HOME/dev
cd $HOME/dev

# Create ~(dev/rice directory
mkdir $HOME/dev/rice
cd $HOME/dev/rice

# Install paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# Install NerdFonts symbols and JetBrains Mono
sudo pacman -S ttf-nerd-fonts-symbols ttf-jetbrains-mono

# Install needed packages
sudo pacman --noconfirm -Sy xorg libx11 libxinerama libxft webkit2gtk dunst feh picom flameshot xorg-xinit sxiv jq

# Clone repos
git clone https://github.com/LukasDoesDev/st.git
git clone https://github.com/LukasDoesDev/dwm-build-scripts.git
git clone https://github.com/LukasDoesDev/dmenu.git

# build st
cd st
sudo make clean install
cd ..

# build dwm
cd dwm-build-scripts
./full.sh
cd ..

# build dmenu
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

# Install rice screenshot software
sudo pacman --noconfirm -Sy cmatrix
paru --noconfirm -S cava

# Install dev software
sudo pacman --noconfirm -Sy python3 python-pip
paru --noconfirm -S vscodium-bin
bash <(curl -sL https://raw.githubusercontent.com/LukasDoesDev/deployarch2/master/install_nvm.sh)

# Install general software
sudo pacman --noconfirm -Sy firefox nemo neovim grep rsync man-db tree git discord gimp inkscape wget curl
paru --noconfirm -S icdiff

# Install youtube stuff
sudo pacman --noconfirm -Sy youtube-dl youtube-viewer

# Install other software
sudo pacman --noconfirm -Sy xdg-utils xdg-user-dirs unzip highlight nmap fzf

# Install gaming software
sudo pacman --noconfirm -Sy minecraft-launcher steam

# Add colors to pacman
sed -i 's/#Color/Color/g' /etc/pacman.conf

# Get dotfiles
curl -fsSL https://raw.githubusercontent.com/LukasDoesDev/dotfiles/master/setup.sh | bash

# Make neovim install plugins
echo ':PlugInstall' >> /tmp/plugInstall.txt
echo ':q!' >> /tmp/plugInstall.txt
nvim -s /tmp/plugInstall.txt
rm -f /tmp/plugInstall.txt

# Configure Nemo to be default file manager
xdg-mime default nemo.desktop inode/directory

echo 'Run "source .bashrc" to apply bash configs, aliases, etc.'
echo 'Run "startx" to start dwm'
echo 'By default, dwm will start automatically when you login through tty1'
echo ''
echo 'terminal     : Alt+Shift+Enter'
echo 'exit         : Alt+Shift+Q'
echo 'firefox      : Alt+Shift+F'
echo 'screenshot   : Alt+Shift+S'
