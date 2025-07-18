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
        .package(url: "https://github.com/nvzqz/FileKit.git", from: "6.1.0"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.15.1"),
        .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"603.0.0"),
        // .package(url: "https://github.com/swiftlang/swift-format", "509.0.0"..<"602.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
        .package(url: "https://github.com/LebJe/TOMLKit.git", from: "0.5.5"),
        .package(url: "https://github.com/tuist/XcodeProj.git", from: "8.15.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
    ],
    targets: [
        .target(
            name: "Cuckoo",
            path: "Source"
        ),
        .testTarget(
            name: "CuckooTests",
            dependencies: ["Cuckoo"],
            path: "Tests"
        ),
        .executableTarget(
            name: "CuckooGenerator",
            dependencies: [
                .product(name: "FileKit", package: "FileKit"),
                .product(name: "Stencil", package: "Stencil"),
                // .product(name: "SwiftFormat", package: "swift-format"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
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
