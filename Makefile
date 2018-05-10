PACKER ?= ~/bin/packer
PACKER_VERSION := 1.2.1
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

validate: $(PACKER)
	$(PACKER) validate st2.json

build: $(PACKER)
	$(PACKER) build \
	  -var 'st2_version=$(ST2_VERSION)' \
	  -var 'box_version=$(BOX_VERSION)' \
	  st2.json

clean:
	rm -rf tmp/*
