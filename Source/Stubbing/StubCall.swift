//
//  StubCall.swift
//  Cuckoo
//
//  Created by Filip Dolnik on 29.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol StubCall {
    var method: String { get }
    var parametersAsString: String { get }
}

public struct ConcreteStubCall<IN>: StubCall {
    public let method: String
    public let parameters: (IN)
    
    public var parametersAsString: String {
        let string = String(describing: parameters)
        if (string.range(of: ",") != nil && string.hasPrefix("(")) || string == "()" {
            return string
        } else {
            // If only one parameter add brackets and quotes
            let wrappedParameter = String(describing: (parameters, 0))            
            return wrappedParameter[..<wrappedParameter.index(wrappedParameter.endIndex, offsetBy: -4)] + ")"
        }
    }
    
    public init(method: String, parameters: (IN)) {
        self.method = method
        self.parameters = parameters
    }
}
