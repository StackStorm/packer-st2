PACKER ?= ~/bin/packer
PACKER_VERSION := 1.2.1
VAGRANT_CLOUD_STANDALONE_VERSION := 0.1.2
GIT ?= git
CURL ?= curl
SHELL := /bin/bash
UNAME := $(shell uname | tr '[:upper:]' '[:lower:]')
# Fetch latest stable release if 'ST2_VERSION' ENV var not set (ex: `2.7.1`)
ST2_VERSION ?= $(shell curl --silent "https://api.github.com/repos/stackstorm/st2/releases/latest" | grep -Po '"tag_name": "v\K.*?(?=")')
# Get today's date if 'BOX_VERSION' ENV var not set (ex: `20180507`)
BOX_VERSION ?= $(shell date -u +%Y%m%d)


.PHONY: install-packer validate build clean

install-packer: tmp/packer_$(PACKER_VERSION).zip
	mkdir -p ~/bin
	unzip -o -d ~/bin $<
	chmod +x $(PACKER)
	@echo Packer $(PACKER_VERSION) was successfully installed!

# Install packer only if it doesn't exist
$(PACKER):
	@$(MAKE) install-packer

tmp/packer_$(PACKER_VERSION).zip:
	curl -fsSLo $@ 'https://releases.hashicorp.com/packer/$(PACKER_VERSION)/packer_$(PACKER_VERSION)_$(UNAME)_amd64.zip'
	@echo Downloaded new Packer version: $(PACKER_VERSION)!

validate: $(PACKER) ~/bin/packer-post-processor-vagrant-cloud-standalone
	$(PACKER) validate st2.json
	$(PACKER) validate st2_deploy.json

build: $(PACKER)
	$(PACKER) build \
	  -var 'st2_version=$(ST2_VERSION)' \
	  -var 'box_version=$(BOX_VERSION)' \
	  st2.json

# 'Vagrant-cloud-standalone' is a forked Packer post-processor plugin to deploy .box artifact to Vagrant Cloud
install-vagrant-cloud-standalone: tmp/vagrant-cloud-standalone_$(VAGRANT_CLOUD_STANDALONE_VERSION).zip
	mkdir -p ~/bin
	unzip -o -d ~/bin $<
	@echo Vagrant-cloud-standalone plugin $(VAGRANT_CLOUD_STANDALONE_VERSION) was successfully installed!
tmp/vagrant-cloud-standalone_$(VAGRANT_CLOUD_STANDALONE_VERSION).zip:
	curl -fsSLo $@ 'https://github.com/armab/packer-post-processor-vagrant-cloud-standalone/releases/download/v$(VAGRANT_CLOUD_STANDALONE_VERSION)/packer-post-processor-vagrant-cloud-standalone_$(UNAME)_amd64.zip'
	@echo Downloaded new Vagrant-cloud-standalone version: $(VAGRANT_CLOUD_STANDALONE_VERSION)!
# Install 'packer-post-processor-vagrant-cloud-standalone' only if it doesn't exist
~/bin/packer-post-processor-vagrant-cloud-standalone:
	@$(MAKE) install-vagrant-cloud-standalone

# Deploy the .box, produced during the `build` to Vagrant Cloud
deploy: $(PACKER) ~/bin/packer-post-processor-vagrant-cloud-standalone
	$(PACKER) build \
	  -var 'st2_version=$(ST2_VERSION)' \
	  -var 'box_version=$(BOX_VERSION)' \
	  st2_deploy.json

clean:
	rm -rf tmp/*
