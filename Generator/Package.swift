import PackageDescription

let package = Package(
    name: "CuckooGenerator",
    targets: [
        Target(name: "CuckooGeneratorFramework"),
        Target(name: "cuckoo_generator", dependencies: [
            .Target(name: "CuckooGeneratorFramework")])
    ],
    dependencies: [
        .Package(url: "https://github.com/jpsim/SourceKitten.git", versions: Version(0, 15, 0)..<Version(0, 17, .max)),
        .Package(url: "https://github.com/TadeasKriz/FileKit.git", Version(4, 0, 1))
    ],
    exclude: [
        "Tests"
    ]
)
