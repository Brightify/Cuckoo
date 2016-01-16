//
//  StubbingFunctions.swift
//  Mockery
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public func stub<M: Mock>(mock: M, @noescape block: M.Stubbing -> Void) {
    block(mock.manager.getStubbingProxy())
}

@warn_unused_result
public func when<IN, OUT>(stub: ToBeStubbedFunction<IN, OUT>) -> ThenReturnValue<IN, OUT> {
    return ThenReturnValue(setOutput: stub.setOutput)
}

@warn_unused_result
public func when<OUT>(stub: ToBeStubbedFunctionNeedingMatcher<Void, OUT>) -> ThenReturnValue<Void, OUT> {
    return when(stub, equalWhen: { _ in true })
}

@warn_unused_result
public func when<IN: AnyObject, OUT>(stub: ToBeStubbedFunctionNeedingMatcher<IN, OUT>) -> ThenReturnValue<IN, OUT> {
    return when(stub, equalWhen: ===)
}

@warn_unused_result
public func when<IN: Equatable, OUT>(stub: ToBeStubbedFunctionNeedingMatcher<IN, OUT>) -> ThenReturnValue<IN, OUT> {
    return when(stub, equalWhen: ==)
}

@warn_unused_result
public func when<IN, OUT>(stub: ToBeStubbedFunctionNeedingMatcher<IN, OUT>, equalWhen equalityFunction: (IN, IN) -> Bool) -> ThenReturnValue<IN, OUT> {
    let matcher = equalTo(stub.parameters, equalWhen: equalityFunction)
    return ThenReturnValue(setOutput: curry(stub.setInputMatcher)(matcher))
}

@warn_unused_result
public func when<IN, OUT>(stub: ToBeStubbedThrowingFunction<IN, OUT>) -> ThenReturnValueOrThrow<IN, OUT> {
    return ThenReturnValueOrThrow(setOutput: stub.setOutput)
}

@warn_unused_result
public func when<OUT>(stub: ToBeStubbedThrowingFunctionNeedingMatcher<Void, OUT>) -> ThenReturnValueOrThrow<Void, OUT> {
    return when(stub, equalWhen: { _ in true })
}

@warn_unused_result
public func when<IN: AnyObject, OUT>(stub: ToBeStubbedThrowingFunctionNeedingMatcher<IN, OUT>) -> ThenReturnValueOrThrow<IN, OUT> {
    return when(stub, equalWhen: ===)
}

@warn_unused_result
public func when<IN: Equatable, OUT>(stub: ToBeStubbedThrowingFunctionNeedingMatcher<IN, OUT>) -> ThenReturnValueOrThrow<IN, OUT> {
    return when(stub, equalWhen: ==)
}

@warn_unused_result
public func when<IN, OUT>(stub: ToBeStubbedThrowingFunctionNeedingMatcher<IN, OUT>, equalWhen equalityFunction: (IN, IN) -> Bool) -> ThenReturnValueOrThrow<IN, OUT> {
    let matcher = equalTo(stub.parameters, equalWhen: equalityFunction)
    return ThenReturnValueOrThrow(setOutput: curry(stub.setInputMatcher)(matcher))
}