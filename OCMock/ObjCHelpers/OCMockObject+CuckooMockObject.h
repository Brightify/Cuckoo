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
