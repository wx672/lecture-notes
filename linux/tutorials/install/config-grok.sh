#!/bin/bash
# Configuration for Debian installation script

BASEURL="https://cs6.swfu.edu.cn/~wx672"
EMAIL="wx672ster@gmail.com"
DOTFILE_DIR="$HOME/.dotfile"
DNS_SERVERS="114.114.114.114 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112"
WGET="wget --no-check-certificate"

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
  "catppuccin.tgz:expected_sha256_placeholder"
  "media-test.mp4:expected_sha256_placeholder"
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
