#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrustMe <T>: NSObject

+ (T)onThis:(id)object;

@end

@interface TrustHim : NSObject

+ (void*)onThis:(id)block;

@end

NS_ASSUME_NONNULL_END
