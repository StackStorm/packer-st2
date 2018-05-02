#!/bin/bash -eu

# Run Integration Tests via Inspec Infra testing framework
# https://www.inspec.io/

# Install Inspec Framework
if ! command -v inspec > /dev/null; then
  echo 'Installing Inspec ...'
  # https://downloads.chef.io/inspec#ubuntu
  TEMP_DEB="$(mktemp)"
  wget -qO "$TEMP_DEB" 'https://packages.chef.io/files/stable/inspec/2.1.59/ubuntu/16.04/inspec_2.1.59-1_amd64.deb'
  sudo dpkg --skip-same-version -i "$TEMP_DEB"
  rm -f "$TEMP_DEB"
fi

echo 'Running InSpec Integration Tests ...'
cd $(dirname $0)
for dir in */; do
  dir=$(basename $dir)
  if [ -f "${dir}/inspec.yml" ]; then
    echo -e "\nRunning tests for \033[1;36m${dir}\033[0m ..."
    sudo inspec exec ${dir}
  fi
done
