#!/bin/bash
# Debian Installation and Configuration Script
# Purpose: Automates setup of a Debian system with custom packages, dotfiles, and configurations
# Author: wx672 (wx672ster@gmail.com)
# Usage: ./install.sh [-d] [-D]
# Options:
#   -d: Enable debug mode (print commands)
#   -D: Enable dry-run mode (simulate actions)
# Prerequisites: Debian base system installed without root password

set -euo pipefail
IFS=$'\n\t'

# === Global Configuration ===
BASEURL="https://cs6.swfu.edu.cn/~wx672"
EMAIL="wx672ster@gmail.com"
DOTFILE_DIR="$HOME/.dotfile"
DNS_SERVERS="114.114.114.114 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112"
WGET=(wget --no-check-certificate)

APT_REPOS=(
  "Types: deb"
  "URIs: http://ftp.cn.debian.org/debian/ https://mirrors.nju.edu.cn/debian/ https://mirrors.bfsu.edu.cn/debian/"
  "Suites: testing sid"
  "Components: main contrib non-free non-free-firmware"
  "Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg"
)

CS6_REPO=(
  "Types: deb"
  "URIs: https://cs6.swfu.edu.cn/debian/"
  "Suites: /"
  "Components: "
  "Signed-By: "
  "Trusted: yes"
)

CONFIG_DIRS=(
  aria2 bat cheat fcitx5 fontconfig helix latexmk lf lftp mpv
  psd ripgrep rofi tmux visidata w3m wezterm yt-dlp zathura
)

STOW_PACKAGES=(
  applications bash bash-completion dot.config emacs git gtk*
  help home keynav less mime nvim pandoc qutebrowser systemd
  tmate vivid wallpapers xorg zellij
)

MISC_FILES=(
  "catppuccin.tgz:3995e437676f4e4fd53d3618b5cbf0925c1af9f23bef42e4e087d80991359a97"
)

USER_SERVICES=(
  emacs fcitx picom udiskie xbanish
)

NETWORK_TROUBLESHOOTING_MSG=$(cat <<EOF
Try:
1. Ensure your Ethernet cable is securely connected.
2. Press Ctrl-Alt-F2 to login to another console.
3. Run 'sudo dhclient' to obtain an IP address.
4. Return to Ctrl-Alt-F1 to continue.
If the issue persists, exit the script.
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
1. Press Ctrl-Alt-F2 to open another console and log in as root.
2. Install sudo with 'apt install sudo'.
3. Return to Ctrl-Alt-F1 to continue.
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
  * Press Super-F1 to view the cheat sheet.
  * Use 'nmtui' to activate Wi-Fi.
  * Trigger Chinese input (fcitx5) with Shift-space. Try 'fcitx5-configtool' if needed.

If the time is incorrect, run:

  sudo dpkg-reconfigure tzdata

If the mouse cursor is missing, Xorg may have issues, likely due to the graphics driver.
Search online for your graphics card model and driver solutions.

Have fun!
EOF
)

# === Global Variables ===
LOG_FILE="/var/log/wx672install.log"
DEBUG=false
DRY_RUN=false
ERR=$(tput setaf 1)     # Red
INFO=$(tput setaf 6)    # Cyan
SUCCESS=$(tput setaf 2) # Green

# === Logging ===
log_message() {
  local level=$1
  local message=$2
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | sudo tee -a "$LOG_FILE"
}

# === Error Handling ===
handle_error() {
  local msg=$1
  local troubleshooting=$2
  log_message "ERROR" "$msg"
  display_dialog -E "Error" "$msg\n\n$troubleshooting"
}

# === Utility Functions ===
display_dialog() {
  local opt
  while getopts ":Eym" OPT; do
    case $OPT in
      E) export NEWT_COLORS='textbox=white,red actbutton=red,white' ;;
      y) opt=(--yes-button Continue --no-button Quit --yesno) ;;
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
  log_message "DEBUG" "Running: $*"
  if $DRY_RUN; then
    echo "[DRY-RUN] Would run: $*"
  else
    "$@"
  fi
}

pause() {
  colorEcho "$INFO" "Press any key to continue..."
  read -rsn1
}

pause_err() {
  colorEcho "$INFO" "Press 'q' to quit, or any other key to continue..."
  read -rsn1
  [[ $REPLY == "q" ]] && exit 1
}

spinner() {
  local pid=$1
  local message=$2
  local spin='-\|/'
  local i=0

  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i + 1) % 4 ))
    printf "\r%s %s" "${spin:$i:1}" "$message"
    sleep 0.1
  done
  printf "\r"
}

# === Validation ===
check_environment() {
  log_message "INFO" "Validating environment..."
  if [[ $EUID -eq 0 ]]; then
    handle_error "Script must run as non-root user" "Use a regular user with sudo privileges."
  fi
  if ! command -v sudo >/dev/null 2>&1; then
    handle_error "sudo not installed" "$SUDO_TROUBLESHOOTING_MSG"
  fi
}

check_network() {
  log_message "INFO" "Checking network connectivity..."
  colorEcho "$INFO" "Checking cs6.swfu.edu.cn reachability..."

  if ! echo "HEAD / HTTP/1.0" >/dev/tcp/cs6.swfu.edu.cn/80; then
    handle_error "cs6.swfu.edu.cn unreachable" "$NETWORK_TROUBLESHOOTING_MSG"
  fi

  log_message "SUCCESS" "cs6.swfu.edu.cn is reachable!"
  colorEcho "$SUCCESS" "cs6.swfu.edu.cn is reachable!"
}

# === Setup Functions ===
configure_sudo() {
  log_message "INFO" "Configuring sudo for $USER..."
  local sudoers_file="/etc/sudoers.d/$USER"

  echo "$USER ALL= NOPASSWD: ALL" | \
    run_command sudo tee "$sudoers_file" >/dev/null
  run_command sudo chmod 440 "$sudoers_file"
}

configure_apt() {
  log_message "INFO" "Configuring APT repositories..."
  run_command sudo rm -f /etc/apt/sources.list

  # Debian sources
  printf "%s\n" "${APT_REPOS[@]}" | run_command sudo tee /etc/apt/sources.list.d/debian.sources
  # CS6 sources
  printf "%s\n" "${CS6_REPO[@]}" | run_command sudo tee /etc/apt/sources.list.d/cs6.sources

  # APT preferences
  cat <<EOF | run_command sudo tee /etc/apt/preferences.d/unstable.pref
Package: *
Pin: release a=unstable
Pin-Priority: 50
EOF

  cat <<EOF | run_command sudo tee /etc/apt/preferences.d/testing.pref
Package: *
Pin: release a=testing
Pin-Priority: 400
EOF

  # Verify repository access
  run_command sudo apt update || \
    handle_error "Failed to update APT" "$NETWORK_TROUBLESHOOTING_MSG"
}

dist_upgrade() {
  log_message "INFO" "Upgrading base system..."
  run_command sudo apt update || {
    handle_error "APT update failed" "$NETWORK_TROUBLESHOOTING_MSG"
  }

  run_command sudo apt -y dist-upgrade || {
    handle_error "APT dist-upgrade failed" "$NETWORK_TROUBLESHOOTING_MSG"
}
  log_message "SUCCESS" "Base system upgraded!"
  colorEcho "$SUCCESS" "Base system upgraded!"
}

install_apt_fast() {
  log_message "INFO" "Installing apt-fast and aria2..."
  run_command sudo apt -y install aria2 apt-fast || {
    handle_error "Failed to install apt-fast" "$NETWORK_TROUBLESHOOTING_MSG"
  }
}

install_packages() {
  local package_group=($@)
  local apt_cmd
  apt_cmd=$(command -v apt-fast || echo apt)

  log_message "INFO" "Installing $package_group..."
  run_command sudo "$apt_cmd" install -y ${package_group[@]} || {
    handle_error "Failed to install ${package_group[@]}" "$NETWORK_TROUBLESHOOTING_MSG"
  }
  log_message "SUCCESS" "${package_group[@]} installed!"
}

configure_dns() {
  local dns_conf='/etc/systemd/resolved.conf'
  if [[ -f $dns_conf ]]; then
    log_message "INFO" "Configuring $dns_conf..."
    run_command sudo sed -i '/^DNS/d' "$dns_conf"
    echo "DNS=$DNS_SERVERS" | run_command sudo tee -a "$dns_conf" >/dev/null
  fi
}

install_all_packages() {
  display_dialog -m "Installing packages" \
    "This may take about an hour, depending on your network speed."

  install_apt_fast
  install_packages wx672-mandatory

  configure_dns
  run_command sudo systemctl restart systemd-resolved.service

  install_packages wx672-recommend
  install_packages wx672chinese
  install_packages wx672exe wx672cli
  install_packages wx672fonts
  install_packages wx672elpa
  install_packages wx672texmf


  # Setup Emacs
  run_command mkdir -p "$HOME/.emacs.d"
  run_command ln -sf /usr/local/share/emacs/elpa "$HOME/.emacs.d/elpa"

  # Remove xterm if installed
  if command -v xterm >/dev/null 2>&1; then
    run_command sudo apt purge -y xterm
  fi
}

configure_dotfiles() {
  log_message "INFO" "Setting up dotfiles..."

  # Remove existing dotfiles
  if [[ -d $HOME/.config || -f $HOME/.bashrc ]]; then
    log_message "INFO" "Removing old dotfiles..."
    run_command rm -rf "$HOME"/.[!.]* || true
  fi

  # Create directories
  sudo rm -rf "$HOME"/{.config,.local,.cache}
  run_command mkdir -p "$HOME"/{.config,.local,.cache}

  # Create symlinks
  for d in "${CONFIG_DIRS[@]}"; do
    run_command ln -sf "/usr/local/share/$d" "$HOME/.config/$d" || \
      handle_error "Failed to create symlink for $d" "Check permissions or disk space."
  done

  run_command ln -sf /usr/local/share/picom/picom.conf "$HOME/.config/picom.conf"
  run_command ln -sf /usr/local/share/starship/starship.toml "$HOME/.config/starship.toml"

  # Temporary .gitconfig
  cat <<EOF | run_command tee "$HOME/.gitconfig"
[https]
    sslVerify = false
[http]
    sslVerify = false
EOF

  # Clone dotfiles
  log_message "INFO" "Cloning dotfiles from $BASEURL/dotfile/.git..."
  run_command git clone "$BASEURL/dotfile/.git" "$DOTFILE_DIR" || \
    handle_error "Failed to clone dotfiles" "$APT_TROUBLESHOOTING_MSG"

  run_command rm -f "$HOME/.gitconfig"  # Replaced by stowed config

  # Create immutable .xsession-errors
  [[ -f "$HOME/.xsession-errors" ]] || {
    run_command true > "$HOME/.xsession-errors"
    run_command sudo chattr +i "$HOME/.xsession-errors"
  }

  # Stow dotfiles
  run_command mkdir -p "$HOME"/{.local/share,.cache/emacs/etc/yasnippet}
  cd "$DOTFILE_DIR" || handle_error "Failed to change to $DOTFILE_DIR" "Check git clone."
  run_command stow -Rt "$HOME" ${STOW_PACKAGES[@]} || \
    handle_error "Failed to stow dotfiles" "Fix in another console (Ctrl-Alt-F2)."
}

# verify_download() {
#   local file=$1
#   local expected_sha256=$2

#   if [[ -f "$file" ]]; then
#     local actual_sha256
#     actual_sha256=$(sha256sum "$file" | cut -d' ' -f1)
#     if [[ "$actual_sha256" != "$expected_sha256" ]]; then
#       handle_error "Checksum mismatch for $file" "File may be corrupted or tampered with."
#     fi
#   fi
# }

download_misc_files() {
  log_message "INFO" "Downloading miscellaneous files..."
  for item in "${MISC_FILES[@]}"; do
    local file=${item%%:*}
    local sha256=${item##*:}
    run_command ${WGET[@]} -nc -P /tmp "$BASEURL/debian-install/misc/$file" || \
      handle_error "Failed downloading $file" "$APT_TROUBLESHOOTING_MSG"
    # verify_download "/tmp/$file" "$sha256"
  done

  run_command tar xf /tmp/catppuccin.tgz -C "$HOME/.config/qutebrowser/"
  run_command sudo dpkg-reconfigure --frontend noninteractive dictd
  run_command sudo chown -R "$USER:$USER" /usr/local

  # Enable user services
  for s in "${USER_SERVICES[@]}"; do
    run_command systemctl --user enable "$s"
  done
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

  echo 'Asia/Shanghai' | run_command sudo tee /etc/timezone
  run_command sudo dpkg-reconfigure -fnoninteractive tzdata
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
}

configure_kmscon() {
  log_message "INFO" "Configuring kmscon..."
  until command -v kmscon >/dev/null 2>&1; do
    run_command sudo apt install -y kmscon
  done

  run_command sudo mkdir -p /etc/kmscon
  cat <<EOF | run_command sudo tee /etc/kmscon/kmscon.conf
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

  run_command sudo systemctl disable kmsconvt@.service
  run_command sudo systemctl enable kmsconvt@tty2.service
}

configure_console() {
  log_message "INFO" "Configuring console..."
  run_command sudo debconf-set-selections <<EOF
tzdata tzdata/Areas select Asia
tzdata tzdata/Zones/Asia select Shanghai
tzdata tzdata/Zones/Etc select UTC
locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, zh_CN.UTF-8 UTF-8
locales locales/default_environment_locale select en_US.UTF-8
console-setup console-setup/fontsize string 16x32
console-setup console-setup/fontface47 select Terminus
console-setup console-setup/fontsize-fb47 select 16x32 (framebuffer only)
console-setup console-setup/fontsize-text47 select 16x32 (framebuffer only)
console-setup console-setup/charmap47 select UTF-8
dictd dictd/run_mode select daemon
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

# === Main ===
main() {
  # Parse options
  while getopts ":dD" opt; do
    case $opt in
      d) DEBUG=true ;;
      D) DRY_RUN=true ;;
      *) echo "Usage: $0 [-d] [-D]" >&2; exit 1 ;;
    esac
  done
  $DEBUG && set -x

  # Initialize logging
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
  install_all_packages
  configure_dotfiles
  download_misc_files
  configure_auto_login
  configure_locale
  configure_keyboard
  configure_kmscon

  # Final message
  log_message "SUCCESS" "Installation completed!"
  unset NEWT_COLORS
  display_dialog -m "Installation completed!" "$CONGRATS_MSG"

  run_command sudo reboot
}

main "$@"
