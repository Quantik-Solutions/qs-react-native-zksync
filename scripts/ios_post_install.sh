#!/bin/sh

# fail if any commands fails
set -e

ROOT_DIR=$(pwd)
ZKSYNC_LIB_DIR="${ROOT_DIR}"/zksync/sdk/zksync-native

# Check for cargo folder
if [ ! -d "$HOME/.cargo" ]; then
  echo "Installing Rust"

  # install rust
  curl https://sh.rustup.rs -o rustup_init.sh
  sh ./rustup_init.sh --default-toolchain nightly -y
  sh ./rustup_init.sh -y
else
  echo "Previous Rust found"
fi

# set default to nightly & update
# shellcheck disable=SC1090
source "$HOME"/.cargo/env
rustup default nightly

rustup update

if ! command -v cargo-lipo &>/dev/null; then
  echo "Installing Cargo-Lipo"
  cargo install cargo-lipo
else
  echo "Cargo-Lipo found"
fi

# iOS targets
rustup target add aarch64-apple-ios x86_64-apple-ios

# Go to zkSync library directory to build
# ZKSYNC_LIB_DIR === zksync/sdk/zksync-native
cd "${ZKSYNC_LIB_DIR}" || exit 1

# CPackage into iOS library release
cargo lipo --release
