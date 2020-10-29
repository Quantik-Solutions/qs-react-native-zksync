#!/usr/bin/env bash
min_ver=23

# Set the home variable
home=$HOME
if [ ! -d "/Users/vagrant" ]; then
  home=/Users/vagrant
else
  exit 1
fi

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
