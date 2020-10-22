#!/bin/bash -eux

echo -e '\033[33mRunning cleanup scripts to reduce the resulting box size ...\033[0m'


# Stop services before the final cleanup
st2ctl stop
systemctl stop mongod rabbitmq-server

# Apt cleanup
apt-get -y autoremove;
apt-get -y clean;
rm -rf /var/lib/apt/lists/* || echo "Suppressing exit $?"

# Remove unneeded files and dirs
rm -rf \
  /tmp/* \
  /var/tmp/* \
  VBoxGuestAdditions_*.iso \
  VBoxGuestAdditions_*.iso.?

# Remove possible caches
find /var/cache -type f -exec rm -rf {} \;

# Clean any logs that have built up during the install
find /var/log/ -type f | while read -r f; do
  dd if=/dev/null of="${f}" status=none
done

# Remove st2actionrunner.xxx.log files with PID in name
find /var/log/st2/ -name st2actionrunner.*.log -exec rm -f {} \;

# Whiteout the swap partition to reduce box size
# Swap is disabled till reboot
SWAP_UUID="$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)"
if [[ "${SWAP_UUID}" ]]; then
  SWAP_PART="$(readlink -f "/dev/disk/by-uuid/${SWAP_UUID}")"
  /sbin/swapoff "${SWAP_PART}"
  dd if=/dev/zero of="${SWAP_PART}" bs=1M || echo "dd exit $? suppressed"
  /sbin/mkswap -U "${SWAP_UUID}" "${SWAP_PART}"
fi

# Zero out the rest of the free space using dd, then delete the written file.
# This will free up VM disk space before packing
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null || echo "dd exit code $? is suppressed";
# Sleeping a bit before rm is required here :/
sleep 5
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
