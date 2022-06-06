import Foundation

protocol ProtocolWithUnavailablePlatformMembers {
    @available(tvOS, unavailable)
    var unavailableProperty: Int { get }

    @available(tvOS, unavailable)
    @available(macCatalyst, unavailable)
    var multiUnavailableProperty: Int { get }

    var availableProperty: Bool { get }

    @available(tvOS, unavailable)
    init(unavailableProperty: Int, multiUnavailableProperty: Int)

    @available(tvOS, unavailable)
    @available(macCatalyst, unavailable)
    init(multiUnavailableProperty: Int)

    @available(iOS, unavailable)
    init()

    @available(tvOS, unavailable)
    func unavailableMethod() -> Int

    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    func multiUnavailableMethod() -> Int

    func availableMethod() -> Bool
}
