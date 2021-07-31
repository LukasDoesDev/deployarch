#!/bin/bash

# Set colors
LIGHTGREEN='\033[1;32m'
LIGHTRED='\033[1;91m'
WHITE='\033[1;97m'
MAGENTA='\033[1;35m'
CYAN='\033[1;96m'
BLUE='\033[1;34m'

if [[ `id -u` -eq 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

while true; do
  printf ${WHITE}"### Setting timezone\n"
  printf ${CYAN}"Enter your timezone in this format: Area/City\n(ex, Europe/Helsinki, America/New_York, Asia/Singapore, Australia/Sydney)\n(https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)\n>"
  read timezone
  
  ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime
  
  if [ "$?" = "0" ]; then
      break
  else
    printf ${LIGHTRED}"Error while setting timezone, please enter it again\n"
    sleep 2
  fi
done

hwclock --systohc

printf ${WHITE}"### Setting locale, charset and keymap\n"

printf ${CYAN}"What locale do you want to use? Must be one of the locales placed in ${BLUE}/usr/share/i18n/locales${CYAN}. Example: fi_FI, en_US, en_GB, en_AU, de_DE. Remember that you can always change this later in ${BLUE}/etc/locale.conf${CYAN}\n>"
read locale

printf ${CYAN}"What charset do you want to use? Must be one of the charsets placed in ${BLUE}/usr/share/i18n/charmaps${CYAN} (Ignore the .gz extension). Example: UTF-8, ISO-8859-1, MAC-UK, MACINTOSH. Remember that you can always change this later in ${BLUE}/etc/locale.conf${CYAN}\n>"
read charset

printf ${CYAN}"What keymap do you want to use? Must be one of the keymaps placed in ${BLUE}/usr/share/kbd/keymaps${CYAN} (Ignore the .map.gz extension). Example: fi, us, pc110, jp106.\n>"
read keymap

echo LANG="${locale}.${charset}" > /etc/locale.conf
echo "${locale}.${charset} ${charset}" >> /etc/locale.gen

echo KEYMAP=${keymap} > /etc/vconsole.conf

locale-gen

printf ${CYAN}"Enter the hostname you want to use\n>"
read newHostname
echo $newHostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.0.1       $newHostname.localdomain $newHostname" >> /etc/hosts



pacman --noconfirm -Sy networkmanager

systemctl enable NetworkManager

while true; do
    printf ${LIGHTGREEN}"Enter the password for the root user\n>"
    read -s password
    printf ${LIGHTGREEN}"Re-enter the password for the root user\n>"
    read -s password_compare
    if [ "$password" = "$password_compare" ]; then
        echo "root:$password" | chpasswd
        break
    else
        printf ${LIGHTRED}"Passwords do not match, re-enter them"
        printf ${WHITE}".\n"
        sleep 3
        clear
    fi
done



pacman --noconfirm -Sy grub efibootmgr

grub-install --target=x86_64-efi --efi-directory=/boot/efi

grub-mkconfig -o /boot/grub/grub.cfg

printf ${LIGHTGREEN}"# =========================\n"
printf ${LIGHTGREEN}"# REBOOT NEEDED\n"
printf ${LIGHTGREEN}"# =========================\n"
printf ${WHITE}"# After you've rebooted and logged into the root user please see the README to see what commands to run:\n"

exit
