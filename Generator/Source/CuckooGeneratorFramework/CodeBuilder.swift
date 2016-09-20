//
//  CodeBuilder.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 06.07.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public class CodeBuilder {
    
    fileprivate static let Tab = "    "

    public fileprivate(set) var code = ""
    
    fileprivate var nesting = 0
    
    public  func clear() {
        code = ""
    }
    
    public  func nest(_ closure: () -> ()) {
        nesting += 1
        closure()
        nesting -= 1
    }
    
    public func nest(_ line: String) {
        nest { self += line }
    }
}

public func +=(left: CodeBuilder, right: String) {
    (0..<left.nesting).forEach { _ in left.code += CodeBuilder.Tab }
    left.code += right
    left.code += "\n"
}
