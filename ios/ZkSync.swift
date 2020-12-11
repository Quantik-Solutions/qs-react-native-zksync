@objc(ZkSync)
class ZkSync: NSObject {

    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        resolve(a*b)
    }

    @objc(publicKeyHashFromPrivateKey:withResolver:withRejecter:)
    func publicKeyHashFromPrivateKey(privateKey: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let result = public_key_hash_from_private_key(privateKey);
        let pubKeyHash = String(cString: result!)
        string_release(UnsafeMutablePointer(mutating: result))
        resolve(pubKeyHash);
    }

    @objc(signMusig:txnMsg:withResolver:withRejecter:)
    func signMusig(_ privateKey: String, txnMsg: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let result = sign_musig(privateKey, txnMsg);
        let signedBytes = String(cString: result!)
        string_release(UnsafeMutablePointer(mutating: result))
        resolve(signedBytes);
    }

    @objc(privateKeyFromSeed:withResolver:withRejecter:)
    func privateKeyFromSeed(seed: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let result = private_key_from_seed(seed);
        let privateKey = String(cString: result!)
        string_release(UnsafeMutablePointer(mutating: result))
        resolve(privateKey);
    }

    @objc(publicKeyFromPrivateKey:withResolver:withRejecter:)
    func publicKeyFromPrivateKey(privateKey: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let result = public_key_from_private_key(privateKey);
        let publickKey = String(cString: result!)
        string_release(UnsafeMutablePointer(mutating: result))
        resolve(publickKey);
    }
}
