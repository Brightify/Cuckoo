import ProjectDescription
import ProjectDescriptionHelpers

let commonBuildSettingsBase: [String: SettingValue] = [
    "PRODUCT_NAME": .string("Cuckoo"),
    "SYSTEM_FRAMEWORK_SEARCH_PATHS": .string("$(PLATFORM_DIR)/Developer/Library/Frameworks"),
]
let mocksBuildSettingsBase: [String: SettingValue] = [
    "PRODUCT_NAME": .string("CuckooMocks"),
    "SYSTEM_FRAMEWORK_SEARCH_PATHS": .string("$(PLATFORM_DIR)/Developer/Library/Frameworks"),
]
// let objCBuildSettingsBase: [String: SettingValue] = [
//     "SWIFT_OBJC_BRIDGING_HEADER": .string("$(PROJECT_DIR)/OCMock/Cuckoo-BridgingHeader.h"),
// ]

func platformSet(platform: PlatformType) -> (targets: [Target], schemes: [Scheme]) {
    var targets: [Target] = []
    var schemes: [Scheme] = []

    // MARK: Swift targets.
    let defaultTarget = Target.target(
        name: "Cuckoo-\(platform)",
        destinations: platform.destinations,
        product: .framework,
        bundleId: "org.brightify.Cuckoo",
        deploymentTargets: platform.deploymentTargets,
        infoPlist: .default,
        sources: [
            "Source/**",
            // "OCMock/**",
        ],
        // headers: .headers(public: ["OCMock/**"]),
        dependencies: [
            .sdk(name: "XCTest", type: .framework, status: .optional),
            // .package(product: "OCMock"),
        ],
        settings: Settings.settings(base: commonBuildSettingsBase)
    )
    targets.append(defaultTarget)

    let mocksTarget = Target.target(
        name: "Cuckoo-\(platform)Tests-Mocks",
        destinations: platform.destinations,
        product: .framework,
        bundleId: "org.brightify.Cuckoo",
        deploymentTargets: platform.deploymentTargets,
        infoPlist: .default,
        sources: [
            "Tests/Swift/Generated/*.swift",
            "Tests/Swift/Source/*.swift",
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
                    #""$PROJECT_DIR"/Generator/bin/cuckoonator"#,
                    "--verbose",
                ].joined(separator: " \\\n\t"))
                """,
                name: "Generate mocks",
                basedOnDependencyAnalysis: false
            ),
        ],
        dependencies: [
            .target(defaultTarget),
            .sdk(name: "XCTest", type: .framework, status: .optional),
        ],
        settings: Settings.settings(base: mocksBuildSettingsBase)
    )
    targets.append(mocksTarget)

    let defaultTestTarget = Target.target(
        name: "Cuckoo-\(platform)Tests",
        destinations: platform.destinations,
        product: .unitTests,
        bundleId: "org.brightify.Cuckoo",
        deploymentTargets: platform.deploymentTargets,
        infoPlist: .default,
        sources: SourceFilesList.sourceFilesList(globs: [
            .glob("Tests/Common/**"),
            // .glob("Tests/OCMock/**"),
            .glob("Tests/Swift/**", excluding: [
                "Tests/Swift/Generated/*.swift",
                "Tests/Swift/Source/*.swift",
            ]),
        ]),
        dependencies: [
            .target(defaultTarget),
            .target(mocksTarget),
            // .package(product: "OCMock"),
        ]
    )
    targets.append(defaultTestTarget)

    // MARK: Schemes.
    schemes.append(
        Scheme.scheme(
            name: defaultTarget.name,
            buildAction: BuildAction.buildAction(targets: [defaultTarget.reference, mocksTarget.reference]),
            testAction: TestAction.targets([TestableTarget.testableTarget(target: defaultTestTarget.reference)])
        )
    )

    return (targets, schemes)
}

let (iOSTargets, iOSSchemes) = platformSet(platform: .iOS)
let (macOSTargets, macOSSchemes) = platformSet(platform: .macOS)
let (tvOSTargets, tvOSSchemes) = platformSet(platform: .tvOS)
let (watchOSTargets, watchOSSchemes) = platformSet(platform: .watchOS)

// MARK: project definition
let project = Project(
    name: "Cuckoo",
    options: .options(automaticSchemesOptions: .disabled, disableSynthesizedResourceAccessors: true),
    packages: [
        // .local(path: "OCMockWrapper"),
    ],
    settings: Settings.settings(base: ["GENERATE_TEST_MOCKS": "YES"]),
    targets: iOSTargets + macOSTargets + tvOSTargets + watchOSTargets,
    schemes: iOSSchemes + macOSSchemes + tvOSSchemes + watchOSSchemes
)
