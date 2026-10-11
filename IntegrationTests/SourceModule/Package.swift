// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SourceModuleRegression",
    platforms: [.macOS(.v13)],
    dependencies: [.package(name: "Cuckoo", path: "../..")],
    targets: [
        .target(name: "OriginalTypes"),
        .target(name: "OtherTypes"),
        .testTarget(
            name: "SourceModuleTests",
            dependencies: ["OriginalTypes", "OtherTypes", .product(name: "Cuckoo", package: "Cuckoo")],
            plugins: [.plugin(name: "CuckooPluginModular", package: "Cuckoo")]
        ),
    ]
)
