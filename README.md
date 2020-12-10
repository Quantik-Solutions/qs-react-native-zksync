# react-native-zksync

## Getting started

`$ npm install react-native-zksync --save`

### Mostly automatic installation

`$ react-native link react-native-zksync`

## Usage
```javascript
import ZkSync from 'react-native-zksync';

// TODO: What to do with the module?
ZkSync;
```


#=======================   react-native-zksynk example run method   ======================

1. Install rust
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
2. Customize the installation 
leaving the default triple host, 
but selecting the nightly installation, 
complete "Profile", 
& modifying the path variable.

*****
   default host triple: x86_64-apple-darwin
    default toolchain: nightly
    profile: complete
  modify PATH variable: yes
*****
$ source $HOME/.cargo/env


3. Install the Rust compile targets for iOS

$ rustup target add aarch64-apple-ios x86_64-apple-ios
4. Install cargo-lipo
cargo install cargo-lipo
5. head into the zksync-java repo
cd $(REPO_ROOT)/zksync/sdk/zksync-java
6. Run cargo lipo
cargo lipo --release
// Resulting library will be located under the target/universal/release directory



the first child ios directory contains the files for the native module itself. The ios directory under the example child is the xcode directory of the example application pulling in the native module.
You'll need to run yarn under the repo root as well as under the example child directory.
Once that's done you will probably also need to run pod deintegrate under the $(REPO_ROOT)/example/ios directory followed by pod install if you get that annoying libyoga problem.
The project also runs from xcode not the react native npm script although you will still need to have ran the npm start command under the example directory, leaving it running in the background.

When you run the example application it pulls up a simple screen with a couple buttons to try out the main functions. They all work except the sign musig function.