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
        .package(url: "https://github.com/avito-tech/Sourcery.git", .revision("4f311aca6c474ee93cac3186399089dc18fc12bd")),
    ],
    targets: [
        .target(
            // MARK: MixboxMocksGeneration
            name: "MixboxMocksGeneration",
            dependencies: [
                "PathKit",
                .product(name: "SourceryFramework", package: "Sourcery"),
                .product(name: "SourceryRuntime", package: "Sourcery"),
            ],
            path: "Frameworks/MocksGeneration/Sources"
        ),
        .target(
            // MARK: MixboxMocksGenerator
            name: "MixboxMocksGenerator",
            dependencies: [
                "MixboxMocksGeneration",
                "PathKit",
            ],
            path: "MocksGenerator/Sources"
        ),
    ]
)
