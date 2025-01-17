DEBUG ?= 0
DEVELOPMENT ?= 1
NUM_PARALLEL_BUILDS := 4

SHELL := /usr/bin/bash -o pipefail
SUDO  := sudo
SPACK_EXE := spack

# for debugging
FILE_TARGETS :=
GENERATED_TARGETS :=
PHONY_TARGETS :=

default: build@__all__

include .makefile.incs/preflight.mak
include .makefile.incs/debug.mak
include .makefile.incs/dnf.mak
include .makefile.incs/build/common.mak
include .makefile.incs/build/entrypoints.mak
include .makefile.incs/build/spack-env-deps.mak
include .makefile.incs/build/spack-build.mak

.SUFFIXES: .build .lock .yaml
.PHONY: $(PHONY_TARGETS)

check:
	_incomplete_build=0; \
	for env in $$(find -maxdepth 1 -mindepth 1 -type d | cut -d/ -f2); do \
		if spack -e $$env find -c | grep -v -E '^(\[[+e]\]|-- |==> |$$)'; then \
			echo "[$$env] build incomplete"; \
			_incomplete_build=1; \
		fi; \
	done; \
	exit $$_incomplete_build

lmod:
	spack_args="--delete-tree -y"; \
	for env in $$(find -maxdepth 1 -mindepth 1 -type d | cut -d/ -f2); do \
		echo spack -e $$env lmod refresh $$spack_args; \
		spack -e $$env lmod refresh $$spack_args; \
		spack_args="-y"; \
	done

gc:
	echo n | spack gc -E -b | grep @ | grep -v -E ' / ' | awk '{printf "/%s\n",$$1}' | xargs -r -t -P $$(nproc) -i spack uninstall --force -y {}
	spack gc -E -b -y

clean:
	spack cacheclean
