// swift-tools-version:5.2

// swiftlint:disable all

import PackageDescription

let package = Package(
    name: "Mixbox",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "MixboxMocksGeneration",
            targets: [
                "MixboxMocksGeneration"
            ]
        ),
        .executable(
            name: "MixboxMocksGenerator",
            targets: [
                "MixboxMocksGenerator"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", .exact("0.30.1")),
        .package(url: "https://github.com/kylef/PathKit.git", .branch("master")),
        <__SOURCERY_PACKAGE__>
    ],
    targets: [
<__TARGETS__>
    ]
)
