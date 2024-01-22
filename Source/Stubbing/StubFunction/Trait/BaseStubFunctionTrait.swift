public protocol BaseStubFunctionTrait {
    associatedtype InputType
    associatedtype OutputType
    
    var stub: ConcreteStub<InputType, OutputType> { get }
}
