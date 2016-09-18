//
//  FileRepresentation.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework

public struct FileRepresentation {
    public let sourceFile: File
    public let declarations: [Token]
    
    public init(sourceFile: File, declarations: [Token]) {
        self.sourceFile = sourceFile
        self.declarations = declarations
    }
}