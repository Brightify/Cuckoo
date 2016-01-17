//
//  MockeryTests.swift
//  MockeryTests
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Cuckoo

class MockeryAPITest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        enum TestError: ErrorType {
            case Unknown
        }
        
        let mock = MockSomething()
        
        // FIXME Should be fatalError when method was not throwing
        
        stub(mock) { mock in
            when(mock.noParameter()).thenReturn()
            when(mock.countCharacters("hello")).thenReturn(1000)
            when(mock.withReturn()).thenReturn("hello world!")
            when(mock.withThrows()).thenThrow(TestError.Unknown)
            
            when(mock.withNoescape("hello", closure: anyClosure())).then {
                $1($0 + " world")
            }
        }
        
        mock.noParameter()
        
        XCTAssertEqual(mock.countCharacters("hello"), 1000)
        
        XCTAssertEqual(mock.withReturn(), "hello world!")
        
        var helloWorld: String = ""
        mock.withNoescape("hello") {
            helloWorld = $0
        }
        XCTAssertEqual(helloWorld, "hello world")
        
        verify(mock).noParameter()
        
        verify(mock).countCharacters(eq("hello"))
        
        verify(mock).withReturn()
        
        verify(mock, never()).withThrows()
        
    }
        
}


// MARK: - Source
protocol Something {
    func noParameter()
    
    func countCharacters(test: String) -> Int
    
    func withReturn() -> String
    
    func withThrows() throws
    
    func withClosure(closure: String -> Int)
    
    func withMultipleParameters(a: String, b: Int, c: Float)
    
    func withNoescape(a: String, @noescape closure: String -> Void)
}

// MARK: - Begin of generated
class MockSomething: Something, Cuckoo.Mock {
    let manager: Cuckoo.MockManager<StubbingProxyImpl, VerificationProxyImpl> = Cuckoo.MockManager()
    let observed: Something?
    
    required init() {
        self.observed = nil
    }
    
    required init(spyOn: Something) {
        self.observed = spyOn
    }
    
    func noParameter() {
        return manager.call("noParameter()", original: observed?.noParameter)()
    }
    
    func countCharacters(test: String) -> Int {
        return manager.call("countCharacters(String)", parameters: test, original: observed?.countCharacters)(test)
    }
    
    func withReturn() -> String {
        return manager.call("withReturn()", original: observed?.withReturn)()
    }
    
    func withThrows() throws {
        return try manager.callThrows("withThrows()", original: observed?.withThrows)()
    }
    
    func withClosure(closure: String -> Int) {
        return manager.call("withClosure(String->Int)", parameters: markerFunction(), original: observed?.withClosure)(closure)
    }
    
    func withMultipleParameters(a: String, b: Int, c: Float) {
        return manager.call("withMultipleParameters(String,b:Int,c:Float)", parameters: (a, b, c), original: observed?.withMultipleParameters)(a: a, b: b, c: c)
    }
    
    func withNoescape(a: String, @noescape closure: String -> Void) {
        return manager.call("withNoescape(String,closure:String->Void)", parameters: (a, closure: markerFunction()), original: observed?.withNoescape)(a, closure: closure)
    }
    
    struct StubbingProxyImpl: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
        
        init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
        
        @warn_unused_result
        func noParameter() -> Cuckoo.ToBeStubbedFunction<Void, Void> {
            return handler.stub("noParameter()")
        }
    
        @warn_unused_result
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == String>(test: M1) -> Cuckoo.ToBeStubbedFunction<String, Int> {
            let matchers: [AnyMatcher<(String)>] = [parameterMatcher(test.matcher, mapping: { $0 })]
            return handler.stub("countCharacters(String)", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withReturn() -> Cuckoo.ToBeStubbedFunction<Void, String> {
            return handler.stub("withReturn()")
        }
        
        @warn_unused_result
        func withThrows() -> Cuckoo.ToBeStubbedThrowingFunction<Void, Void> {
            return handler.stubThrowing("withThrows()")
        }
        
        @warn_unused_result
        func withClosure<M1: Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.ToBeStubbedFunction<String -> Int, Void> {
            let matchers: [AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.stub("withClosure(String->Int)", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withNoescape<
            M1: Matchable, M2: Matchable
            where M1.MatchedType == String, M2.MatchedType == (String -> Void)
            >(a: M1, closure: M2) -> Cuckoo.ToBeStubbedFunction<(String, closure: String -> Void), Void>
        {
            let matchers: [AnyMatcher<(String, closure: String -> Void)>] = [
                parameterMatcher(a.matcher) { $0.0 },
                parameterMatcher(closure.matcher) { $0.closure }
            ]
            return handler.stub("withNoescape(String,closure:String->Void)", parameterMatchers: matchers)
        }
    }
    
    struct VerificationProxyImpl: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
        
        init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
        
        func noParameter() -> __DoNotUse<Void> {
            return handler.verify("noParameter()")
        }
        
        func countCharacters<
            P1: Matchable
            where P1.MatchedType == String
        >(test: P1) -> __DoNotUse<Int> {
            let matchers: [AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.verify("countCharacters(String)", parameterMatchers: matchers)
        }
        
        func withReturn() -> __DoNotUse<String> {
            return handler.verify("withReturn()")
        }
        
        func withThrows() -> __DoNotUse<Void> {
            return handler.verify("withThrows()")
        }
        
        func withClosure<
            P1: Matchable
            where P1.MatchedType == (String -> Int)
        >(closure: P1) -> __DoNotUse<String -> Int> {
            let matchers: [AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.verify("withClosure(String->Int)", parameterMatchers: matchers)
        }
        
        func withMultipleParameters<
            P1: Matchable, P2: Matchable, P3: Matchable
            where P1.MatchedType == String, P2.MatchedType == Int, P3.MatchedType == Float
            >(a: P1, b: P2, c: P3) -> __DoNotUse<Void>
        {
            let matchers: [AnyMatcher<(String, b: Int, c: Float)>] = [
                parameterMatcher(a.matcher) { $0.0 },
                parameterMatcher(b.matcher) { $0.b },
                parameterMatcher(c.matcher) { $0.c }
            ]
            return handler.verify("withMultipleParameters(String,b:Int,c:Float)", parameterMatchers: matchers)
        }
    }
}
