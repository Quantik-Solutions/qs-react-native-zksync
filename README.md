# react-native-zksync

## Getting started

`$ npm install react-native-zksync --save`

### Mostly automatic installation

`$ react-native link react-native-zksync`

### iOS Installation

1.

```jsx
$ cd node_modules/react-native-zksync/zksync/sdk/zksync-java && sh ./scripts/ios_post_install.sh
```

2. Under the general settings of the X-Code target add the node_modules/react-native-zksync/zksync/sdk/zksync-java/target/universal/release/libzksyncsign.a library into the "Frameworks, Libraries, and Embedded Content" menu.

## Usage

```
import ZkSync from 'react-native-zksync';// TODO: What to do with the module?ZkSync;
```
