# packer-st2
Packer templates for building Vagrant box with [StackStorm](https://github.com/stackstorm/st2) community installed

## Building Vagrant & OVA

### Requirements
The following tools are required for the build process:
- Virtualbox - https://www.virtualbox.org/wiki/Downloads
- Packer - https://www.packer.io/downloads.html (`make install-packer`)
- VMware ovftool - https://www.vmware.com/support/developer/ovf/


### Build Steps
* Run Packer via `make build`

The Packer build process will import `Ubuntu 16.04 Xenial Server` iso image in Virtualbox, bootstrap Ubuntu server with all the required settings (automating typical iso live CD install steps),
install & configure StackStorm, test it with [InSpec integration tests](/test), cleanup image, make the image compatible with VMware via `ovftool` and finally export both the Vagrant box and .OVA image into the [`/builds`](/builds) directory.
> See [`st2.json`](/st2.json) which codifies Packer build pipeline and could be used as a source of entire automation logic.
