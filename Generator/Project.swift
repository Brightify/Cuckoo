import ProjectDescription
import ProjectDescriptionHelpers

let target = Target(
    name: "Cuckoonator",
    platform: .macOS,
    product: .commandLineTool,
    productName: "cuckoonator",
    bundleId: "Cuckoonator",
    deploymentTarget: .macOS(targetVersion: "12.0"),
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
    ].map(TargetDependency.package(product:))
)

let testTarget = Target(
    name: "CuckoonatorTests",
    platform: .macOS,
    product: .unitTests,
    bundleId: "CuckoonatorTests",
    deploymentTarget: target.deploymentTarget,
    sources: SourceFilesList(globs: [
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
        .package(url: "https://github.com/nvzqz/FileKit.git", .exact("6.1.0")),
        .package(url: "https://github.com/kylef/Stencil.git", .exact("0.15.1")),
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("509.0.0")),
        .package(url: "https://github.com/apple/swift-format.git", .exact("509.0.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", .exact("1.2.3")),
        .package(url: "https://github.com/LebJe/TOMLKit.git", .exact("0.5.5")),
        .package(url: "https://github.com/tuist/XcodeProj.git", .exact("8.15.0")),
        .package(url: "https://github.com/onevcat/Rainbow", .exact("4.0.1")),
    ],
    targets: [
        target,
        testTarget,
    ],
    schemes: [
        Scheme(
            name: "Generator",
            buildAction: BuildAction.buildAction(
                targets: ["Cuckoonator"],
                postActions: [
                    ExecutionAction(
                        title: "Copy executable",
                        scriptText: #"\cp "$BUILT_PRODUCTS_DIR/$EXECUTABLE_NAME" "$PROJECT_DIR/bin/cuckoonator""#,
                        target: "Cuckoonator"
                    )
                ],
                runPostActionsOnFailure: false
            ),
            testAction: TestAction.targets([TestableTarget(target: testTarget.reference)]),
            runAction: RunAction.runAction(
                executable: "Cuckoonator",
                arguments: Arguments(
                    environment: [
                        "PROJECT_DIR": Environment.projectDir.requireString(message: "TUIST_PROJECT_DIR environment property is required."),
                    ],
                    launchArguments: [
                        // Any changes here should be reflected in `../Project.swift` as well.
                        LaunchArgument(name: "--configuration ./Cuckoofile", isEnabled: true),
                        LaunchArgument(name: "--verbose", isEnabled: true),
                    ]
                )
            )
        ),
    ]
)
