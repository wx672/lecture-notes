#!/bin/bash

BASEURL="https://cs6.swfu.edu.cn/~wx672"
WGET="wget --no-check-certificate"
EMAIL="wx672ster@gmail.com"
DOTFILE="$HOME/.dotfile"

MSG_NOTE="This script WON'T work unless you have the Debian base system successfully installed. If not yet, follow my installation guide to do it now.

	- https://cs6.swfu.edu.cn/~wx672/debian-install/install.html

NOTE: DO NOT set the root password while installing the base system!"

MSG_CONGRATS="Now, I am going to reboot your computer.

Upon finishing boot up, if you are lucky to see the mouse cursor showing on the screen, you can hit
       * Super-t to bring up a terminal. Or,
       * Super-F1 to show the cheat sheet.
       * use 'nmtui' to activate your wifi.
       * trigger Chinese input (fcitx5) by hitting Shift-space. Try fcitx5-configtool otherwise. 

If the mouse cursor isn't there at all, that probably means the Xorg doesn't work well. This usually has something to do with the graphic card driver. In this unlucky case, you have to ask google for more info.

Have fun!"

PKG_IMP="alsa-utils aptitude aria2 bash-completion blight bluetooth ca-certificates curl debconf default-jre dialog dosfstools dzen2 git git-extras info init iputils-ping isc-dhcp-client isenkram iw less libpam-tmpdir linux-image-amd64 mosh nano neovim network-manager os-prober pipewire-audio rename rfkill stow sudo systemd-resolved systemd-timesyncd tmux tmux-plugin-manager udiskie wpasupplicant xorg xsel wmctrl whiptail"

# use isenkram to handle firmwares 
#firmware-linux-nonfree firmware-misc-nonfree firmware-amd-graphics firmware-iwlwifi 
PKG_REC="alacritty apt-file bat catdoc cht.sh cmark convmv dict dict-foldoc dict-gcide dict-jargon dict-vera dict-wn elpa-pdf-tools-server emacs emacs-common-non-dfsg eza fd-find ffmpeg firmware-linux-free fzf g++ gawk gcc gdb global hunspell imagemagick ipcalc keynav kmscon lf libnotify-bin libreoffice-calc libreoffice-impress libreoffice-writer libreoffice-qt6 libtext-csv-xs-perl lshw lynx make manpages-posix manpages-posix-dev mdp mpv mupdf mupdf-tools netcat-openbsd nmap notification-daemon nsxiv ntfs-3g org-mode-doc 7zip-rar pandoc parted poppler-utils profile-sync-daemon proxychains4 pulsemixer pv pqiv qutebrowser qt6ct rar ripgrep rofi rsync tcpdump tlp tmate tpp ttyrec universal-ctags unoconv unrar visidata vivid wamerican-insane wireless-regdb xbanish xlsx2csv zathura zoxide"

PKG_CHN="fcitx5 fcitx5-chinese-addons fcitx5-config-qt fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt5 fcitx5-module-cloudpinyin fcitx5-module-pinyinhelper fcitx5-module-punctuation fcitx5-module-xorg fonts-arphic-ukai fonts-arphic-uming fonts-noto-cjk fonts-wqy-microhei fonts-wqy-zenhei im-config"

TRY_NET="Try:\n\n
1. Make sure your Ethernet cable is firmly connected.\n
2. Press Ctrl-Alt-F2 to login another console.\n
3. Type 'sudo dhclient' to get an IP address. If succeed,\n
4. Type Ctrl-Alt-F1 to come back and continue.\n\n
If you can't fix it, quit."

TRY_APT="It could be:\n\n
1. A network failure. If so, you should go fix it, and come back to continue.\n
2. A server side error (server down? git repo changed?). In this case, you should quit this script, and alarm me with a bug report ($EMAIL)."

TRY_SUDO="You shouldn't set the root password while installing the base system! Now you have to install 'sudo' yourself.\n\n
1. Type Ctrl-Alt-F2 to open another console. login as root.\n
2. Install 'sudo' by typing 'apt install sudo'. \n
3. Type Ctrl-Alt-F1 to come back and continue."

ERR_USAGE=1
ERR_QUIT=2
ERR_APT=3
ERR_NET=4

######### Color output #########
ERR=$(tput setaf 1)     # red
INFO=$(tput setaf 6)    # cyan
SUCCESS=$(tput setaf 2) # green
#WARN=$(tput setaf 3)   # yellow
#BOLD=$(tput bold)

colorEcho()
{
	echo -e $(tput bold)"$1""$2"$(tput sgr0)
}
################################

pause(){
	colorEcho $INFO "\nNow, press any key to continue..."

	while :
	do
		for s in / - \\ \|
		do
			printf "\r$s"
			sleep .1
		done
        read -s -n1 -t 0.1 && break
	done
    echo -en "\r \r" # wipe out the waiting -\|/
}

pause_err(){
	colorEcho $INFO "\nPress q to quit, or any other key to continue..."
    while read -s -n1
    do
		case $REPLY in
			q) exit $ERR_INT ;;
			*) break ;;
		esac
    done
}

errbox()
{
	# title
	colorEcho $ERR "*** ${1}! ***"
	# body
	echo -e $2
	pause_err
}

# https://funprojects.blog/2022/04/06/text-interfaces-with-whiptail-and-dialog/
mywhiptail(){
	while getopts :Eym OPT; do
		case $OPT in
			E) export NEWT_COLORS='textbox=white,red actbutton=red,white'
			   ;;
			y) CMD='--yes-button Continue --no-button Quit --yesno '
			   ;;
			m) CMD='--msgbox '
			   ;;
			?) exit 1
		esac
	done
	shift $(( OPTIND - 1 ))
	OPTIND=1

	whiptail --title "$1" $CMD "$2" 20 80
}

checkIP(){
	colorEcho $INFO "Checking network..."

	until ip r | grep -q default
	do
		colorEcho $ERR 'Error: You are offline!'
		echo "Trying dhclient..."
		until sudo dhclient
		do
			errbox "Failed to get an IP address" "Cannot proceed without Internet. $TRY_NET"
		done
	done
	
	colorEcho $SUCCESS 'Great! We are online!'
	colorEcho $INFO "Checking cs6 reachability..."

	until ping -c3 cs6.swfu.edu.cn
	do
		errbox "cs6 is unreachable" "$TRY_NET"
	done
	
	colorEcho $SUCCESS "cs6 is reachable!"
}

sudo_nopass(){
	colorEcho $INFO "adding /etc/sudoers.d/$USER"
	
	until command -v sudo
	do
		mywhiptail -Em "Error: sudo is not installed!" "$TRY_SUDO"
	done
	
	sudo tee /etc/sudoers.d/$USER <<<"$USER    ALL = NOPASSWD: ALL"
	sudo chmod 440 /etc/sudoers.d/$USER
}

apt_setup()
{
    # sources.list
	colorEcho $INFO "Populating /etc/apt/sources.list ..."
    
    cat <<EOF | sudo tee /etc/apt/sources.list
deb http://mirrors.163.com/debian     sid main contrib non-free non-free-firmware
deb http://ftp2.cn.debian.org/debian  sid main contrib non-free non-free-firmware
deb http://mirrors.ustc.edu.cn/debian sid main contrib non-free non-free-firmware
# deb http://mirrors.163.com/debian testing main contrib non-free non-free-firmware
# deb http://mirrors.163.com/debian testing-updates main contrib non-free non-free-firmware
# deb http://mirrors.163.com/debian testing-proposed-updates main contrib non-free non-free-firmware
# deb http://ftp2.cn.debian.org/debian testing main contrib non-free non-free-firmware
# deb http://ftp2.cn.debian.org/debian testing-updates main contrib non-free non-free-firmware
# deb http://ftp2.cn.debian.org/debian testing-proposed-updates main contrib non-free non-free-firmware
# deb http://mirrors.ustc.edu.cn/debian testing main contrib non-free non-free-firmware
# deb http://mirrors.ustc.edu.cn/debian testing-updates main contrib non-free non-free-firmware
# deb http://mirrors.ustc.edu.cn/debian testing-proposed-updates main contrib non-free non-free-firmware
EOF

	# sometimes have to try -t=sid -t=testing to get around dep issues
	# colorEcho $INFO "Populating /etc/apt/preferences.d/ ..."

	# sudo mkdir -p /etc/apt/preferences.d

# 	cat <<EOF | sudo tee /etc/apt/preferences.d/stable.pref
# Package: *
# Pin: release a=stable
# Pin-Priority: 900
# EOF

# 	cat <<EOF | sudo tee /etc/apt/preferences.d/testing.pref
# Package: *
# Pin: release a=testing
# Pin-Priority: 400
# EOF

# 	cat <<EOF | sudo tee /etc/apt/preferences.d/unstable.pref
# Package: *
# Pin: release a=unstable
# Pin-Priority: 50
# EOF

	cat <<EOF | sudo tee /etc/apt-fast.conf
DOWNLOADBEFORE=true
MIRRORS=( 'http://mirrors.163.com/debian,http://mirrors.ustc.edu.cn/debian,http://ftp2.cn.debian.org/debian' )
EOF
}

dist_upgrade(){
	colorEcho $INFO "Upgrading the base system..."

	until { sudo apt-get update && sudo apt-get -t=sid -y dist-upgrade; }; do
		errbox "apt update/dist-upgrade failed" "Most probably a network problem. $TRY_NET"
	done

	colorEcho $SUCCESS "Done upgrading the base system!"
}

more_pkgs(){
    sudo apt-get -y install aria2

    if $WGET $BASEURL/debian-install/apt-fast.deb
	then
	    sudo dpkg -i apt-fast.deb && \
			rm -f apt-fast.deb || \
				colorEcho $ERR "Failed installing apt-fast!";
	fi

	mywhiptail -m "$(echo $PKG_IMP $PKG_REC $PKG_CHN | wc -w)+ packages to be installed!" \
			   "This step usually takes about an hour to finish. It could take longer if your network is slow."

    if APT=$(command -v apt-fast) && command -v aria2c; then
        colorEcho $INFO "Great! Found both apt-fast and aria2c."
    else
        APT="apt-get"
    fi
           
	until sudo $APT install -y $PKG_IMP
	do
		errbox "$APT install failed for some important packages" \
			   "In case of a networking problem, $TRY_NET"
	done

	### Setup /etc/systemd/resolved.conf ###
	DNS_CONF=/etc/systemd/resolved.conf

	[[ -f $DNS_CONF ]] && {
		colorEcho $INFO "Configuring $DNS_CONF ..."

		sudo sed -i '/^DNS/d' $DNS_CONF

		sudo tee --append $DNS_CONF <<< \
			 'DNS=114.114.114.114 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112'
	}

	sudo systemctl restart systemd-resolved.service
	###############################################
	
	until sudo $APT install -y $PKG_REC
	do
		errbox "$APT install failed for some recommended packages" \
			   "In case of a networking problem, $TRY_NET"
	done
	
	until sudo $APT install -y $PKG_CHN
	do
		errbox "$APT install failed for some Chinese packages" \
			   "In case of a networking problem, $TRY_NET"
	done

    unset APT
}

dotfile()
{	
	cat<<EOF > .gitconfig 
[https]
    sslVerify = false
[http]
    sslVerify = false
EOF

	colorEcho $INFO "Cloning dotfiles from $BASEURL/dotfile/.git ..."
	
    until git clone $BASEURL/dotfile/.git $DOTFILE
	do
		errbox "git clone dotfile failed" "$TRY_APT"
	done

	# replaced later by ~/.config/git/config
	rm -f .gitconfig

	> .xsession-errors && sudo chattr +i .xsession-errors

	#stow
	
	rm -f $HOME/.bash* $HOME/.profile

	mkdir -p .config/tmux .local/share .emacs.d .cache/emacs/etc/yasnippet

	cd $DOTFILE

	until stow -R alacritty applications aria2 bash bash-completion bin cheat clash dot.config emacs fcitx5 fontconfig git gtk* help home keynav latexmk less lf lftp mpv nvim picom psd qt5ct qutebrowser ripgrep rofi starship systemd tmate tmux visidata vivid w3m wallpapers xorg yt-dlp zathura
	do
		errbox "Error stowing some packages" "Fix this in another console (Ctrl-Alt-F2) and then come back to continue."
	done	

	sudo cp $DOTFILE/usr/local/bin/* /usr/local/bin/

	sudo ln -sf /usr/bin/st /usr/local/bin/xterm
    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
    sudo ln -sf /usr/bin/batcat /usr/local/bin/cat
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
    sudo ln -sf /usr/bin/nsxiv /usr/local/bin/sxiv
}

misc_files()
{ 
	colorEcho $INFO "Downloading misc files..."
	
	local DIR="$HOME/tmp"
	test -d $DIR || mkdir $DIR
	
	until $WGET -nc -P $DIR $BASEURL/debian-install/misc/{stterm.deb,dwm.deb,elpa.tgz,tmux-plugins.tgz,FiraCodeNerdFont.tgz,cn/dict-cn.tgz,cargo.bin.tgz,media-test.mp4,clash.meta,starship}
	do
		errbox "Failed downloading misc files" "$TRY_APT"
	done
	
	sudo dpkg -i $DIR/*.deb
	
	tar zxf $DIR/elpa.tgz -C $HOME/.emacs.d/

	systemctl --user enable emacs

	tar zxf $DIR/tmux-plugins.tgz -C $HOME/.config/tmux/

	sudo tar zxf $DIR/dict-cn.tgz -C /usr/share/dictd/ && {
        sudo dpkg-reconfigure --frontend noninteractive dictd
	}

    sudo mkdir -p /usr/local/share/fonts/truetype/nerd-fonts
	sudo tar zxf $DIR/FiraCodeNerdFont.tgz -C /usr/local/share/fonts/truetype/nerd-fonts/
	
    tar zxf $DIR/cargo.bin.tgz cargo/bin/sk -O > $DIR/sk
	
	sudo mv $DIR/{clash.meta,starship,sk} /usr/local/bin && sudo chmod 755 /usr/local/bin/*
	
	rm -rf $DIR
}

auto_login(){
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
    
    cat <<EOF | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER --noclear %I \$TERM
EOF
}

locale_zh(){
    # generating locales
    cat <<EOF | sudo tee /etc/locale.gen
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
EOF
	sudo dpkg-reconfigure -fnoninteractive locales

    # update /etc/default/locale; locales have to be selected and generated in advance
    sudo update-locale \
         LANG \
         LANGUAGE="en_US:en" \
         LC_CTYPE="zh_CN.UTF-8" \
         LC_NUMERIC="en_US.UTF-8" \
         LC_TIME="en_US.UTF-8" \
         LC_COLLATE="en_US.UTF-8" \
         LC_MONETARY="en_US.UTF-8" \
         LC_MESSAGES="en_US.UTF-8" \
         LC_PAPER="en_US.UTF-8" \
         LC_NAME="en_US.UTF-8" \
         LC_ADDRESS="en_US.UTF-8" \
         LC_TELEPHONE="en_US.UTF-8" \
         LC_MEASUREMENT="en_US.UTF-8" \
         LC_IDENTIFICATION="en_US.UTF-8" \
         LC_ALL

    # config timezone
    sudo tee /etc/timezone <<<'Asia/Shanghai'
    sudo dpkg-reconfigure -fnoninteractive tzdata
}

xkey(){
    cat <<EOF | sudo tee /etc/default/keyboard 
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS="terminate:ctrl_alt_bksp,ctrl:nocaps"
BACKSPACE="guess"
EOF

	cat <<EOF | sudo tee /etc/X11/xorg.conf.d/30-libinput.conf
Section "InputClass"
    Identifier "libinput touchpad catchall"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
	Option "Tapping"	"on"
	Option "TappingDrag"	"on"
	Option "NaturalScrolling"	"on"
	Option "TappingButtonMap"	"lrm"
	Option "ClickMethod"	"clickfinger"
	Option "DisableWhileTyping"	"true"
EndSection
EOF
}

kmscon_setup()
{
	until command -v kmscon; do sudo apt install -y kmscon; done
	
	# kmscon
	sudo mkdir /etc/kmscon
	
	cat <<EOF | sudo tee /etc/kmscon/kmscon.conf
font-name=Fira Code, Noto Sans Mono CJK SC
font-size=22
font-engine=pango
palette=solarized
xkb-layout=us
xkb-options=ctrl:nocaps
grab-zoom-in=<Ctrl>equal
drm
hwaccel
EOF
	# tty2 only
	sudo systemctl disable kmsconvt@.service
	sudo systemctl  enable kmsconvt@tty2.service	
}

# no longer needed since is done by the *.postinst scripts
alternatives_setup()
{
	# x-window-manager
	WM="$(command -v dwm)"
	[ "$WM" ] && sudo update-alternatives --set x-window-manager "$WM"

	# x-terminal-emulator

	until command -v alacritty; do sudo apt install -y alacritty; done

	ALACRITTY="$(command -v alacritty)"

	# no need to install. thanks to 'dpkg -i alacritty.deb'.
    sudo update-alternatives --install /usr/bin/x-terminal-emulator \
			 x-terminal-emulator "$ALACRITTY" 90
	
	[ "$ALACRITTY" ] && {
        sudo update-alternatives --set x-terminal-emulator "$ALACRITTY"
	}
}

############# Real work starts here ##############

sudo debconf-set-selections <<EOF
tzdata	tzdata/Areas	select	Asia
tzdata	tzdata/Zones/Etc	select	UTC
tzdata	tzdata/Zones/Asia	select	Shanghai
locales	locales/locales_to_be_generated	multiselect	en_US.UTF-8 UTF-8, zh_CN.UTF-8 UTF-8
locales	locales/default_environment_locale	select	en_US.UTF-8
console-setup	console-setup/fontsize	string	16x32
console-setup	console-setup/fontface47	select	Terminus
console-setup	console-setup/fontsize-fb47	select	16x32 (framebuffer only)
console-setup	console-setup/fontsize-text47	select	16x32 (framebuffer only)
console-setup	console-setup/charmap47	select	UTF-8
dictd	dictd/run_mode	select	daemon
EOF

# use large font in console
cat <<EOF | sudo tee /etc/default/console-setup 
ACTIVE_CONSOLES="/dev/tty[1-6]"
CHARMAP="UTF-8"
CODESET="Lat15"
FONTFACE="Terminus"
FONTSIZE="16x32"
VIDEOMODE=
EOF
	
sudo dpkg-reconfigure -fnoninteractive console-setup

# Startup message
mywhiptail -y "NOTE" "$MSG_NOTE" || exit $ERR_QUIT

checkIP

sudo_nopass

apt_setup

dist_upgrade

more_pkgs

dotfile

misc_files

auto_login

locale_zh

xkey

kmscon_setup

# no longer needed since is done by the *.postinst scripts
alternatives_setup

# congrats!
unset NEWT_COLORS
mywhiptail -m "Installation completed successfully!" "$MSG_CONGRATS"

sudo reboot
