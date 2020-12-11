#!/usr/bin/env bash
MIN_VERSION=23

# Set the HOME variable
HOME=$HOME
#if [ ! -d "/Users/vagrant" ]; then
#  HOME=/Users/vagrant
#else
#  exit 1
#fi

# Make sure we have rust in scope
source "${HOME}"/.cargo/env

# Android targets
rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

# Go to zkSync library directory to build
cd "$ZKSYNC_LIB_DIR" || exit 1

# Build the android aar releases
cargo ndk --target aarch64-linux-android --android-platform ${MIN_VERSION} -- build --release
cargo ndk --target armv7-linux-androideabi --android-platform ${MIN_VERSION} -- build --release
cargo ndk --target i686-linux-android --android-platform ${MIN_VERSION} -- build --release
cargo ndk --target x86_64-linux-android --android-platform ${MIN_VERSION} -- build --release

# Move results into native module directory to be used
ANDROID_JNI_ROOT="${HOME}"/git/android/src/main/jniLibs
LIB_NAME=libzksync.so

rm -rf "${ANDROID_JNI_ROOT}"

mkdir "${ANDROID_JNI_ROOT}"
mkdir "${ANDROID_JNI_ROOT}"/arm64-v8a
mkdir "${ANDROID_JNI_ROOT}"/armeabi-v7a
mkdir "${ANDROID_JNI_ROOT}"/x86
mkdir "${ANDROID_JNI_ROOT}"/x86_64

cp "$ZKSYNC_LIB_DIR"/target/aarch64-linux-android/release/${LIB_NAME} "${ANDROID_JNI_ROOT}"/arm64-v8a/${LIB_NAME}
cp "$ZKSYNC_LIB_DIR"/target/armv7-linux-androideabi/release/${LIB_NAME} "${ANDROID_JNI_ROOT}"/armeabi-v7a/${LIB_NAME}
cp "$ZKSYNC_LIB_DIR"/target/i686-linux-android/release/${LIB_NAME} "${ANDROID_JNI_ROOT}"/x86/${LIB_NAME}
cp "$ZKSYNC_LIB_DIR"/target/x86_64-linux-android/release/${LIB_NAME} "${ANDROID_JNI_ROOT}"/x86_64/${LIB_NAME}

# List devices
adb devices

# iOS targets
rustup target add aarch64-apple-ios x86_64-apple-ios

# Go to zkSync library directory to build
cd "$ZKSYNC_LIB_DIR" || exit 1

# Create C headers & package into iOS library release
cbindgen src/lib.rs -l c > ZkSync.h
cargo lipo --release

# Move results into native module directory to be used
inc=$PROJECT_ROOT/ios/include
libs=$PROJECT_ROOT/ios/libs

mkdir "${inc}"
mkdir "${libs}"

cp ZkSync.h "${inc}"
cp "$ZKSYNC_LIB_DIR"/target/universal/release/libzksync.a "${libs}"

