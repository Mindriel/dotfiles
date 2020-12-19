#!/usr/bin/env sh
set -e

if [ '--debug' = "$1" ] || [ '-d' = "$1" ]; then
  set -x
  shift
fi
test 0 = $#

LOG_FILE=`basename $0`.log
echo '++++++++++' >> $HOME/$LOG_FILE
date >> $HOME/$LOG_FILE

if [ "$EUID" != 0 ]; then
  SUDO_CMD='sudo'
else
  SUDO_CMD=''
fi

$SUDO_CMD apt update

# Set timezone
$SUDO_CMD timedatectl set-timezone Poland

# Reconfigure locals
#$SUDO_CMD dpkg-reconfigure locales #TODO: en_GB.UTF-8 and pl_PL.UTF-8

# Upgrade
$SUDO_CMD apt full-upgrade --no-install-recommends --no-install-suggests -y


# Install essentials
$SUDO_CMD apt install -y --no-install-recommends --no-install-suggests \
  vim \
  git \
  tmux \
  wget \
  curl \
  terminator \
  avahi-utils \
  openssh-server

# SSH
$SUDO_CMD systemctl enable ssh
$SUDO_CMD service ssh start

# Avahi SSH service
$SUDO_CMD cp /usr/share/doc/avahi-daemon/examples/ssh.service /etc/avahi/services/
$SUDO_CMD sed -i "s|use-ipv6=yes|use-ipv6=no|g" /etc/avahi/avahi-daemon.conf
$SUDO_CMD service avahi-daemon restart

# Change hostname
$SUDO_CMD sed -i "s|raspberrypi|SmallBerry|g" /etc/hosts
$SUDO_CMD sed -i "s|raspberrypi|SmallBerry|g" /etc/hostname
$SUDO_CMD hostname SmallBerry

# Install Raspotify
curl -sL https://dtcooper.github.io/raspotify/install.sh | sh
## Configure Raspotify for SmallBerry
$SUDO_CMD sed -i "s|defaults.ctl.card 0|defaults.ctl.card 1|g" /usr/share/alsa/alsa.conf
$SUDO_CMD sed -i "s|defaults.pcm.card 0|defaults.pcm.card 1|g" /usr/share/alsa/alsa.conf

# For Big Red Button
$SUDO_CMD apt install -y omxplayer fonts-freefont-ttf

# Pi user should enter password for sudo
$SUDO_CMD rm -f /etc/sudoers.d/*pi*

# TODO: Change default password
#$SUDO_CMD passwd pi raspberry <new-password>

# Clean up a little
$SUDO_CMD apt autoremove -y

# dotfiles
if [ "$EUID" != 0 ]; then
  if [ ! -d $HOME/dotfiles ]; then
    git clone https://github.com/Mindriel/dotfiles $HOME/dotfiles
  fi
  if ! grep -qq pretty.rc ~/.bashrc; then
    echo '' >> ~/.bashrc
    echo '. ~/dotfiles/bin/pretty.rc' >> ~/.bashrc
  fi
fi

# Ending
echo 'Now go and REBOOT.' | tee /dev/stderr 

date >> $HOME/$LOG_FILE
echo '----------' >> $HOME/$LOG_FILE
