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

# Make sure we have rust in scope
source "${home}"/.cargo/env

# iOS targets
rustup target add aarch64-apple-ios x86_64-apple-ios

# Go to zkSync library directory to build
# ZKSYNC_LIB_DIR === zksync/sdk/zksync-java
cd "$ZKSYNC_LIB_DIR" || exit 1

# Create C headers & package into iOS library release
cbindgen src/lib.rs -l c > ZkSyncSign.h
cargo lipo --release

# Move results into native module directory to be used
inc=$PROJECT_ROOT/ios/include
libs=$PROJECT_ROOT/ios/libs

rm -rf "${inc}"
rm -rf "${inc}"

mkdir "${inc}"
mkdir "${libs}"

cp ZkSyncSign.h "${inc}"
cp "$ZKSYNC_LIB_DIR"/target/universal/release/libzksyncsign.a "${libs}"
