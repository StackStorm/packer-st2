#!/bin/bash -eux
###
## Install Vagrant Hashicorp SSH Key
## This way Vagrant can auth via known SSH key + user combination
###

echo -e '\033[33mAuthorizing insecure Vagrant SSH key-based access ...\033[0m'
mkdir -pm 700 /home/vagrant/.ssh
curl --retry 3 --insecure --silent --show-error --location "https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub" > /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh

# See: https://superuser.com/questions/1160025/how-to-solve-ttyname-failed-inappropriate-ioctl-for-device-in-vagrant
echo -e '\033[33mFix Vagrant provision "ttyname" warning ...\033[0m'
sed -i -e 's/^mesg n.*/test -t 0 \&\& mesg n/' /root/.profile
