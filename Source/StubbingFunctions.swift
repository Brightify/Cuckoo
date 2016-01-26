//
//  StubbingFunctions.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Start the stubbing for the given mock. Can be used multiple times.
public func stub<M: Mock>(mock: M, @noescape block: M.Stubbing -> Void) {
    block(mock.manager.getStubbingProxy())
}

@warn_unused_result
public func when<IN, OUT>(stub: ToBeStubbedFunction<IN, OUT>) -> ThenReturnValue<IN, OUT> {
    return ThenReturnValue(setOutput: stub.setOutput)
}

@warn_unused_result
public func when<IN, OUT>(stub: ToBeStubbedThrowingFunction<IN, OUT>) -> ThenReturnValueOrThrow<IN, OUT> {
    return ThenReturnValueOrThrow(setOutput: stub.setOutput)
}