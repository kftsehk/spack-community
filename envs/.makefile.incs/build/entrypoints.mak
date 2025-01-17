BUILD_TARGETS := $(addprefix build@,$(SPACK_ENVS))
REBUILD_TARGETS := $(addprefix rebuild@,$(SPACK_ENVS))


build@__all__: $(addprefix build@,$(SPACK_CORE_ENVS))
	@echo "[build] All completed"

rebuild@__all__: $(addprefix rebuild@,$(SPACK_CORE_ENVS))
	@echo "[rebuild] All completed"

$(BUILD_TARGETS):
build@%: %/spack.build %/spack.yaml
	@echo "[$*] build completed"

$(REBUILD_TARGETS):
rebuild@: %/spack.yaml
	-rm $*/spack.build
	$(MAKE) build@$*
	@echo "[$*] rebuild completed"

GENERATED_TARGETS := $(GENERATED_TARGETS) $(BUILD_TARGETS) $(REBUILD_TARGETS)
PHONY_TARGETS := $(PHONY_TARGETS) build@__all__ rebuild@__all__
