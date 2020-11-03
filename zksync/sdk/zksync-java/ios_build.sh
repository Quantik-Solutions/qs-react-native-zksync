#!/usr/bin/env bash

cbindgen src/lib.rs -l c > ZkSync.h
cargo lipo --release

# we're still in the `rust` folder so...
inc=../../../ios/include
libs=../../../ios/libs

mkdir ${inc}
mkdir ${libs}

cp ZkSync.h ${inc}
cp target/universal/release/libzksync.a ${libs}
