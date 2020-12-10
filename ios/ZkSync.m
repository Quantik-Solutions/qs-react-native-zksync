#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(ZkSync, NSObject)

    RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
                    withResolver:(RCTPromiseResolveBlock)resolve
                    withRejecter:(RCTPromiseRejectBlock)reject)

    RCT_EXTERN_METHOD(publicKeyHashFromPrivateKey:  (NSString)pKey
                    withResolver:(RCTPromiseResolveBlock)resolve
                    withRejecter:(RCTPromiseRejectBlock)reject)

    RCT_EXTERN_METHOD(signMusig:    (NSString)pKey
                    (NSString)txnMsg
                    withResolver:(RCTPromiseResolveBlock)resolve
                    withRejecter:(RCTPromiseRejectBlock)reject)

    RCT_EXTERN_METHOD(privateKeyFromSeed:(NSString)seed
                    withResolver:(RCTPromiseResolveBlock)resolve
                    withRejecter:(RCTPromiseRejectBlock)reject)

    RCT_EXTERN_METHOD(publicKeyFromPrivateKey:(NSString)privateKey
                    withResolver:(RCTPromiseResolveBlock)resolve
                    withRejecter:(RCTPromiseRejectBlock)reject)

@end
