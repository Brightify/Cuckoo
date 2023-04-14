import ProjectDescription

public enum PlatformType: String {
    case iOS
    case macOS
    case tvOS

    public var platform: Platform {
        switch self {
        case .iOS:
            return .iOS
        case .macOS:
            return .macOS
        case .tvOS:
            return .tvOS
        }
    }

    public var libraryDeploymentTarget: DeploymentTarget {
        switch self {
        case .iOS:
            return .iOS(targetVersion: "11.0", devices: [.iphone, .ipad])
        case .macOS:
            return .macOS(targetVersion: "10.13")
        case .tvOS:
            return .tvOS(targetVersion: "11.0")
        }
    }

    public var testDeploymentTarget: DeploymentTarget {
        switch self {
        case .iOS:
            return .iOS(targetVersion: "13.0", devices: [.iphone, .ipad])
        case .macOS:
            return .macOS(targetVersion: "10.15")
        case .tvOS:
            return .tvOS(targetVersion: "13.0")
        }
    }
}
