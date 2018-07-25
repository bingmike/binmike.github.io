#!/bin/bash

echo Step one is to understand that this script overwrites system files
echo Uh-oh, we are already goimg.

# Typos in a previous version of this line resulted in a jacked up clock
ln -sf /usr/share/zoneinfo/America/Phoenix /etc/localtime
hwclock --systohc

cat > /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
EOF
locale-gen

cat > /etc/locale.conf << EOF
LANG=en_US.UTF-8
EOF

# I added NOPASSWD to mike because I was doing a remote install and couldn't
# get my terminal (Android app JuiceSSH) to work with a sudo password. If this
# is too much (it isn't) then just remove it.

cat > /etc/sudoers << EOF
root ALL=(ALL) ALL
mike ALL=(ALL) NOPASSWD: ALL
EOF

echo "stream14" > /etc/hostname

cat > /etc/hosts << EOF
127.0.0.1	localhost
::1		localhost
127.0.1.1	stream14.localdomain	stream14
192.168.1.3	movieroom
192.168.1.4	dijkstra
EOF

# User Setup

echo Set root password
passwd
groupadd mike
useradd -m -g mike -s /bin/bash mike
echo Set mike password
passwd mike
cat > /home/mike/.xinitrc << EOF
feh --bg-scale "/home/mike/images/hummer.png" &
/home/mike/scripts/dwmstatus.sh &
dwm
EOF
cat > /home/mike/.bashrc << EOF
alias ls='ls --color=auto'
alias ll='ls -l'
alias rm='rm -i'
alias mv='mv -i'
alias x='startx > /dev/null 2>&1'
setxkbmap -option ctrl:nocaps
export PS1="[[\\033[01;32m\\]\\u@\\h[\\033[01;00m\\] [\\033[01;32m\\]\\w[\\033[01;00m\\]]$ "
export EDITOR=vim
EOF
cat > /home/mike/.vimrc << EOF
set number
colorscheme default
set cursorline
set lazyredraw
set noshowmatch
set incsearch
set hlsearch
set nowrap
syntax on
EOF
cat > /home/mike/.profile << EOF
xset -dpms
EOF
mkdir /home/mike/images
curl http://mike.dog/hummer.png -o /home/mike/images/hummer.png
mkdir /home/mike/suckless
curl http://dl.suckless.org/dwm/dwm-6.1.tar.gz -o /home/mike/suckless/dwm.tgz
curl http://dl.suckless.org/tools/dmenu-4.8.tar.gz -o /home/mike/suckless/dmenu.tgz
curl http://dl.suckless.org/st/st-0.8.tar.gz -o /home/mike/suckless/st.tgz
mkdir /home/mike/scripts
cat > /home/mike/scripts/dwmstatus.sh << EOF
#!/bin/bash

while true
do
	upower -i \$(upower -e|grep bat)|grep state|grep disch > /dev/null && CHARGING="v" || CHARGING="^"
	LOAD=\$(uptime|sed -e"s/ //g"|cut -d"v" -f2|cut -d":" -f2|cut -d"," -f1)
	JUICE=\$(upower -i \$(upower -e | grep BAT)|grep perc|sed -e"s/ //g"|cut -d":" -f2)
	xsetroot -name "\$(date +"%A,  %B %-d, %Y  |  %-I:%M %P")  |  \${LOAD}  |  \${JUICE}\${CHARGING}"
	sleep 10
done
EOF

chown -R mike:mike /home/mike

grub-install --target=i386-pc /dev/mmcblk0
grub-mkconfig -o /bot/grub/grub.cfg

echo Exit the chroot environment and reboot
