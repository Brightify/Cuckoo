//
//  MockeryTests.swift
//  MockeryTests
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import Mockery

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
        
        let mock = Mock_Something()
        
        // FIXME Should be fatalError when method was not throwing
        
        stub(mock) { mock in
            when(mock.noParameter()).thenReturn()
            when(mock.countCharacters("hello")).thenReturn(1000)
            when(mock.withReturn()).thenReturn("hello world!")
            //            when(mock.withThrows()).thenThrow(TestError.Unknown)
        }
        
        mock.noParameter()
        
        XCTAssertEqual(mock.countCharacters("hello"), 1000)
        
        XCTAssertEqual(mock.withReturn(), "hello world!")
        
        verify(mock).noParameter()
        
        verify(mock).countCharacters(eq("hello"))
        
        verify(mock).withReturn()
        
        verify(mock, never()).withThrows()
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
        
}


// MARK: - Source
class Something {
    func noParameter() { }
    
    func countCharacters(test: String) -> Int { return test.characters.count }
    
    func withReturn() -> String { return "" }
    
    func withThrows() throws { }
    
    func withClosure(closure: String -> Int) { closure("hello") }
    
    func withMultipleParameters(a: String, b: Int, c: Float) { }
    
    func withNoescape(a: String, @noescape closure: String -> Void) { closure(a) }
}

// MARK: - Begin of generated
class Mock_Something: Something, Mockery.Mock {
    let manager: Mockery.MockManager<StubbingProxyImpl, VerificationProxyImpl> = Mockery.MockManager()
    
    override func noParameter() {
        return manager.call("noParameter()")
    }
    
    override func countCharacters(test: String) -> Int {
        return manager.call("countCharacters(String)", parameters: test)
    }
    
    override func withReturn() -> String {
        return manager.call("withReturn()")
    }
    
    override func withThrows() throws {
        return try manager.callThrows("withThrows()")
    }
    
    override func withClosure(closure: String -> Int) {
        return manager.call("withClosure(String->Int)")
    }
    
    override func withMultipleParameters(a: String, b: Int, c: Float) {
        return manager.call("withMultipleParameters(String,b:Int,c:Float)")
    }
    
    override func withNoescape(a: String, @noescape closure: String -> Void) {
        return manager.call("withNoescape(String,closure:String->Void)", parameters: (a: a, markerFunction(String.self, Void.self)), original: super.withNoescape(a, closure: closure))
    }
    
    struct StubbingProxyImpl: Mockery.StubbingProxy {
        let handler: Mockery.StubbingHandler
        
        init(handler: Mockery.StubbingHandler) {
            self.handler = handler
        }
        
        @warn_unused_result
        func noParameter() -> Mockery.ToBeStubbedFunctionNeedingMatcher<Void, Void> {
            return handler.stub("noParameter()", parameters: ())
        }
    
        @warn_unused_result
        func countCharacters(test: String) -> Mockery.ToBeStubbedFunctionNeedingMatcher<String, Int> {
            return handler.stub("countCharacters(String)", parameters: test)
        }
        
        @warn_unused_result
        func withReturn() -> Mockery.ToBeStubbedFunctionNeedingMatcher<Void, String> {
            return handler.stub("withReturn()", parameters: ())
        }
        
        @warn_unused_result
        func withThrows() -> Mockery.ToBeStubbedThrowingFunctionNeedingMatcher<Void, Void> {
            return handler.stubThrowing("withThrows()", parameters: ())
        }
        
        @warn_unused_result
        func withClosure(matcher: AnyMatcher<String -> Int>) -> Mockery.ToBeStubbedFunction<String -> Int, Void> {
            return handler.stub("withClosure(String->Int)", matcher: matcher)
        }
    }
    
    struct VerificationProxyImpl: Mockery.VerificationProxy {
        let handler: Mockery.VerificationHandler
        
        init(handler: Mockery.VerificationHandler) {
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
