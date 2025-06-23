import Foundation
import SwiftSyntax
import SwiftParser

final class Crawler: SyntaxVisitor {
    static func crawl(url: URL) throws -> Crawler {
        let file = try String(contentsOf: url)
        let syntaxTree = Parser.parse(source: file)
        #if DEBUG
        // Comment out the line above and uncomment the one below to test specific strings.
        // The `testString` is at the bottom of this file.
//        let syntaxTree = Parser.parse(source: testString)
        #endif
        let crawler = Self(container: nil, url: url)
        crawler.walk(syntaxTree)
        return crawler
    }

    var imports: [Import] = []
    var tokens: [Token] = []

    private var container: Reference<Token>?

    private let url: URL

    private init(container: Reference<Token>?, url: URL) {
        self.container = container
        self.url = url

        super.init(viewMode: .sourceAccurate)
    }

    override func visit(_ node: ImportDeclSyntax) -> SyntaxVisitorContinueKind {
        let path = node.path.description
        if let importKind = node.importKindSpecifier?.trimmed.text {
            // Component import.
            imports.append(.component(kind: importKind, name: path))
        } else {
            // Target import.
            imports.append(.library(name: path))
        }
        return .skipChildren
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        debug(node)

        // Skip `final` classes.
        guard !node.modifiers.isFinal else { return .skipChildren }

        var token = ClassDeclaration(
            parent: container,
            attributes: attributes(from: node.attributes),
            accessibility: accessibility(from: node.modifiers) ?? (container as? HasAccessibility)?.accessibility ?? .internal,
            name: node.name.filteredDescription,
            genericParameters: genericParameters(from: node.genericParameterClause?.parameters),
            genericRequirements: genericRequirements(from: node.genericWhereClause?.requirements),
            inheritedTypes: inheritedTypes(from: node.inheritanceClause?.inheritedTypes),
            members: []
        )

        guard token.accessibility.isAccessible else { return .skipChildren }

        let crawler = Crawler(container: Reference(token), url: url)
        crawler.walk(members: node.memberBlock)
        token.members = crawler.tokens
        tokens.append(token)
        return .skipChildren
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        debug(node)
        let inheritedTypes = inheritedTypes(from: node.inheritanceClause?.inheritedTypes)
        var token = ProtocolDeclaration(
            parent: container,
            attributes: attributes(from: node.attributes),
            accessibility: accessibility(from: node.modifiers) ?? (container as? HasAccessibility)?.accessibility ?? .internal,
            name: node.name.filteredDescription,
            genericParameters: (genericParameters(from: node.primaryAssociatedTypeClause?.primaryAssociatedTypes) + associatedTypes(from: node.memberBlock.members)).merged(),
            genericRequirements: genericRequirements(from: node.genericWhereClause?.requirements),
            inheritedTypes: inheritedTypes,
            members: []
        )

        guard token.accessibility.isAccessible else { return .skipChildren }

        let crawler = Crawler(container: Reference(token), url: url)
        crawler.walk(members: node.memberBlock)
        token.members = crawler.tokens
        tokens.append(token)
        return .skipChildren
    }

    // Enum mocking is not supported, this is used to parse nested classes.
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        debug(node)
        var token = NamespaceDeclaration(
            parent: container,
            attributes: attributes(from: node.attributes),
            accessibility: accessibility(from: node.modifiers) ?? (container as? HasAccessibility)?.accessibility ?? .internal,
            name: node.name.filteredDescription,
            members: []
        )

        guard token.accessibility.isAccessible else { return .skipChildren }

        let crawler = Crawler(container: Reference(token), url: url)
        crawler.walk(members: node.memberBlock)
        token.members = crawler.tokens
        tokens.append(token)
        return .skipChildren
    }

    // Extension mocking is not supported, this is used to parse nested classes.
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        debug(node)
        var token = NamespaceDeclaration(
            parent: container,
            attributes: attributes(from: node.attributes),
            accessibility: accessibility(from: node.modifiers) ?? (container as? HasAccessibility)?.accessibility ?? .internal,
            name: node.extendedType.filteredDescription,
            members: []
        )

        guard token.accessibility.isAccessible else { return .skipChildren }

        let crawler = Crawler(container: Reference(token), url: url)
        crawler.walk(members: node.memberBlock)
        token.members = crawler.tokens
        tokens.append(token)
        return .skipChildren
    }

    // Struct mocking is not supported, this is used to parse nested classes.
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        debug(node)
        var token = NamespaceDeclaration(
            parent: container,
            attributes: attributes(from: node.attributes),
            accessibility: accessibility(from: node.modifiers) ?? (container as? HasAccessibility)?.accessibility ?? .internal,
            name: node.name.filteredDescription,
            members: []
        )

        guard token.accessibility.isAccessible else { return .skipChildren }

        let crawler = Crawler(container: Reference(token), url: url)
        crawler.walk(members: node.memberBlock)
        token.members = crawler.tokens
        tokens.append(token)
        return .skipChildren
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let container, container.isMockable else { return .skipChildren }

        tokens.append(contentsOf: parse(node))
        return .skipChildren
    }

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let container, container.isMockable else { return .skipChildren }

        if let initializer = parse(node) {
            tokens.append(initializer)
        }
        return .skipChildren
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let container, container.isMockable else { return .skipChildren }

        if let method = parse(node) {
            tokens.append(method)
        }
        return .skipChildren
    }

    override func visit(_ node: IfConfigDeclSyntax) -> SyntaxVisitorContinueKind {
        // TODO: Implement #if functionality.
        return .visitChildren
    }

    override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
        tokens.append(Typealias(syntax: node))
        return .skipChildren
    }

    private func walk(members: MemberBlockSyntax) {
        for member in members.members {
            walk(member)
        }
    }

    private func debug(_ node: DeclSyntaxProtocol, additionalInfo: String? = nil) {
        let description: String
        switch node {
        case let node as ClassDeclSyntax:
            description = "class \(node.name.filteredDescription)"
        case let node as ProtocolDeclSyntax:
            description = "protocol \(node.name.filteredDescription)"
        case let node as StructDeclSyntax:
            description = "struct \(node.name.filteredDescription)"
        case let node as ExtensionDeclSyntax:
            description = "extension \(node.extendedType.filteredDescription)"
        case let node as EnumDeclSyntax:
            description = "enum \(node.name.filteredDescription)"
        default:
            description = "Unknown declaration \(node.filteredDescription)"
        }

        log(
            .verbose,
            message: [description, additionalInfo].compactMap { $0 }.joined(separator: " ")
        )
    }
}

// MARK: - Variable crawling.
extension Crawler {
    private func parse(_ variableGroup: VariableDeclSyntax) -> [Variable] {
        let isConstant = variableGroup.bindingSpecifier.tokenKind == .keyword(.let)

        guard !variableGroup.modifiers.isStatic && !variableGroup.modifiers.isFinal else { return [] }

        let attributes = attributes(from: variableGroup.attributes)

        var accessibility = Accessibility.internal
        var setterAccessibility: Accessibility?
        let modifiers = variableGroup.modifiers
        if !modifiers.isEmpty {
            for modifier in modifiers {
                let tokenKind = modifier.name.tokenKind

                guard let parsedAccessibility = Accessibility(tokenKind: tokenKind) else {
                    continue
                }

                if modifier.detail?.detail.tokenKind == .identifier("set") {
                    setterAccessibility = parsedAccessibility
                } else {
                    accessibility = parsedAccessibility
                }
            }
        }

        // Early return for private variable.
        guard accessibility.isAccessible else { return [] }

        return variableGroup.bindings
            .compactMap(variable(from:))
            .map {
                Variable(
                    parent: container,
                    documentation: documentation(from: variableGroup.leadingTrivia),
                    attributes: attributes,
                    accessibility: accessibility,
                    setterAccessibility: $0.isReadOnly ? nil : setterAccessibility ?? (container as? HasAccessibility)?.accessibility ?? .internal,
                    name: $0.identifier,
                    type: $0.type,
                    effects: $0.effects,
                    isConstant: isConstant
                )
            }
    }

    private func variable(from binding: PatternBindingSyntax) -> VariablePart? {
        guard case .identifier(let identifier) = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.tokenKind else { return nil }

        let type: ComplexType
        if let explicitType = binding.typeAnnotation?.type {
            type = ComplexType(syntax: explicitType)
        } else if let initializer = binding.initializer?.value.filteredDescription, let guessedType = TypeGuesser.guessType(from: initializer) {
            type = .type(guessedType)
        } else {
            fatalError("Can't infer type of property '\(identifier)' in file \(url)")
        }

        let isReadOnly: Bool
        let effects: Variable.Effects
        switch binding.accessorBlock?.accessors {
        case .accessors(let accessors):
            let accessorsContainGet = accessors.contains { $0.accessorSpecifier.tokenKind == .keyword(.get) }
            let accessorsContainSet = accessors.contains { $0.accessorSpecifier.tokenKind == .keyword(.set) }
            isReadOnly = accessorsContainGet && !accessorsContainSet

            let getAccessor = accessors.first { $0.accessorSpecifier.tokenKind == .keyword(.get) }
            effects = Variable.Effects(
                isThrowing: getAccessor?.effectSpecifiers?.throwsClause != nil,
                isAsync: getAccessor?.effectSpecifiers?.asyncSpecifier?.isPresent == true
            )
        case .getter:
            isReadOnly = true
            effects = Variable.Effects()
        case nil:
            isReadOnly = false
            effects = Variable.Effects()
        }

        return VariablePart(
            identifier: identifier,
            type: type,
            isReadOnly: isReadOnly,
            effects: effects
        )
    }

    private struct VariablePart {
        var identifier: String
        var type: ComplexType
        var isReadOnly: Bool
        var effects: Variable.Effects
    }
}

extension Crawler {
    private func parse(_ initializer: InitializerDeclSyntax) -> Initializer? {
        let accessibility = initializer.modifiers.lazy.compactMap { Accessibility(tokenKind: $0.name.tokenKind) }.first ?? (container as? HasAccessibility)?.accessibility ?? .internal

        guard accessibility.isAccessible else { return nil }

        let parameters = self.parameters(from: initializer.signature.parameterClause.parameters)

        return Initializer(
            parent: container,
            documentation: documentation(from: initializer.leadingTrivia),
            attributes: attributes(from: initializer.attributes),
            accessibility: accessibility,
            signature: Method.Signature(
                genericParameters: genericParameters(from: initializer.genericParameterClause?.parameters),
                parameters: parameters,
                asyncType: nil,
                throwType: ThrowType(syntax: initializer.signature.effectSpecifiers?.throwsClause),
                returnType: nil,
                whereConstraints: genericRequirements(from: initializer.genericWhereClause?.requirements)
            ),
            isRequired: initializer.modifiers.contains { $0.name == .keyword(.required) },
            isOptional: initializer.optionalMark?.isPresent == true
        )
    }
}

// MARK: - Method crawling.
extension Crawler {
    private func parse(_ method: FunctionDeclSyntax) -> Method? {
        // Can't mock static and final members.
        guard !method.modifiers.isStatic && !method.modifiers.isFinal else { return nil }

        guard case .identifier(let identifier) = method.name.tokenKind else { return nil }

        let accessibility = method.modifiers.lazy.compactMap { Accessibility(tokenKind: $0.name.tokenKind) }.first ?? (container as? HasAccessibility)?.accessibility ?? .internal

        guard accessibility.isAccessible else { return nil }

        let parameters = self.parameters(from: method.signature.parameterClause.parameters)
        let returnType = method.signature.returnClause.flatMap { ComplexType(syntax: $0.type) }

        return Method(
            parent: container,
            documentation: documentation(from: method.leadingTrivia),
            attributes: attributes(from: method.attributes),
            accessibility: accessibility,
            name: identifier,
            signature: Method.Signature(
                genericParameters: genericParameters(from: method.genericParameterClause?.parameters),
                parameters: parameters,
                asyncType: method.signature.effectSpecifiers?.asyncSpecifier.flatMap { AsyncType(rawValue: $0.filteredDescription) },
                throwType: ThrowType(syntax: method.signature.effectSpecifiers?.throwsClause),
                returnType: returnType ?? ComplexType.type("Void"),
                whereConstraints: genericRequirements(from: method.genericWhereClause?.requirements)
            ),
            isOptional: method.modifiers.contains { $0.name.tokenKind == .keyword(.optional) }
        )
    }
}

extension Crawler {
    private func parameters(from parameterList: FunctionParameterListSyntax) -> [MethodParameter] {
        parameterList.map { parameter in
            MethodParameter(
                name: parameter.firstName.filteredDescription,
                innerName: nil,
                type: ComplexType(syntax: parameter.type)
            )
        }
    }

    private func documentation(from trivia: Trivia) -> [String] {
        var docStrings: [String] = []
        for piece in trivia.pieces.reversed() {
            switch piece {
            case .docLineComment(let string):
                docStrings.insert(string.replacingOccurrences(of: "///", with: ""), at: 0)
            case .docBlockComment(let string):
                docStrings.insert(
                    contentsOf: string
                        .components(separatedBy: .newlines)
                        .map { $0.replacingOccurrences(of: "/**", with: "").replacingOccurrences(of: "*/", with: "") },
                    at: 0
                )
            case .newlines:
                // Only process docstrings directly attached to the declaration.
                break
            default:
                return []
            }
        }

        return docStrings.compactMap { $0.trimmed.nilIfEmpty }
    }

    private func attributes(from attributeList: AttributeListSyntax?) -> [Attribute] {
        attributeList?.children(viewMode: .fixedUp)
            .compactMap { $0.as(AttributeSyntax.self).flatMap(attribute(from:)) }
            ?? []
    }

    private func attribute(from attribute: AttributeSyntax) -> Attribute? {
        if case .identifier(let identifier) = attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.tokenKind {
            switch identifier {
            case "available":
                return .available(
                    arguments: attribute.arguments?.description
                        .split(separator: ",")
                        .map { String($0).trimmed } ?? []
                )
            // These will need some more work, not sure if worth the effort.
//            case "objc":
//                return .objc
//            case "objcMembers":
//                return .objcMembers
            default:
                log(.verbose, message: "Ignoring unsupported attribute '\(attribute.attributeName.trimmedDescription)'")
                return nil
            }
        } else {
            log(.verbose, message: "Ignoring unsupported attribute '\(attribute.attributeName.trimmedDescription)'")
            return nil
        }
    }

    private func accessibility(from modifierList: DeclModifierListSyntax?) -> Accessibility? {
        modifierList?.lazy.compactMap { Accessibility(tokenKind: $0.name.tokenKind) }.first
    }

    private func genericParameters(from genericParameterList: GenericParameterListSyntax?) -> [GenericParameter] {
        genericParameterList?.map { genericParameter in
            GenericParameter(
                name: genericParameter.name.filteredDescription,
                inheritedTypes: inheritedTypes(from: genericParameter.inheritedType?.trimmed)
            )
        } ?? []
    }

    private func genericParameters(from primaryAssociatedTypeList: PrimaryAssociatedTypeListSyntax?) -> [GenericParameter] {
        primaryAssociatedTypeList?.compactMap { associatedType in
            return GenericParameter(
                name: associatedType.name.text,
                inheritedTypes: []
            )
        } ?? []
    }

    private func associatedTypes(from memberList: MemberBlockItemListSyntax) -> [GenericParameter] {
        memberList.compactMap { member in
            guard let associatedType = member.decl.as(AssociatedTypeDeclSyntax.self),
                  case .identifier(let identifier) = associatedType.name.tokenKind else { return nil }

            return GenericParameter(
                name: identifier,
                inheritedTypes: inheritedTypes(from: associatedType.inheritanceClause?.inheritedTypes)
            )
        }
    }

    private func genericRequirements(from genericRequirementList: GenericRequirementListSyntax?) -> [String] {
        genericRequirementList?.map { $0.requirement.filteredDescription } ?? []
    }

    private func inheritedTypes(from inheritedTypesList: InheritedTypeListSyntax?) -> [String] {
        inheritedTypesList?.flatMap { inheritedType -> [String] in
            inheritedTypes(from: inheritedType.type)
        } ?? []
    }

    private func inheritedTypes(from inheritedType: TypeSyntax?) -> [String] {
        guard let inheritedType else { return [] }
        if let compositeType = inheritedType.as(CompositionTypeSyntax.self) {
            return compositeType.elements.compactMap { $0.type.trimmedDescription }
        } else {
            return [inheritedType.trimmedDescription]
        }
    }
}

#if DEBUG
extension Crawler {
    private static let testString =
"""
public struct Prefs {}

public extension Prefs {
enum Key: String {
case blabla
}
}

// DUDE
@objcMembers
class Multi {
//    @available(iOS 42.0, *)
//    var gg: Bool = false

//    @available(*, renamed: "sameInstance(as:)")
//    let g: Bool
//    @available(*, renamed: "sameInstance(as:)")
//    private(set) var geg: Stool

    typealias MyInt = Int
    typealias MyIntGen<Generics> = Int<Generics>

    var didSet: Int = 3 {
        didSet {}
    }

    let constant = 3

    var gg: Dictionary<Int, String>
    var ggwp: Array<String>

    func gg(_ value: Any?, forKey: Prefs.Key) -> Jedna.Dva {}

    func generico<G: APIManager.GraphQLSomething>(plek: inout Enum.Gaga) {}

    func compositionalParameters(param1: any Equatable & Numeric, param2: OnlyLabelProtocol & Codable)

    @objc
    var hammo: Tpikulka!

    var heya: @escaping @convention(block) (_ jenda: Bool, _ dav: Krekr) async throws -> Void
    var heya: (@escaping @convention(block) (_ jenda: Bool, _ dav: Krekr) async throws -> Void)?

    /// Hola mi amor
    /// mamma mia
    var greg: Cruel {
        get {
            greg
        }
        set {
            greg = newValue
        }
    }

    #if DEBUG
    var pravda: Cool {
        thing
    }
    #elseif RELEASE
    var pravda: Cool {
        some
    }
    #endif

    /**
        This is everything you need to know.
    */
    func gaga<G: T>(plek: inout Gaga) {

    }
}

protocol Brek<Crack: Codable> {
    associatedtype plak: Encodable

    var asyncThrowsProperty: Int { get async throws }
    var mutableProperty: Int { get set }

    func drak()
}
"""
}
#endif
