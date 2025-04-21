import ProjectDescription

public enum PlatformType: String {
    case iOS
    case macOS
    case tvOS
    case watchOS

    public var destinations: Destinations {
        switch self {
        case .iOS:
            return [.iPhone, .iPad]
        case .macOS:
            return [.mac]
        case .tvOS:
            return [.appleTv]
        case .watchOS:
            return [.appleWatch]
        }
    }

    public var deploymentTargets: DeploymentTargets {
        switch self {
        case .iOS:
            return .iOS("13.0")
        case .macOS:
            return .macOS("10.15")
        case .tvOS:
            return .tvOS("13.0")
        case .watchOS:
            return .watchOS("8.0")
        }
    }
}
