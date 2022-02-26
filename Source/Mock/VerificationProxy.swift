public protocol VerificationProxy {
    init(manager: MockManager, callMatcher: CallMatcher, sourceLocation: SourceLocation)
}
