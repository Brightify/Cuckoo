//
//  OCMockObject+CuckooMockObject.m
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

#import "OCMockObject+CuckooMockObject.h"

@implementation CuckooMockObject

- (id)initWithMockObject:(id)aMockObject {
    mockObject = aMockObject;

    return self;
}

- (id)mockObject {
    return mockObject;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([[OCMMacroState globalState] recorder]) {
        NSMethodSignature *signature = [invocation methodSignature];
        NSUInteger n = [signature numberOfArguments];
        for(NSUInteger i = 2; i < n; i++) {
            const char *argType = [signature getArgumentTypeAtIndex:(NSUInteger)i];

            if(OCMIsObjectType(argType))
            {
                void* value;
                [invocation getArgument:&value atIndex:i];

                // replace with `any` matcher, Cuckoo is a Swift library where comparing closures doesn't make sense
                if ([(__bridge id)(value) isKindOfClass:objc_getClass("__NSMallocBlock__")]) {
                    void* anyMatcher = CFBridgingRetain([OCMArg any]);
                    [invocation setArgument:&anyMatcher atIndex:i];
                }
            }
        }
    }

    [invocation invokeWithTarget: mockObject];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [mockObject methodSignatureForSelector:sel];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [mockObject isKindOfClass: aClass];
}

@end
