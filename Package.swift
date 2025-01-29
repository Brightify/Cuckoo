// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Cuckoo",
    platforms: [
        .iOS("13.0"),
        .tvOS("13.0"),
        .macOS("10.15"),
        .watchOS("8.0"),
    ],
    products: [
        .library(
            name: "Cuckoo",
            targets: ["Cuckoo"]
        ),
        .plugin(
            name: "CuckooPluginSingleFile",
            targets: ["CuckooPluginSingleFile"]
        ),
        // FIXME: Currently unusable because Xcode doesn't allow using prebuild commands with executable targets
        // .plugin(
        //     name: "CuckooPluginIndividualFiles",
        //     targets: ["CuckooPluginIndividualFiles"]
        // ),
    ],
    dependencies: [
        // Any dependency changes must also be reflected in Generator/Project.swift.
        .package(url: "https://github.com/nvzqz/FileKit.git", exact: "6.1.0"),
        .package(url: "https://github.com/kylef/Stencil.git", exact: "0.15.1"),
        .package(url: "https://github.com/apple/swift-syntax.git", exact: "509.0.0"),
        .package(url: "https://github.com/apple/swift-format.git", exact: "509.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.2.3"),
        .package(url: "https://github.com/LebJe/TOMLKit.git", exact: "0.5.5"),
        .package(url: "https://github.com/tuist/XcodeProj.git", exact: "8.15.0"),
        .package(url: "https://github.com/onevcat/Rainbow", exact: "4.0.1"),
        .package(path: "./OCMockWrapper"),
    ],
    targets: [
        .target(
            name: "Cuckoo",
            dependencies: ["OCMockWrapper"],
            path: "Source",
            swiftSettings: [
                .unsafeFlags(["-enable-library-evolution"]),
            ]
        ),
        .testTarget(
            name: "CuckooTests",
            dependencies: ["Cuckoo", "OCMockWrapper"],
            path: "Tests"
        ),
        .executableTarget(
            name: "CuckooGenerator",
            dependencies: [
                .product(name: "FileKit", package: "FileKit"),
                .product(name: "Stencil", package: "Stencil"),
                .product(name: "SwiftFormat", package: "swift-format"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "TOMLKit", package: "TOMLKit"),
                .product(name: "XcodeProj", package: "XcodeProj"),
                .product(name: "Rainbow", package: "Rainbow"),
            ],
            path: "Generator/Sources"
        ),
        .plugin(
            name: "CuckooPluginSingleFile",
            capability: .buildTool(),
            dependencies: ["CuckooGenerator"],
            path: "Generator/Plugin/File"
        ),
        // .plugin(
        //     name: "CuckooPluginIndividualFiles",
        //     capability: .buildTool(),
        //     dependencies: ["CuckooGenerator"],
        //     path: "Generator/Plugin/Directory"
        // ),
    ]
)
