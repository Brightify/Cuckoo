import Foundation

extension MockManager {
    internal static let preconfiguredManagerThreadLocal = ThreadLocal<MockManager>()

    public static var preconfiguredManager: MockManager? {
        preconfiguredManagerThreadLocal.value
    }
}
