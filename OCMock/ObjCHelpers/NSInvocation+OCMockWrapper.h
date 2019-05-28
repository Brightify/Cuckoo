//
//  NSInvocation+OCMockWrapper.h
//  Cuckoo-CocoaPodsTests
//
//  Created by Matyáš Kříž on 27/05/2019.
//  Copyright © 2019 Cuckoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (OCMockWrapper)

- (NSArray*)arguments;

- (void)setReturnNSValue:(NSValue*)returnValue;

@end

NS_ASSUME_NONNULL_END
