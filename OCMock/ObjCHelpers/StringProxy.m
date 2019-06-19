//
//  OCMockObject+CuckooMockObject.m
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

#import "StringProxy.h"

@implementation StringProxy
{
    NSString *string;
    OCMConstraint *constraint;
}

- (instancetype)initWithConstraint:(id)aConstraint {
    NSUInteger length = 2048;
    NSMutableString* str = [[NSMutableString alloc] initWithCapacity: length];

    for (NSUInteger i = 0; i < length; i++) {
        [str appendFormat: @"%ld", i % 10];
    }

    string = str;

    constraint = aConstraint;

    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([string respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:string];
    } else if ([constraint respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:constraint];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [string respondsToSelector:aSelector] || [constraint respondsToSelector:aSelector];
}

- (BOOL)evaluate:(id)passedArg {
    return [constraint evaluate:passedArg];
}

- (id)copyWithZone: (NSZone *)zone {
    StringProxy *newProxy = [[[self class] allocWithZone:zone] init];
    newProxy->constraint = constraint;
    newProxy->string = [string copyWithZone:zone];
    return newProxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if (!strcmp(sel_getName(sel), "copyWithZone:")) {
        return [super methodSignatureForSelector:sel];
    }

    NSMethodSignature* signature;
    if ((signature = [string methodSignatureForSelector:sel])) {
        return signature;
    } else if ((signature = [constraint methodSignatureForSelector:sel])) {
        return signature;
    } else {
        return nil;
    }
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [string isKindOfClass:aClass] || [constraint isKindOfClass:aClass];
}

@end
