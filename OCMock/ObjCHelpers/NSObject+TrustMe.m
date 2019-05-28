//
//  NSObject+TrustMe.m
//  Cuckoo-CocoaPodsTests
//
//  Created by Tadeáš Kříž on 28/05/2019.
//  Copyright © 2019 Cuckoo. All rights reserved.
//

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
