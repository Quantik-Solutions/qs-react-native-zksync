#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

CWD=$(pwd)
ZKSYNC_LIB_DIR="${CWD}"/zksync/sdk/zksync-java
TEST_APP_DIR="${CWD}"/example

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

if ! command -v detox --version &>/dev/null; then
  echo "Installing detox-cli"
  npm i -g detox-cli
else
  echo "detox-cli found"
fi

# Android targets
rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

# iOS targets
rustup target add aarch64-apple-ios x86_64-apple-ios

# Yarn dependencies
cd "${CWD}" || exit 1
yarn

cd "${TEST_APP_DIR}" || exit 1
yarn

# Go to zkSync library directory to build
# ZKSYNC_LIB_DIR === zksync/sdk/zksync-java
cd "${ZKSYNC_LIB_DIR}" || exit 1

# Create C headers & package into iOS library release
cbindgen src/lib.rs -l c > ZkSyncSign.h
cargo lipo --release

# Move results into native module directory to be used
inc="${CWD}"/ios/include
libs="${CWD}"/ios/libs

rm -rf "${inc}"
rm -rf "${libs}"

mkdir "${inc}"
mkdir "${libs}"

cp ZkSyncSign.h "${inc}"
cp "${ZKSYNC_LIB_DIR}"/target/universal/release/libzksyncsign.a "${libs}"

# If on iOS uncomment the following
#if ! command -v applesimutils &>/dev/null; then
#  echo "Installing applesimutils"
#  brew tap wix/brew
#  brew install applesimutils
#else
#  echo "applesimutils found"
#fi
