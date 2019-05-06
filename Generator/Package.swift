// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "CuckooGenerator",
    products: [
        .library(name: "CuckooGeneratorFramework", targets:["CuckooGeneratorFramework", "cuckoo_generator"]),
        .executable(name: "cuckoo_generator", targets: ["cuckoo_generator"])

    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", .upToNextMinor(from: "0.21.2")),
        .package(url: "https://github.com/nvzqz/FileKit.git", .branch("develop")),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.13.1"),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.12.0")
        ],
    targets: [
        .target(name: "CuckooGeneratorFramework", dependencies: [
            "FileKit", "SourceKittenFramework", "Stencil", "Commandant"], exclude: ["Tests"]),

        .target(name: "cuckoo_generator", dependencies: [
            .target(name: "CuckooGeneratorFramework")], exclude: ["Tests"]),
        ]
)
