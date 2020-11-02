#import "ZkSync.h"

@implementation ZkSync

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
	// TODO: Implement some actually useful functionality
	callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}

RCT_EXPORT_METHOD(publicKeyHashFromPrivateKey:(NSString *)pKey callback:(RCTResponseSenderBlock)callback) {
	const char *cString = pKey.UTF8String;

	NSString *result  = public_key_hash_from_private_key()
	callback()		
}

@end
