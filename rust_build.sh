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

cargo install cargo-ndk
cargo install cargo-lipo
cargo install cbindgen

bash ./android_build.sh
