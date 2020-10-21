#!/usr/bin/env bash -eux

echo -e '\033[33mInstalling Virtualbox guest additions ...\033[0m'

# NOTE! Since Ubuntu v16.04.7 .iso install of VBoxGuestAdditions fails (see https://github.com/StackStorm/packer-st2/pull/49).
# Use this temporary method instead  which provides less guest additions features, but works.
sudo apt-get -y install virtualbox-guest-dkms virtualbox-guest-utils

# TODO: Revert the code below once the upstream Ubuntu/Virtualbox is fixed
## Without libdbus virtualbox would not start automatically after compile
#apt-get -y install --no-install-recommends libdbus-1-3
#
## Install Linux headers and compiler toolchain
#apt-get -y install build-essential linux-headers-$(uname -r)
#
## The netboot installs the VirtualBox support (old) so we have to remove it
#apt-get install -y dkms
#
#
#echo $VBOX_ISO
#mount -o loop $VBOX_ISO /mnt
#sh /mnt/VBoxLinuxAdditions.run --nox11 || echo "Suppressing exit code $?"
#umount /mnt
#rm $VBOX_ISO
#
## Can remove the unneeded packages now
#apt-get -y remove linux-headers-$(uname -r) build-essential dkms
