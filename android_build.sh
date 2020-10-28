#!/usr/bin/env bash
# set the version to use the library
min_ver=23
# verify before executing this that you have the proper targets installed
cargo ndk --target aarch64-linux-android --android-platform ${min_ver} -- build --release --manifest-path ./zksync/sdk/zksync-java/Cargo.toml
cargo ndk --target armv7-linux-androideabi --android-platform ${min_ver} -- build --release --manifest-path ./zksync/sdk/zksync-java/Cargo.toml
cargo ndk --target i686-linux-android --android-platform ${min_ver} -- build --release --manifest-path ./zksync/sdk/zksync-java/Cargo.toml
cargo ndk --target x86_64-linux-android --android-platform ${min_ver} -- build --release --manifest-path ./zksync/sdk/zksync-java/Cargo.toml
# moving libraries to the android project

jniLibs=./android/src/main/jniLibs
libName=libzksync.so

rm -rf ${jniLibs}

mkdir ${jniLibs}
mkdir ${jniLibs}/arm64-v8a
mkdir ${jniLibs}/armeabi-v7a
mkdir ${jniLibs}/x86
mkdir ${jniLibs}/x86_64

cp ./zksync/sdk/zksync-java/target/aarch64-linux-android/release/${libName} ${jniLibs}/arm64-v8a/${libName}
cp ./zksync/sdk/zksync-java/target/armv7-linux-androideabi/release/${libName} ${jniLibs}/armeabi-v7a/${libName}
cp ./zksync/sdk/zksync-java/target/i686-linux-android/release/${libName} ${jniLibs}/x86/${libName}
cp ./zksync/sdk/zksync-java/target/x86_64-linux-android/release/${libName} ${jniLibs}/x86_64/${libName}
