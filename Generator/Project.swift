import ProjectDescription
import ProjectDescriptionHelpers

let target = Target.target(
    name: "Cuckoonator",
    destinations: .macOS,
    product: .commandLineTool,
    productName: "cuckoonator",
    bundleId: "Cuckoonator",
    deploymentTargets: .macOS("12.0"),
    sources: "Sources/**",
    dependencies: [
        "FileKit",
        "Stencil",
        "SwiftFormat",
        "SwiftSyntax",
        "ArgumentParser",
        "TOMLKit",
        "XcodeProj",
        "Rainbow",
    ].map { TargetDependency.package(product: $0) }
)

let testTarget = Target.target(
    name: "CuckoonatorTests",
    destinations: .macOS,
    product: .unitTests,
    bundleId: "CuckoonatorTests",
    deploymentTargets: target.deploymentTargets,
    sources: SourceFilesList.sourceFilesList(globs: [
        // TODO: This is wrong but testing CLI is not supported, must separate generator into CLI and internal targets.
        target.sources?.globs,
        ["Tests/**"],
    ].compactMap { $0 }.flatMap { $0 }),
    // TODO: This is wrong but testing CLI is not supported, must separate generator into CLI and internal targets.
    dependencies: target.dependencies
)

// MARK: project definition
let project = Project(
    name: "Generator",
    options: .options(automaticSchemesOptions: .disabled, disableSynthesizedResourceAccessors: true),
    packages: [
        // Any dependency changes must also be reflected in ../Package.swift.
        .package(url: "https://github.com/nvzqz/FileKit.git", from: "6.1.0"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.15.1"),
        .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"602.0.0"),
        .package(url: "https://github.com/swiftlang/swift-format", "509.0.0"..<"602.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
        .package(url: "https://github.com/LebJe/TOMLKit.git", from: "0.5.5"),
        .package(url: "https://github.com/tuist/XcodeProj.git", from: "8.15.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
    ],
    targets: [
        target,
        testTarget,
    ],
    schemes: [
        Scheme.scheme(
            name: "Generator",
            buildAction: BuildAction.buildAction(
                targets: ["Cuckoonator"],
                postActions: [
                    ExecutionAction.executionAction(
                        title: "Copy executable",
                        scriptText: #"\cp "$BUILT_PRODUCTS_DIR/$EXECUTABLE_NAME" "$PROJECT_DIR/bin/cuckoonator""#,
                        target: "Cuckoonator"
                    )
                ],
                runPostActionsOnFailure: false
            ),
            testAction: TestAction.targets([TestableTarget.testableTarget(target: testTarget.reference)]),
            runAction: RunAction.runAction(
                executable: "Cuckoonator",
                arguments: Arguments.arguments(
                    environmentVariables: [
                        "PROJECT_DIR": Environment.projectDir.requireString(message: "TUIST_PROJECT_DIR environment property is required."),
                    ],
                    launchArguments: [
                        // Any changes here should be reflected in `../Project.swift` as well.
                        LaunchArgument.launchArgument(name: "--configuration ./Cuckoofile", isEnabled: true),
                        LaunchArgument.launchArgument(name: "--verbose", isEnabled: true),
                    ]
                )
            )
        ),
    ]
)
