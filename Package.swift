// swift-tools-version:5.2

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
        .package(url: "https://github.com/jpsim/SourceKitten.git", .exact("0.23.1")),
        .package(url: "https://github.com/kylef/PathKit.git", .branch("master")),
        .package(url: "https://github.com/krzysztofzablocki/Sourcery.git", .exact("1.0.0"))
    ],
    targets: [
        .target(
            name: "MixboxMocksGeneration",
            dependencies: [
                "PathKit",
                .product(name: "SourceryFramework", package: "Sourcery"),
                .product(name: "SourceryRuntime", package: "Sourcery")
            ],
            path: "Frameworks/MocksGeneration"
        ),
        .target(
            name: "MixboxMocksGenerator",
            dependencies: [
                "MixboxMocksGeneration"
            ],
            path: "MocksGenerator"
        )
    ]
)
