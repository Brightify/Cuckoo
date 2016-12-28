//
//  Generator.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct Generator {
    
    private let declarations: [Token]
    private let code = CodeBuilder()
    
    public init(file: FileRepresentation) {
        declarations = file.declarations
    }
    
    public func generate() -> String {
        code.clear()
        declarations.forEach { generate(for: $0, withOuterAccessibility: .Internal) }
        return code.code
    }
    
    private func generate(for token: Token, withOuterAccessibility outerAccessibility: Accessibility) {
        switch token {
        case let containerToken as ContainerToken:
            generateClass(for: containerToken)
            generateNoImplStubClass(for: containerToken)
        case let property as InstanceVariable:
            generateProperty(for: property, withOuterAccessibility: outerAccessibility)
        case let method as Method:
            generateMethod(for: method, withOuterAccessibility: outerAccessibility)
        default:
            break
        }
    }

    private func generateClass(for token: ContainerToken) {
        guard token.accessibility.isAccessible else { return }
        
        code += ""
        code += "\(token.accessibility.sourceName)class \(mockClassName(of: token.name)): \(token.name), Cuckoo.Mock {"
        code.nest {
            code += "\(token.accessibility.sourceName)typealias MocksType = \(token.name)"
            code += "\(token.accessibility.sourceName)typealias Stubbing = \(stubbingProxyName(of: token.name))"
            code += "\(token.accessibility.sourceName)typealias Verification = \(verificationProxyName(of: token.name))"
            code += "\(token.accessibility.sourceName)let manager = Cuckoo.MockManager()"
            code += ""
            code += "private var observed: \(token.name)?"
            code += ""
            code += "\(token.accessibility.sourceName)func spy(on victim: \(token.name)) -> Self {"
            code.nest {
                code += "observed = victim"
                code += "return self"
            }
            code += "}"
            token.children.forEach { generate(for: $0, withOuterAccessibility: token.accessibility) }
            code += ""
            generateStubbing(for: token)
            code += ""
            generateVerification(for: token)
        }
        code += "}"
    }

    private func minAccessibility(_ val1: Accessibility, _ val2: Accessibility) -> Accessibility {
        if val1 == .Public || val2 == .Public {
            return .Public
        }

        if val1 == .Internal || val2 == .Internal {
            return .Internal
        }

        return .Private
    }

    private func generateProperty(for token: InstanceVariable, withOuterAccessibility outerAccessibility: Accessibility) {
        guard token.accessibility.isAccessible else { return }
        let accessibility = minAccessibility(token.accessibility, outerAccessibility)

        code += ""
        code += "\(accessibility.sourceName)\(token.overriding ? "override " : "")var \(token.name): \(token.type) {"
        code.nest {
            code += "get {"
            code.nest("return manager.getter(\"\(token.name)\", original: observed.map { o in return { () -> \(token.type) in o.\(token.name) } })")
            code += "}"
            if token.readOnly == false {
                code += "set {"
                code.nest("manager.setter(\"\(token.name)\", value: newValue, original: observed != nil ? { self.observed?.\(token.name) = $0 } : nil)")
                code += "}"
            }
        }
        code += "}"
    }
    
    private func generateMethod(for token: Method, withOuterAccessibility outerAccessibility: Accessibility) {
        guard token.accessibility.isAccessible else { return }
        guard !token.isInit else { return }
        
        let override = token is ClassMethod ? "override " : ""
        let parametersSignature = token.parameters.enumerated().map { "\($1.labelAndName): \($1.type)" }.joined(separator: ", ")

        let parametersSignatureWithoutNames = token.parameters.map { "\($0.name): \($0.type)" }.joined(separator: ", ")
        
        var managerCall: String
        let tryIfThrowing: String
        if token.isThrowing {
            managerCall = "try manager.callThrows(\"\(token.fullyQualifiedName)\""
            tryIfThrowing = "try "
        } else {
            managerCall = "manager.call(\"\(token.fullyQualifiedName)\""
            tryIfThrowing = ""
        }
        managerCall += ", parameters: (\(token.parameters.map { $0.name }.joined(separator: ", ")))"
        let methodCall = token.parameters.enumerated().map {
                if let label = $1.label {
                    return "\(label): \($1.name)"
                } else {
                    return $1.name
                }
            }.joined(separator: ", ")
        managerCall += ", original: observed.map { o in return { (\(parametersSignatureWithoutNames))\(token.returnSignature) in \(tryIfThrowing)o.\(token.rawName)(\(methodCall)) } })"
        
        let accessibility = minAccessibility(token.accessibility, outerAccessibility)
        code += ""
        code += "\(accessibility.sourceName)\(override)\(token.isInit ? "" : "func " )\(token.rawName)(\(parametersSignature))\(token.returnSignature) {"
        code.nest("return \(managerCall)")
        code += "}"
    }
    
    private func generateStubbing(for token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateStubbingClass(for: containerToken)
        case let property as InstanceVariable:
            generateStubbingProperty(for: property)
        case let method as Method:
            generateStubbingMethod(for: method)
        default:
            break
        }
    }
    
    private func generateStubbingClass(for token: ContainerToken) {
        guard token.accessibility.isAccessible else { return }
        
        code += "\(token.accessibility.sourceName)struct \(stubbingProxyName(of: token.name)): Cuckoo.StubbingProxy {"
        code.nest {
            code += "private let manager: Cuckoo.MockManager"
            code += ""
            code += "\(token.accessibility.sourceName)init(manager: Cuckoo.MockManager) {"
            code.nest("self.manager = manager")
            code += "}"
            token.children.forEach { generateStubbing(for: $0) }
        }
        code += "}"
    }
    
    private func generateStubbingProperty(for token: InstanceVariable) {
        guard token.accessibility.isAccessible else { return }
        
        let propertyType = token.readOnly ? "Cuckoo.ToBeStubbedReadOnlyProperty" : "Cuckoo.ToBeStubbedProperty"
        
        code += ""
        code += "var \(token.name): \(propertyType)<\(genericSafeType(from: token.type))> {"
        code.nest("return \(propertyType)(manager: manager, name: \"\(token.name)\")")
        code += "}"
    }
    
    private func generateStubbingMethod(for token: Method) {
        guard token.accessibility.isAccessible else { return }
        guard !token.isInit else { return }
        
        let stubFunction: String
        if token.isThrowing {
            if token.returnType == "Void" {
                stubFunction = "Cuckoo.StubNoReturnThrowingFunction"
            } else {
                stubFunction = "Cuckoo.StubThrowingFunction"
            }
        } else {
            if token.returnType == "Void" {
                stubFunction = "Cuckoo.StubNoReturnFunction"
            } else {
                stubFunction = "Cuckoo.StubFunction"
            }
        }
        
        let inputTypes = token.parameters.map { $0.typeWithoutAttributes }.joined(separator: ", ")
        var returnType = "\(stubFunction)<(\(genericSafeType(from: inputTypes)))"
        if token.returnType != "Void" {
            returnType += ", "
            returnType += genericSafeType(from: token.returnType)
        }
        returnType += ">"
        
        code += ""
        code += ("\(token.accessibility.sourceName)func \(token.rawName)\(matchableGenerics(with: token.parameters))" +
            "(\(matchableParameterSignature(with: token.parameters))) -> \(returnType)\(matchableGenerics(where: token.parameters)) {")
        let matchers: String
        if token.parameters.isEmpty {
            matchers = "[]"
        } else {
            code.nest(parameterMatchers(for: token.parameters))
            matchers = "matchers"
        }
        code.nest("return \(stubFunction)(stub: manager.createStub(\"\(token.fullyQualifiedName)\", parameterMatchers: \(matchers)))")
        code += "}"
    }
    
    private func generateVerification(for token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateVerificationClass(for: containerToken)
        case let property as InstanceVariable:
            generateVerificationProperty(for: property)
        case let method as Method:
            generateVerificationMethod(for: method)
        default:
            break
        }
    }
    
    private func generateVerificationClass(for token: ContainerToken) {
        guard token.accessibility.isAccessible else { return }
        
        code += "\(token.accessibility.sourceName)struct \(verificationProxyName(of: token.name)): Cuckoo.VerificationProxy {"
        code.nest {
            code += "private let manager: Cuckoo.MockManager"
            code += "private let callMatcher: Cuckoo.CallMatcher"
            code += "private let sourceLocation: Cuckoo.SourceLocation"
            code += ""
            code += "\(token.accessibility.sourceName)init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {"
            code.nest {
                code += "self.manager = manager"
                code += "self.callMatcher = callMatcher"
                code += "self.sourceLocation = sourceLocation"
            }
            code += "}"
            token.children.forEach { generateVerification(for: $0) }
        }
        code += "}"
    }
    
    private func generateVerificationProperty(for token: InstanceVariable) {
        guard token.accessibility.isAccessible else { return }
        
        let propertyType = token.readOnly ? "Cuckoo.VerifyReadOnlyProperty" : "Cuckoo.VerifyProperty"
        
        code += ""
        code += "var \(token.name): \(propertyType)<\(genericSafeType(from: token.type))> {"
        code.nest("return \(propertyType)(manager: manager, name: \"\(token.name)\", callMatcher: callMatcher, sourceLocation: sourceLocation)")
        code += "}"
    }
    
    private func generateVerificationMethod(for token: Method) {
        guard token.accessibility.isAccessible else { return }
        guard !token.isInit else { return }
        
        code += ""
        code += "@discardableResult"
        code += ("\(token.accessibility.sourceName)func \(token.rawName)\(matchableGenerics(with: token.parameters))" +
            "(\(matchableParameterSignature(with: token.parameters))) -> Cuckoo.__DoNotUse<\(genericSafeType(from: token.returnType))>\(matchableGenerics(where: token.parameters)) {")
        let matchers: String
        if token.parameters.isEmpty {
            matchers = "[] as [Cuckoo.ParameterMatcher<Void>]"
        } else {
            code.nest(parameterMatchers(for: token.parameters))
            matchers = "matchers"
        }
        code.nest("return manager.verify(\"\(token.fullyQualifiedName)\", callMatcher: callMatcher, parameterMatchers: \(matchers), sourceLocation: sourceLocation)")
        code += "}"
    }
    
    private func generateNoImplStubClass(for token: ContainerToken) {
        guard token.accessibility.isAccessible else { return }
        
        code += ""
        code += "\(token.accessibility.sourceName)class \(stubClassName(of: token.name)): \(token.name) {"
        code.nest {
            token.children.forEach { generateNoImplStub(for: $0, withOuterAccessibility: token.accessibility) }
        }
        code += "}"
    }
    
    private func generateNoImplStub(for token: Token, withOuterAccessibility outerAccessibility: Accessibility) {
        switch token {
        case let property as InstanceVariable:
            generateNoImplStubProperty(for: property, withOuterAccessibility: outerAccessibility)
        case let method as Method:
            generateNoImplStubMethod(for: method, withOuterAccessibility: outerAccessibility)
        default:
            break
        }
    }

    private func generateNoImplStubProperty(for token: InstanceVariable, withOuterAccessibility outerAccessibility: Accessibility) {
        guard token.accessibility.isAccessible else { return }
        
        let accessibility = minAccessibility(token.accessibility, outerAccessibility)
        code += ""
        code += "\(accessibility.sourceName)\(token.overriding ? "override " : "")var \(token.name): \(token.type) {"
        code.nest {
            code += "get {"
            code.nest("return DefaultValueRegistry.defaultValue(for: (\(token.type)).self)")
            code += "}"
            if token.readOnly == false {
                code += "set {"
                code += "}"
            }
        }
        code += "}"
    }
    
    private func generateNoImplStubMethod(for token: Method, withOuterAccessibility outerAccessibility: Accessibility) {
        guard token.accessibility.isAccessible else { return }
        guard !token.isInit else { return }
        
        let override = token is ClassMethod ? "override " : ""
        let parametersSignature = token.parameters.enumerated().map { "\($1.labelAndName): \($1.type)" }.joined(separator: ", ")
        
        let accessibility = minAccessibility(token.accessibility, outerAccessibility)
        code += ""
        code += "\(accessibility.sourceName)\(override)func \(token.rawName)(\(parametersSignature))\(token.returnSignature) {"
        code.nest("return DefaultValueRegistry.defaultValue(for: (\(token.returnType)).self)")
        code += "}"
    }
    
    private func mockClassName(of originalName: String) -> String {
        return "Mock" + originalName
    }
    
    private func stubClassName(of originalName: String) -> String {
        return originalName + "Stub"
    }
    
    private func stubbingProxyName(of originalName: String) -> String {
        return "__StubbingProxy_" + originalName
    }
    
    private func verificationProxyName(of originalName: String) -> String {
        return "__VerificationProxy_" + originalName
    }
    
    private func matchableGenerics(with parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let genericParameters = (1...parameters.count).map { "M\($0): Cuckoo.Matchable" }.joined(separator: ", ")
        return "<\(genericParameters)>"
    }
    
    private func matchableGenerics(where parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let whereClause = parameters.enumerated().map { "M\($0 + 1).MatchedType == \(genericSafeType(from: $1.typeWithoutAttributes))" }.joined(separator: ", ")
        return " where \(whereClause)"
    }
    
    private func matchableParameterSignature(with parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        return parameters.enumerated().map { "\($1.labelAndName): M\($0 + 1)" }.joined(separator: ", ")
    }
    
    private func parameterMatchers(for parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let tupleType = parameters.map { $0.typeWithoutAttributes }.joined(separator: ", ")
        let matchers = parameters.enumerated().map { "wrap(matchable: \($1.name)) { $0\(parameters.count > 1 ? ".\($0)" : "") }" }.joined(separator: ", ")
        return "let matchers: [Cuckoo.ParameterMatcher<(\(genericSafeType(from: tupleType)))>] = [\(matchers)]"
    }
    
    private func genericSafeType(from type: String) -> String {
        return type.replacingOccurrences(of: "!", with: "?")
    }
}
