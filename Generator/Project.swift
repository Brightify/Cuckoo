import ProjectDescription
import ProjectDescriptionHelpers

// MARK: project definition
let project = Project(
    name: "Generator",
    options: .options(automaticSchemesOptions: .disabled, disableSynthesizedResourceAccessors: true),
    packages: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", .upToNextMinor(from: "0.21.2")),
        .package(url: "https://github.com/nvzqz/FileKit.git", .branch("develop")),
        .package(url: "https://github.com/kylef/Stencil.git", .exact("0.14.2")),
        .package(url: "https://github.com/Carthage/Commandant.git", .exact("0.15.0")),
    ],
    targets: [
        Target(
            name: "CuckooGenerator",
            platform: .macOS,
            product: .commandLineTool,
            productName: "cuckoo_generator",
            bundleId: "CuckooGenerator",
            deploymentTarget: DeploymentTarget.macOS(targetVersion: "10.13"),
            sources: "Source/**",
            dependencies: ["FileKit", "SourceKittenFramework", "Stencil", "Commandant"].map(TargetDependency.package(product:))
        ),
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
