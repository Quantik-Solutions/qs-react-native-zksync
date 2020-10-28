#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# install rust
curl https://sh.rustup.rs -o rustup_init.sh

#sh ./rustup_init.sh --default-toolchain nightly -y
sh ./rustup_init.sh -y

source $HOME/.cargo/env

# Android targets
rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
# iOS targets
rustup target add aarch64-apple-ios armv7-apple-ios armv7s-apple-ios x86_64-apple-ios i386-apple-ios

cargo install cargo-ndk
cargo install cargo-lipo
cargo install cbindgen

bash ./android_build.sh
