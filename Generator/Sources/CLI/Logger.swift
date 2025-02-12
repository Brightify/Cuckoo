import Foundation

final class Logger {
    enum LogLevel: Comparable {
        case verbose
        case info
        case error
    }

    nonisolated(unsafe) static let shared = Logger()

    var logLevel: LogLevel = .info

    private init() {}

    func log(_ level: LogLevel, message: [Any], separator: String = " ") {
        if level >= logLevel {
            print(message.map(String.init(describing:)).joined(separator: separator))
        }
    }
}

func log(_ level: Logger.LogLevel, message: Any...) {
    Logger.shared.log(level, message: message)
}
