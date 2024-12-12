##############################
#!/bin/bash

BASEURL="https://cs6.swfu.edu.cn/~wx672"
WGET="wget --no-check-certificate"
EMAIL="wx672ster@gmail.com"
DOTFILE="$HOME/.dotfile"

MSG_NOTE="This script WON'T work unless you have the Debian base system successfully installed. If not yet, follow my installation guide to do it now.

	- "$BASEURL"/debian-install/install.html

NOTE: Do NOT set root password while installing the base system!"

MSG_CONGRATS="Now, I am going to reboot your computer.

Upon finishing boot up, if you are lucky to see the mouse cursor showing on the screen, you can hit
     * Super-t to bring up a terminal. Or,
     * Super-F1 to show the cheat sheet.
     * use 'nmtui' to activate your wifi.
     * trigger Chinese input (fcitx5) by hitting Shift-space. Try fcitx5-configtool otherwise. 

If the time is not correctly set, do:

		sudo dpkg-reconfigure tzdata

If the mouse cursor isn't there at all, that probably means the Xorg doesn't work well. This usually has something to do with the graphic card driver. In this unlucky case, you have to ask google for more info.

Have fun!"

TRY_NET="Try:\n\n
1. Make sure your Ethernet cable is firmly connected.\n
2. Press Ctrl-Alt-F2 to login another console.\n
3. Type 'sudo dhclient' to get an IP address. If succeed,\n
4. Type Ctrl-Alt-F1 to come back and continue.\n\n
If you can't fix it, quit."

TRY_APT="It could be:\n\n
1. A network failure. If so, you should go fix it, and come back to continue.\n
2. A server side error (server down? git repo changed?). In this case, you should quit this script, and alarm me with a bug report ($EMAIL)."

TRY_SUDO="You shouldn't have set the root password while installing the base system! Now you have to install 'sudo' yourself.\n\n
1. Type Ctrl-Alt-F2 to open another console. login as root.\n
2. Install 'sudo' by typing 'apt install sudo'. \n
3. Type Ctrl-Alt-F1 to come back and continue."

ERR_USAGE=1
ERR_QUIT=2
ERR_APT=3
ERR_NET=4

### Use equivs-build: wx672-mandatory, wx672-recommend, wx672-chinese instead.
# PKG_IMP="alsa-utils aptitude aria2 bash-completion blight bluetooth ca-certificates curl debconf dwm dzen2 git git-extras info init iputils-ping isc-dhcp-client isenkram iw less libpam-tmpdir linux-image-amd64 mosh nano neovim network-manager os-prober pipewire-audio rename rfkill stow stterm sudo systemd-resolved systemd-timesyncd tmux tmux-plugin-manager udiskie wpasupplicant xorg xsel wmctrl whiptail"

# use isenkram to handle firmwares 
#firmware-linux-nonfree firmware-misc-nonfree firmware-amd-graphics firmware-iwlwifi 
# PKG_REC="apt-file bat catdoc cht.sh convmv default-jre dialog dict dict-foldoc dict-gcide dict-jargon dict-vera dict-wn dosfstools du-dust elpa-pdf-tools-server emacs emacs-common-non-dfsg eza fd-find ffmpeg firmware-linux-free fzf g++ gawk gcc gdb git-delta global hunspell imagemagick ipcalc keynav kmscon lf libnotify-bin libreoffice-calc libreoffice-impress libreoffice-writer libreoffice-qt6 libtext-csv-xs-perl lloconv lpdf lshw make manpages-posix manpages-posix-dev mdp mihomo mpv mupdf nala ncat netcat-openbsd nmap notification-daemon nsxiv ntfs-3g org-mode-doc pandoc parted poppler-utils profile-sync-daemon procs proxychains4 pulsemixer pv pqiv qrcp qutebrowser qt6ct ripgrep rofi rsync tcpdump tlp tmate tpp ttyrec unar universal-ctags visidata vivid wamerican-insane wezterm wireless-regdb xbanish xlsx2csv zathura zoxide"

# PKG_CHN="fcitx5 fcitx5-config-qt fcitx5-frontend-gtk2 fcitx5-frontend-all fcitx5-chinese-addons fcitx5-module-cloudpinyin fcitx5-pinyin fonts-noto-cjk fonts-wqy-microhei im-config"

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

	until echo "HEAD / HTTP/1.0" >/dev/tcp/cs6.swfu.edu.cn/80
	do
		errbox "cs6 is unreachable!" "$TRY_NET"
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
deb http://ftp.cn.debian.org/debian/ sid main contrib non-free non-free-firmware
deb https://mirror.sjtu.edu.cn/debian/ sid main contrib non-free non-free-firmware
deb https://mirrors.bfsu.edu.cn/debian/ sid main contrib non-free non-free-firmware
EOF

	cat <<EOF | sudo tee /etc/apt/sources.list.d/cs6.list
deb [trusted=yes] https://cs6.swfu.edu.cn/debian /
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
MIRRORS=( 'http://ftp.cn.debian.org/debian,https://mirrors.ustc.edu.cn/debian,https://mirrors.bfsu.edu.cn/debian' )
EOF
}

dist_upgrade(){
	colorEcho $INFO "Upgrading the base system..."

	until { sudo apt-get update && sudo apt-get -y dist-upgrade; }; do
		errbox "apt update/dist-upgrade failed" "Most probably a network problem. $TRY_NET"
	done

	colorEcho $SUCCESS "Done upgrading the base system!"
}

more_pkgs(){
	# apt-fast is from https://cs6.swfu.edu.cn/debian/pool/
	sudo apt-get -y install aria2 apt-fast
	
	# $WGET $BASEURL/debian-install/apt-fast.deb && {
	#   sudo dpkg -i apt-fast.deb && \
		# 		rm -f apt-fast.deb || \
		# 		colorEcho $ERR "Failed installing apt-fast!";
	# 	}

	# mywhiptail -m "$(echo $PKG_IMP $PKG_REC $PKG_CHN | wc -w)+ packages to be installed!" \
	mywhiptail -m "Hundreds of packages to be installed!" \
	   "This step usually takes about an hour to finish. It could take longer if your network is slow."

	if APT=$(command -v apt-fast) && command -v aria2c; then
		colorEcho $INFO "Great! Found both apt-fast and aria2c."
	else
		APT="apt-get"
	fi
           
	# until sudo $APT install -y $PKG_IMP; do
	until sudo $APT install -y wx672-mandatory; do
		errbox "$APT install wx672-mandatory failed!" \
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
	
	# until sudo $APT install -y $PKG_REC; do
	until sudo $APT install -y wx672-recommend; do
		errbox "$APT install wx672-recommend failed!" \
			   "In case of a networking problem, $TRY_NET"
	done
	
	# until sudo $APT install -y $PKG_CHN; do
	until sudo $APT install -y wx672-chinese; do
		errbox "$APT install wx672-chinese failed!" \
			   "In case of a networking problem, $TRY_NET"
	done

	until sudo $APT install -y wx672exe wx672cli; do
		errbox "$APT install wx672exe wx672cli failed!" \
			   "In case of a networking problem, $TRY_NET"
	done

	until sudo $APT install -y wx672fonts; do
		errbox "$APT install wx672fonts failed!" \
			   "In case of a networking problem, $TRY_NET"
	done

	unset APT
	command -v xterm && sudo apt purge xterm
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
	
	until git clone $BASEURL/dotfile/.git $DOTFILE;	do
		errbox "git clone dotfile failed" "$TRY_APT"
	done

	rm -f .gitconfig # replaced later with ~/.config/git/config

	> .xsession-errors && sudo chattr +i .xsession-errors

	###### stow ######
	rm -f $HOME/{.bash*,.profile}

	mkdir -p .config/tmux .local/share .emacs.d .cache/emacs/etc/yasnippet

	cd $DOTFILE
	
	# bin is no longer stowed since it's managed by wx672cli now.
	until stow -Rt $HOME applications aria2 bash bash-completion bat cheat dot.config emacs fcitx5 fontconfig git gtk* helix help home keynav latexmk less lf lftp mpv mime nvim pandoc picom psd qutebrowser ripgrep rofi starship systemd tmate tmux visidata vivid w3m wallpapers wezterm xorg yt-dlp zathura zellij;	do
		errbox "Error stowing some packages" "Fix this in another console (Ctrl-Alt-F2) and then come back to continue."
	done	
}

misc_files()
{ 
	colorEcho $INFO "Downloading misc files..."
	
	local DIR="$HOME/tmp"
	mkdir -p $DIR
	#stterm.deb,dwm.deb,
	until $WGET -nc -P $DIR $BASEURL/debian-install/misc/{catppuccin.tgz,elpa.tgz,tmux-plugins.tgz,cn/dict-cn.tgz,media-test.mp4}; do
		errbox "Failed downloading misc files" "$TRY_APT"
	done
	
	# sudo dpkg -i $DIR/*.deb
	
	tar xf $DIR/elpa.tgz         -C $HOME/.emacs.d/
	tar xf $DIR/catppuccin.tgz   -C $HOME/.config/qutebrowser/
	tar xf $DIR/tmux-plugins.tgz -C $HOME/.config/tmux/

	sudo tar xf $DIR/dict-cn.tgz -C /usr/share/dictd/ && {
		sudo dpkg-reconfigure --frontend noninteractive dictd
	}

	### Fonts (obsolete)
	### use wx672fonts.deb instead
	# until aria2c -d $DIR --no-conf -x16 $BASEURL/debian-install/misc/fonts.txz; do
	# 	errbox "Failed downloading misc files" "$TRY_APT"
	# done

	sudo chown -R $USER:$USER /usr/local
	# tar xf $DIR/fonts.txz -C /usr/local/share/

	# sudo mkdir -p /usr/local/share/fonts/truetype/nerd-fonts
	# sudo tar zxf $DIR/FiraCodeNerdFont.tgz -C /usr/local/share/fonts/truetype/nerd-fonts/
	
	### Populating /usr/local/bin/
	# sudo cp $DOTFILE/usr/local/bin/* /usr/local/bin/ # cheat, ffcast, sk, uni
	# sudo mv $DIR/starship /usr/local/bin 
	# sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
	rm -rf $DIR

	### Enable user services
	for s in emacs fcitx picom udiskie xbanish; do
		systemctl --user enable $s
	done
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
	local WM="$(command -v dwm)"
	[ "$WM" ] && sudo update-alternatives --set x-window-manager "$WM"

	local WEZ="/usr/local/bin/open-wezterm-here"
	local ST="$(command -v st)"

	[ "$WEZ" ] && sudo update-alternatives --set x-terminal-emulator "$WEZ" \
					   || sudo update-alternatives --set x-terminal-emulator "$ST"

	sudo update-alternatives --install /usr/local/bin/cat cat /usr/bin/cat 30
	sudo update-alternatives --install /usr/local/bin/cat cat /usr/bin/batcat 50
	batcat cache --build
	sudo chmod 755 /usr/local/bin/*
}

############# Real work starts here ##############

sudo debconf-set-selections <<EOF
tzdata	tzdata/Areas	select	Asia
tzdata	tzdata/Zones/Asia	select	Shanghai
tzdata	tzdata/Zones/Etc	select	UTC
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
