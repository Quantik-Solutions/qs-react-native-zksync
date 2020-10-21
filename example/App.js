import React, {Component} from 'react';
import {Button, StyleSheet, Text, View} from 'react-native';
import ZkSync from '@quantik-solutions/react-native-zksync';

const hexPrivateKey =
  '0166c0b613d99406d577ebbb582ede3086ce86423d0a61f4c3864d2ca392f496';
const hexSeed = '199659b1c85eb4048e5d47620669492f6ed38194530e023d8c8e161aa72db3a32ebec7e33bbe7bec10a61531c87595bd15681ad1756cb1a74d6426e0b513cd151c';

const verifiedPKey = "03853bd993011bfdb9d0a8bbac8c751c5a82dd69c6c28fcf4e6d43ffeef7e77e"
const verifiedMsgByte = "07000000872a4bf836d0ab56e07e5fa1d773c27026e86ca21f24123639df1c980fb6f9782d15908406410c272400011b8f00000000";
const verifiedSignatureResult = "b16b44d5fbc4bd7689b3f5e8344a1dada5cd9202f4411a705bd545f585b48b232f58d00392f0f7420fa13c7b4b3f8b278774c4a50aef1521afd54f3e51f9e91f7f4a1271141f0a3d439b0b856082fcc38f68bfd62855030f126e4e1019a5cc04";
const verifiedPubKeyHash = "b16b44d5fbc4bd7689b3f5e8344a1dada5cd9202f4411a705bd545f585b48b23";
const verifiedSignature = "2f58d00392f0f7420fa13c7b4b3f8b278774c4a50aef1521afd54f3e51f9e91f7f4a1271141f0a3d439b0b856082fcc38f68bfd62855030f126e4e1019a5cc04";
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
              console.log(await this.signMusig(verifiedPKey, verifiedMsgByte))
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
