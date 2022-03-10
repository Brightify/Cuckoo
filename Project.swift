import ProjectDescription
import ProjectDescriptionHelpers

let commonBuildSettingsBase: [String: SettingValue] = [
    "PRODUCT_NAME": .string("Cuckoo"),
    "SYSTEM_FRAMEWORK_SEARCH_PATHS": .string("$(PLATFORM_DIR)/Developer/Library/Frameworks"),
]
let objCBuildSettingsBase: [String: SettingValue] = [
    "SWIFT_OBJC_BRIDGING_HEADER": .string("$(PROJECT_DIR)/OCMock/Cuckoo-BridgingHeader.h"),
]

let defaultBuildSettings = Settings.settings(base: commonBuildSettingsBase)
let objCBuildSettings = Settings.settings(base: commonBuildSettingsBase.merging(objCBuildSettingsBase, uniquingKeysWith: { $1 }))

func platformSet(platform: PlatformType) -> (targets: [Target], schemes: [Scheme]) {
    var targets: [Target] = []
    var schemes: [Scheme] = []

    // MARK: Swift targets.
    let defaultTarget = Target(
        name: "Cuckoo-\(platform)",
        platform: platform.platform,
        product: .framework,
        bundleId: "org.brightify.Cuckoo",
        deploymentTarget: platform.libraryDeploymentTarget,
        infoPlist: .default,
        sources: "Source/**",
        dependencies: [
            .sdk(name: "XCTest", type: .framework, status: .required),
        ],
        settings: defaultBuildSettings
    )
    targets.append(defaultTarget)

    let defaultTestTarget = Target(
        name: "Cuckoo-\(platform)Tests",
        platform: platform.platform,
        product: .unitTests,
        bundleId: "org.brightify.Cuckoo",
        deploymentTarget: platform.testDeploymentTarget,
        infoPlist: .default,
        sources: [
            "Tests/Common/**",
            "Tests/Swift/**",
        ],
        scripts: [
            .pre(
                // Any changes in the mock generation phase should be reflected in `Generator/Project.swift` as well.
                script: """
                if [ "$GENERATE_TEST_MOCKS" = "NO" ] ; then exit; fi

                # Make sure the generator is up-to-date.
                echo 'Building generator.'
                "$PROJECT_DIR"/build_generator

                echo 'Generating mocks.'
                \([
                    #""$PROJECT_DIR"/Generator/bin/cuckoo_generator generate"#,
                    "--testable Cuckoo",
                    "--exclude ExcludedTestClass,ExcludedProtocol",
                    #"--output "$PROJECT_DIR"/Tests/Swift/Generated/GeneratedMocks.swift"#,
                    #"--glob "$PROJECT_DIR"/Tests/Swift/Source/*.swift"#,
                ].joined(separator: " \\\n\t"))
                """,
                name: "Generate mocks",
                basedOnDependencyAnalysis: false
            ),
        ],
        dependencies: [
            .target(name: defaultTarget.name),
        ]
    )
    targets.append(defaultTestTarget)

    // MARK: ObjC targets.
    let objCTarget = Target(
        name: "Cuckoo_OCMock-\(platform)",
        platform: platform.platform,
        product: .framework,
        bundleId: "org.brightify.Cuckoo",
        deploymentTarget: platform.libraryDeploymentTarget,
        infoPlist: .default,
        sources: [
            "Source/**",
            "OCMock/**",
        ],
        headers: .headers(public: ["OCMock/**"]),
        dependencies: [
            .sdk(name: "XCTest", type: .framework, status: .required),
        ],
        settings: objCBuildSettings
    )
    targets.append(objCTarget)

    let objCTestTarget = Target(
        name: "Cuckoo_OCMock-\(platform)Tests",
        platform: platform.platform,
        product: .unitTests,
        bundleId: "org.brightify.Cuckoo",
        deploymentTarget: platform.testDeploymentTarget,
        infoPlist: .default,
        sources: [
            "Tests/Common/**",
            "Tests/OCMock/**",
        ],
        dependencies: [
            .target(name: objCTarget.name),
        ]
    )
    targets.append(objCTestTarget)

    // MARK: Schemes.
    schemes.append(
        Scheme(
            name: defaultTarget.name,
            buildAction: BuildAction.buildAction(targets: [defaultTarget.reference]),
            testAction: TestAction.targets([.init(target: defaultTestTarget.reference)])
        )
    )

    schemes.append(
        Scheme(
            name: objCTarget.name,
            shared: false,
            buildAction: .init(targets: [.init(stringLiteral: objCTarget.name)]),
            testAction: TestAction.targets([.init(target: objCTestTarget.reference)])
        )
    )

    return (targets, schemes)
}

let (iOSTargets, iOSSchemes) = platformSet(platform: .iOS)
let (macOSTargets, macOSSchemes) = platformSet(platform: .macOS)
let (tvOSTargets, tvOSSchemes) = platformSet(platform: .tvOS)

// MARK: project definition
let project = Project(
    name: "Cuckoo",
    options: .options(automaticSchemesOptions: .disabled, disableSynthesizedResourceAccessors: true),
    packages: [
        // .remote(url: "https://github.com/erikdoe/ocmock", .revision("21cce26d223d49a9ab5ae47f28864f422bfe3951")),
    ],
    settings: Settings.settings(base: ["GENERATE_TEST_MOCKS": "YES"]),
    targets: iOSTargets + macOSTargets + tvOSTargets,
    schemes: iOSSchemes + macOSSchemes + tvOSSchemes
)
