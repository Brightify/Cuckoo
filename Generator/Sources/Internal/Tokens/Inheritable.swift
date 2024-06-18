import Foundation

protocol Inheritable {
    // Support to dynamically define whether the token is inheritable or not.
    var isInheritable: Bool { get }

    func isEqual(to other: Inheritable) -> Bool
}

extension Inheritable {
    var isInheritable: Bool { true }
}
