# Changelog

## In Development
* Fix Vagrant Cloud deploy step, caused by wrong 'file not exist' error (#31)

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
