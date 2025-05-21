#!/bin/bash
# Debian Installation and Configuration Script
# Purpose: Automates setup of a Debian system with custom packages, dotfiles, and configurations
# Author: wx672 (wx672ster@gmail.com)
# Usage: ./install.sh [-D]
# Options:
#   -D: Enable dry-run mode (simulate actions)
# Prerequisites: Debian base system installed without root password

set -euo pipefail

# === Global Configuration ===
CS6="cs6.swfu.edu.cn"
BASEURL="https://$CS6/~wx672"
EMAIL="wx672ster@gmail.com"
DOTFILE_DIR="$HOME/.dotfile"
KEY_FILE="wx672repo.gpg"
KEY_DIR="/etc/apt/trusted.gpg.d"

APT_REPOS=(
		"Types: deb"
		"URIs: http://ftp.cn.debian.org/debian/ https://mirrors.ustc.edu.cn/debian/ https://mirrors.bfsu.edu.cn/debian/"
		"Suites: testing sid"
		"Components: main contrib non-free non-free-firmware"
		"Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg"
)

CS6_REPO=(
		"Types: deb"
		"URIs: https://cs6.swfu.edu.cn/debian/"
		"Suites: sid"
		"Components: main"
		"Signed-By: /etc/apt/trusted.gpg.d/wx672repo.gpg"
		"Trusted: yes"
)

UNSTABLE=(
"Package: *"
"Pin: release a=unstable"
"Pin-Priority: 50"
)

TESTING=(
"Package: *"
"Pin: release a=testing"
"Pin-Priority: 400"
)

DNS_SERVERS=(223.5.5.5 223.6.6.6 8.8.8.8 8.8.4.4 9.9.9.9)

# USER_SERVICES=( udiskie )

NETWORK_TROUBLESHOOTING_MSG=$(cat <<EOF
Try:
1. Ensure your Ethernet cable is firmly connected.
2. Login another console (Ctrl-Alt-F2).
3. Run 'sudo dhclient' to obtain an IP address.
4. Come back (Ctrl-Alt-F1) to continue.
If the issue persists, exit the script. Shout at $EMAIL.
EOF
													 )

APT_TROUBLESHOOTING_MSG=$(cat <<EOF
Possible causes:
1. Network failure. Fix the network and retry.
2. Server-side issue (down or repository changed?). Report a bug to $EMAIL.
EOF
											 )

SUDO_TROUBLESHOOTING_MSG=$(cat <<EOF
You shouldn't have set the root password during base system installation!
To fix:
1. Login another console (Ctrl-Alt-F2) as root.
2. Install sudo (apt install sudo).
3. Come back (Ctrl-Alt-F1) to continue.
EOF
												)

TEX_MSG=$(cat <<EOF
It will take quite a while to install this package.
If you don't need LaTeX, you can skip it for now.
You can install it later when you really need it.
EOF
			 )

NOTE_MSG=$(cat <<EOF
This script requires a successfully installed Debian base system.
If not installed, follow the guide at:

  - ${BASEURL}/debian-install/install.html

NOTE: Do NOT set a root password during base system installation!
EOF
				)

CONGRATS_MSG=$(cat <<EOF
The system will now reboot.

After reboot, if you see the mouse cursor:
  * Press Super-t to open a terminal.
  * Press Super-F1 to see keyboard shortcuts.
  * Use 'nmtui' to activate the Wi-Fi.
  * Trigger Chinese input (fcitx5) with Shift-space. Try 'fcitx5-configtool' if needed.

If the mouse cursor is missing, Xorg may have issues, likely due to the graphics driver.
Search online for your graphics card model and driver solutions.

Have fun!
EOF
						)

# === Global Variables ===
LOG_FILE="/var/log/wx672install.log"
DRY_RUN=false
# shellcheck disable=SC2034
{
	ERROR=$(tput setaf 1)   # Red
	INFO=$(tput setaf 6)    # Cyan
	SUCCESS=$(tput setaf 2) # Green
	DEBUG=$(tput setaf 3)   # Yellow
}
	
# === Logging ===
log_message() {
		local level=$1
		local message=$2
		echo -n "$(date '+%Y-%m-%d %H:%M:%S')" | sudo tee -a "$LOG_FILE"
		colorEcho "${!level}" "[$level] $message" | sudo tee -a "$LOG_FILE"
}

# === Error Handling ===
handle_error() {
		local msg=$1
		local troubleshooting=$2
		log_message "ERROR" "$msg"
		display_dialog -E "Error" "$msg\n\n$troubleshooting"
		return 1
}

# === Utility Functions ===
display_dialog() {
		local opt
		while getopts ":Eysm" OPT; do
				case $OPT in
						E) export NEWT_COLORS='textbox=white,red actbutton=red,white' ;;
						y) opt=(--yes-button Continue --no-button Quit --yesno) ;;
						s) opt=(--yes-button Skip --no-button Continue --yesno) ;;
						m) opt=(--msgbox) ;;
						?) handle_error "Invalid dialog option" "Check script usage." ;;
				esac
		done
		shift $(( OPTIND - 1 ))
		OPTIND=1

		run_command whiptail --title "$1" ${opt[@]} "$2" 20 80
}

colorEcho() {
		echo -e "$(tput bold) $1 $2 $(tput sgr0)"
}

run_command() {
		log_message "DEBUG" "$*"
		if $DRY_RUN; then
				echo "[DRY_RUN] Would run: $*"
		else
				"$@"
		fi
}

# === Validation ===
check_environment() {
		log_message "INFO" "Validating environment..."
		if [[ $EUID -eq 0 ]]; then
				handle_error "Script must run as non-root user" "Use a regular user with sudo privileges."
		fi
		command -v sudo || {
				handle_error "sudo not installed" "$SUDO_TROUBLESHOOTING_MSG"; }
}

check_network() {
		log_message "INFO" "Checking $CS6 reachability..."

		echo "HEAD / HTTP/1.0" >/dev/tcp/"$CS6"/80 || {
				handle_error "$CS6 unreachable" "$NETWORK_TROUBLESHOOTING_MSG"; }

		log_message "SUCCESS" "$CS6 is reachable."
}

# === Setup Functions ===
configure_console() {
		log_message "INFO" "Configuring console..."
		run_command sudo debconf-set-selections <<EOF
console-setup console-setup/fontsize string 16x32
console-setup console-setup/fontface47 select Terminus
console-setup console-setup/fontsize-fb47 select 16x32 (framebuffer only)
console-setup console-setup/fontsize-text47 select 16x32 (framebuffer only)
console-setup console-setup/charmap47 select UTF-8
EOF

		cat <<EOF | run_command sudo tee /etc/default/console-setup
ACTIVE_CONSOLES="/dev/tty[1-6]"
CHARMAP="UTF-8"
CODESET="Lat15"
FONTFACE="Terminus"
FONTSIZE="16x32"
VIDEOMODE=
EOF
		run_command sudo dpkg-reconfigure -fnoninteractive console-setup
}

configure_sudo() {
		log_message "INFO" "Configuring sudo for $USER..."

		local sudoers_file="/etc/sudoers.d/$USER"

		echo "$USER ALL= NOPASSWD: ALL" | run_command sudo tee "$sudoers_file"

		run_command sudo chmod 440 "$sudoers_file"
}

configure_apt() {
		log_message "INFO" "Configuring APT repositories..."
		run_command sudo rm -f /etc/apt/sources.list

		# Key for cs6
		run_command sudo mkdir -p /etc/apt/trusted.gpg.d
		run_command sudo wget $BASEURL/$KEY_FILE -O $KEY_DIR/$KEY_FILE || {
			handle_error "GPG key for cs6 repo setup failed" "$APT_TROUBLESHOOTING_MSG"; }

		log_message "SUCCESS" "Done setting up gpg key for cs6 repo."

		# Debian sources
		printf "%s\n" "${APT_REPOS[@]}" | run_command sudo tee /etc/apt/sources.list.d/debian.sources
		# CS6 sources
		printf "%s\n" "${CS6_REPO[@]}" | run_command sudo tee /etc/apt/sources.list.d/cs6.sources
		# APT preferences
		printf "%s\n" "${UNSTABLE[@]}" | run_command sudo tee /etc/apt/preferences.d/unstable.pref
		printf "%s\n" "${TESTING[@]}"  | run_command sudo tee /etc/apt/preferences.d/testing.pref

		# Verify repository access
		run_command sudo apt update || {
				handle_error "APT update failed" "$APT_TROUBLESHOOTING_MSG"; }

		log_message "SUCCESS" "Done apt update."
}

dist_upgrade() {
		log_message "INFO" "Upgrading base system..."

		run_command sudo apt -y dist-upgrade || {
				handle_error "APT dist-upgrade failed" "$APT_TROUBLESHOOTING_MSG"; }

		log_message "SUCCESS" "Base system upgraded."
}

install_nala() {
		log_message "INFO" "Installing nala..."
		run_command sudo apt -y install nala || {
				handle_error "Failed to install nala" "Trying apt-fast..."; }

		log_message "SUCCESS" "Done installing nala."

		log_message "INFO" "Running nalafetch..."
		if nalafetch; then
			run_command sudo rm -f /etc/apt/sources.list.d/debian.sources
			log_message "SUCCESS" "Done nalafetch."
			run_command sudo nala upgrade || {
					handle_error "nalafetch failed" "$APT_TROUBLESHOOTING_MSG"; }

			log_message "SUCCESS" "Done nala upgrade."
		else
			handle_error "nalafetch failed" "Trying apt-fast..."
		fi
}

nalafetch() {
    local fetched="/etc/apt/sources.list.d/fetch.sources"
    run_command sudo nala fetch -c CN --debian sid --auto --non-free
    run_command sudo sed -i '/^Suites:/ s/:.*$/: testing sid/' $fetched
    cat $fetched
}

install_apt_fast() {
		log_message "INFO" "Installing apt-fast, aria2..."
		fast=( apt-fast aria2 )
		run_command sudo debconf-set-selections <<EOF
apt-fast	apt-fast/aptmanager	    select	apt
apt-fast	apt-fast/downloader	    select	aria2c
apt-fast	apt-fast/maxconperfile	string	8
apt-fast	apt-fast/maxconpersrv	  string	10
apt-fast	apt-fast/maxdownloads	  string	5
apt-fast  apt-fast/dlflag         boolean false
EOF
		# shellcheck disable=SC2068
		run_command sudo apt -y install ${fast[@]} || {
			handle_error "Failed to install ${fast[*]}" "$APT_TROUBLESHOOTING_MSG";
		}
		log_message "SUCCESS" "Done installing apt-fast and aria2."
}

configure_dns() {
		local dns_conf='/etc/systemd/resolved.conf'
		if [[ -f $dns_conf ]]; then
				log_message "INFO" "Configuring $dns_conf..."
				run_command sudo sed -i '/^DNS/d' "$dns_conf"
				echo "DNS=${DNS_SERVERS[*]}" | run_command sudo tee -a "$dns_conf"
		fi
		log_message "SUCCESS" "Done configuring $dns_conf."
		run_command sudo systemctl restart systemd-resolved.service
}

install_packages() {
		local package_group apt_cmd
		read -ra package_group <<< "$@"
		apt_cmd=$(command -v nala || command -v apt-fast || echo apt)

		log_message "INFO" "Installing ${package_group[*]}..."
		run_command sudo "$apt_cmd" install -y ${package_group[@]} || {
				handle_error "Failed to install ${package_group[*]}" "$APT_TROUBLESHOOTING_MSG"; }

		log_message "SUCCESS" "${package_group[*]} installed."
}

install_all_packages() {
		display_dialog -m "Installing packages" \
									 "This may take about an hour, depending on your network speed."

		install_packages wx672-mandatory
		configure_dns
		install_packages wx672cli 
		install_packages wx672tmux
		install_packages wx672emacs
		install_packages wx672font
		install_packages wx672xorg
		install_packages wx672qutebrowser
		
		if display_dialog -s "Installing wx672texmf?" "$TEX_MSG"; then
				true
		else
				install_packages wx672texmf
		fi
}

misc_files() {
		log_message "INFO" "Managing miscellaneous files..."

		command -v blight && {
			run_command sudo blight setup
		}

		# Enable user services (come along with wx672cli)
		# for s in "${USER_SERVICES[@]}"; do
		# 		run_command systemctl --user enable "$s"
		# done
}

configure_auto_login() {
		log_message "INFO" "Configuring auto-login..."
		run_command sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
		cat <<EOF | run_command sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER --noclear %I \$TERM
EOF
}

configure_locale() {
		log_message "INFO" "Configuring locale..."

		run_command sudo debconf-set-selections <<EOF
locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, zh_CN.UTF-8 UTF-8
locales locales/default_environment_locale select en_US.UTF-8
EOF
		cat <<EOF | run_command sudo tee /etc/locale.gen
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
EOF
		run_command sudo dpkg-reconfigure -fnoninteractive locales

		run_command sudo update-locale \
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

		log_message "SUCCESS" "Done setting up locales."
}

configure_keyboard() {
		log_message "INFO" "Configuring keyboard..."
		cat <<EOF | run_command sudo tee /etc/default/keyboard
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS="terminate:ctrl_alt_bksp,ctrl:nocaps"
BACKSPACE="guess"
EOF

		cat <<EOF | run_command sudo tee /etc/X11/xorg.conf.d/30-libinput.conf
Section "InputClass"
  Identifier "libinput touchpad catchall"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Driver "libinput"
  Option "Tapping" "on"
  Option "TappingDrag" "on"
  Option "NaturalScrolling" "on"
  Option "TappingButtonMap" "lrm"
  Option "ClickMethod" "clickfinger"
  Option "DisableWhileTyping" "true"
EndSection
EOF

		log_message "SUCCESS" "Done setting up keyboard."
}

configure_timezone() {
		log_message "INFO" "Configuring timezone..."
		run_command sudo debconf-set-selections <<EOF
tzdata  tzdata/Areas            select  Asia
tzdata  tzdata/Zones/Africa     select
tzdata  tzdata/Zones/America    select
tzdata  tzdata/Zones/Antarctica select
tzdata  tzdata/Zones/Arctic     select
tzdata  tzdata/Zones/Asia       select  Shanghai
tzdata  tzdata/Zones/Atlantic   select
tzdata  tzdata/Zones/Australia  select
tzdata  tzdata/Zones/Etc        select  UTC
tzdata  tzdata/Zones/Europe     select
tzdata  tzdata/Zones/Indian     select
tzdata  tzdata/Zones/Pacific    select
tzdata  tzdata/Zones/US         select
EOF
		echo 'Asia/Shanghai' | run_command sudo tee /etc/timezone
		run_command sudo dpkg-reconfigure -fnoninteractive tzdata
		
		log_message "SUCCESS" "Done setting up tzdata."
}

# === Main ===
main() {
		# Parse options
		while getopts ":D" opt; do
				case $opt in
						D) DRY_RUN=true ;;
						*) echo "Usage: $0 [-d] [-D]" >&2; exit 1 ;;
				esac
		done
		
		set -x

		# Initialize logging
		true | run_command sudo tee "$LOG_FILE"
		log_message "INFO" "Starting Debian installation script..."

		# Validate environment
		check_environment
		check_network

		# Display startup message
		display_dialog -y "NOTE" "$NOTE_MSG" || exit 1

		# Run setup steps
		configure_console
		configure_sudo
		configure_apt
		dist_upgrade
		install_nala || install_apt_fast
		install_all_packages
		misc_files
		configure_auto_login
		configure_locale
		configure_keyboard
		configure_timezone

		# Final message
		log_message "SUCCESS" "Installation completed!"
		unset NEWT_COLORS
		display_dialog -m "Installation completed!" "$CONGRATS_MSG"

		run_command sudo reboot
}

main "$@"
