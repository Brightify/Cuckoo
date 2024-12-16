// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OCMockWrapper",
    products: [
        .library(name: "OCMockWrapper", targets: ["OCMockWrapper"])
    ],
    dependencies: [
        .package(name: "OCMock", url: "https://github.com/erikdoe/ocmock.git", .revision("2c0bfd373289f4a7716db5d6db471640f91a6507"))
    ],
    targets: [
        .target(name: "OCMockWrapper", dependencies: [
            .product(name: "OCMock", package: "OCMock")
        ])
    ]
)
