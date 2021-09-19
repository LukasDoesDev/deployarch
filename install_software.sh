#!/bin/bash

if [[ `id -u` -eq 0 ]] ; then echo "Please do not run as root, AUR packages will fail installing" ; exit 1 ; fi

# Install base development and git packages
sudo pacman --noconfirm -Sy --needed base-devel git

# Create ~/dev directory
mkdir $HOME/dev
cd $HOME/dev

# Create ~/dev/rice directory
mkdir $HOME/dev/rice
cd $HOME/dev/rice

# Install paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# Install needed packages
sudo pacman --noconfirm -Sy xorg xorg-xrdb libx11 libxinerama libxft webkit2gtk dunst feh picom flameshot xorg-xinit xorg-xrandr rxvt-unicode 

# sudo pacman --noconfirm -S python
python package_installer.py

for f in ./setup/*.sh; do
  bash "$f" 
done

# Add colors to pacman
sed -i 's/#Color/Color/g' /etc/pacman.conf

# Get dotfiles
curl -fsSL https://raw.githubusercontent.com/LukasDoesDev/dotfiles/master/setup.sh | bash

# Make neovim install plugins
echo ':PlugInstall' >> /tmp/plugInstall.txt
echo ':q!' >> /tmp/plugInstall.txt
nvim -s /tmp/plugInstall.txt
rm -f /tmp/plugInstall.txt

# Configure GTK to use dark mode
# https://askubuntu.com/questions/806200/how-can-you-enable-gtk3-themes-dark-theme-mode-when-using-unity-7
# TODO: https://unix.stackexchange.com/questions/137643/editing-ini-like-files-with-a-script#152083
cat <<EOF >>~/.config/gtk-3.0/settings.ini
[Settings]
gtk-application-prefer-dark-theme=1
EOF

# Configure Nemo to launch urxvt as the terminal emulator
gsettings set org.cinnamon.desktop.default-applications.terminal exec urxvt

echo 'Run "source .bashrc" to apply bash configs, aliases, etc.'
echo 'Run "startx" to start dwm'
echo 'By default, dwm will start automatically when you login through tty1'
echo ''
echo 'terminal     : Alt+Shift+Enter'
echo 'exit         : Alt+Shift+Q'
echo 'firefox      : Alt+Shift+F'
echo 'screenshot   : Alt+Shift+S'
echo 'close window : Alt+Shift+C'
echo ''
echo "The latest info on keybinds, patches, etc. can be found in my dwm-build-scripts repository\'s readme:"
echo 'https://github.com/LukasDoesDev/dwm-build-scripts#readme'
