cd $HOME/dev/rice

# Clone repos
git clone https://github.com/LukasDoesDev/dwm-build-scripts.git
git clone https://github.com/LukasDoesDev/dmenu.git

# build dwm
cd dwm-build-scripts
./full.sh install
cd ..

# build dmenu
cd dmenu
sudo make clean install
cd ..