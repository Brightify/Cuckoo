import Foundation

public struct Attribute: Hashable {
    public enum Kind: String, Hashable {
        case objc = "source.decl.attribute.objc"
        case optional = "source.decl.attribute.optional"
        case lazy = "source.decl.attribute.lazy"
        case required = "source.decl.attribute.required"
        case override = "source.decl.attribute.override"
        case convenience = "source.decl.attribute.convenience"
        case weak = "source.decl.attribute.weak"
        case ibAction = "source.decl.attribute.ibaction"
        case ibOutlet = "source.decl.attribute.iboutlet"
        case available = "source.decl.attribute.available"
        case final = "source.decl.attribute.final"
    }

    public var kind: Kind
    public var text: String

    public var isSupported: Bool {
        switch (kind) {
        case .objc, .optional, .lazy, .required, .override, .convenience, .weak, .ibAction, .ibOutlet, .final:
            return false
        case .available:
            return true
        }
    }

    public var unavailablePlatform: String? {
        guard kind == .available,
              text.hasPrefix("@available(") else {
            return nil
        }

        let parameters = text
            .dropFirst("@available(".count)
            .dropLast()
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        guard parameters.count >= 2,
              parameters[1] == "unavailable" else {
            return nil
        }

        return String(parameters[0])
    }
}

extension Attribute: Token {
    public func isEqual(to other: Token) -> Bool {
        guard let otherAttribute = other as? Attribute else { return false }
        return self.kind == otherAttribute.kind && self.text == otherAttribute.text
    }

    public func serialize() -> [String : Any] {
        return ["text": text]
    }
}
