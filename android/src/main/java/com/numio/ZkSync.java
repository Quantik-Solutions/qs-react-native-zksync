package com.numio;
import com.facebook.react.bridge.PromiseImpl;

public class ZkSync {
    private static native void publicKeyHashFromPrivateKey(ZkSync callback, String privateKey);
    private static native void signMusig(ZkSync callback, String privateKey, String txnMsg);
    private static native void privateKeyFromSeed(ZkSync callback, String seed);

    private PromiseImpl promise;

    public void setPromise(PromiseImpl promise) {
        this.promise = promise;
    }

    public void publicKeyHashFromPrivateKey(String privateKey) {
        ZkSync.publicKeyHashFromPrivateKey(this, privateKey);
    }

    public void signMusig(String privateKey, String txnMsg) {
        ZkSync.signMusig(this, privateKey, txnMsg);
    }

    public void privateKeyFromSeed(String seed) {
        ZkSync.privateKeyFromSeed(this, seed);
    }

    public void resolveCallback(String result) {
       promise.resolve(result);
    }
}
