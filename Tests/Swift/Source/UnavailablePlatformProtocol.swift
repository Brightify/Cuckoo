import Foundation

@available(tvOS, unavailable)
protocol UnavailablePlatformProtocol {
    var availableProperty: Bool { get }
}

protocol ProtocolWithUnavailablePlatformMembers {
    @available(tvOS, unavailable)
    var unavailableProperty: Int { get }

    @available(tvOS, unavailable)
    @available(macCatalyst, unavailable)
    var multiUnavailableProperty: Int { get }

    var availableProperty: Bool { get }

    @available(tvOS, unavailable)
    init(unavailableProperty: Int)

    @available(tvOS, unavailable)
    func unavailableMethod() -> Int

    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    func multiUnavailableMethod() -> Int

    func availableMethod() -> Bool
}
