import Foundation

extension MockManager {
    nonisolated(unsafe) internal static let preconfiguredManagerThreadLocal = ThreadLocal<MockManager>()

    public static var preconfiguredManager: MockManager? {
        preconfiguredManagerThreadLocal.value
    }
}
