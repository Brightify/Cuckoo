import Foundation

@available(tvOS, unavailable)
protocol UnavailablePlatformProtocol {
    @available(tvOS, unavailable)
    var unavailableProperty: Int { get set}

    var availableProperty: Bool { get }
}
