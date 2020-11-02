package com.numio;

import com.facebook.react.bridge.*;
import com.numio.ZkSync;
public class ZkSyncModule extends ReactContextBaseJavaModule {
    private final ReactApplicationContext reactContext;

    public ZkSyncModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        System.loadLibrary("zksyncsign");
    }

    @Override
    public String getName() {
        return "ZkSync";
    }

    @ReactMethod
    public void sampleMethod(String stringArgument, int numberArgument, Callback callback) {
        // TODO: Implement some actually useful functionality
        callback.invoke("Received numberArgument: " + numberArgument + " stringArgument: " + stringArgument);
    }

    @ReactMethod
    public void publicKeyHashFromPrivateKey(String pKey, Promise promise) {
        try {
            ZkSync zkSync = new ZkSync();
            zkSync.setPromise((PromiseImpl) promise);
            zkSync.publicKeyHashFromPrivateKey(pKey);
        } catch (Error e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void signMusig(String pKey, String txnMsg, Promise promise) {
        try {
            ZkSync zkSync = new ZkSync();
            zkSync.setPromise((PromiseImpl) promise);
            zkSync.signMusig(pKey, txnMsg);
        } catch (Error e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void privateKeyFromSeed(String seed, Promise promise) {
        try {
            ZkSync zkSync = new ZkSync();
            zkSync.setPromise((PromiseImpl) promise);
            zkSync.privateKeyFromSeed(seed);
        } catch (Error e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void publicKeyFromPrivateKey(String privateKey, Promise promise) {
        try {
            ZkSync zkSync = new ZkSync();
            zkSync.setPromise((PromiseImpl) promise);
            zkSync.publicKeyFromPrivateKey(privateKey);
        } catch (Error e) {
            promise.reject(e);
        }
    }
}
