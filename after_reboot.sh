#!/bin/bash

# Set colors
LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;91m'
WHITE='\033[1;97m'
MAGENTA='\033[1;35m'
CYAN='\033[1;96m'
BLUE='\033[1;34m'

scriptdir=$(pwd)

if [[ `id -u` -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

./test_network.sh
if [ "$?" != "0" ]; then
    exit 1
fi

printf ${WHITE}"### Installing bash-completion\n"
pacman --noconfirm -S bash-completion

printf ${WHITE}"### Setting up non-root user\n"
./add_user.sh

printf ${WHITE}

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers


printf ${CYAN}"If you want to install our rice and recommended software please log in as the user you just created and run the following command:\n"
printf ${WHITE}"cd ${scriptdir}/install_software.sh\n"



printf ${LIGHTGREEN}"\n#====================#\n    ARCH IS READY! \n#====================#\n"
printf ${WHITE}"# Your arch installation should now be ready for use!\n"

printf ${WHITE}
