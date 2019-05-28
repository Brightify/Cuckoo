//
//  OCMockObject+Workaround.h
//  Cuckoo-CocoaPodsTests
//
//  Created by Tadeáš Kříž on 28/05/2019.
//  Copyright © 2019 Cuckoo. All rights reserved.
//

#import <OCMock/OCMock.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCMockObject (Workaround)

+ (id)mockForWorkaroundProtocol:(id)aProtocol;

@end

NS_ASSUME_NONNULL_END
