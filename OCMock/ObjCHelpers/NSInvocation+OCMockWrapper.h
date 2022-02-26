#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (OCMockWrapper)

- (NSArray*)arguments;

- (void)setReturnNSValue:(NSValue*)returnValue;

@end

NS_ASSUME_NONNULL_END
