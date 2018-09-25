# Changelog

## In Development

## v2.9.0-20180925
* Use correct version of linux-headers
* Upgrade from Ubuntu 16.04.4 to 16.04.5

## v2.9.0-20180921
* StackStorm 2.9.0 released

## v2.8.1-20180717
* StackStorm 2.8.1 released

## v2.8.0-20180710
* StackStorm 2.8.0 released


## v2.7.2-20180614
* Use /30 mask for private network (access via IP `10.10.10.10`). (#41)

## v2.7.2-20180523
* Add Vagrant port-forwarding rule to access st2web via `https://127.0.0.1:9000/` as a fallback (#36)

## v2.7.2-20180516
* StackStorm 2.7.2 released

## v2.7.1-20180514
* StackStorm 2.7.1 released
* Fix Vagrant Cloud deploy step, caused by wrong 'file not exist' error (#31)
* Expose StackStorm Vagrant access via IP `10.10.10.10` (#29)
* Extract from `CIRCLE_TAG` and pin `ST2_VERSION` & `BOX_VERSION` on release (#33)

## v2.7.1-20180511
* Add continuous integration (#19)
* Deploy tagged builds to GitHub releases (#25)
* Add `ST2_VERSION` and `BOX_VERSION` ENV vars for version pinning (#26)
* Create custom [`vagrant-cloud-standalone`](https://github.com/armab/packer-post-processor-vagrant-cloud-standalone) Packer post processor, `make deploy` to Vagrant Cloud (#27)

## v2.7.1-20180507
* Initial release with minimally working StackStorm Vagrant box, created from Packer build pipeline
* Add first system Vagrant-focused integration tests, tie them with the build (#5)
* Add custom MOTD/welcome message after logging in to console (#15)
* Add StackStorm infrastructure integration tests, ship with new `st2-integration-tests` executable available to user (#20)
* Install Virtualbox guest additions (#22)
