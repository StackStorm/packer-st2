#!/usr/bin/env bash -eux

echo -e '\033[33mInstalling Virtualbox guest additions ...\033[0m'

# Without libdbus virtualbox would not start automatically after compile
apt-get -y install --no-install-recommends libdbus-1-3

# Install Linux headers and compiler toolchain
apt-get -y install build-essential linux-headers-$(uname -r)

# The netboot installs the VirtualBox support (old) so we have to remove it
apt-get install -y dkms

# Install the VirtualBox guest additions
VBOX_VERSION=$(cat ~/.vbox_version)
VBOX_ISO=VBoxGuestAdditions_${VBOX_VERSION}.iso

echo "${VBOX_ISO}"
mount -o loop "${VBOX_ISO}" /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11 || echo "Suppressing exit code $?"
umount /mnt
rm "${VBOX_ISO}"

# Can remove the unneeded packages now
apt-get -y remove build-essential dkms
