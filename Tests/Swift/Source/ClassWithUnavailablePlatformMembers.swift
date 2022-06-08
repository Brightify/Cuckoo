import Foundation

class ClassWithUnavailablePlatformMembers {
    @available(tvOS, unavailable)
    var unavailableProperty: Int = 0

    @available(tvOS, unavailable)
    @available(macCatalyst, unavailable)
    var multiUnavailableProperty: Int = 1

    var availableProperty: Bool = false

    @available(tvOS, unavailable)
    init(unavailableProperty: Int, multiUnavailableProperty: Int) {
        self.unavailableProperty = unavailableProperty
        self.multiUnavailableProperty = multiUnavailableProperty
    }

    @available(tvOS, unavailable)
    @available(macCatalyst, unavailable)
    init(multiUnavailableProperty: Int) {
        self.unavailableProperty = 0
        self.multiUnavailableProperty = multiUnavailableProperty
    }

    @available(iOS, unavailable)
    init() {}

    @available(tvOS, unavailable)
    func unavailableMethod() -> Int {
        unavailableProperty
    }

    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    func multiUnavailableMethod() -> Int {
        multiUnavailableProperty
    }

    func availableMethod() -> Bool {
        availableProperty
    }
}
