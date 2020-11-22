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
        .package(url: "https://github.com/jpsim/SourceKitten.git", .exact("0.23.1")),
        .package(url: "https://github.com/kylef/PathKit.git", .branch("master")),
        .package(url: "https://github.com/avito-tech/Sourcery.git", .revision("10a8955f07a1dfeb9c9ad40b97fe8f95ff14dc29")),
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
