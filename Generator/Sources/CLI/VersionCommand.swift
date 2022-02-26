import Foundation
import Commandant
import Result

struct VersionCommand: CommandProtocol {

    static let appVersion = Bundle.allFrameworks.filter {
        $0.bundleIdentifier == "org.brightify.CuckooGeneratorFramework"
    }.first?.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""

    let verb = "version"
    let function = "Prints the version of this generator."

    func run(_ options: Options) -> Result<Void, CuckooGeneratorError> {
        print(VersionCommand.appVersion)
        return .success(())
    }

    struct Options: OptionsProtocol {
        static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<CuckooGeneratorError>> {
            return .success(Options())
        }
    }
}
