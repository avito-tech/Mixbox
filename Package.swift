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
        .library(
            name: "MixboxDi",
            targets: [
                "MixboxDi"
            ]
        ),
        .library(
            name: "MixboxBuiltinDi",
            targets: [
                "MixboxBuiltinDi"
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
        .package(url: "https://github.com/avito-tech/Sourcery.git", .revision("0564feccdc8fade6c68376bdf7f8dab9b79863fe")),
    ],
    targets: [
        .target(
            // MARK: MixboxBuiltinDi
            name: "MixboxBuiltinDi",
            dependencies: [
                "MixboxDi"
            ],
            path: "Frameworks/BuiltinDi/Sources",
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES")
            ]
        ),
        .target(
            // MARK: MixboxDi
            name: "MixboxDi",
            dependencies: [
                
            ],
            path: "Frameworks/Di/Sources",
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES")
            ]
        ),
        .target(
            // MARK: MixboxMocksGeneration
            name: "MixboxMocksGeneration",
            dependencies: [
                "PathKit",
                .product(name: "SourceryFramework", package: "Sourcery"),
                .product(name: "SourceryRuntime", package: "Sourcery")
            ],
            path: "Frameworks/MocksGeneration/Sources"
        ),
        .target(
            // MARK: MixboxMocksGenerator
            name: "MixboxMocksGenerator",
            dependencies: [
                "MixboxMocksGeneration",
                "PathKit"
            ],
            path: "MocksGenerator/Sources"
        )
    ]
)
