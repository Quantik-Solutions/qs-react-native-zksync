#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x

# iOS targets
rustup target add aarch64-apple-ios x86_64-apple-ios
