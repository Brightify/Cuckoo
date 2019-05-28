//
//  OCMockObject+CuckooMockObject.h
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

#import <OCMock/OCMock.h>

NS_ASSUME_NONNULL_BEGIN

@interface CuckooMockObject : NSProxy
{
    id mockObject;
}

- (id)initWithMockObject:(id)aMockObject;

- (id)mockObject;

@end


NS_ASSUME_NONNULL_END
