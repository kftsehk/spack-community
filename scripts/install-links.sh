#!/bin/bash

set -exuo pipefail

LS="ls -l --color=always"
MKDIR="mkdir -p"
LN="ln -s -f -n"

pushd $SPACK_ROOT

$MKDIR dist
$LN ../opt/spack dist/apps
$LN ../site/scripts/03-site dist/bin
$LN ../var/spack/bootstrap dist/bootstrap
$LN ../var/spack/cache dist/cache
$LN ../site/envs/03-site dist/envs
$LN /opt/shared/installers dist/installers
$LN /opt/shared/licenses dist/licenses
$LN ../share/spack/lmod dist/lmod
$LN ../share/spack/templates dist/templates
$LS dist

$MKDIR var/spack
$LN ../../site/envs/03-site var/spack/environments
$LS var/spack

$MKDIR etc/spack
$LN ../../site/conf/03-site/concretizer.yaml etc/spack/concretizer.yaml
$LN ../../site/conf/03-site/config.yaml etc/spack/config.yaml
$LN ../../site/conf/03-site/linux etc/spack/linux
$LN /opt/shared/licenses etc/spack/licenses
$LN ../../site/conf/03-site/mirrors.yaml etc/spack/mirrors.yaml
$LN ../../site/conf/03-site/modules.yaml etc/spack/modules.yaml
$LN ../../site/conf/03-site/packages.yaml etc/spack/packages.yaml
$LS etc/spack

set +x

if [ ! -d var/spack/bootstrap ]; then
  spack bootstrap now
fi

set -x

$LS dist

pdm venv create -f $(which $(ls /usr/bin/python3.1[012]))
pdm lock -d -G dev --python ">=3.10" --platform linux --implementation cpython
pdm sync -d -G dev
