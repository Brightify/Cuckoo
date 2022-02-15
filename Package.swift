// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Cuckoo",
    products: [
        .library(
            name: "Cuckoo",
            targets: ["Cuckoo"]),
        .library(
            name: "Cuckoo_OCMock",
            targets: ["Cuckoo", "Cuckoo_OCMock"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/erikdoe/ocmock",
            .revisionItem("afd2c6924e8a36cb872bc475248b978f743c6050")
        )
    ],
    targets: [
        .target(
            name: "Cuckoo",
            dependencies: [],
            path: "Source"),
        .target(
            name: "Cuckoo_OCMock-Objc",
            dependencies: ["OCMock"],
            path: "OCMock/ObjCHelpers",
            publicHeadersPath: "."),
        .target(
            name: "Cuckoo_OCMock",
            dependencies: ["Cuckoo", "Cuckoo_OCMock-Objc"],
            path: "OCMock/Swift"),
        .testTarget(
            name: "CuckooTests",
            dependencies: ["Cuckoo"],
            path: "Tests"),
    ]
)
