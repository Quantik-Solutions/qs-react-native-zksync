package com.numio;

public class ZkSync {
    private static native void privateKeyToPublicKeyHash(ZkSync callback, String privateKey);
    private PromiseInterface promise;

    enum FunctionEnum {
        PKEY_TO_PUBKEY_HASH
    }

    interface PromiseInterface {
        void resolve(String result);
        void reject(String result);
    }

    public static void main(String[] args) {
        if (args.length > 1) {
            FunctionEnum functionEnum = FunctionEnum.valueOf(args[0]);
            switch (functionEnum) {
                case PKEY_TO_PUBKEY_HASH:
                    ZkSync.privateKeyToPublicKeyHash(new ZkSync(), args[1]);
            }
        }
    }

    public void resolveCallback(String result) {
        System.out.println(result);
    }
}
