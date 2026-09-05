protocol ActorProtocol: Actor {
    var value: Int { get set }

    func increment()

    func fetchRemoteValue() async -> Int
}

protocol ChildActorProtocol: ActorProtocol {
    func childMethod()
}
