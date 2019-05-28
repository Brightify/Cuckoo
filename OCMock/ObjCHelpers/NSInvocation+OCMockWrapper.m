//
//  NSInvocation+OCMockWrapper.m
//  Cuckoo-CocoaPodsTests
//
//  Created by Matyáš Kříž on 27/05/2019.
//  Copyright © 2019 Cuckoo. All rights reserved.
//

#import "NSInvocation+OCMockWrapper.h"
#import <OCMock/OCMFunctions.h>

BOOL OCMEqualTypesAllowingOpaqueStructs(const char *type1, const char *type2);

@interface NSValue(OCMAdditions)

- (BOOL)getBytes:(void *)outputBuf objCType:(const char *)targetType;

@end

@implementation NSInvocation (OCMockWrapper)

- (NSArray*)arguments {
    NSMutableArray* arguments = [[NSMutableArray alloc] init];
    NSUInteger argumentCount = [[self methodSignature] numberOfArguments];

    for (int i = 2; i < argumentCount; i++) {
        const char * _Nonnull argType = [self.methodSignature getArgumentTypeAtIndex: i];

        NSUInteger size = 0;
        NSGetSizeAndAlignment(argType, &size, NULL);
        void* arg = calloc(1, size);
        [self getArgument:&arg atIndex: i];

        NSValue* _Nonnull n = [NSValue value:&arg withObjCType: argType];
        if (OCMIsObjectType(argType)) {
            [arguments addObject:(__bridge id _Nonnull)(arg)];
        } else if (n) {
            [arguments addObject:n];
        } else {
            [arguments addObject:[NSNull new]];
        }
    }

    return arguments;
}

- (void)setReturnNSValue:(NSValue*)returnValue {
    const char *returnType = [[self methodSignature] methodReturnType];
    NSUInteger returnTypeSize = [[self methodSignature] methodReturnLength];
    char valueBuffer[returnTypeSize];
    
    if([self isMethodReturnType:returnType compatibleWithValueType:[returnValue objCType]]) {
        [returnValue getValue:valueBuffer];
        [self setReturnValue:valueBuffer];
    } else if([returnValue getBytes:valueBuffer objCType:returnType]) {
        [self setReturnValue:valueBuffer];
    } else {
        [NSException raise:NSInvalidArgumentException
                    format:@"Return value cannot be used for method; method signature declares '%s' but value is '%s'.", returnType, [returnValue objCType]];
    }
}

- (BOOL)isMethodReturnType:(const char *)returnType compatibleWithValueType:(const char *)valueType {
    /* Same types are obviously compatible */
    if(strcmp(returnType, valueType) == 0)
    return YES;

    /* Allow void* for methods that return id, mainly to be able to handle nil */
    if(strcmp(returnType, @encode(id)) == 0 && strcmp(valueType, @encode(void *)) == 0)
    return YES;

    return OCMEqualTypesAllowingOpaqueStructs(returnType, valueType);
}

@end
