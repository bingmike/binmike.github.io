#!/bin/bash

# arch.sh
# v0.0.11
# Mike Jordan

# Installs Arch Linux and dwm on a Stream14 Laptop in Southwestern U.S.
# For a user account named mike. With my personal suckless patches.
# This is a very narrow use case. 

# Zero out the hard drive to make that first image Just Exactly Perfect
echo "Zeroing out the hard drive... 6½ minutes."
dd if=/dev/zero of=/dev/mmcblk0 bs=4194304 status=progress

# Create our one true partition and format
# (Stream14 has a single internal nonreplacable 32GB sd card)
echo "Generating partition"
echo -e "n\n\n\n\n\nw" | fdisk /dev/mmcblk0
mkfs.ext4 /dev/mmcblk0p1

echo "Installing Arch..."

# If your clock is not right at the begining of an Arch install,
# your computer will explode
timedatectl set-ntp true

# In a more complex setup, different mountpoints are set here
# TODO Consider a swapfile. This install is only 2.6GB. 2GB for swap.
mount /dev/mmcblk0p1 /mnt || exit

# This is my short mirrorlist. These guys all ping in the 30s
cat > /etc/pacman.d/mirrorlist << EOF
Server = http://mirrors.kernel.org/archlinux/\$repo/os/\$arch
Server = http://mirrors.ocf.berkeley.edu/archlinux/\$repo/os/\$arch
Server = http://archlinux.surlyjake.com/archlinux/\$repo/os/\$arch
Server = http://mirror.lty.me/archlinux/\$repo/os/\$arch
Server = http://mirrors.sonic.net/archlinux/\$repo/os/\$arch
EOF

# The paragraph of packages is all of the Chrome dependencies.
# That's followed by "base" packages (edited for shit like nano)
# followed by my needs. fakeroot and pkgconf might be misplaced

pacstrap /mnt \
adwaita-icon-theme at-spi2-atk at-spi2-core atk avahi \
cairo cantarell-fonts colord dconf desktop-file-utils \
fribidi gdk-pixbuf2 glib-networking gsettings-desktop-schemas \
gtk-update-icon-cache hicolor-icon-theme jasper js52 \
json-glib lcms2 libcanberra libcroco libdaemon libdatrie \
libgusb libproxy librsvg libsoup libthai libxcomposite \
libxkbcommon libxrandr lzo nspr pango polkit rest \
shared-mime-info sound-theme-freedesktop tdb \
wayland-protocols gtk3 libcups libxss nss \
              bash \
              bzip2 \
              coreutils \
              cronie \
                 run-parts \
              cryptsetup \
              device-mapper \
              dhcpcd \
              diffutils \
              e2fsprogs \
              file \
              filesystem \
              findutils \
              gawk \
              gcc-libs \
              gettext \
              glibc \
              grep \
              gzip \
              inetutils \
              iproute2 \
              iputils \
              less \
              linux \
              logrotate \
              man-db \
              man-pages \
              netctl \
              pacman \
              pciutils \
              perl \
              procps-ng \
              psmisc \
              sed \
              shadow \
              sysfsutils \
              systemd-sysvcompat \
              tar \
              usbutils \
              util-linux \
              which \
              alsa-utils \
              conky \
	      dialog \
	      feh \
	      gcc \
	      git \
	      grub \
	      fakeroot \
	      make \
              patch \
	      pkgconf \
              scrot \
	      sshfs \
	      sudo \
	      vim \
	      wpa_supplicant \
	      ttf-liberation \
	      upower \
              unclutter \
              xorg-xset \
              xorg-xsetroot \
	      xorg-server \
	      xorg-xinit || exit

genfstab -U /mnt >> /mnt/etc/fstab

# We want wifi, ideally without posting passwords online
# Here's my solution for wifi at first boot.
cp /run/netctl/wpa_supplicant-wlo1.conf /mnt/.wifi

curl http://mike.dog/arch2.sh -o /mnt/continue_installation.sh
chmod +x /mnt/continue_installation.sh

arch-chroot /mnt ./continue_installation.sh

reboot
