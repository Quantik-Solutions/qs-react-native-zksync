import { Signature } from "./types";
// @ts-ignore
import ZkSync from '@teamnumio/react-native-zksync';
import { utils } from "ethers";

export async function privateKeyFromSeed(privateKey: Uint8Array): Promise<Uint8Array> {
    return utils.arrayify(`0x${await ZkSync.privateKeyFromSeed(utils.hexlify(privateKey).substr(2))}`)
}

export async function signTransactionBytes(privKey: Uint8Array, bytes: Uint8Array): Promise<Signature> {
    const signaturePacked = await ZkSync.signMusig(utils.hexlify(privKey).substr(2), utils.hexlify(bytes).substr(2));
    const pubKey = utils.hexlify(utils.arrayify(`0x${signaturePacked}`).slice(0, 32)).substr(2)
    const signature = utils.hexlify(utils.arrayify(`0x${signaturePacked}`).slice(32)).substr(2)
    return {
        pubKey,
        signature
    };
}

export async function privateKeyToPubKeyHash(privateKey: Uint8Array): Promise<string> {
    return await ZkSync.publicKeyHashFromPrivateKey(utils.hexlify(privateKey).substr(2));
}
