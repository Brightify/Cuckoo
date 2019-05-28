//
//  ObjectiveCatcher.m
//  Cuckoo-CocoaPodsTests
//
//  Created by Matyáš Kříž on 27/05/2019.
//  Copyright © 2019 Cuckoo. All rights reserved.
//

#import "ObjectiveCatcher.h"

@implementation ObjectiveCatcher

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

@end
