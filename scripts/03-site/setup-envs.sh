_spack_variant="origin"
_spack_root="/home/kftse/spack-develop/$_spack_variant"
_spack_system_config_path="$_spack_root/site/conf/02-system"
_spack_user_config_path="$(realpath --canonicalize-missing ${SPACK_USER_CONFIG_PATH:-$HOME/.spack@$_spack_variant})"
_spack_user_cache_path="$(realpath --canonicalize-missing ${SPACK_USER_CACHE_PATH:-$HOME/.spack@$_spack_variant})"

function _spack_variant_init() {
  echo "==> You are using [$_spack_variant] spack instance"
  echo
  echo "Please do not mix packages installed from different spack instances"
  echo

  echo "==> Checking spack config and cache paths"

  if [[ "$_spack_user_config_path/" =~ "$HOME/.spack/" ]]; then
    echo "E=> Refuse to use ~/.spack as spack config path"
    echo "    Please unset SPACK_USER_CONFIG_PATH in environment, or set SPACK_USER_CONFIG_PATH to a different path"
    return 1
  elif [ -d "${_spack_user_config_path}" ]; then
    if ! (cat "${_spack_user_config_path}/.spack-config.variant" 2>/dev/null | grep -s -q "^$_spack_variant\$"); then
      echo "E=> Found existing spack config at ${_spack_user_config_path}"
      echo "    But the config is not for [$_spack_variant]"
      echo "    Please remove this directory if you want to use this path"
      return 1
    fi
  else
    mkdir -p "${_spack_user_config_path}"
    echo "$_spack_variant" >"${_spack_user_config_path}/.spack-config.variant"
    echo "$_spack_variant" >"${_spack_user_config_path}/.spack-cache.variant"
  fi
  echo "    Your spack config is located at ${_spack_user_config_path}"

  if [[ "$_spack_user_cache_path/" =~ "$HOME/.spack/" ]]; then
    echo "E=> Refuse to use ~/.spack as spack cache path"
    echo "    Please unset SPACK_USER_CACHE_PATH in environment, or set SPACK_USER_CACHE_PATH to a different path"
    return 1
  elif [ -d "${_spack_user_cache_path}" ]; then
    if ! (cat "${_spack_user_cache_path}/.spack-cache.variant" 2>/dev/null | grep -s -q "^$_spack_variant\$"); then
      echo "E=> Found existing spack cache at ${_spack_user_cache_path}"
      echo "    But the cache is not for [$_spack_variant]"
      echo "    Please remove this directory if you want to use this path"
      return 1
    fi
  else
    mkdir -p "${_spack_user_cache_path}"
    echo "$_spack_variant" >"${_spack_user_cache_path}/.spack-cache.variant"
  fi
  echo "    Your spack apps are located at ${_spack_user_cache_path}"
  echo

  export SPACK_VARIANT="$_spack_variant"
  export SPACK_ROOT="$_spack_root"
  export SPACK_SYSTEM_CONFIG_PATH="$_spack_system_config_path"
  export SPACK_USER_CONFIG_PATH="$_spack_user_config_path"
  export SPACK_USER_CACHE_PATH="$_spack_user_cache_path"
  return 0
}

_spack_variant_init
_spack_variant_init_ret=$?
unset -f _spack_variant_init
unset _spack_variant _spack_root _spack_system_config_path _spack_user_config_path _spack_user_cache_path
if [ $_spack_variant_init_ret -eq 0 ]; then
  unset _spack_variant_init_ret
  echo "==> Setting up spack [$SPACK_VARIANT] environment"
  export MODULEPATH="$(echo $MODULEPATH | tr ':' '\n' | grep -v 'spack' | tr '\n' ':')"
  module use $SPACK_ROOT/dist/lmod/linux-*/Core || true
  source $SPACK_ROOT/share/spack/setup-env.sh
else
  unset _spack_variant_init_ret
  echo "E=> Failed to setup spack [$SPACK_VARIANT] environment"
  echo "    Please fix the above error and try again"
fi
