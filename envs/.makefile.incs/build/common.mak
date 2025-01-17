SPACK_ENVS := $(shell find -maxdepth 2 -mindepth 2 -iname "spack.yaml" | cut -d/ -f2)
SPACK_CORE_ENVS := $(shell echo -n $(SPACK_ENVS) | tr ' ' '\n' | grep -v -e '^spack-gcc-bootstrap$$' -e '^spack-gcc$$' -e '^dev-')

SPACK_CONFIG_MAIN := .spack-config.main.log
SPACK_CONFIG_MODULE := .spack-config.module.log
SPACK_CONFIG_VIEW := .spack-config.view.log
SPACK_CONFIG_MIRRORS := .spack-config.mirrors.log


dump-spack-config:
	$(MAKE) -k .spack-config.main.log .spack-config.module.log .spack-config.view.log .spack-config.mirrors.log

$(SPACK_CONFIG_MAIN):
	( for i in compilers concretizer repos packages config upstreams; do \
		spack config get $$i; \
	done ) 2>&1 | tee $@

$(SPACK_CONFIG_MODULE):
	( spack config get modules ) 2>&1  | tee $@

$(SPACK_CONFIG_VIEW):
	( spack config get view ) 2>&1  | tee $@

$(SPACK_CONFIG_MIRRORS):
	( spack config get mirrors ) 2>&1  | tee $@

FILE_TARGETS := $(FILE_TARGETS) $(SPACK_CONFIG_MAIN) $(SPACK_CONFIG_MODULE) $(SPACK_CONFIG_VIEW) $(SPACK_CONFIG_MIRRORS)
PHONY_TARGETS := $(PHONY_TARGETS) dump-spack-config
