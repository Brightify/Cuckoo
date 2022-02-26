#import "OCMockObject+Workaround.h"

@implementation OCMockObject (Workaround)

+ (id)mockForWorkaroundProtocol:(id)aProtocol {
    return [self mockForProtocol:aProtocol];
}

@end
