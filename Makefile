PACKER ?= ~/bin/packer
PACKER_VERSION := 1.2.2
GIT ?= git
CURL ?= curl
SHELL := /bin/bash
UNAME := $(shell uname | tr '[:upper:]' '[:lower:]')


.PHONY: install-packer validate build clean

install-packer: tmp/packer_$(PACKER_VERSION).zip
	mkdir -p ~/bin
	unzip -o -d ~/bin $<
	chmod +x ~/bin/packer
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
	$(PACKER) build st2.json

clean:
	rm -rf tmp/*
