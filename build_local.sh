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
# if ! command -v cargo-ndk &>/dev/null; then
#   echo "Installing Cargo-NDK"
#   cargo install cargo-ndk
# else
#   echo "Cargo-NDK found"
# fi

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

# iOS targets
rustup target add aarch64-apple-ios x86_64-apple-ios

# Go to zkSync library directory to build
# ZKSYNC_LIB_DIR === zksync/sdk/zksync-java
cd "./zksync/sdk/zksync-java" || exit 1

# Create C headers & package into iOS library release
cbindgen src/lib.rs -l c > ZkSyncSign.h
cargo lipo --release

# Move results into native module directory to be used
inc=../../../ios/include
libs=../../../ios/libs

rm -rf "${inc}"
rm -rf "${inc}"

mkdir "${inc}"
mkdir "${libs}"

cp ZkSyncSign.h "${inc}"
cp "$ZKSYNC_LIB_DIR"/target/universal/release/libzksyncsign.a "${libs}"
