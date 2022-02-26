#import "NSObject+TrustMe.h"
#import <OCMock/OCMock.h>

@implementation TrustMe

+ (id)onThis:(id)object {
    return object;
}

@end

@implementation TrustHim

+ (void*)onThis:(id)block {
    return (__bridge void * _Nonnull)(block);
}

@end
