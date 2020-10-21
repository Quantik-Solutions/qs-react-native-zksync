import { Signature } from "./types";
// @ts-ignore
import ZkSync from '@quantik-solutions/react-native-zksync';
import { utils } from "ethers";

export async function privateKeyFromSeed(privateKey: Uint8Array): Promise<Uint8Array> {
    return await ZkSync.privateKeyFromSeed(utils.toUtf8String(privateKey))
}

// TODO: Check this, the substr in between what seems to be concatenated strings
export async function signTransactionBytes(privKey: Uint8Array, bytes: Uint8Array): Promise<Signature> {
    const signaturePacked = await ZkSync.signMusig(utils.hexlify(privKey).substr(2), utils.hexlify(bytes).substr(2));
    const pubKey = utils.hexlify(utils.arrayify(`$0x{signaturePacked}`).slice(0, 32)).substr(2)
    const signature = utils.hexlify(utils.arrayify(`$0x{signaturePacked}`).slice(32)).substr(2)
    return {
        pubKey,
        signature
    };
}

export async function privateKeyToPubKeyHash(privateKey: Uint8Array): Promise<string> {
    return await ZkSync.publicKeyHashFromPrivateKey(utils.toUtf8String(privateKey));
}