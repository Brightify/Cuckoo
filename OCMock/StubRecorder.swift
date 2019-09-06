//
//  StubRecorder.swift
//  Cuckoo
//
//  Created by Matyáš Kříž on 06/09/2019.
//

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
