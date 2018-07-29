#!/bin/bash

echo Step one is boot into the Arch live environment, and save an image of the existing drive to a USB device.
echo Step two is zero out the existing drive.
echo Step three is to fdisk and mkfs the partitions you want.
echo
echo if you did these things, you can safely continue.

exit

# arch.sh
# v0.0.6
# Mike Jordan

# Installs Arch Linux and dwm on a Stream14 Laptop in Southwestern U.S.
# For a user account named mike. The stream should have a single linux
# partition on it's drive named mmcblk0p1. This is a very narrow use case. 

timedatectl set-ntp true

mount /dev/mmcblk0p1 /mnt || exit

cat > /etc/pacman.d/mirrorlist << EOF
Server = http://mirrors.kernel.org/archlinux/\$repo/os/\$arch
Server = http://mirrors.ocf.berkeley.edu/archlinux/\$repo/os/\$arch
Server = http://archlinux.surlyjake.com/archlinux/\$repo/os/\$arch
Server = http://mirror.lty.me/archlinux/\$repo/os/\$arch
Server = http://mirrors.sonic.net/archlinux/\$repo/os/\$arch
EOF

# Chrome dependencies follwed by base packages (edited) followed by my needs

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
	      sshfs \
	      sudo \
	      vim \
	      wpa_supplicant \
	      ttf-liberation \
	      upower \
              unclutter \
              xorg-xsetroot \
	      xorg-server \
	      xorg-xinit || exit

genfstab -U /mnt >> /mnt/etc/fstab

cp /run/netctl/wpa_supplicant-wlo1.conf /mnt/.wifi

curl http://mike.dog/arch2.sh -o /mnt/continue_installation.sh
echo Run ./continue_installation.sh now from the chroot environment.

arch-chroot /mnt

