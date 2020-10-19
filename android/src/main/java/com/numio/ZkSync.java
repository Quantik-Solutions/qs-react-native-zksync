package com.numio;
import com.facebook.react.bridge.PromiseImpl;

public class ZkSync {
//
//    public ZkSync(PromiseImpl ogPromise) {
//        promise = ogPromise;
//    }

    private static native void privateKeyToPublicKeyHash(ZkSync callback, String privateKey);

    public void setPromise(PromiseImpl promise) {
        this.promise = promise;
    }

    private PromiseImpl promise;
    enum FunctionEnum {
        PKEY_TO_PUBKEY_HASH
    }

    public void privateKeyToPublicKeyHash(String privateKey) {
        ZkSync.privateKeyToPublicKeyHash(this, privateKey);
    }

    public void resolveCallback(String result) {
       promise.resolve(result);
    }
}
