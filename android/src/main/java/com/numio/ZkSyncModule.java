package com.numio;

import com.facebook.react.bridge.*;
import com.numio.ZkSync;
public class ZkSyncModule extends ReactContextBaseJavaModule {
    private static native String privateKeyFromSeed(final String input);
    private static native String privateKeyToPublicKeyHash(final String input);

    private final ReactApplicationContext reactContext;

    public ZkSyncModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        System.loadLibrary("zksync");
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

//    @ReactMethod
//    public void pKeyFromSeed(String hexSeed, Promise promise) {
//        try {
//            String hexPKey = privateKeyFromSeed(hexSeed);
//            promise.resolve(hexPKey);
//        } catch (Error e) {
//            promise.reject(e);
//        }
//    }

    @ReactMethod
    public void pKeyToPubKeyHash(String pKey, Promise promise) {
        try {

            ZkSync zkSync = new ZkSync();
            zkSync.setPromise((PromiseImpl) promise);
            zkSync.privateKeyToPublicKeyHash(pKey);
//            String hexHash = privateKeyToPublicKeyHash(pKey);
        } catch (Error e) {
            promise.reject(e);
        }
    }
}
