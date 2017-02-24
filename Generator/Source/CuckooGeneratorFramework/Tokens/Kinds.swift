//
//  Kinds.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum Kinds: String {
    case ProtocolDeclaration = "source.lang.swift.decl.protocol"
    case InstanceMethod = "source.lang.swift.decl.function.method.instance"
    case MethodParameter = "source.lang.swift.decl.var.parameter"
    case ClassDeclaration = "source.lang.swift.decl.class"
    case ExtensionDeclaration = "source.lang.swift.decl.extension"
    case InstanceVariable = "source.lang.swift.decl.var.instance"
    case Optional = "source.decl.attribute.optional"
}
