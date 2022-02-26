#ifndef ObjectiveCatcher_h
#define ObjectiveCatcher_h

#import <Foundation/Foundation.h>

@interface ObjectiveCatcher: NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

#endif /* ObjectiveCatcher_h */
