public protocol Stub {
    var method: String { get }
}

public class ConcreteStub<IN, OUT>: Stub {
    public let method: String
    let parameterMatchers: [ParameterMatcher<IN>]
    var actions: [StubAction<IN, OUT>] = []
    
    init(method: String, parameterMatchers: [ParameterMatcher<IN>]) {
        self.method = method
        self.parameterMatchers = parameterMatchers
    }
    
    func appendAction(_ action: StubAction<IN, OUT>) {
        actions.append(action)
    }
}

public class ClassConcreteStub<IN, OUT>: ConcreteStub<IN, OUT> { }
