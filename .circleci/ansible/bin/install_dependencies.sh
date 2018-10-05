#!/bin/bash

# TODO: Eventually this step will not be required since these packages will be part of the custom
#       image (which hasn't been created yet).
# TODO: See "Codify the ova build Infrastructure #8": https://github.com/StackStorm/ova/issues/8

sudo apt-get install -y unzip

# Install virtualbox
if [ ! -e /sbin/vboxconfig ]; then
  sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian xenial contrib non-free' > /etc/apt/sources.list.d/virtualbox.list"
  wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
  sudo apt-get install -y linux-headers-generic linux-headers-$(uname -r)
  sudo apt-get update && sudo apt-get install -y --allow-unauthenticated virtualbox-5.2
  /sbin/vboxconfig
fi

echo -e '\033[33mInstalling Virtualbox guest additions ...\033[0m'

# Without libdbus virtualbox would not start automatically after compile
apt-get -y install --no-install-recommends libdbus-1-3

# Install Linux headers and compiler toolchain
apt-get -y install build-essential linux-headers-$(uname -r)

# The netboot installs the VirtualBox support (old) so we have to remove it
apt-get install -y dkms

# Install the VirtualBox guest additions
VBOX_VERSION=$(cat ~/.vbox_version)
VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso

echo $VBOX_ISO
mount -o loop $VBOX_ISO /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11 || echo "Suppressing exit code $?"
umount /mnt
rm $VBOX_ISO

# Can remove the unneeded packages now
apt-get -y remove linux-headers-$(uname -r) build-essential dkms
