public protocol Stub {
    var method: String { get }
}

public class ConcreteStub<IN, OUT, ERROR: Error>: Stub {
    public let method: String
    let parameterMatchers: [ParameterMatcher<IN>]
    var actions: [StubAction<IN, OUT, ERROR>] = []
    
    init(method: String, parameterMatchers: [ParameterMatcher<IN>]) {
        self.method = method
        self.parameterMatchers = parameterMatchers
    }
    
    func appendAction(_ action: StubAction<IN, OUT, ERROR>) {
        actions.append(action)
    }
}

public class ClassConcreteStub<IN, OUT, ERROR: Error>: ConcreteStub<IN, OUT, ERROR> { }
