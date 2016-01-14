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
        
        verify(mock).countCharacters("hello")
        
        verify(mock).withReturn()
        
        verify(mock, never()).withThrows()
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
        
}


// MARK: - Source
protocol Something {
    func noParameter()
    
    func countCharacters(test: String) -> Int
    
    func withReturn() -> String
    
    func withThrows() throws
}

// MARK: - Begin of generated
struct Mock_Something: Something, Mockery.Mock {
    let manager: Mockery.MockManager<StubbingProxyImpl, VerificationProxyImpl> = Mockery.MockManager()
    
    func noParameter() {
        return manager.call("noParameter()")
    }
    
    func countCharacters(test: String) -> Int {
        return manager.call("countCharacters(String)", parameters: test)
    }
    
    func withReturn() -> String {
        return manager.call("withReturn()")
    }
    
    func withThrows() throws {
        return try manager.callThrows("withThrows()")
    }
    
    struct StubbingProxyImpl: Mockery.StubbingProxy {
        let handler: Mockery.StubbingHandler
        
        init(handler: Mockery.StubbingHandler) {
            self.handler = handler
        }
        
        @warn_unused_result
        func noParameter() -> Mockery.ToBeStubbedFunction<Void, Void> {
            return handler.stub("noParameter()", parameters: ())
        }
    
        @warn_unused_result
        func countCharacters(test: String) -> Mockery.ToBeStubbedFunction<String, Int> {
            return handler.stub("countCharacters(String)", parameters: test)
        }
        
        @warn_unused_result
        func withReturn() -> Mockery.ToBeStubbedFunction<Void, String> {
            return handler.stub("withReturn()", parameters: ())
        }
        
        @warn_unused_result
        func withThrows() -> Mockery.ToBeStubbedThrowingFunction<Void, Void> {
            return handler.stubThrowing("withThrows()", parameters: ())
        }
    }
    
    struct VerificationProxyImpl: Mockery.VerificationProxy {
        let handler: Mockery.VerificationHandler
        
        init(handler: Mockery.VerificationHandler) {
            self.handler = handler
        }
        
        func noParameter() {
            return handler.verify("noParameter()", parameters: ())
        }
        
        func countCharacters(test: String) {
            return handler.verify("countCharacters(String)", parameters: test)
        }
        
        func withReturn() {
            return handler.verify("withReturn()", parameters: ())
        }
        
        func withThrows() {
            return handler.verify("withThrows()", parameters: ())
        }
        
    }
}
