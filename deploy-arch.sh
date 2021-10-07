#! /bin/bash

# pacman -Sy vim git sudo

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

sed -i -e 's/\#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "LANGUAGE=en_GB" >> /etc/locale.conf
echo "KEYMAP=fr" >> /etc/vconsole.conf
echo p14s > /etc/hostname
echo "127.0.1.1 adrien" >> /etc/hosts


read -p "ROOT PASSWORD"
passwd
useradd -G wheel -m adrien
read -p "ADRIEN PASSWORD"
passwd adrien

# look for wheel and uncomment (keep password though)
visudo

pacman -S grub efibootmgr os-prober

read -p "GRUB INIT"
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
read -p "GRUB END"

pacman -S --needed - < pkglist.txt
#pacman -Sy arandr abcde alsa-utils audacity bluez bluez-utils calcurse chromium clang conky cups feh firefox fzf gcc-fortran go gnupg gpartedhtop krita kdenlive libreoffice-fresh moc network-manager-applet networkmanager networkmanager-openvpn nm-connection-editor pandoc pass pulseaudio pulseaudio-alsa pulseaudio-bluetooth r rsync scrot shotwell simple-scan sox spectrwm tcl texinfo texlive-bibtexextra texlive-core texlive-fontsextra texlive-formatsextra texlive-games texlive-humanities texlive-langgreek texlive-latexextra texlive-music texlive-pictures texlive-pstricks texlive-publishers texlive-science tk tlp tmux transmission-gtk ttf-ibm-plex ttf-roboto udiskie unclutter unrar unzip ttf-roboto udiskie unclutter unrar unzip vifm w3m wget wmctrl xdotool xterm youtube-dl zathura zathura-djvu zathura-pdf-mupdf

# multilib
sed -i -e '/\#\[multilib\]/{s/\#\[multilib\]/[multilib]/;N;s/\#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf
systemctl enable NetworkManager.service
systemctl start NetworkManager.service
systemctl enable cups.service
systemctl start cups.service
systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
