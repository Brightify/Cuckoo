//
//  StringProxy.h
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

#import <Foundation/Foundation.h>
#import <OCMock/OCMConstraint.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringProxy: NSObject//: NSProxy

- (instancetype)initWithConstraint:(id)aConstraint;

@end

NS_ASSUME_NONNULL_END
