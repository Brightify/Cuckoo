import XCTest
import Cuckoo
@testable import CuckooMocks

private class GenericProtocolConformerClass<C: AnyObject, V>: GenericProtocol {
    let readOnlyPropertyC: C
    var readWritePropertyV: V

    let constant: Int = 0
    var optionalProperty: V?

    required init(theC: C, theV: V) {
        readOnlyPropertyC = theC
        readWritePropertyV = theV
    }

    func callSomeC(theC: C) -> Int {
        return 1
    }

    func callSomeV(theV: V) -> Int {
       return processV(theV)
    }

    func compute(classy: C, value: V) -> C {
       return computeC(classy, value)
    }

    func noReturn() {}
    
    func computeAsync(classy: C, value: V) async -> (C, V) {
        return (computeC(classy, value), value)
    }
    
    func noReturnAsync() async {}
    
    private func processV(_ theV: V) -> Int {
        switch theV {
        case let int as Int:
            return int
        case let string as String:
            return Int(string) ?? 8008135
        default:
            return 0
        }
    }

    private func computeC(_ classy: C, _ value: V) -> C {
        guard let testyClassy = classy as? TestedClass else { return classy }
        switch value {
        case let int as Int:
            testyClassy.readWriteProperty = int
        case _ as String:
            testyClassy.optionalProperty = nil
        default:
            break
        }
        return testyClassy as! C
    }

    func closureParameter(closure: @escaping () -> Void) {}
    
    func genericParameter<T>(value: T) {}
    
    func genericAndAassociatedTypeParameters<T>(value: T, theC: C, theV: V) -> (C?) -> V {
        { _ in theV }
    }
}

private struct GenericProtocolConformerStruct<C: AnyObject, V>: GenericProtocol {
    let readOnlyPropertyC: C
    var readWritePropertyV: V

    let constant: Int = 0
    var optionalProperty: V?

    init(theC: C, theV: V) {
        readOnlyPropertyC = theC
        readWritePropertyV = theV
    }

    func callSomeC(theC: C) -> Int {
        return 1
    }

    func callSomeV(theV: V) -> Int {
        return 0
    }

    func compute(classy: C, value: V) -> C {
        return classy
    }

    func noReturn() {}
    
    func computeAsync(classy: C, value: V) async -> (C, V) {
        return (classy, value)
    }
    
    func noReturnAsync() async {}

    func closureParameter(closure: @escaping () -> Void) {}
    
    func genericParameter<T>(value: T) {}
    
    func genericAndAassociatedTypeParameters<T>(value: T, theC: C, theV: V) -> (C?) -> V {
        { _ in theV }
    }
}

private final class MixedPrimaryAssociatedTypeProtocolConformerClass<Input: Equatable, Output: Equatable>: MixedPrimaryAssociatedTypeProtocol {

    let defaultOutput: Output

    init(defaultOutput: Output) {
        self.defaultOutput = defaultOutput
    }

    func convertToOutput<T>(
        value: sending T,
        input: sending Input,
        convert: @escaping @MainActor @Sendable (T, Input) async throws -> Output?
    ) async rethrows -> Output {
        if let result = try await convert(value, input) {
            return result
        }
        return defaultOutput
    }
}

private struct MixedPrimaryAssociatedTypeProtocolConformerStruct<Input: Equatable, Output: Equatable>: MixedPrimaryAssociatedTypeProtocol {
    var defaultOutput: Output

    func convertToOutput<T>(
        value: T,
        input: Input,
        convert: @escaping @MainActor @Sendable (T, Input) async throws -> Output?
    ) async rethrows -> Output {
        if let result = try await convert(value, input) {
            return result
        }
        return defaultOutput
    }
}

@available(iOS 16.0.0, macOS 13.0.0, watchOS 9.0, tvOS 16, *)
final class GenericProtocolTest: XCTestCase {
    private func createMock<V>(value: V, classy: MockTestedClass = MockTestedClass()) -> MockGenericProtocol<MockTestedClass, V> {
        return MockGenericProtocol(theC: classy, theV: value)
    }

    func testReadOnlyProperty() {
        let mock = createMock(value: 10)
        stub(mock) { mock in
            when(mock.readOnlyPropertyC.get).thenReturn(MockTestedClass())
        }

        _ = mock.readOnlyPropertyC

        verify(mock).readOnlyPropertyC.get()
    }

    func testReadWriteProperty() {
        let mock = createMock(value: 10)
        stub(mock) { mock in
            when(mock.readWritePropertyV.get).then { 11 }
            when(mock.readWritePropertyV.set(anyInt())).thenDoNothing()
        }

        mock.readWritePropertyV = 42
        XCTAssertEqual(mock.readWritePropertyV, 11)
        verify(mock).readWritePropertyV.get()
        verify(mock).readWritePropertyV.set(42)
    }

    func testOptionalProperty() {
        let mock = createMock(value: false)
        var called = false
        stub(mock) { mock in
            when(mock.optionalProperty.get).thenReturn(true)
            when(mock.optionalProperty.set(any())).then { _ in called = true }
            when(mock.optionalProperty.set(isNil())).then { _ in called = true }
        }

        mock.optionalProperty = nil
        mock.optionalProperty = false

        XCTAssertTrue(mock.optionalProperty == true)
        XCTAssertTrue(called)
        verify(mock).optionalProperty.get()
        verify(mock).optionalProperty.set(equal(to: false))
        verify(mock, times(2)).optionalProperty.set(any())
        verify(mock).optionalProperty.set(isNil())
    }

    func testCallSomeC() {
        let mock = createMock(value: 1337)
        let classy = MockTestedClass()
        let expected = 42
        stub(mock) { mock in
            when(mock.callSomeC(theC: classy)).thenReturn(expected)
        }

        let actual = mock.callSomeC(theC: classy)

        XCTAssertEqual(actual, expected)
        verify(mock).callSomeC(theC: classy)
    }

    func testCallSomeV() {
        let mock = createMock(value: 1)
        let expected = 99
        stub(mock) { mock in
            when(mock.callSomeV(theV: equal(to: 1))).thenReturn(expected)
        }

        let actual = mock.callSomeV(theV: 1)

        XCTAssertEqual(actual, expected)
        verify(mock).callSomeV(theV: equal(to: 1))
    }

    func testCompute() {
        let mock = createMock(value: 5)
        let classy = MockTestedClass()
        let expected = MockTestedClass()
        stub(mock) { mock in
            when(mock.compute(classy: classy, value: equal(to: 5))).thenReturn(expected)
        }

        let actual = mock.compute(classy: classy, value: 5)

        XCTAssertTrue(actual === expected)
        verify(mock).compute(classy: classy, value: equal(to: 5))
    }

    func testClosureParameter() {
        let mock = createMock(value: 10)
        var closureInvoked = false
        stub(mock) { mock in
            when(mock.closureParameter(closure: any())).then { closure in
                closure()
            }
        }

        mock.closureParameter {
            closureInvoked = true
        }

        XCTAssertTrue(closureInvoked)
        verify(mock).closureParameter(closure: any())
    }

    func testGenericParameter() {
        let mock = createMock(value: 10)
        var captured: Any?
        let expected = "wow"
        stub(mock) { mock in
            when(mock.genericParameter(value: equal(to: expected))).then { (value: String) in
                captured = value
            }
        }

        mock.genericParameter(value: expected)

        XCTAssertEqual(captured as? String, expected)
        verify(mock).genericParameter(value: equal(to: expected))
    }

    func testGenericAndAssociatedTypeParameters() {
        let expected = 2112
        let mock = createMock(value: expected)
        let classy = MockTestedClass()
        stub(mock) { mock in
            when(mock.genericAndAassociatedTypeParameters(value: equal(to: "value"), theC: classy, theV: equal(to: expected))).then { (_: String, _: MockTestedClass, theV: Int) -> (MockTestedClass?) -> Int in
                { _ in theV }
            }
        }

        let closure = mock.genericAndAassociatedTypeParameters(value: "value", theC: classy, theV: expected)

        XCTAssertEqual(closure(classy), expected)
        verify(mock).genericAndAassociatedTypeParameters(value: equal(to: "value"), theC: classy, theV: equal(to: expected))
    }

    func testNoReturn() {
        let mock = createMock(value: "Hello. Sniffing through tests? If you're having trouble with Cuckoo, shoot us a message!")
        var called = false
        stub(mock) { mock in
            when(mock.noReturn()).then { _ in called = true }
        }

        mock.noReturn()

        XCTAssertTrue(called)
        verify(mock).noReturn()
    }

    func testModification() {
        let mock = createMock(value: ["EXTERMINATE!": "EXTERMINATE!!", "EXTERMINATE!!!": "EXTERMINATE!!!!"])
        let original = GenericProtocolConformerClass(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"])
        mock.enableDefaultImplementation(original)
        
        original.readWritePropertyV["Are you sure?"] = "Yeah, I'm just waiting for my wife."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀", "Are you sure?": "Yeah, I'm just waiting for my wife."])

        original.readWritePropertyV["Alright, have a nice weekend!"] = "Thanks, you too."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀",
                                                 "Are you sure?": "Yeah, I'm just waiting for my wife.",
                                                 "Alright, have a nice weekend!": "Thanks, you too."])

        verify(mock, times(2)).readWritePropertyV.get()
    }

    // the next two test cases show using a struct as the default implementation and changing its state:
    // - NOTE: This only applies for `struct`s, not `class`es.
    // using: `enableDefaultImplementation(mutating:)` reflects the original's state at all times
    func testStructModification() {
        let mock = createMock(value: ["EXTERMINATE!": "EXTERMINATE!!", "EXTERMINATE!!!": "EXTERMINATE!!!!"])
        var original = GenericProtocolConformerStruct(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"])
        mock.enableDefaultImplementation(mutating: &original)

        original.readWritePropertyV["Are you sure?"] = "Yeah, I'm just waiting for my wife."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀", "Are you sure?": "Yeah, I'm just waiting for my wife."])

        original.readWritePropertyV["Alright, have a nice weekend!"] = "Thanks, you too."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀",
                                                 "Are you sure?": "Yeah, I'm just waiting for my wife.",
                                                 "Alright, have a nice weekend!": "Thanks, you too."])

        verify(mock, times(2)).readWritePropertyV.get()
    }

    // using: `enableDefaultImplementation(_:)` reflects the original's state at the time of enabling default implementation with the struct
    func testStructNonModification() {
        let mock = createMock(value: ["EXTERMINATE!": "EXTERMINATE!!", "EXTERMINATE!!!": "EXTERMINATE!!!!"])
        var original = GenericProtocolConformerStruct(theC: MockTestedClass(), theV: ["Sir, may I help you?": "Nope, just lookin' 👀"])
        mock.enableDefaultImplementation(original)

        original.readWritePropertyV["Are you sure?"] = "Yeah, I'm just waiting for my wife."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀"])
        XCTAssertEqual(original.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀", "Are you sure?": "Yeah, I'm just waiting for my wife."])

        original.readWritePropertyV["Alright, have a nice weekend!"] = "Thanks, you too."
        XCTAssertEqual(mock.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀"])
        XCTAssertEqual(original.readWritePropertyV, ["Sir, may I help you?": "Nope, just lookin' 👀",
                                                 "Are you sure?": "Yeah, I'm just waiting for my wife.",
                                                 "Alright, have a nice weekend!": "Thanks, you too."])

        verify(mock, times(2)).readWritePropertyV.get()
    }

    func testComputeAsync() async {
        let expectedReturn = (MockTestedClass(), 10)
        let mock = createMock(value: expectedReturn.1, classy: expectedReturn.0)
        stub(mock) { mock in
            when(mock.computeAsync(classy: any(), value: any())).thenReturn(expectedReturn)
        }

        let actualReturn = await mock.computeAsync(classy: expectedReturn.0, value: expectedReturn.1)
        
        XCTAssertTrue(expectedReturn.0 === actualReturn.0)
        XCTAssertEqual(expectedReturn.1, actualReturn.1)
        verify(mock).computeAsync(classy: expectedReturn.0, value: expectedReturn.1)
    }

    func testNoReturnAsync() async {
        let mock = createMock(value: 10)
        stub(mock) { mock in
            when(mock.noReturnAsync()).thenDoNothing()
        }

        await mock.noReturnAsync()
        
        verify(mock).noReturnAsync()
    }
    
    // MARK: - MockMixedPrimaryAssociatedTypeProtocol
    
    private typealias ConvertClosure = @MainActor @Sendable (Int, String) async throws -> Int?
    
    private func createMock() -> MockMixedPrimaryAssociatedTypeProtocol<String, Int> {
        MockMixedPrimaryAssociatedTypeProtocol()
    }

    func testDefaultOutputProperty() {
        let mock = createMock()
        let expected = 77
        stub(mock) { mock in
            when(mock.defaultOutput.get).thenReturn(expected)
        }

        XCTAssertEqual(mock.defaultOutput, expected)
        verify(mock).defaultOutput.get()
    }

    func testConvertToOutputStubbing() async throws {
        let mock = createMock()
        let value = 5
        let input = "input"
        let expected = 123
        
        stub(mock) { mock in
            when(mock.convertToOutput(value: anyInt(), input: anyString(), convert: any(ConvertClosure.self)))
                .thenReturn(expected)
        }
        let closure: @MainActor @Sendable (Int, String) async throws -> Int? = { _, _ in nil }

        let actual = try await mock.convertToOutput(value: value, input: input, convert: closure)

        XCTAssertEqual(actual, expected)
        verify(mock).convertToOutput(value: equal(to: value), input: equal(to: input), convert: any(ConvertClosure.self))
    }

    func testConvertToOutputDefaultImplementation() async throws {
        let defaultImpl = MixedPrimaryAssociatedTypeProtocolConformerClass<String, Int>(defaultOutput: 7)
        let mock = createMock()
        mock.enableDefaultImplementation(defaultImpl)

        let value = 3
        let input = "abc"
        let closure: @MainActor @Sendable (Int, String) async throws -> Int? = { value, input in
            value + input.count
        }
        let expected = value + input.count

        XCTAssertEqual(mock.defaultOutput, defaultImpl.defaultOutput)
        let result = try await mock.convertToOutput(value: value, input: input, convert: closure)

        XCTAssertEqual(result, expected)
        verify(mock).defaultOutput.get()
        verify(mock).convertToOutput(value: equal(to: value), input: equal(to: input), convert: any(ConvertClosure.self))
    }

    func testStructDefaultImplementationReflectsMutations() async throws {
        var defaultImpl = MixedPrimaryAssociatedTypeProtocolConformerStruct<String, Int>(defaultOutput: 5)
        let mock = createMock()
        mock.enableDefaultImplementation(mutating: &defaultImpl)

        XCTAssertEqual(mock.defaultOutput, 5)

        defaultImpl.defaultOutput = 9

        XCTAssertEqual(mock.defaultOutput, 9)
        
        let value = 3
        let input = "abc"

        let fallback: @MainActor @Sendable (Int, String) async throws -> Int? = { _, _ in nil }
        let result = try await mock.convertToOutput(value: value, input: input, convert: fallback)

        XCTAssertEqual(result, 9)
        verify(mock, times(2)).defaultOutput.get()
        verify(mock).convertToOutput(value: equal(to: value), input: equal(to: input), convert: any(ConvertClosure.self))
    }
}

extension MockTestedClass: Matchable{
    public typealias MatchedType = MockTestedClass
    
    public var matcher: ParameterMatcher<MockTestedClass> {
        return ParameterMatcher<MockTestedClass> { other in
            return self === other
        }
    }
}
