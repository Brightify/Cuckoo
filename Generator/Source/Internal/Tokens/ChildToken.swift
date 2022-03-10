import Foundation

public protocol ChildToken: Token {
    var parent: Reference<ParentToken>? { get set }
}
