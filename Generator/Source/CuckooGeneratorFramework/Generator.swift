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
        declarations.forEach { generate($0) }
        return code.code
    }
    
    private func generate(token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateMockingClass(containerToken)
        case let property as InstanceVariable:
            generateMockingProperty(property)
        case let method as Method:
            generateMockingMethod(method)
        default:
            break
        }
    }
    
    private func generateMockingClass(token: ContainerToken) {
        guard token.accessibility != .Private else { return }
        
        code += ""
        code += "\(token.accessibility.sourceName)class \(mockClassName(token.name)): \(token.name), Cuckoo.Mock {"
        code.nest {
            code += "\(token.accessibility.sourceName)typealias Stubbing = \(stubbingProxyName(token.name))"
            code += "\(token.accessibility.sourceName)typealias Verification = \(verificationProxyName(token.name))"
            code += "\(token.accessibility.sourceName)let manager = Cuckoo.MockManager()"
            code += ""
            code += "private var observed: \(token.name)?"
            code += ""
            code += "\(token.accessibility.sourceName)required\(token.implementation ? " override" : "") init() {"
            code += "}"
            code += ""
            code += "\(token.accessibility.sourceName)required init(spyOn victim: \(token.name)) {"
            code.nest("observed = victim")
            code += "}"
            token.children.forEach { generate($0) }
            code += ""
            generateStubbing(token)
            code += ""
            generateVerification(token)
        }
        code += "}"
    }
    
    private func generateMockingProperty(token: InstanceVariable) {
        guard token.accessibility != .Private else { return }
        
        code += ""
        code += "\(token.accessibility.sourceName)\(token.overriding ? "override " : "")var \(token.name): \(token.type) {"
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
    
    private func generateMockingMethod(token: Method) {
        guard token.accessibility != .Private else { return }
        
        let override = token is ClassMethod ? "override " : ""
        let parametersSignature = token.parameters.enumerate().map { "\($1.attributes.sourceRepresentation)\($1.labelAndNameAtPosition($0)): \($1.type)" }.joinWithSeparator(", ")
        
        var managerCall: String
        let tryIfThrowing: String
        if token.isThrowing {
            managerCall = "try manager.callThrows(\"\(token.fullyQualifiedName)\""
            tryIfThrowing = "try "
        } else {
            managerCall = "manager.call(\"\(token.fullyQualifiedName)\""
            tryIfThrowing = ""
        }
        let escapingParameters = token.parameters.map {
            if $0.attributes.contains(Attributes.noescape) || ($0.attributes.contains(Attributes.autoclosure) && !$0.attributes.contains(Attributes.escaping)) {
                return "Cuckoo.markerFunction()"
            } else {
                return $0.name
            }
        }.joinWithSeparator(", ")
        managerCall += ", parameters: (\(escapingParameters))"
        let methodCall = token.parameters.enumerate().map { ($1.labelOrNameAtPosition($0), $1.name ) }.map { $0.isEmpty ? $1 : "\($0): \($1)" }.joinWithSeparator(", ")
        managerCall += ", original: observed.map { o in return { (\(parametersSignature))\(token.returnSignature) in \(tryIfThrowing)o.\(token.rawName)(\(methodCall)) } })"
        
        code += ""
        code += "\(token.accessibility.sourceName)\(override)\(token.isInit ? "" : "func " )\(token.rawName)(\(parametersSignature))\(token.returnSignature) {"
        code.nest("return \(managerCall)")
        code += "}"
    }
    
    private func generateStubbing(token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateStubbingClass(containerToken)
        case let property as InstanceVariable:
            generateStubbingProperty(property)
        case let method as Method:
            generateStubbingMethod(method)
        default:
            break
        }
    }
    
    private func generateStubbingClass(token: ContainerToken) {
        guard token.accessibility != .Private else { return }
        
        code += "\(token.accessibility.sourceName)struct \(stubbingProxyName(token.name)): Cuckoo.StubbingProxy {"
        code.nest {
            code += "private let manager: Cuckoo.MockManager"
            code += ""
            code += "\(token.accessibility.sourceName)init(manager: Cuckoo.MockManager) {"
            code.nest("self.manager = manager")
            code += "}"
            token.children.forEach { generateStubbing($0) }
        }
        code += "}"
    }
    
    private func generateStubbingProperty(token: InstanceVariable) {
        guard token.accessibility != .Private else { return }
        
        let propertyType = token.readOnly ? "Cuckoo.ToBeStubbedReadOnlyProperty" : "Cuckoo.ToBeStubbedProperty"
        
        code += ""
        code += "var \(token.name): \(propertyType)<\(token.type)> {"
        code.nest("return \(propertyType)(manager: manager, name: \"\(token.name)\")")
        code += "}"
    }
    
    private func generateStubbingMethod(token: Method) {
        guard token.accessibility != .Private else { return }
        
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
        
        let inputTypes = token.parameters.map { $0.type }.joinWithSeparator(", ")
        var returnType = "\(stubFunction)<(\(inputTypes))"
        if token.returnType != "Void" {
            returnType += ", "
            returnType += token.returnType
        }
        returnType += ">"
        
        code += ""
        code += "@warn_unused_result"
        code += ("\(token.accessibility.sourceName)func \(token.rawName)\(matchableGenerics(token.parameters))" +
                "(\(matchableParameterSignature(token.parameters))) -> \(returnType) {")
        let matchers: String
        if token.parameters.isEmpty {
            matchers = "[]"
        } else {
            code.nest(parameterMatchers(token.parameters))
            matchers = "matchers"
        }
        code.nest("return \(stubFunction)(stub: manager.createStub(\"\(token.fullyQualifiedName)\", parameterMatchers: \(matchers)))")
        code += "}"
    }
    
    private func generateVerification(token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateVerificationClass(containerToken)
        case let property as InstanceVariable:
            generateVerificationProperty(property)
        case let method as Method:
            generateVerificationMethod(method)
        default:
            break
        }
    }
    
    private func generateVerificationClass(token: ContainerToken) {
        guard token.accessibility != .Private else { return }
        
        code += "\(token.accessibility.sourceName)struct \(verificationProxyName(token.name)): Cuckoo.VerificationProxy {"
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
            token.children.forEach { generateVerification($0) }
        }
        code += "}"
    }
    
    private func generateVerificationProperty(token: InstanceVariable) {
        guard token.accessibility != .Private else { return }
        
        let propertyType = token.readOnly ? "Cuckoo.VerifyReadOnlyProperty" : "Cuckoo.VerifyProperty"
        
        code += ""
        code += "var \(token.name): \(propertyType)<\(token.type)> {"
        code.nest("return \(propertyType)(manager: manager, name: \"\(token.name)\", callMatcher: callMatcher, sourceLocation: sourceLocation)")
        code += "}"
    }
    
    private func generateVerificationMethod(token: Method) {
        guard token.accessibility != .Private else { return }
        
        code += ""
        code += ("\(token.accessibility.sourceName)func \(token.rawName)\(matchableGenerics(token.parameters))" +
                "(\(matchableParameterSignature(token.parameters))) -> Cuckoo.__DoNotUse<\(token.returnType)> {")
        let matchers: String
        if token.parameters.isEmpty {
            matchers = "[] as [Cuckoo.ParameterMatcher<Void>]"
        } else {
            code.nest(parameterMatchers(token.parameters))
            matchers = "matchers"
        }
        code.nest("return manager.verify(\"\(token.fullyQualifiedName)\", callMatcher: callMatcher, parameterMatchers: \(matchers), sourceLocation: sourceLocation)")
        code += "}"
    }
    
    private func mockClassName(originalName: String) -> String {
        return "Mock" + originalName
    }
    
    private func stubbingProxyName(originalName: String) -> String {
        return "__StubbingProxy_" + originalName
    }
    
    private func verificationProxyName(originalName: String) -> String {
        return "__VerificationProxy_" + originalName
    }
    
    private func matchableGenerics(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let genericParameters = (1...parameters.count).map { "M\($0): Cuckoo.Matchable" }.joinWithSeparator(", ")
        let whereClause = parameters.enumerate().map { "M\($0 + 1).MatchedType == \($1.type)" }.joinWithSeparator(", ")
        return "<\(genericParameters) where \(whereClause)>"
    }
    
    private func matchableParameterSignature(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        return parameters.enumerate().map { "\($1.labelAndNameAtPosition($0)): M\($0 + 1)" }.joinWithSeparator(", ")
    }
    
    private func parameterMatchers(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let tupleType = parameters.map { $0.type }.joinWithSeparator(", ")
        let matchers = parameters.enumerate().map { "wrapMatchable(\($1.name)) { $0\(parameters.count > 1 ? ".\($0)" : "") }" }.joinWithSeparator(", ")
        return "let matchers: [Cuckoo.ParameterMatcher<(\(tupleType))>] = [\(matchers)]"
    }
}
