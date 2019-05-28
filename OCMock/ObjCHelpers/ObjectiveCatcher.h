//
//  ObjectiveCatcher.h
//  Cuckoo-CocoaPodsTests
//
//  Created by Matyáš Kříž on 27/05/2019.
//  Copyright © 2019 Cuckoo. All rights reserved.
//

#ifndef ObjectiveCatcher_h
#define ObjectiveCatcher_h

#import <Foundation/Foundation.h>

@interface ObjectiveCatcher: NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

#endif /* ObjectiveCatcher_h */
