#!/bin/bash

echo Step one is boot into the Arch live environment, and save an image of the existing drive to a USB device.
echo Step two is zero out the existing drive.
echo Step three is to fdisk and mkfs the partitions you want.
echo
echo You should have both arch1.sh and arch2.sh here, so wifi-menu is already set up?
echo
echo if you did all of these things, you can safely continue.

exit

# If it's been forever, and you don't remember the commands:
#
# To save an image of an existing drive (usually /dev/mmcblk0 or mmcblk1 on stream14):
#
# Boot into the arch live environment, and mount a thumbdrive to save the image
# Run dd if=/dev/mmcblk0 conv=sync,noerror bs=8192K status=progress | gzip -c > td/backupname.img.gz
#
# To zero out the stream14 drive device, run:
# dd if=/dev/zero of=/dev/mmcblk0 bs=16384K status=progress
#
# This will obliterate the drive, so you need to repartition with fdisk or something.
# Don't forget to at least mkfs.ext4 /dev/mmcblk0p1. If you've forgotten how to do
# these things, something is wrong with your head

timedatectl set-ntp true

# mount file systems as necessary. If you're doing anything more
# complex than "everything on one partition", probably should consult
# arch install guide here

# Even so much as a swap partition necessiatates a little more effort here.

mount /dev/mmcblk0p1 /mnt || exit

# Point pacman to the fastest mirror
cat > /etc/pacman.d/mirrorlist << EOF
Server = http://mirrors.kernel.org/archlinux/\$repo/os/\$arch
Server = http://mirrors.ocf.berkeley.edu/archlinux/\$repo/os/\$arch
Server = http://archlinux.surlyjake.com/archlinux/\$repo/os/\$arch
Server = http://mirror.lty.me/archlinux/\$repo/os/\$arch
Server = http://mirrors.sonic.net/archlinux/\$repo/os/\$arch
EOF

pacstrap /mnt base \
	      dialog \
	      feh \
	      gcc \
	      git \
	      grub \
	      fakeroot \
	      make \
	      pkgconf \
	      sshfs \
	      sudo \
	      vim \
	      wpa_supplicant \
	      ttf-liberation \
	      upower \
	      xorg \
	      xorg-apps \
	      xorg-server \
	      xorg-xinit || exit

genfstab -U /mnt >> /mnt/etc/fstab

echo Run ./arch2.sh now from the chroot environment.
mv arch2.sh /mnt
arch-chroot /mnt

