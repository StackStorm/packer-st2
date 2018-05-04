#!/bin/bash

# TODO: Eventually this step will not be required since these packages will be part of the custom
#       image (which hasn't been created yet).
# TODO: See "Codify the ova build Infrastructure #8": https://github.com/StackStorm/ova/issues/8

# Install virtualbox
if [ ! -e /sbin/vboxconfig ]; then
  sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian xenial contrib non-free' > /etc/apt/sources.list.d/virtualbox.list"
  wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
  sudo apt-get update && sudo apt-get install -y --allow-unauthenticated virtualbox-5.2
  sudo apt-get install -y linux-headers-generic linux-headers-4.4.0-112-generic
  /sbin/vboxconfig
fi
