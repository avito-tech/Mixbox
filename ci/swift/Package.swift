// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "MixboxSwiftCI",
    // TODO: Swift 5.0
//    platforms: [
//        .macOS(.v10_13),
//    ],
    products: [
        .executable(
            name: "RunUnitTestsTask",
            targets: [
                "RunUnitTestsTask"
            ]
        ),
        .executable(
            name: "RunBlackBoxTestsTask",
            targets: [
                "RunBlackBoxTestsTask"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/AliSoftware/Dip", .exact("7.0.0"))
    ],
    targets: [
        .target(
            name: "RunUnitTestsTask",
            dependencies: [
                "BuildDsl"
            ]
        ),
        .target(
            name: "RunBlackBoxTestsTask",
            dependencies: [
                "BuildDsl"
            ]
        ),
        .target(
            name: "BuildDsl",
            dependencies: [
                "Di"
            ]
        ),
        .target(
            name: "Emcee",
            dependencies: [
                "Bash",
                "CiFoundation"
            ]
        ),
        .target(
            name: "Simctl",
            dependencies: [
                "Bash"
            ]
        ),
        .target(
            name: "SingletonHell",
            dependencies: [
                "Dip",
                "Bash",
                "CiFoundation",
                "Tasks",
                "Cocoapods",
                "Git",
                "Simctl",
                "Emcee"
            ]
        ),
        .testTarget(
            name: "SimctlTests",
            dependencies: [
                "Simctl"
            ]
        ),
        .target(
            name: "Bash",
            dependencies: [
                "CiFoundation"
            ]
        ),
        .testTarget(
            name: "BashTests",
            dependencies: [
                "Bash"
            ]
        ),
        .target(
            name: "Tasks",
            dependencies: [
                "CiFoundation"
            ]
        ),
        .target(
            name: "Di",
            dependencies: [
                "Dip",
                "Bash",
                "CiFoundation",
                "Tasks",
                "Cocoapods",
                "Git",
                "Simctl",
                "Emcee",
                "SingletonHell"
            ]
        ),
        .target(
            name: "CiFoundation",
            dependencies: [
            ]
        ),
        .target(
            name: "Git",
            dependencies: [
                "Bash"
            ]
        ),
        .target(
            name: "Cocoapods",
            dependencies: [
                "Bash"
            ]
        )
    ],
    swiftLanguageVersions: [
        // TODO: Swift 5.0
        .v4_2
    ]
)
