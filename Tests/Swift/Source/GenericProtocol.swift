import Foundation

protocol GenericProtocol {
    associatedtype C: AnyObject
    associatedtype V

    var readOnlyPropertyC: C { get }
    var readWritePropertyV: V { get set }

    var constant: Int { get }
    var optionalProperty: V? { get set }

    init(theC: C, theV: V)

    func callSomeC(theC: C) -> Int
    func callSomeV(theV: V) -> Int
    func compute(classy: C, value: V) -> C
    func noReturn()

    /**
     Multiline documentation string test.
     It can of course have multiple lines
    */
    func computeAsync(classy: C, value: V) async -> (C, V)
    func noReturnAsync() async

    /// Test for a bug that produces uncompilable code when associated types are used along with closures.
    /// Requires change from WrappableType to ComplexType.
    func closureParameter(closure: @escaping () -> Void)
}

protocol PrimaryAssociatedTypeProtocol<Output> {
    associatedtype Output: Equatable
    
    func connect() -> Output
}
