import ProjectDescription

let sharedBase: [String: SettingValue] = [
    "PRODUCT_NAME": .string("Cuckoo"),
    "SYSTEM_FRAMEWORK_SEARCH_PATHS": .string("$(PLATFORM_DIR)/Developer/Library/Frameworks"),
]
let objCBase: [String: SettingValue] = ["SWIFT_OBJC_BRIDGING_HEADER": .string("$(PROJECT_DIR)/OCMock/Cuckoo-BridgingHeader.h")]

let defaultBuildSettings = Settings(base: sharedBase)
let objCBuildSettings = Settings(base: sharedBase.merging(objCBase, uniquingKeysWith: { $1 }))

enum PlatformType: String {
    case iOS
    case macOS
    case tvOS

    var platform: Platform {
        switch self {
        case .iOS:
            return .iOS
        case .macOS:
            return .macOS
        case .tvOS:
            return .tvOS
        }
    }
}

func platformSet(platform: PlatformType, deploymentTarget: DeploymentTarget?) -> (targets: [Target], schemes: [Scheme]) {
    var targets: [Target] = []
    var schemes: [Scheme] = []

    let defaultTarget = Target(
        name: "Cuckoo-\(platform)",
        platform: platform.platform,
        product: .framework,
        bundleId: "org.brightify.Cuckoo",
        deploymentTarget: deploymentTarget,
        infoPlist: .extendingDefault(with: [:]),
        sources: "Source/**",
        settings: defaultBuildSettings
    )
    targets.append(defaultTarget)

    let defaultTestTarget = Target(
        name: "Cuckoo-\(platform)Tests",
        platform: platform.platform,
        product: .unitTests,
        bundleId: "org.brightify.Cuckoo",
        infoPlist: .extendingDefault(with: [:]),
        sources: [
            "Tests/Common/**",
            "Tests/Swift/**",
        ],
        actions: [
            .pre(
                path: "run",
                arguments: [
                    "generate",
                    "--testable",
                    "Cuckoo",
                    "--exclude",
                    "ExcludedTestClass,ExcludedProtocol",
                    "--output",
                    #""$PROJECT_DIR"/Tests/Swift/Generated/GeneratedMocks.swift"#,
                    "--glob",
                    #""$PROJECT_DIR"/Tests/Swift/Source/*.swift"#,
                ],
                name: "Generate Mockinos"
            )
        ],
        dependencies: [
            .target(name: defaultTarget.name)
        ]
    )
    targets.append(defaultTestTarget)

    let defaultScheme = Scheme(
        name: defaultTarget.name,
        buildAction: .init(targets: [.init(stringLiteral: defaultTarget.name)]),
        testAction: .init(targets: [.init(stringLiteral: defaultTestTarget.name)])
    )
    schemes.append(defaultScheme)


    let objCTarget = Target(
        name: "Cuckoo_OCMock-\(platform)",
        platform: platform.platform,
        product: .framework,
        bundleId: "org.brightify.Cuckoo",
        deploymentTarget: deploymentTarget,
        infoPlist: .extendingDefault(with: [:]),
        sources: [
            "Source/**",
            "OCMock/**",
        ],
        headers: .init(private: ["OCMock/**"]),
        dependencies: [
            .cocoapods(path: "."),
            .sdk(name: "OCMock.framework", status: .required),
        ],
        settings: objCBuildSettings
    )
    targets.append(objCTarget)

    let objCTestTarget = Target(
        name: "Cuckoo_OCMock-\(platform)Tests",
        platform: platform.platform,
        product: .unitTests,
        bundleId: "org.brightify.Cuckoo",
        infoPlist: .extendingDefault(with: [:]),
        sources: [
            "Tests/Common/**",
            "Tests/OCMock/**",
        ],
        dependencies: [
            .target(name: objCTarget.name)
        ]
    )
    targets.append(objCTestTarget)

    let objCScheme = Scheme(
        name: objCTarget.name,
        shared: false,
        buildAction: .init(targets: [.init(stringLiteral: objCTarget.name)]),
        testAction: .init(targets: [.init(stringLiteral: objCTestTarget.name)])
    )
    schemes.append(objCScheme)


    return (targets, schemes)
}

let (iOSTargets, iOSSchemes) = platformSet(platform: .iOS, deploymentTarget: .iOS(targetVersion: "8.0", devices: [.iphone, .ipad]))
let (macOSTargets, macOSSchemes) = platformSet(platform: .macOS, deploymentTarget: .macOS(targetVersion: "10.9"))
let (tvOSTargets, tvOSSchemes) = platformSet(platform: .tvOS, deploymentTarget: nil)

// MARK: project definition
let project = Project(
    name: "Cuckoo",
    targets: iOSTargets + macOSTargets + tvOSTargets,
    schemes: iOSSchemes + macOSSchemes + tvOSSchemes,
    additionalFiles: [
        "Scripts/**",
        "Generator/CuckooGenerator.xcodeproj",
    ])
