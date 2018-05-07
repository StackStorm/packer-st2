# StackStorm Vagrant & OVA
[![Latest Release](https://img.shields.io/github/release/StackStorm/packer-st2/all.svg)](https://github.com/StackStorm/packer-st2/releases)
[![Download from Vagrant Cloud](https://img.shields.io/badge/Vagrant-cloud%20%E2%86%92-1563ff.svg)](https://app.vagrantup.com/stackstorm/boxes/st2/)

[Packer](https://www.packer.io/intro/index.html) templates with [InSpec](https://www.inspec.io/) integration tests for building Vagrant box & OVA image with [StackStorm](https://github.com/stackstorm/st2) community installed.
A fully tested and packaged artifacts are produced during the build pipeline.


## Usage
### Vagrant Quick Start
Starting a Vagrant VM is easy:
```
vagrant init stackstorm/st2
vagrant up
```

### Updating the Vagrant box
Once we release a newer version, Vagrant will warn you about the available update. To update the box:
```
vagrant box outdated
vagrant box remove stackstorm/st2
vagrant up
```

### OVA Virtual Appliance
Virtual appliance is available for download as `.OVA` image from the [Github Releases](https://github.com/StackStorm/packer-st2/releases) page.<br>
> _Linux login credentials:_<br>
> Username: `vagrant`<br>
> Password: `vagrant`
>
> _StackStorm login details:_<br>
> Username: `st2admin`<br>
> Password: `Ch@ngeMe`

At the moment only Virtualbox provider is supported. VMWare-compatible virtual appliance is available with [StackStorm Enterprise (EWC)](https://stackstorm.com/#product) image. Ask [StackStorm Support](mailto:support@stackstorm.com) for more info.

### `st2-integration-tests`
Sometimes StackStorm does not run properly for some reason.<br>
Discovering why at a infra level is the responsibility of `st2-integration-tests` which will perform StackStorm InSpec Tests and report back with more detailed info.<br>
This can save time for both user & engineering team to avoid extensive troubleshooting steps.

If something went wrong, - just run `st2-integration-tests`!


## Building Vagrant & OVA
### Requirements
The following tools are required for the build process:
- Virtualbox - https://www.virtualbox.org/wiki/Downloads
- Packer - https://www.packer.io/downloads.html (`make install-packer`)

### Build Steps
* Run Packer via `make build`

The Packer build process will import `Ubuntu 16.04 Xenial Server` iso image in Virtualbox, bootstrap Ubuntu server with all the required settings (automating typical iso live CD install steps),
install & configure StackStorm and finally export both the Vagrant box and .OVA image into the [`/builds`](/builds) directory.
> See [`st2.json`](/st2.json) which codifies Packer build pipeline and could be used as a source of entire automation logic.


## Testing
[`/test`](/test) directory contains Integration tests, powered by [InSpec.io](https://www.inspec.io/) Infrastructure Testing framework.
Tests are performed at the end of the Packer build pipeline after entire installation and configuration. They ensure that custom OS Linux-level modifications are in place and StackStorm was really deployed, works correctly and alive with other services it relies on like RabbitMQ, PostgreSQL, MongoDB.
To make testing close to a real-world scenario, an additional VM reboot step in the build pipeline is performed before running the actual integration tests.

> Please don't forget to include respective tests for every new critical feature of the system!<br>
> See https://www.inspec.io/docs/reference/dsl_inspec/ and existing `/tests` examples which makes easy to add more tests.
