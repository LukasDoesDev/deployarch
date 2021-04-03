# deployarch
deploys an arch machine

## Usage

### (WARNING) This installer is for UEFI

Do the following in your UEFI/BIOS settings:
 - Disable Secure Boot
 - Disable Launch CSM or Legacy Support
 - Set Boot Mode to UEFI
 - Enable USB Boot

Boot to the official installlation ISO and run the following commands:
```sh
loadkeys # <your keyboard layout, for me it's "fi">
# Download and run a script that will download and run the REAL script :D
bash <(curl -sL thatonelukas.tk/files/deployarch/deployarch.sh)
```
And after that script has run reboot to the drive you installed Arch on, login to root and run these commands:
```sh
# Download and run a script that will download and run the REAL script :D
bash <(curl -sL thatonelukas.tk/files/deployarch/after_reboot.sh)
```
And after that you should have a working Arch installation.
## Install recommended software:
### (WARNING) Run as a non-root user, otherwise AUR will fail
```sh
# Download and run a script that will download and run the REAL script :D
bash <(curl -sL thatonelukas.tk/files/deployarch/install_software.sh)
```
or if you used the setup script, this should do it:
```sh
/root/deploayarch2-master/install_software.sh
```
"source .bashrc" to apply bash stuff
"startx" to start dwm

my dwm keybinds:
 - terminal : Alt+Shift+Enter
 - exit     : Alt+Shift+Q
 - firefox   : Alt+Shift+F
