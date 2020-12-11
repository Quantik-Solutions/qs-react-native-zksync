import React, {Component} from 'react';
import {Button, StyleSheet, Text, View} from 'react-native';
import ZkSync from '@teamnumio/react-native-zksync';
import TestData from './testData.json';

export default class App extends Component<{}> {
  state = {
    status: 'starting',
    message: '',
  };

  privateKeyFromSeed = async (seed) => {
    let result = await ZkSync.privateKeyFromSeed(seed);
    this.setState({
      status: 'native callback received',
      message: result,
    });
  };

  pubKeyHashFromPKey = async (pKey) => {
    try {
      let result = await ZkSync.publicKeyHashFromPrivateKey(pKey);
      this.setState({
        status: 'native callback received',
        message: result,
      });
    } catch (e) {
      console.log(e);
    }
  };

  signMusig = async (pKey, hexTxnMsg) => {
    try {
      let result = await ZkSync.signMusig(pKey, hexTxnMsg);
      this.setState({
        status: 'native callback received',
        message: result,
      });
    } catch (e) {
      console.log(e);
    }
  };

  pubKeyFromPKey = async (pKey) => {
    try {
      let result = await ZkSync.publicKeyFromPrivateKey(pKey);
      this.setState({
        status: 'native callback received',
        message: result,
      });
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
            testID="pubKeyHash"
            title="pub Key Hash"
            onPress={async () =>
              console.log(await this.pubKeyHashFromPKey(TestData.hexPrivateKey))
            }
          />
        </View>
        <View style={styles.btnWrapper}>
          <Button
            style={styles.btn}
            testID="signMusig"
            title="sign musig"
            onPress={async () =>
              console.log(
                await this.signMusig(
                  TestData.verifiedPKey,
                  TestData.verifiedMsgByte,
                ),
              )
            }
          />
        </View>
        <View style={styles.btnWrapper}>
          <Button
            style={styles.btn}
            title="seed to pkey"
            testID="seedToPubKey"
            onPress={async () =>
              console.log(await this.privateKeyFromSeed(TestData.hexSeed))
            }
          />
        </View>
        <View style={styles.btnWrapper}>
          <Button
            style={styles.btn}
            testID="pKeyToPubKey"
            title="pkey to pubkey"
            onPress={async () =>
              console.log(await this.pubKeyFromPKey(TestData.verifiedPKey))
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
