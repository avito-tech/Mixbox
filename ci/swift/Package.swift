// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "MixboxSwiftCI",
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
        ),
        .executable(
            name: "CheckIpcDemoTask",
            targets: [
                "CheckIpcDemoTask"
            ]
        ),
        .executable(
            name: "CheckDemoTask",
            targets: [
                "CheckDemoTask"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/AliSoftware/Dip", .revision("e02f1697155cdcb546ee350e5803ecc6fc66cfa9"))
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
            name: "CheckIpcDemoTask",
            dependencies: [
                "BuildDsl"
            ]
        ),
        .target(
            name: "CheckDemoTask",
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
        .v4_2
    ]
)
