#!/bin/bash

CS6WX672="https://cs6.swfu.edu.cn/~wx672"
WGET="wget --no-check-certificate"
EMAIL="wx672ster@gmail.com"
DOTFILE="$HOME/.dotfile"

ERR_USAGE=1
ERR_INT=2

##### color code ######
ERR=$(tput setaf 1)     # red
WARN=$(tput setaf 3)    # yellow
INFO=$(tput setaf 6)    # cyan
SUCCESS=$(tput setaf 2) # green
BOLD=$(tput bold)

colorEcho(){
	echo -e $(tput bold)"$1""$2"$(tput sgr0)
}

pause(){
	colorEcho $INFO "\nNow, press any key to continue..."
    while true
    do
        printf "\r-";  sleep 0.1
        printf "\r\\"; sleep 0.1
        printf "\r|";  sleep 0.1
        printf "\r/"
        read -s -n1 -t 0.1
        [ $? -eq 0 ] && break
    done
    echo -en "\r \r" # wipe out the waiting -\|/
}

pause_err(){
	colorEcho $INFO "\nScared? Press q to quit."
	colorEcho $INFO "Feeling lucky? Press any key (other than q) to continue..."
    while read -s -n1
    do
		case $REPLY in
			q) exit $ERR_INT ;;
			*) break ;;
		esac
    done
}

note(){
	colorEcho $INFO "****************************** NOTE! ******************************"
	cat<<EOF
This script can only be used AFTER the Debian base system has been successfully installed.
If not yet, you should follow my installation guide to do it now.

	- https://cs6.swfu.edu.cn/~wx672/debian-install/install.html

NOTE: Do NOT set the root password while installing the base system.
EOF
	colorEcho $INFO "*******************************************************************"

	pause_err
}

checkIP(){
	colorEcho $INFO "Checking network..."

	while ! ip a | grep dynamic
	do
		colorEcho $ERR '****************** Oops! No IP address! ******************'
		echo "Try getting an IP address via DHCP..."
		while ! sudo dhclient
		do
			colorEcho $ERR "*** Failed to get an IP address! ***"
			cat<<EOF
You cannot continue the installation without an IP address!
Now you have two choices:
1. press q to quit the installation;
2. If you don't want to quit, press Ctrl-Alt-F2 to login another console, and try fixing the problem yourself. If succeed, press Ctrl-Alt-F1 to come back and continue.
EOF
			pause_err
		done
	done
	
	colorEcho $SUCCESS 'Great! IP address is ready!'

	cs6reachable
}

cs6reachable(){
	colorEcho $INFO "Checking cs6 reachability..."

	while ! ping -c3 cs6.swfu.edu.cn
	do
		colorEcho $ERR "********** ERROR! cs6 is unreachable! **********"
		cat<<EOF
You have two choices:
1. Press q to quit the installation;
2. Don't have to quit if the problem is on your side. You can press Ctrl-Alt-F2 to login another console, fix the network problem and then hit Ctrl-Alt-F1 to come back and continue.
EOF
		colorEcho $ERR "************************************************"
		pause_err
	done
	
	colorEcho $SUCCESS "cs6 is reachable!"
	return 0;
}

sudo_nopass(){
	colorEcho $INFO "adding /etc/sudoers.d/$USER"
	while ! type sudo
	do
		colorEcho $ERR "********** ERROR! sudo is not installed! **********"
		cat<<EOF
Oh, no, told you don't set the root password while installing the base system! Now you have to install 'sudo' yourself. 

1. Type Ctrl-Alt-F2 to open another console. login as root.
2. Install 'sudo' by typing 'apt install sudo'. 
3. Type Ctrl-Alt-F1 to come back and continue.
EOF
		colorEcho $ERR "***************************************************"
		pause_err
	done
	echo -e "$USER\tALL = NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
	sudo chmod 440 /etc/sudoers.d/$USER
}

sources_list(){
	colorEcho $INFO "Modifying /etc/apt/sources.list"
	sudo rm /etc/apt/sources.list
# 	cat <<EOF | sudo tee /etc/apt/sources.list
# deb http://ftp2.cn.debian.org/debian testing main contrib non-free
# deb http://ftp2.cn.debian.org/debian testing-updates main contrib non-free
# deb http://ftp2.cn.debian.org/debian testing-proposed-updates main contrib non-free	
# EOF
	cat <<EOF | sudo tee /etc/apt/sources.list
deb http://ftp2.cn.debian.org/debian sid main contrib non-free
EOF
}

dist_upgrade(){
	colorEcho $INFO "Upgrading the base system..."
	cat<<EOF
This step usually takes less than 30 mins. It could takes longer if your network is slow.
EOF
	pause

	while ! sudo apt update && sudo apt-get -y dist-upgrade
	do
		colorEcho $ERR "******************** SYSTEM UPGRADING FAILED! ********************"
		cat<<EOF
This is unusual. You have to check the error message carefully, and figure out what's wrong with it.Press Ctrl-Alt-F2 to login another console, fix the problem, and then come back to continue.
EOF
		colorEcho $ERR "******************************************************************"
		pause_err
	done

	colorEcho $SUCCESS "Done upgrading the base system!"
	
	sudo apt-get -y install wget
}

more_pkgs(){
	echo "Downloading package list from cs6.swfu.edu.cn..."
	cd	
	while ! $WGET $CS6WX672/debian-install/{01-important,02-recommend,03-chinese}
	do
		rm -f 0*
		colorEcho $ERR "********** Oops! Failed downloading files! **********"
		cat<<EOF
Perhaps a temporary network failure? You can press Ctrl-Alt-F2 to login another console. Try fixing the problem, and then type Ctrl-Alt-F1 to come back and continue.
EOF
		colorEcho $ERR "*****************************************************"
		pause_err
	done
	
	cat<<EOF
Files downloaded successfully!
Installing $(cat 0* | wc -l) packages and their dependencies...
This step usually takes about an hour to finish. It could take longer if your network is slow.
EOF
		pause

		while ! sudo apt-get -y install $(cat 0*)
		do
			colorEcho $ERR "********** Oops! apt-get error! **********"
			cat<<EOF
Life shouldn't be this hard! Don't cry. You still have choices:
1. Press any key to try your luck again;
2. Step 1 doesn't work? Let's try harder...Press Ctrl-Alt-F2 to login another console, try fixing the problem, then type Ctrl-Alt-F1 to come back and try again;
3. Press q to quit the installation.
EOF
			colorEcho $ERR "******************************************"
			pause_err
		done
}

misc_files(){
	cd
	touch .xsession-errors && \
	cat /dev/null > .xsession-errors && \
	sudo chattr +i .xsession-errors

	colorEcho $INFO "Downloading misc files..."
	while ! $WGET $CS6WX672/debian-install/{elpa.tgz,tmux-plugins.tgz,cn/dict-cn.tgz}
	do
		colorEcho $ERR "********** Oops! Failed downloading misc files! **********"
		cat<<EOF
It could be:
1. A network failure. If so, you should go fix it, and come back to continue.
2. A server side error (server down, files missing, etc.). In this case, you should press q to quit this script, and send me a bug report ($EMAIL).
EOF
		colorEcho $ERR "**********************************************************"
		pause_err
	done
	
	tar zxf elpa.tgz -C ~/.emacs.d/

	tar zxf tmux-plugins.tgz -C ~/.tmux/

	sudo tar zxf dict-cn.tgz -C /usr/share/dict/ && \
		sudo dpkg-reconfigure dictd	
}

auto_login(){
	cd
	sudo cp -r $DOTFILE/etc/systemd/system/getty@tty1.service.d/ /etc/systemd/system/
	sudo sed -i "s/wx672/$USER/" /etc/systemd/system/getty@tty1.service.d/override.conf
}

locale_zh(){
	colorEcho $INFO "******************** Locale configuration ********************"
	cat<<EOF
Upon hitting the <ENTER> key, you will see the locale configuration widnow. In it, you should choose only the followings:
        [X] en_US.UTF-8 UTF-8
        [X] zh_CN.GB18030 GB18030
        [X] zh_CN.UTF-8 UTF-8
And select <None> as the default locale.
EOF
	colorEcho $INFO "**************************************************************"
	pause

	sudo dpkg-reconfigure locales

	cd
    sudo cp $DOTFILE/etc/default/locale /etc/default
}

xkey(){
	cd
	sudo cp $DOTFILE/etc/default/keyboard /etc/default/ 
}

dotfile(){
	cd
	rm -rf $DOTFILE .bash*

	cat<<EOF > .gitconfig
[https]
        sslVerify = false
[http]
        sslVerify = false
EOF
	colorEcho $INFO "Cloning dotfiles from cs6..."
	while ! git clone $CS6WX672/dotfile/.git $DOTFILE
	do
		colorEcho $ERR "********** Oops! git clone dotfile failed! **********"
		cat<<EOF
It could be:
1. A network failure. If so, you should go fix it, and come back to continue.
2. A server side error (server down? git repo changed?). In this case, you should press q to quit this script, and send me a bug report ($EMAIL).
EOF
		colorEcho $ERR "*****************************************************"
		pause_err
	done

	rm -f .gitconfig
	ln -sf $DOTFILE/dot.* .
	ln -sf $DOTFILE/help/dot.* .
	rename 's/dot//' dot.*
	sudo cp $DOTFILE/etc/bash.bashrc /etc
	sudo ln -sf $DOTFILE/usr/local/bin/st /usr/local/bin/st 
	sudo ln -sf $DOTFILE/usr/local/bin/stud /usr/local/bin/stud 
	sudo ln -sf st /usr/local/bin/xterm
	
	misc_files
	auto_login
	locale_zh
	xkey
}

sawfish_ugliness(){
	cd
	UGLINESS="sawfish-merlin-ugliness_1.3.1-1_all.deb"
	if $WGET $CS6WX672/debian-install/sawfish/$UGLINESS
	then
		sudo dpkg -i $UGLINESS
		sudo sed -i '/expert/s/^/;/' /usr/share/sawfish/site-lisp/merlin/uglicon.jl
		sudo sed -i '/gnome/s/^/;/' /etc/X11/sawfish/site-init.d/00debian.jl
		sudo sed -i '/debian/s/^/;/' /etc/X11/sawfish/site-init.d/00menu.jl
	else
		colorEcho $ERR "********** Failed downloading sawfish-merlin-ugliness package! **********"
		cat<<EOF
It could be:
1. A network failure.
2. A server side error (server down? file missing?).

In any case, this is an optional package. That means you can live without it. So, now you can just ignore this error message, and press any key to continue. But don't forget to send me a bug report ($EMAIL).
EOF
		colorEcho $ERR "*************************************************************************"
		pause
	fi
}

congrats(){
	colorEcho $SUCCESS "******************** Congrats! ********************"
	cat<<EOF
Done installation! Now, I am going to reboot your computer.
Upon finishing boot up, you should see a black screen with a rather big mouse cursor showing at the center of your screen.

NOTE: If the big mouse cursor doesn't shown up, that probably means the Xorg doesn't work
well. This usually has something to do with the graphic card driver. In this unlucky case,
you have to ask google for more info.

If you are lucky to see the big mouse cursor showing at the center of the black screen, you can hit
   	   * Super-t to bring up a terminal. Or,
	   * Super-F1 to show the cheat sheet.
	   * use 'nmtui' to activate your wifi.
	   * trigger Chinese input (fcitx) by hitting Shift-space. If it doesn't work, you can try fcitx-configtool. 

Have fun!
EOF
	colorEcho $SUCCESS "**************************************************"
	pause
	sudo reboot
}

note
checkIP
sudo_nopass
sources_list
dist_upgrade
more_pkgs
dotfile
sawfish_ugliness
congrats
