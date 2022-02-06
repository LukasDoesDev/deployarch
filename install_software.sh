#!/bin/bash

if [[ `id -u` -eq 0 ]] ; then echo "Please do not run as root, AUR packages will fail installing" ; exit 1 ; fi

script_dir="`realpath \`dirname ${BASH_SOURCE[0]}\``"
echo SCRIPT DIR $script_dir
sleep 6


# Install base development and git packages
sudo pacman --noconfirm -Sy --needed base-devel git

# Create ~/dev and ~/dev/rice directories if they do not exist
mkdir -pv $HOME/dev/rice
cd $HOME/dev/rice

if ! command -v paru &>/dev/null ; then
  # Install paru
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
fi

echo GOING BACK
cd $script_dir

sleep 3

# Install needed packages
# COMMENTED OUT because package_installer.py will do it for us
#sudo pacman --noconfirm -Sy xorg xorg-xrdb libx11 libxinerama libxft webkit2gtk dunst feh picom flameshot xorg-xinit xorg-xrandr rxvt-unicode 

sudo pacman --noconfirm -S --needed python
python fzf_installer.py

sleep 3

for f in ./setup/*.sh; do
  bash "$f" 
done

# Add colors to pacman
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo sed -i -z 's|#\[multilib\]\n#Include|[multilib]\nInclude|g' /etc/pacman.conf
#cat /etc/pacman.conf | sed -z 's|#\[multilib\]\n#Include|[multilib]\nInclude|g' | sudo tee /etc/pacman.conf

sleep 3

# Get dotfiles
sudo pacman --noconfirm -S --needed rsync curl bash git stow
curl -fsSL https://raw.githubusercontent.com/LukasDoesDev/dotfiles/master/setup.sh | bash

sleep 3

# Make neovim install plugins
#echo ':PlugInstall' > /tmp/plugInstall.txt
#echo ':q!' >> /tmp/plugInstall.txt
#nvim -s /tmp/plugInstall.txt
#rm -f /tmp/plugInstall.txt
#nvim +PlugInstall +qall
nvim +PackerSync +qall

# Configure GTK to use dark mode
# https://askubuntu.com/questions/806200/how-can-you-enable-gtk3-themes-dark-theme-mode-when-using-unity-7
# TODO: https://unix.stackexchange.com/questions/137643/editing-ini-like-files-with-a-script#152083
mkdir -pv ~/.config/'gtk-3.0'
[ -f $HOME/.config/'gtk-3.0'/settings.ini ] || touch $HOME/.config/'gtk-3.0'/settings.ini 
grep -q 'gtk-applications-prefer-dark-theme' $HOME/.config/'gtk-3.0'/settings.ini || cat <<EOF >>$HOME/.config/gtk-3.0/settings.ini
[Settings]
gtk-application-prefer-dark-theme=1
EOF

# Configure Nemo to launch Alacritty as the terminal emulator
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

echo Done!

#echo 'Run "source .bashrc" to apply bash configs, aliases, etc.'
#echo 'Run "startx" to start dwm'
#echo 'By default, dwm will start automatically when you login through tty1'
#echo ''
#echo 'terminal     : Alt+Shift+Enter'
#echo 'exit         : Alt+Shift+Q'
#echo 'firefox      : Alt+Shift+F'
#echo 'screenshot   : Alt+Shift+S'
#echo 'close window : Alt+Shift+C'
#echo ''
#echo "The latest info on keybinds, patches, etc. can be found in my dwm-build-scripts repository's readme:"
#echo 'https://github.com/LukasDoesDev/dwm-build-scripts#readme'
