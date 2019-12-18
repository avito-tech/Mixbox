// swift-tools-version:5.0
// swiftlint:disable trailing_comma

import PackageDescription

let package = Package(
    name: "MixboxSwiftCI",
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        .executable(
            name: "TeamcityGrayBoxTestsBuild",
            targets: [
                "TeamcityGrayBoxTestsBuild"
            ]
        ),
        .executable(
            name: "TeamcityBlackBoxTestsBuild",
            targets: [
                "TeamcityBlackBoxTestsBuild"
            ]
        ),
        .executable(
            name: "TravisLogicTestsBuild",
            targets: [
                "TravisLogicTestsBuild"
            ]
        ),
        .executable(
            name: "TeamcityStaticChecksBuild",
            targets: [
                "TeamcityStaticChecksBuild"
            ]
        ),
        .executable(
            name: "TravisOversimplifiedDemoBuild",
            targets: [
                "TravisOversimplifiedDemoBuild"
            ]
        ),
        .executable(
            name: "TeamcityIpcDemoBuild",
            targets: [
                "TeamcityIpcDemoBuild"
            ]
        ),
        .executable(
            name: "TeamcityLogicTestsBuild",
            targets: [
                "TeamcityLogicTestsBuild"
            ]
        ),
        .executable(
            name: "TeamcityOversimplifiedDemoBuild",
            targets: [
                "TeamcityOversimplifiedDemoBuild"
            ]
        ),
        .executable(
            name: "TravisIpcDemoBuild",
            targets: [
                "TravisIpcDemoBuild"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/avito-tech/Emcee", 
            .revision("8012542954fcb1700b0c3760adca55de4749cc89")
        ),
        .package(
            url: "https://github.com/AliSoftware/Dip",
             .revision("e02f1697155cdcb546ee350e5803ecc6fc66cfa9")
        ),
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            .exact("4.8.2")
        )
    ],
    targets: [
        .target(
            name: "TeamcityGrayBoxTestsBuild",
            dependencies: [
                "BuildDsl",
                "CiFoundation",
                "Destinations",
                "RunGrayBoxTestsTask",
                "SingletonHell",
            ]
        ),
        .target(
            name: "TeamcityBlackBoxTestsBuild",
            dependencies: [
                "BuildDsl",
                "CiFoundation",
                "Destinations",
                "RunBlackBoxTestsTask",
                "SingletonHell",
            ]
        ),
        .target(
            name: "Tasks",
            dependencies: [
                "CiFoundation",
            ]
        ),
        .target(
            name: "Di",
            dependencies: [
                "Bash",
                "Brew",
                "Bundler",
                "CiFoundation",
                "Cocoapods",
                "Destinations",
                "Dip",
                "Emcee",
                "EmceeInterfaces",
                "Git",
                "RemoteFiles",
                "Simctl",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
            ]
        ),
        .target(
            name: "CheckDemoTask",
            dependencies: [
                "Bash",
                "Bundler",
                "CiFoundation",
                "Destinations",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
            ]
        ),
        .target(
            name: "RunBlackBoxTestsTask",
            dependencies: [
                "Bash",
                "Bundler",
                "CiFoundation",
                "Destinations",
                "Emcee",
                "EmceeInterfaces",
                "RemoteFiles",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
            ]
        ),
        .target(
            name: "StaticChecksTask",
            dependencies: [
                "Bash",
                "CiFoundation",
                "Cocoapods",
                "Git",
                "SingletonHell",
                "Tasks",
            ]
        ),
        .target(
            name: "Destinations",
            dependencies: [
                "CiFoundation",
                "Git",
            ]
        ),
        .target(
            name: "CiFoundation",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "AllTests",
            dependencies: [
                "Bash",
                "CiFoundation",
                "Di",
                "Git",
                "RemoteFiles",
                "Simctl",
                "StaticChecksTask",
            ]
        ),
        .target(
            name: "TravisLogicTestsBuild",
            dependencies: [
                "BuildDsl",
                "RunUnitTestsTask",
            ]
        ),
        .target(
            name: "TeamcityStaticChecksBuild",
            dependencies: [
                "BuildDsl",
                "StaticChecksTask",
            ]
        ),
        .target(
            name: "Brew",
            dependencies: [
                "Bash",
            ]
        ),
        .target(
            name: "SingletonHell",
            dependencies: [
                "CiFoundation",
            ]
        ),
        .target(
            name: "Bash",
            dependencies: [
                "CiFoundation",
            ]
        ),
        .target(
            name: "BuildDsl",
            dependencies: [
                "Di",
                "Dip",
                "Tasks",
            ]
        ),
        .target(
            name: "Simctl",
            dependencies: [
                "Bash",
                "CiFoundation",
            ]
        ),
        .target(
            name: "TravisOversimplifiedDemoBuild",
            dependencies: [
                "BuildDsl",
                "Bundler",
                "CheckDemoTask",
                "Cocoapods",
            ]
        ),
        .target(
            name: "TeamcityIpcDemoBuild",
            dependencies: [
                "BuildDsl",
                "CheckIpcDemoTask",
            ]
        ),
        .target(
            name: "RunGrayBoxTestsTask",
            dependencies: [
                "Bash",
                "Bundler",
                "CiFoundation",
                "Destinations",
                "Emcee",
                "EmceeInterfaces",
                "RemoteFiles",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
            ]
        ),
        .target(
            name: "TeamcityLogicTestsBuild",
            dependencies: [
                "BuildDsl",
                "RunUnitTestsTask",
            ]
        ),
        .target(
            name: "Xcodebuild",
            dependencies: [
                "Bash",
                "CiFoundation",
                "Cocoapods",
                "Destinations",
                "Git",
                "Simctl",
                "SingletonHell",
            ]
        ),
        .target(
            name: "Emcee",
            dependencies: [
                "Bash",
                "Brew",
                "CiFoundation",
                "Destinations",
                "EmceeInterfaces",
                "RemoteFiles",
            ]
        ),
        .target(
            name: "CheckIpcDemoTask",
            dependencies: [
                "Bash",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
            ]
        ),
        .target(
            name: "Cocoapods",
            dependencies: [
                "Bash",
                "Bundler",
            ]
        ),
        .target(
            name: "Bundler",
            dependencies: [
                "Bash",
                "Git",
            ]
        ),
        .target(
            name: "RemoteFiles",
            dependencies: [
                "Alamofire",
                "Bash",
                "CiFoundation",
            ]
        ),
        .target(
            name: "Git",
            dependencies: [
                "CiFoundation",
            ]
        ),
        .target(
            name: "TeamcityOversimplifiedDemoBuild",
            dependencies: [
                "BuildDsl",
                "CheckDemoTask",
            ]
        ),
        .target(
            name: "TravisIpcDemoBuild",
            dependencies: [
                "BuildDsl",
                "CheckIpcDemoTask",
            ]
        ),
        .target(
            name: "RunUnitTestsTask",
            dependencies: [
                "Bash",
                "Bundler",
                "CiFoundation",
                "Cocoapods",
                "Destinations",
                "Git",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v4_2
    ]
)
