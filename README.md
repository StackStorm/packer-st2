# packer-st2
Packer templates for building Vagrant box with [StackStorm](https://github.com/stackstorm/st2) community installed

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

### `st2-integration-tests`
From a user's standpoint, for easier StackStorm troubleshooting there is an `st2-integration-tests` executable shipped in sbin/PATH.<br>
Sometimes StackStorm is not running properly by some reason.
Finding an answer is a responsibility of `st2-integration-tests` which will run StackStorm InSpec Tests and report back with more detailed info.
This can save time for both user & engineering team to avoid extensive troubleshooting steps.

If something went wrong, - just ask them to run `st2-integration-tests`!
