#!/bin/bash

echo Step one is boot into the Arch live environment, and save an image of the existing drive to a USB device.
echo Step two is zero out the existing drive.
echo Step three is to fdisk and mkfs the partitions you want.
echo
echo if you did these things, you can safely continue.

exit

# arch.sh
# v0.0.4
# Mike Jordan

# Installs Arch Linux, dwm, and Google Chrome on a Stream14 Laptop in Southwestern U.S.

timedatectl set-ntp true

mount /dev/mmcblk0p1 /mnt || exit

cat > /etc/pacman.d/mirrorlist << EOF
Server = http://mirrors.kernel.org/archlinux/\$repo/os/\$arch
Server = http://mirrors.ocf.berkeley.edu/archlinux/\$repo/os/\$arch
Server = http://archlinux.surlyjake.com/archlinux/\$repo/os/\$arch
Server = http://mirror.lty.me/archlinux/\$repo/os/\$arch
Server = http://mirrors.sonic.net/archlinux/\$repo/os/\$arch
EOF

pacstrap /mnt conky \
              bash \
              bzip2 \
              coreutils \
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
              lvm2 \
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
	      xorg-server \
	      xorg-xinit || exit

genfstab -U /mnt >> /mnt/etc/fstab

curl http://mike.dog/arch2.sh -o /mnt/continue_installation.sh
echo Run ./continue_installation.sh now from the chroot environment.

arch-chroot /mnt

