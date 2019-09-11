//
//  ObjectiveStub.swift
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

/**
 * Objective-C equivalent to Cuckoo's own `stub` for protocols.
 * - parameter type: Type for which to create a mock. (e.g. `UITableViewDelegate.self`)
 * - parameter stubbing: Closure that takes a `Stubber` object along with an object of specified type. (usage: `stubber.when(mock.METHOD).then...`)
 */
public func objcStub<T: NSObjectProtocol>(for type: T.Type, file: StaticString = #file, line: UInt = #line, stubbing: (Stubber<T>, T) -> Void) -> T {
    let mock = TrustMe<T>.onThis(CuckooMockObject(mockObject: OCMockObject.mock(forWorkaroundProtocol: type)))
    stubbing(Stubber<T>(), mock)
    return mock
}

/**
 * Objective-C equivalent to Cuckoo's own `stub` for classes.
 * - parameter type: Type for which to create a mock. (e.g. `UIViewController.self`)
 * - parameter stubbing: Closure that takes a `Stubber` object along with an object of specified type. (usage: `stubber.when(mock.METHOD).then...`)
 */
public func objcStub<T: NSObject>(for type: T.Type, file: StaticString = #file, line: UInt = #line, stubbing: (Stubber<T>, T) -> Void) -> T {
    let mock = TrustMe<T>.onThis(CuckooMockObject(mockObject: OCMockObject.mock(for: type) as Any))
    stubbing(Stubber<T>(), mock)
    return mock
}
