PACKER ?= ~/bin/packer
PACKER_VERSION := 1.8.4
VAGRANT ?= ~/bin/vagrant
VAGRANT_VERSION := 2.3.4
# VAGRANT_CLOUD_STANDALONE_VERSION := 0.1.3
GIT ?= git
CURL ?= curl
SHELL := /bin/bash
UNAME := $(shell uname | tr '[:upper:]' '[:lower:]')
# Fetch latest stable release if 'ST2_VERSION' ENV var not set (ex: `2.7.1`)
ST2_VERSION ?= $(shell curl --silent "https://api.github.com/repos/stackstorm/st2/releases/latest" | jq -r .tag_name | sed 's/^v//')
# Get today's date if 'BOX_VERSION' ENV var not set (ex: `20180507`)
BOX_VERSION ?= $(shell date -u +%Y%m%d)
BOX_ORG ?= stackstorm


.PHONY: install-inspec inspec-lint install-packer validate build publish publish-manually clean install-vagrant

VAGRANT = $(shell command -v vagrant 2>/dev/null)
install-vagrant:
ifeq (,$(VAGRANT))
	@{ \
		case $(UNAME) in \
			darwin) \
				curl -fsSLo tmp/vagrant.dmg 'https://releases.hashicorp.com/vagrant/$(VAGRANT_VERSION)/vagrant_$(VAGRANT_VERSION)_$(UNAME)_amd64.dmg'; \
				hdiutil attach tmp/vagrant.dmg; \
				sudo installer -pkg /Volumes/Vagrant/vagrant.pkg -target /; \
				hdiutil detach /dev/disk2s1; \
				@echo Vagrant $(VAGRANT_VERSION) was successfully installed!
				;; \
			linux) \
				curl -fsSLo tmp/vagrant.zip 'https://releases.hashicorp.com/vagrant/$(VAGRANT_VERSION)/vagrant_$(VAGRANT_VERSION)_$(UNAME)_amd64.zip'; \
				mkdir -p ~/bin 2>/dev/null; \
				unzip -o -d ~/bin tmp/vagrant.zip; \
				chmod +x bin/vagrant; \
				@echo Vagrant $(VAGRANT_VERSION) was successfully installed!
				;; \
		esac \
	}
	VAGRANT = $(shell command -v vagrant 2>/dev/null)
endif

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

# ~/bin/packer-post-processor-vagrant-cloud-standalone

validate: $(PACKER)
	$(PACKER) validate st2.json
	$(PACKER) validate \
		-var 'st2_version=$(ST2_VERSION)' \
		-var 'box_version=$(BOX_VERSION)' \
		-var 'box_org=$(BOX_ORG)' \
		st2_publish.json

INSPEC = $(shell command -v inspec 2>/dev/null)
install-inspec: # https://docs.chef.io/inspec/install
ifeq (,$(INSPEC))
	@{ \
		case $(UNAME) in \
			darwin) \
				brew install chef/chef/inspec; \
				;; \
			linux) \
				curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec; \
				;; \
		esac \
	}
	INSPEC = $(shell command -v inspec 2>/dev/null)
endif

inspec-lint: $(INSPEC)
	@{ \
		cd test/integration/ && \
		for dir in */; do \
			dir=$$(basename $$dir) ; \
			if [ -f "$${dir}/inspec.yml" ]; then \
				echo -e "\nRunning Inspec lint for \033[1;36m$${dir}\033[0m ..."; \
				inspec check --chef-license=accept-silent --diagnose $${dir}; \
			fi \
		done \
	}

#	$(PACKER) validate st2_deploy.json

build: $(PACKER) validate
	$(PACKER) build \
		-var 'st2_version=$(ST2_VERSION)' \
		-var 'box_version=$(BOX_VERSION)' \
		-var 'box_org=$(BOX_ORG)' \
		st2.json

publish: $(PACKER) validate
	$(PACKER) build \
		-var 'st2_version=$(ST2_VERSION)' \
		-var 'box_version=$(BOX_VERSION)' \
		-var 'box_org=$(BOX_ORG)' \
		st2_publish.json

publish-manually: $(VAGRANT)
	vagrant cloud publish \
		--description "Box with StackStorm (aka 'IFTTT for Ops') event-driven automation platform: auto-remediation, security responses, facilitated troubleshooting, complex deployments, ChatOps and more. \n* https://stackstorm.com/ \n* Documentation: https://docs.stackstorm.com/ \n* Community: https://stackstorm.com/community-signup \n* Forum: https://forum.stackstorm.com/" \
		--short-description "StackStorm v$(ST2_VERSION)-$(BOX_VERSION)" \
		--version-description "StackStorm v$(ST2_VERSION)-$(BOX_VERSION)" \
		--checksum-type sha256 --checksum "$(shell sha256sum builds/st2_v$(ST2_VERSION)-$(BOX_VERSION).box | awk '{print $$1}')" \
		--force --release $(BOX_ORG)/st2 $(ST2_VERSION)-$(BOX_VERSION) virtualbox builds/st2_v$(ST2_VERSION)-$(BOX_VERSION).box

# 'Vagrant-cloud-standalone' is a forked Packer post-processor plugin to deploy .box artifact to Vagrant Cloud
# install-vagrant-cloud-standalone: tmp/vagrant-cloud-standalone_$(VAGRANT_CLOUD_STANDALONE_VERSION).zip
# 	mkdir -p ~/bin
# 	unzip -o -d ~/bin $<
# 	@echo Vagrant-cloud-standalone plugin $(VAGRANT_CLOUD_STANDALONE_VERSION) was successfully installed!
# tmp/vagrant-cloud-standalone_$(VAGRANT_CLOUD_STANDALONE_VERSION).zip:
# 	curl -fsSLo $@ 'https://github.com/armab/packer-post-processor-vagrant-cloud-standalone/releases/download/v$(VAGRANT_CLOUD_STANDALONE_VERSION)/packer-post-processor-vagrant-cloud-standalone_$(UNAME)_amd64.zip'
# 	@echo Downloaded new Vagrant-cloud-standalone version: $(VAGRANT_CLOUD_STANDALONE_VERSION)!
# # Install 'packer-post-processor-vagrant-cloud-standalone' only if it doesn't exist
# ~/bin/packer-post-processor-vagrant-cloud-standalone:
# 	@$(MAKE) install-vagrant-cloud-standalone

# Deploy the .box, produced during the `build` to Vagrant Cloud
# deploy: $(PACKER) ~/bin/packer-post-processor-vagrant-cloud-standalone
# 	$(PACKER) build \
# 	  -var 'st2_version=$(ST2_VERSION)' \
# 	  -var 'box_version=$(BOX_VERSION)' \
# 	  st2_deploy.json

clean:
	rm -rf tmp/*
