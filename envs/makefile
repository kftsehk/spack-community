SHELL := /usr/bin/bash
TARGETS := $(addprefix .,$(addsuffix .build,$(shell find -maxdepth 1 -mindepth 1 -type d | cut -d/ -f2)))

.dnf-upgrade.build:
	sudo dnf --refresh upgrade -y 2>&1 | tee $@

$(TARGETS):
.%.build: $*/ .dnf-upgrade.build
	spack -e $* lock -U 2>&1 | tee $@
	( \
		for i in {1..4}; do \
			spack -e $* sync & \
		done; \
		for i in {1..4}; do \
			wait; \
		done; \
	) 2>&1 | tee -a $@

check:
	_incomplete_build=0; \
	for env in $$(find -maxdepth 1 -mindepth 1 -type d | cut -d/ -f2); do \
		if spack -e $$env find -c | grep -v -E '^(\[[+e]\]|-- |==> |$$)'; then \
			echo "[$$env] build incomplete"; \
			_incomplete_build=1; \
		fi; \
	done; \
	exit $$_incomplete_build

clean:
	spack cacheclean

dist-clean: clean
	spack gc -E -b -y
