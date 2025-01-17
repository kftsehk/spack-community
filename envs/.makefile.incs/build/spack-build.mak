SPACK_ENV_LOCK_TARGETS := $(addsuffix /spack.lock,$(SPACK_ENVS))
SPACK_ENV_BUILD_TARGETS := $(addsuffix /spack.build,$(SPACK_ENVS))


$(SPACK_ENV_LOCK_TARGETS):
%/spack.lock: %/spack.yaml $(SPACK_CONFIG_MAIN) $(DNF_UPGRADE_TARGET) $(FORCE_REBUILD_TARGET)
	$(SPACK_EXE) -e $* lock -U 2>&1

$(SPACK_ENV_BUILD_TARGETS):
%/spack.build: %/spack.lock $(SPACK_CONFIG_MAIN) $(FORCE_REBUILD_TARGET)
	( \
		for i in {1..$(NUM_PARALLEL_BUILDS)}; do \
			$(SPACK_EXE) -e $* sync & \
		done; \
		exitcode=0; \
		for i in {1..$(NUM_PARALLEL_BUILDS)}; do \
			wait; \
			exitcode=$$((exitcode + $$?)); \
		done; \
		exit $$exitcode; \
	) 2>&1 | tee -a $*/build-$(shell date +%Y%m%d%H%M%S).log \
	  && touch $@

FILE_TARGETS := $(FILE_TARGETS) $(SPACK_ENV_LOCK_TARGETS) $(SPACK_ENV_BUILD_TARGETS)
