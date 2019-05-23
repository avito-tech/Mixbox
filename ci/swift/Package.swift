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
        ),
        .executable(
            name: "RunGrayBoxTestsTask",
            targets: [
                "RunGrayBoxTestsTask"
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
            name: "RunGrayBoxTestsTask",
            dependencies: [
                "BuildDsl"
            ]
        ),
        .target(
            name: "Brew",
            dependencies: [
                "Bash"
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
                "CiFoundation",
                "Brew"
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
            name: "AllTests",
            dependencies: [
                "BuildDsl" // everything
            ]
        ),
        .target(
            name: "Bash",
            dependencies: [
                "CiFoundation"
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
                "SingletonHell",
                "Brew"
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
