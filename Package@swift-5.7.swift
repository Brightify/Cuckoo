// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Cuckoo",
    platforms: [.macOS("12.0")],
    products: [
        .library(
            name: "Cuckoo",
            targets: ["Cuckoo"]
        ),
        .plugin(
            name: "CuckooPlugin",
            targets: ["CuckooPlugin"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", .upToNextMinor(from: "0.34.1")),
        .package(url: "https://github.com/nvzqz/FileKit.git", branch: "develop"),
        .package(url: "https://github.com/kylef/Stencil.git", exact: "0.14.2"),
        .package(url: "https://github.com/Carthage/Commandant.git", exact: "0.15.0"),
    ],
    targets: [
        .executableTarget(
            name: "CuckooGenerator",
            dependencies: [
                .product(name: "SourceKittenFramework", package: "SourceKitten"),
                .product(name: "FileKit", package: "FileKit"),
                .product(name: "Stencil", package: "Stencil"),
                .product(name: "Commandant", package: "Commandant"),
            ],
            path: "Generator/Source"
        ),
        .plugin(
            name: "CuckooPlugin",
            capability: .buildTool(),
            dependencies: ["CuckooGenerator"],
            path: "Generator/Plugin"
        ),
        .target(
            name: "Cuckoo",
            dependencies: [],
            path: "Source"
        ),
        .testTarget(
            name: "CuckooTests",
            dependencies: ["Cuckoo"],
            path: "Tests"
        ),
    ]
)
