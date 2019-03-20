//
//  Utils.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

internal func getterName(_ property: String) -> String {
    return property + "#get"
}

internal func setterName(_ property: String) -> String {
    return property + "#set"
}

public func wrap<M: Matchable, IN>(matchable: M, mapping: @escaping (IN) -> M.MatchedType) -> ParameterMatcher<IN> {
    return ParameterMatcher {
        return matchable.matcher.matches(mapping($0))
    }
}

public func wrap<M: OptionalMatchable, IN, O>(matchable: M, mapping: @escaping (IN) -> M.OptionalMatchedType?) -> ParameterMatcher<IN> where M.OptionalMatchedType == O {
    return ParameterMatcher {
        return matchable.optionalMatcher.matches(mapping($0))
    }
}

public typealias SourceLocation = (file: StaticString, line: UInt)

public func escapingStub<IN1, OUT>(for closure: (IN1) -> OUT) -> (IN1) -> OUT {
    return { _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}

public func escapingStub2<IN1, IN2, OUT>(for closure: (IN1, IN2) -> OUT) -> (IN1, IN2) -> OUT {
    return { _, _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}

public func escapingStub3<IN1, IN2, IN3, OUT>(for closure: (IN1, IN2, IN3) -> OUT) -> (IN1, IN2, IN3) -> OUT {
    return { _, _, _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}

public func escapingStub4<IN1, IN2, IN3, IN4, OUT>(for closure: (IN1, IN2, IN3, IN4) -> OUT) -> (IN1, IN2, IN3, IN4) -> OUT {
    return { _, _, _, _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}

public func escapingStub5<IN1, IN2, IN3, IN4, IN5, OUT>(for closure: (IN1, IN2, IN3, IN4, IN5) -> OUT) -> (IN1, IN2, IN3, IN4, IN5) -> OUT {
    return { _, _, _, _, _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}

public func escapingStub6<IN1, IN2, IN3, IN4, IN5, IN6, OUT>(for closure: (IN1, IN2, IN3, IN4, IN5, IN6) -> OUT) -> (IN1, IN2, IN3, IN4, IN5, IN6) -> OUT {
    return { _, _, _, _, _, _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}

public func escapingStub7<IN1, IN2, IN3, IN4, IN5, IN6, IN7, OUT>(for closure: (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT) -> (IN1, IN2, IN3, IN4, IN5, IN6, IN7) -> OUT {
    return { _, _, _, _, _, _, _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}

public func escapingStub<IN, OUT>(for closure: (inout IN) -> OUT) -> (inout IN) -> OUT {
    return { _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}

public func escapingStub<IN, OUT>(for closure: (IN) throws -> OUT) -> (IN) throws -> OUT {
    return { _ in
        fatalError("This is a stub! It's not supposed to be called!")
    }
}
