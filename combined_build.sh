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

#if [ ! -a "${home}/.cargo/config.toml" ]; then
  echo "
  [build]
  rustc-wrapper = /usr/local/bin/sccache
  incremental = false
  " >> "${home}"/.cargo/config.toml
#fi

#!/usr/bin/env bash
min_ver=23

# Set the home variable
home=$HOME
#if [ ! -d "/Users/vagrant" ]; then
#  home=/Users/vagrant
#else
#  exit 1
#fi

# Make sure we have rust in scope
source "${home}"/.cargo/env

# Android targets
rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

# Go to zkSync library directory to build
cd "$ZKSYNC_LIB_DIR" || exit 1

# Build the android aar releases
cargo ndk --target aarch64-linux-android --android-platform ${min_ver} -- build --release
cargo ndk --target armv7-linux-androideabi --android-platform ${min_ver} -- build --release
cargo ndk --target i686-linux-android --android-platform ${min_ver} -- build --release
cargo ndk --target x86_64-linux-android --android-platform ${min_ver} -- build --release

# Move results into native module directory to be used
jniLibs="${home}"/git/android/src/main/jniLibs
libName=libzksync.so

rm -rf "${jniLibs}"

mkdir "${jniLibs}"
mkdir "${jniLibs}"/arm64-v8a
mkdir "${jniLibs}"/armeabi-v7a
mkdir "${jniLibs}"/x86
mkdir "${jniLibs}"/x86_64

cp "$ZKSYNC_LIB_DIR"/target/aarch64-linux-android/release/${libName} "${jniLibs}"/arm64-v8a/${libName}
cp "$ZKSYNC_LIB_DIR"/target/armv7-linux-androideabi/release/${libName} "${jniLibs}"/armeabi-v7a/${libName}
cp "$ZKSYNC_LIB_DIR"/target/i686-linux-android/release/${libName} "${jniLibs}"/x86/${libName}
cp "$ZKSYNC_LIB_DIR"/target/x86_64-linux-android/release/${libName} "${jniLibs}"/x86_64/${libName}

# List devices
adb devices


