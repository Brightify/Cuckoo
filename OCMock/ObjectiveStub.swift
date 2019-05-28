//
//  ObjectiveStub.swift
//  Cuckoo+OCMock-iOS
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import XCTest

public func objectiveStub<T: NSObjectProtocol>(for type: T.Type, file: StaticString = #file, line: UInt = #line, stubbing: (Stubber<T>, T) -> Void) -> T {
    if let mock = CuckooMockObject(mockObject: OCMockObject.mock(forWorkaroundProtocol: type)) as? T {
        stubbing(Stubber<T>(), mock)
        return mock
    } else {
        let errorMessage = "Failed to create an OCMock object for the type \(type). Make sure it's an Objective-C object."
        XCTFail(errorMessage, file: file, line: line)
        fatalError(errorMessage)
    }
}

public func objectiveStub<T: NSObject>(for type: T.Type, file: StaticString = #file, line: UInt = #line, stubbing: (Stubber<T>, T) -> Void) -> T {
    if let mock = CuckooMockObject(mockObject: OCMockObject.mock(for: type)) as? T {
        stubbing(Stubber<T>(), mock)
        return mock
    } else {
        let errorMessage = "Failed to create an OCMock object for the type \(NSStringFromClass(type)). Make sure it's an Objective-C object."
        XCTFail(errorMessage, file: file, line: line)
        fatalError(errorMessage)
    }
}

public class Stubber<MOCK> {
    public func when<OUT>(_ invocation: @autoclosure () -> OUT) -> StubRecorder<OUT> {
        OCMMacroState.beginStubMacro()
        _ = invocation()

        let recorder = OCMMacroState.endStubMacro()
        return StubRecorder(recorder: recorder!)
    }
}

public class StubRecorder<OUT> {
    private let recorder: OCMStubRecorder

    public init(recorder: OCMStubRecorder) {
        self.recorder = recorder
    }

    public func thenThrow(_ error: Error) {
        let exception = NSException(name: NSExceptionName(rawValue: error.localizedDescription), reason: error.localizedDescription, userInfo: [:])
        recorder.andThrow(exception)
    }

    public func thenCallRealImplementation() {
        recorder.andForwardToRealObject()
    }
}

public extension StubRecorder where OUT: NSValueConvertible {
    func thenReturn(_ value: OUT) {
        recorder.andReturn(value.toNSValue())
    }

    func then(do block: @escaping ([Any]) -> OUT) {
        recorder.andDo { invocation in
            guard let invocation = invocation else { return }
            let result = block(invocation.arguments()).toNSValue()
            invocation.setReturn(result)
            invocation.retainArguments()
        }
    }
}

public extension StubRecorder where OUT == Void {
    func thenDoNothing() {
        recorder.andDo { _ in }
    }

    func then(do block: @escaping ([Any]) -> Void) {
        recorder.andDo { invocation in
            guard let invocation = invocation else { return }

            block(invocation.arguments())
            invocation.retainArguments()
        }
    }
}

public extension StubRecorder where OUT: NSObject {
    func thenReturn(_ object: OUT) {
        recorder.andReturn(object)
    }

    func then(do block: @escaping ([Any]) -> OUT) {
        recorder.andDo { invocation in
            guard let invocation = invocation else { return }

            var result = block(invocation.arguments())
            invocation.setReturnValue(&result)
            invocation.retainArguments()
        }
    }
}

public extension StubRecorder where OUT: CuckooOptionalType, OUT.Wrapped: NSObject {
    func thenReturn(_ object: OUT) {
        recorder.andReturn(object)
    }

    func then(do block: @escaping ([Any]) -> OUT) {
        recorder.andDo { invocation in
            guard let invocation = invocation else { return }

            var result = block(invocation.arguments())
            invocation.setReturnValue(&result)
            invocation.retainArguments()
        }
    }
}
