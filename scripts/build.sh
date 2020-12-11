#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# Set the home variable
home=$HOME
#if [ ! -d "/Users/vagrant" ]; then
#  home=/Users/vagrant
#else
#  exit 1
#fi

# Check for cargo folder
if [ ! -d "${home}/.cargo" ]; then
  echo "Installing Rust"

  # install rust
  curl https://sh.rustup.rs -o rustup_init.sh
  sh ./rustup_init.sh --default-toolchain nightly -y
  sh ./rustup_init.sh -y
else
  echo "Previous Rust found"
fi

# shellcheck disable=SC1090
source "${home}"/.cargo/env
rustup default nightly

# Check for needed cargo utils
if ! command -v cargo-ndk &>/dev/null; then
  echo "Installing Cargo-NDK"
  cargo install cargo-ndk
else
  echo "Cargo-NDK found"
fi

if ! command -v cargo-lipo &>/dev/null; then
  echo "Installing Cargo-Lipo"
  cargo install cargo-lipo
else
  echo "Cargo-Lipo found"
fi

if ! command -v cbindgen &>/dev/null; then
  echo "Installing cbindgen"
  cargo install cbindgen
else
  echo "cbindgen found"
fi

if ! command -v sccache &>/dev/null; then
  echo "Installing sccache"
  brew install sccache
else
  echo "sccache found"
fi

if [ ! -d "${home}"/sccache_dir ]; then
  echo "Creating SC Cache Directory"
  mkdir "${home}"/sccache_dir
else
  echo "previous sccache_dir found"
fi

if [ ! -a "${home}/.cargo/config.toml" ]; then
  cp "$PROJECT_ROOT"/cargo_config.toml "${home}"/.cargo/config.toml
fi
