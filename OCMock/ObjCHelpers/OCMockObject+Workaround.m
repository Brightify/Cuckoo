//
//  OCMockObject+Workaround.m
//  Cuckoo-CocoaPodsTests
//
//  Created by Tadeáš Kříž on 28/05/2019.
//  Copyright © 2019 Cuckoo. All rights reserved.
//

#import "OCMockObject+Workaround.h"

@implementation OCMockObject (Workaround)

+ (id)mockForWorkaroundProtocol:(id)aProtocol {
    return [self mockForProtocol:aProtocol];
}

@end
