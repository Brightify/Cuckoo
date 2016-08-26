//
//  CodeBuilder.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 06.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public class CodeBuilder {
    private static let Tab = "    "

    public private(set) var code = ""
    
    private var nesting = 0
    
    public func clear() {
        code = ""
    }
    
    public func nest(@noescape closure: () -> ()) {
        nesting += 1
        closure()
        nesting -= 1
    }
    
    public func nest(line: String) {
        nest { self += line }
    }
}

public func +=(left: CodeBuilder, right: String) {
    (0..<left.nesting).forEach { _ in left.code += CodeBuilder.Tab }
    left.code += right
    left.code += "\n"
}