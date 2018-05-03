#!/bin/bash

# TODO: Eventually this step will not be required since these packages will be part of the custom image (which hasn't been created yet).
# TODO: See "Codify the ova build Infrastructure #8": https://github.com/StackStorm/ova/issues/8
###### PROVISION SERVER

S3_URI='https://s3-us-west-2.amazonaws.com/bwc-installer/ova-dependencies'

# Install packer
PACKER_VER='1.2.3'

PACKER_ZIP="packer_${PACKER_VER}_linux_amd64.zip"
PACKER_URI="${S3_URI}/${PACKER_ZIP}"

if [ ! -x /usr/local/bin/packer ]; then
  sudo wget -O ${PACKER_ZIP} ${PACKER_URI}
  sudo apt-get install -y unzip
  unzip -d /usr/local/bin ${PACKER_ZIP}
fi

if [ -e ${PACKER_ZIP} ]; then
  rm -f ${PACKER_ZIP}
fi

# Install ovftool
LIB='/usr/lib'
OVFTOOL_TGZ='vmware-ovftool.tgz'
OVFTOOL_URI=${S3_URI}/${OVFTOOL_TGZ}
if [ ! -e /usr/bin/ovftool ]; then
  wget -O ${LIB}/${OVFTOOL_TGZ} ${OVFTOOL_URI}
  if [ -f ${LIB}/${OVFTOOL_TGZ} ]; then
    pushd ${LIB} && \
    tar xfz ${OVFTOOL_TGZ} && \
    rm -f ${OVFTOOL_TGZ} && \
    popd
  fi
  ln -s  ${LIB}/vmware-ovftool/ovftool /usr/bin/ovftool
fi

# Install virtualbox
if [ ! -e /sbin/vboxconfig ]; then
  sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian xenial contrib non-free' > /etc/apt/sources.list.d/virtualbox.list"
  wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
  sudo apt-get update && sudo apt-get install -y --allow-unauthenticated virtualbox-5.2
  sudo apt-get install -y linux-headers-generic linux-headers-4.4.0-112-generic
  /sbin/vboxconfig
fi

###### DEPLOY IMAGE AS CIRCLECI ARTIFACT
