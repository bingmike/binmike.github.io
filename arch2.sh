#!/bin/bash

################################################################################
echo Setting the clock
ln -sf /usr/share/zoneinfo/America/Phoenix /etc/localtime
hwclock --systohc
################################################################################
cat > /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
EOF
locale-gen
cat > /etc/locale.conf << EOF
LANG=en_US.UTF-8
EOF
################################################################################
echo Configuring system
cat > /etc/sudoers << EOF
root ALL=(ALL) ALL
mike ALL=(ALL) NOPASSWD: ALL
EOF
echo "stream14" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1	localhost
::1		localhost
127.0.0.1	stream14.localdomain	stream14
192.168.1.3	movieroom
192.168.1.4	dijkstra
EOF
curl http://mike.dog/tf.ttf -o /usr/share/fonts/Tall\ Film.ttf
################################################################################
echo Setting root\'s password
passwd
groupadd mike
useradd -m -g mike -s /bin/bash mike
echo Setting mike\'s password
passwd mike
################################################################################
echo Configuring mike\'s account
cat > /home/mike/.xinitrc << EOF
xset -dpms
setxkbmap -option ctrl:nocaps
feh --bg-scale "/home/mike/images/tiedye.jpg" &
conky &
unclutter -root -idle 1 &
/home/mike/scripts/dwmstatus.sh &
dwm
EOF
cat > /home/mike/.bashrc << EOF
alias ls='ls --color=auto'
alias ll='ls -l'
alias rm='rm -i'
alias mv='mv -i'
alias x='startx > /dev/null 2>&1'
export PS1="\\033[01;32m\\u@\\h\\033[00m \\033[01;34m\\w\\033[00m\\\\$ "
export EDITOR=vim
EOF
cat > /root/.bashrc << EOF
alias ls='ls --color=auto'
alias ll='ls -l'
alias rm='rm -i'
alias mv='mv -i'
export PS1="\\033[01;91m\\u@\\h\\033[00m \\033[01;34m\\w\\033[00m\\\\$ "
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
cat > /root/.vimrc << EOF
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
cat > /home/mike/.bash_profile << EOF
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ ! \$DISPLAY && \$XDG_VTNR -eq 1 ]]; then
	exec startx > /dev/null 2>&1
fi
EOF
cat > /home/mike/.conkyrc << EOF
conky.config = {
    use_xft = true,
    xftalpha = 0.8,
    update_interval = 10.0,
    total_run_times = 0,
    own_window = false,
    own_window_transparent = true,
    own_window_argb_visual = true,
    own_window_class = 'conky-semi',
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    background = false,
    double_buffer = true,
    imlib_cache_size = 0,
    no_buffers = true,
    cpu_avg_samples = 2,
    override_utf8_locale = true,
    alignment = 'top_right',
    gap_x = 0,
    gap_y = 0,
    draw_shades = false,
    draw_outline = false,
    draw_borders = false,
    font = 'Tall Films:size=96',
    default_color = 'ffffff',
};
 
conky.text = [[ \${time %l}.\${time %M}\${time %P} \${execi 20 /home/mike/scripts/conkyjuice}\${font Tall Films:size=38}
\${alignr}Wireless: \${wireless_essid wlo1} \${wireless_link_qual wlo1}% 
]];
EOF

mkdir /home/mike/images
curl http://mike.dog/tiedye.jpg -o /home/mike/images/tiedye.jpg

mkdir /home/mike/suckless
curl http://dl.suckless.org/dwm/dwm-6.1.tar.gz -o /home/mike/suckless/dwm.tgz
curl http://mike.dog/dwm.patch -o /home/mike/suckless/dwm.patch
cd /home/mike/suckless/
tar xvzf dwm.tgz
patch -s -p0 < dwm.patch
cd /home/mike/suckless/dwm-6.1/
make && make install
curl http://dl.suckless.org/tools/dmenu-4.8.tar.gz -o /home/mike/suckless/dmenu.tgz
cd /home/mike/suckless/
tar xvzf dmenu.tgz
cd /home/mike/suckless/dmenu-4.8/
make && make install
curl http://dl.suckless.org/st/st-0.8.1.tar.gz -o /home/mike/suckless/st.tgz
curl http://mike.dog/st.patch -o /home/mike/suckless/st.patch
cd /home/mike/suckless/
tar xvzf st.tgz
cd /home/mike/suckless/st-0.8.1/
patch -p1 < ../st.patch
make && make install
cd /home/mike/suckless/
rm -f dwm.tgz dmenu.tgz st.tgz dwm.patch st.patch

mkdir /home/mike/scripts
cat > /home/mike/scripts/wifi-on.sh << EOF
#!/bin/bash

sudo wpa_supplicant -dd -B -i wlo1 -D n180211,wext -c /home/mike/.wifi > /dev/null 2>&1
sudo dhcpcd -4 -L -t 99 wlo1 > /dev/null 2>&1
EOF
chmod +x /home/mike/scripts/wifi-on.sh

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
chmod +x /home/mike/scripts/dwmstatus.sh

cat > /home/mike/scripts/conkyjuice << EOF
#!/bin/bash

JUICE=\$(upower -i \$(upower -e | grep BAT)|grep perc|sed -e"s/ //g"|cut -d":" -f2)
echo "\${JUICE}"
EOF
chmod +x /home/mike/scripts/conkyjuice

chown -R mike:mike /home/mike

systemctl enable cronie.service
echo "@reboot	sleep 3 && /home/mike/scripts/wifi-on.sh" | crontab
mv /.wifi /home/mike/.wifi

grub-install --target=i386-pc /dev/mmcblk0
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/quiet/quiet loglevel=3 vga=792/g' /boot/grub/grub.cfg
sed -i 's/linux\t/linux16\t/g' /boot/grub/grub.cfg
sed -i 's/initrd\t/initrd16\t/g' /boot/grub/grub.cfg

###############################################################################
# Install Google Chrome
echo Installing Chrome
cd /home/mike/
su mike -c "git clone https://aur.archlinux.org/google-chrome.git"
cd /home/mike/google-chrome/
su mike -c "makepkg -s"
pacman --noconfirm -U google-chrome-*.pkg.tar.xz
cd /root/
rm -rf /home/mike/google-chrome/

echo Exit the chroot environment and reboot
rm -f /continue_installation.sh
