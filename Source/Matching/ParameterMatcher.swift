//
//  ParameterMatcher.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 04.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// ParameterMatcher matches parameters of methods in stubbing and verification.
public struct ParameterMatcher<T>: Matchable {
    private let matchesFunction: (T) -> Bool
    
    public init(matchesFunction: @escaping (T) -> Bool = { _ in true }) {
        self.matchesFunction = matchesFunction
    }
    
    public var matcher: ParameterMatcher<T> {
        return self
    }
    
    public func matches(_ input: T) -> Bool {
        return matchesFunction(input)
    }
}

public protocol CuckooOptionalType {
    associatedtype Wrapped

    static func from(optional: Optional<Wrapped>) -> Self
}

extension Optional: CuckooOptionalType {
    public static func from(optional: Optional<Wrapped>) -> Optional<Wrapped> {
        return optional
    }
}

extension ParameterMatcher: OptionalMatchable where T: CuckooOptionalType {
    public typealias OptionalMatchedType = T.Wrapped

    public var optionalMatcher: ParameterMatcher<T.Wrapped?> {
        return ParameterMatcher<T.Wrapped?> { other in
            self.matchesFunction(T.from(optional: other))
        }
    }
}
