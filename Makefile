PACKER ?= packer

.PHONY: packer-lint
packer-lint:
	$(PACKER) validate st2.json

.PHONY: build
build:
	$(PACKER) build st2.json

.PHONY: debug-build
debug-build:
	$(PACKER) build --on-error=ask st2.json
