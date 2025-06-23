public protocol BaseStubFunctionTrait {
    associatedtype InputType
    associatedtype OutputType
    associatedtype ErrorType: Error
    
    var stub: ConcreteStub<InputType, OutputType, ErrorType> { get }
}
