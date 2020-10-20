import React, {Component} from 'react';
import {Button, StyleSheet, Text, View} from 'react-native';
import ZkSync from '@quantik-solutions/react-native-zksync';

const hexPrivateKey =
  '0166c0b613d99406d577ebbb582ede3086ce86423d0a61f4c3864d2ca392f496';
const hexSeed =
  '199659b1c85eb4048e5d47620669492f6ed38194530e023d8c8e161aa72db3a32ebec7e33bbe7bec10a61531c87595bd15681ad1756cb1a74d6426e0b513cd151c';
const correctPubKeyHash = '7731c2c99f46cc2f7f5e564ffd8f5e17e0a8160b';

export default class App extends Component<{}> {
  state = {
    status: 'starting',
    message: '--',
  };

  componentDidMount() {
    ZkSync.sampleMethod('Testing', 123, (message) => {
      this.setState({
        status: 'native callback received',
        message,
      });
    });
  }

  privateKeyFromSeed = async (seed) => {
    return await ZkSync.privateKeyFromSeed(seed);
  };

  pubKeyHashFromPKey = async (pKey) => {
    try {
      return await ZkSync.publicKeyHashFromPrivateKey(pKey);
    } catch (e) {
      console.log(e);
    }
  };

  signMusig = async (pKey, hexTxnMsg) => {
    try {
      return await ZkSync.signMusig(pKey, hexTxnMsg);
    } catch (e) {
      console.log(e);
    }
  };

  pubKeyFromPKey = async (pKey) => {
    try {
      return await ZkSync.publicKeyFromPrivateKey(pKey);
    } catch (e) {
      console.log(e);
    }
  };

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>☆NATIVE CALLBACK MESSAGE☆</Text>
        <Text style={styles.instructions}>{this.state.message}</Text>
        <View style={styles.btnWrapper}>
          <Button
            style={styles.btn}
            title="pub Key Hash"
            onPress={async () =>
              console.log(await this.pubKeyHashFromPKey(hexPrivateKey))
            }
          />
        </View>
        <View style={styles.btnWrapper}>
          <Button
            style={styles.btn}
            title="sign musig"
            onPress={async () =>
              console.log(await this.signMusig(hexPrivateKey, hexSeed))
            }
          />
        </View>
        <View style={styles.btnWrapper}>
          <Button
            style={styles.btn}
            title="seed to pkey"
            onPress={async () =>
              console.log(await this.privateKeyFromSeed(hexSeed))
            }
          />
        </View>
        <View style={styles.btnWrapper}>
          <Button
            style={styles.btn}
            title="pkey to pubkey"
            onPress={async () =>
              console.log(await this.pubKeyFromPKey(hexPrivateKey))
            }
          />
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  btnWrapper: {
    margin: 10,
  },
});
