import Foundation
import UIKit


@objc(ZkSync)
class ZkSync: NSObject {

    @objc   //(multiply:withB:withResolver:withRejecter:)
    func multiply(_ a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        resolve(a*b)
    }

    @objc   //(publicKeyHashFromPrivateKey:withResolver:withRejecter:)
    func publicKeyHashFromPrivateKey(_ privateKey: NSString, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let privateKeyS = privateKey as String
        let result = public_key_hash_from_private_key(privateKeyS);
        let pubKeyHash = String(cString: result!)
        string_release(UnsafeMutablePointer(mutating: result))
        resolve(pubKeyHash);
    }

    @objc   //(signMusig:txnMsg:withResolver:withRejecter:)
    func signMusig(_ privateKey: NSString, txnMsg: NSString, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let privateKeyS = privateKey as String
        let txnMsgS = txnMsg as String
        let result = sign_musig(privateKeyS, txnMsgS);
        let signedBytes = String(cString: result!)
        string_release(UnsafeMutablePointer(mutating: result))
        resolve(signedBytes);
    }

    @objc   //(privateKeyFromSeed:withResolver:withRejecter:)
    func privateKeyFromSeed(_ seed: NSString, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let seedS = seed as String
        let result = private_key_from_seed(seedS);
        let privateKey = String(cString: result!)
        string_release(UnsafeMutablePointer(mutating: result))
        resolve(privateKey);
    }

    //...   @objc   (publicKeyFromPrivateKey:withResolver:withRejecter:)
    @objc func publicKeyFromPrivateKey(_ privateKey: NSString, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let privateKeyS = privateKey as String

        let result = public_key_from_private_key(privateKeyS);
        let publickKey = String(cString: result!)
        string_release(UnsafeMutablePointer(mutating: result))
        resolve(publickKey);
    }
}
