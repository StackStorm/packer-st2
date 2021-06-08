#!/bin/bash -eux

echo -e '\033[33mRunning cleanup scripts before installing StackStorm ...\033[0m'

## NB! Disabled as it installs 114 revision of the kernel resulting in:
## "Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)"
## Latest confirmed working kernel version: 4.15.0-112
# Delete all Linux headers
#dpkg --list \
#  | awk '{ print $2 }' \
#  | grep 'linux-headers' \
#  | xargs apt-get -y purge;

# Remove specific Linux kernels, such as linux-image-3.11.0-15-generic but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-generic', etc.
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-.*-generic' \
    | grep -v `uname -r` \
    | xargs apt-get -y purge;

# Delete Linux source
dpkg --list \
    | awk '{ print $2 }' \
    | grep linux-source \
    | xargs apt-get -y purge;

# Delete development packages
# NB! Run this before installing StackStorm as it may pull some 'dev' dependencies itself
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-dev$' \
    | xargs apt-get -y purge;

# delete docs packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-doc$' \
    | xargs apt-get -y purge;

# Delete X11 libraries
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6;

# Delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf;

# Delete oddities
apt-get -y purge popularity-contest installation-report command-not-found command-not-found-data friendly-recovery fonts-ubuntu-font-family-console laptop-detect;

# Delete the massive firmware packages
apt-get -y purge linux-firmware
