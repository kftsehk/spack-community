# list of dependencies between spack environments
# one's LOCK should depends on another's BUILD
# as concretization can result in different deps 

spack-gcc/spack.lock: spack-gcc-bootstrap/spack.build

$(addsuffix /spack.lock,$(SPACK_CORE_ENVS)): spack-gcc/spack.build
