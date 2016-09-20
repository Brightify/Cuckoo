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
    
    private func generate(_ token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generate(class: containerToken)
        case let property as InstanceVariable:
            generate(property: property)
        case let method as Method:
            generate(method: method)
        default:
            break
        }
    }
    
    private func generate(class token: ContainerToken) {
        guard token.accessibility != .Private else { return }
        
        code += ""
        code += "\(token.accessibility.sourceName)class \(mockClassName(token.name)): \(token.name), Cuckoo.Mock {"
        code.nest {
            code += "\(token.accessibility.sourceName)typealias MocksType = \(token.name)"
            code += "\(token.accessibility.sourceName)typealias Stubbing = \(stubbingProxyName(token.name))"
            code += "\(token.accessibility.sourceName)typealias Verification = \(verificationProxyName(token.name))"
            code += "\(token.accessibility.sourceName)let manager = Cuckoo.MockManager()"
            code += ""
            code += "private var observed: \(token.name)?"
            if (token.children.filter { ($0 as? Method)?.isInit == true }.isEmpty) {
                code += ""
                code += "\(token.accessibility.sourceName)\(token.implementation ? "override " : "")init() {"
                code += "}"
            }
            code += ""
            code += "\(token.accessibility.sourceName)func spy(on victim: \(token.name)) -> Self {"
            code.nest {
                code += "observed = victim"
                code += "return self"
            }
            code += "}"
            token.children.forEach { generate($0) }
            code += ""
            generateStubbing(token)
            code += ""
            generateVerification(token)
        }
        code += "}"
    }
    
    private func generate(property token: InstanceVariable) {
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
    
    private func generate(method token: Method) {
        guard token.accessibility != .Private else { return }
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
        
        code += ""
        code += "\(token.accessibility.sourceName)\(override)\(token.isInit ? "" : "func " )\(token.rawName)(\(parametersSignature))\(token.returnSignature) {"
        code.nest("return \(managerCall)")
        code += "}"
    }
    
    private func generateStubbing(_ token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateStubbing(class: containerToken)
        case let property as InstanceVariable:
            generateStubbing(property: property)
        case let method as Method:
            generateStubbing(method: method)
        default:
            break
        }
    }
    
    private func generateStubbing(class token: ContainerToken) {
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
    
    private func generateStubbing(property token: InstanceVariable) {
        guard token.accessibility != .Private else { return }
        
        let propertyType = token.readOnly ? "Cuckoo.ToBeStubbedReadOnlyProperty" : "Cuckoo.ToBeStubbedProperty"
        
        code += ""
        code += "var \(token.name): \(propertyType)<\(token.type)> {"
        code.nest("return \(propertyType)(manager: manager, name: \"\(token.name)\")")
        code += "}"
    }
    
    private func generateStubbing(method token: Method) {
        guard token.accessibility != .Private else { return }
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
        var returnType = "\(stubFunction)<(\(inputTypes))"
        if token.returnType != "Void" {
            returnType += ", "
            returnType += token.returnType
        }
        returnType += ">"
        
        code += ""
        code += ("\(token.accessibility.sourceName)func \(token.rawName)\(matchableGenerics(token.parameters))" +
                "(\(matchableParameterSignature(token.parameters))) -> \(returnType)\(matchableGenericsWhere(token.parameters)) {")
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
    
    private func generateVerification(_ token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateVerification(class: containerToken)
        case let property as InstanceVariable:
            generateVerification(property: property)
        case let method as Method:
            generateVerification(method: method)
        default:
            break
        }
    }
    
    private func generateVerification(class token: ContainerToken) {
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
    
    private func generateVerification(property token: InstanceVariable) {
        guard token.accessibility != .Private else { return }
        
        let propertyType = token.readOnly ? "Cuckoo.VerifyReadOnlyProperty" : "Cuckoo.VerifyProperty"
        
        code += ""
        code += "var \(token.name): \(propertyType)<\(token.type)> {"
        code.nest("return \(propertyType)(manager: manager, name: \"\(token.name)\", callMatcher: callMatcher, sourceLocation: sourceLocation)")
        code += "}"
    }
    
    private func generateVerification(method token: Method) {
        guard token.accessibility != .Private else { return }
        guard !token.isInit else { return }
        
        code += ""
        code += "@discardableResult"
        code += ("\(token.accessibility.sourceName)func \(token.rawName)\(matchableGenerics(token.parameters))" +
                "(\(matchableParameterSignature(token.parameters))) -> Cuckoo.__DoNotUse<\(token.returnType)>\(matchableGenericsWhere(token.parameters)) {")
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
    
    private func mockClassName(_ originalName: String) -> String {
        return "Mock" + originalName
    }
    
    private func stubbingProxyName(_ originalName: String) -> String {
        return "__StubbingProxy_" + originalName
    }
    
    private func verificationProxyName(_ originalName: String) -> String {
        return "__VerificationProxy_" + originalName
    }
    
    private func matchableGenerics(_ parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let genericParameters = (1...parameters.count).map { "M\($0): Cuckoo.Matchable" }.joined(separator: ", ")
        return "<\(genericParameters)>"
    }
    
    private func matchableGenericsWhere(_ parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let whereClause = parameters.enumerated().map { "M\($0 + 1).MatchedType == \($1.typeWithoutAttributes)" }.joined(separator: ", ")
        return " where \(whereClause)"
    }
    
    private func matchableParameterSignature(_ parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        return parameters.enumerated().map { "\($1.labelAndName): M\($0 + 1)" }.joined(separator: ", ")
    }
    
    private func parameterMatchers(_ parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let tupleType = parameters.map { $0.typeWithoutAttributes }.joined(separator: ", ")
        let matchers = parameters.enumerated().map { "wrap(matchable: \($1.name)) { $0\(parameters.count > 1 ? ".\($0)" : "") }" }.joined(separator: ", ")
        return "let matchers: [Cuckoo.ParameterMatcher<(\(tupleType))>] = [\(matchers)]"
    }
}
