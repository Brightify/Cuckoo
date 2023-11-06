import ProjectDescription
import ProjectDescriptionHelpers

let target = Target(
    name: "CuckooGenerator",
    platform: .macOS,
    product: .commandLineTool,
    productName: "cuckoo_generator",
    bundleId: "CuckooGenerator",
    deploymentTarget: .macOS(targetVersion: "10.15"),
    sources: "Sources/**",
    dependencies: [
        "FileKit",
        "Stencil",
        "SwiftFormat",
        "SwiftSyntax",
        "ArgumentParser",
        "TOMLKit",
    ].map(TargetDependency.package(product:))
)

let testTarget = Target(
    name: "GeneratorTests",
    platform: .macOS,
    product: .unitTests,
    bundleId: "CuckooGeneratorTests",
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
        .package(url: "https://github.com/nvzqz/FileKit.git", .exact("6.1.0")),
        .package(url: "https://github.com/kylef/Stencil.git", .exact("0.15.1")),
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("509.0.0")),
        .package(url: "https://github.com/apple/swift-format.git", .exact("509.0.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", .exact("1.2.3")),
        .package(url: "https://github.com/LebJe/TOMLKit.git", .exact("0.5.5")),
    ],
    targets: [
        target,
        testTarget,
    ],
    schemes: [
        Scheme(
            name: "Generator",
            buildAction: BuildAction.buildAction(
                targets: ["CuckooGenerator"],
                postActions: [
                    ExecutionAction(
                        title: "Copy executable",
                        scriptText: #"\cp "$BUILT_PRODUCTS_DIR/$EXECUTABLE_NAME" "$PROJECT_DIR/bin/cuckoo_generator""#,
                        target: "CuckooGenerator"
                    )
                ],
                runPostActionsOnFailure: false
            ),
            testAction: TestAction.targets([TestableTarget(target: testTarget.reference)]),
            runAction: RunAction.runAction(
                executable: "CuckooGenerator",
                arguments: Arguments(
                    launchArguments: [
                        // Any changes here should be reflected in `../Project.swift` as well.
                        LaunchArgument(name: "generate", isEnabled: true),
                        LaunchArgument(name: "--testable Cuckoo", isEnabled: true),
                        LaunchArgument(name: "--exclude ExcludedTestClass,ExcludedProtocol", isEnabled: true),
                        LaunchArgument(name: #"--output "$PROJECT_DIR"/GeneratedMocks.swift"#, isEnabled: true),
                        // This is the input file(s) glob.
                        LaunchArgument(name: #"--glob "$PROJECT_DIR"/../Tests/Swift/Source/*.swift"#, isEnabled: true),
                    ]
                )
            )
        ),
    ]
)
