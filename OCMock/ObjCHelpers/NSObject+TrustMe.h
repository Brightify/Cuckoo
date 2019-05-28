//
//  NSObject+TrustMe.h
//  Cuckoo-CocoaPodsTests
//
//  Created by Tadeáš Kříž on 28/05/2019.
//  Copyright © 2019 Cuckoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrustMe <T>: NSObject

+ (T)onThis:(id)object;

@end

@interface TrustHim : NSObject

+ (void*)onThis:(id)block;

@end

NS_ASSUME_NONNULL_END
