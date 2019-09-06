//
//  ObjectiveStub.swift
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

public func objcStub<T: NSObjectProtocol>(for type: T.Type, file: StaticString = #file, line: UInt = #line, stubbing: (Stubber<T>, T) -> Void) -> T {
    let mock = TrustMe<T>.onThis(CuckooMockObject(mockObject: OCMockObject.mock(forWorkaroundProtocol: type)))
    stubbing(Stubber<T>(), mock)
    return mock
}

public func objcStub<T: NSObject>(for type: T.Type, file: StaticString = #file, line: UInt = #line, stubbing: (Stubber<T>, T) -> Void) -> T {
    let mock = TrustMe<T>.onThis(CuckooMockObject(mockObject: OCMockObject.mock(for: type) as Any))
    stubbing(Stubber<T>(), mock)
    return mock
}
