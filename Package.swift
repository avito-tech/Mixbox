// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Mixbox",
    products: [
        .library(name: "MixboxAnyCodable", targets: [ "MixboxAnyCodable" ])
    ],
    targets: [
        .target(
            name: "MixboxAnyCodable",
            dependencies: [],
            path: "Frameworks/AnyCodable",
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES")
            ]
        )
    ]
)
