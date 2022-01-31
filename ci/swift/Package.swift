// swift-tools-version:5.3
// swiftlint:disable trailing_comma file_length

// This file is generated via MakePackage python code. Do not modify it.

import PackageDescription

let package = Package(
    name: "MixboxSwiftCI",
    platforms: [
        .macOS(.v11),
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
            name: "TeamcityCheckReleaseToCocoapodsBuild",
            targets: [
                "TeamcityCheckReleaseToCocoapodsBuild"
            ]
        ),
        .executable(
            name: "TeamcityUiTestsDemoBuild",
            targets: [
                "TeamcityUiTestsDemoBuild"
            ]
        ),
        .executable(
            name: "TeamcityReleaseToCocoapodsBuild",
            targets: [
                "TeamcityReleaseToCocoapodsBuild"
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
            name: "TeamcityManagePodOwnersBuild",
            targets: [
                "TeamcityManagePodOwnersBuild"
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
            name: "TravisIpcDemoBuild",
            targets: [
                "TravisIpcDemoBuild"
            ]
        ),
    ],
    dependencies: [
        .package(
            name: "EmceeTestRunner",
            url: "https://github.com/avito-tech/Emcee", 
            .revision("312b38ba3de954ee880521f52be792c9c7fff3bc")
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
            name: "Releases",
            dependencies: [
                "Bundler",
                "CiFoundation",
                "Cocoapods",
                "Git",
                .product(name: "EmceeInterfaces", package: "EmceeTestRunner"),
            ]
        ),
        .target(
            name: "Tasks",
            dependencies: [
            ]
        ),
        .target(
            name: "CheckReleaseToCocoapodsTask",
            dependencies: [
                "Bash",
                "Bundler",
                "CiFoundation",
                "Destinations",
                "Emcee",
                "Git",
                "Releases",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
            ]
        ),
        .target(
            name: "TeamcityCheckReleaseToCocoapodsBuild",
            dependencies: [
                "BuildDsl",
                "CheckReleaseToCocoapodsTask",
                "CiFoundation",
                "Destinations",
                "Releases",
                "SingletonHell",
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
                "Tasks",
                "TestRunning",
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
            name: "TeamcityUiTestsDemoBuild",
            dependencies: [
                "BuildDsl",
                "CheckDemoTask",
            ]
        ),
        .target(
            name: "TeamcityReleaseToCocoapodsBuild",
            dependencies: [
                "BuildDsl",
                "CiFoundation",
                "Destinations",
                "ReleaseToCocoapodsTask",
                "Releases",
                "SingletonHell",
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
                "Cocoapods",
                "Git",
                "Releases",
                "RemoteFiles",
                "Simctl",
                "StaticChecksTask",
                "TeamcityDi",
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
                "CiFoundation",
                "SingletonHell",
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
            name: "TeamcityManagePodOwnersBuild",
            dependencies: [
                "BuildDsl",
                "ManagePodOwnersTask",
            ]
        ),
        .target(
            name: "CiDi",
            dependencies: [
                "Bash",
                "Brew",
                "Bundler",
                "CiFoundation",
                "Cocoapods",
                "Destinations",
                "Dip",
                "Emcee",
                "Git",
                "Releases",
                "RemoteFiles",
                "Simctl",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
                .product(name: "EmceeInterfaces", package: "EmceeTestRunner"),
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
                "CiDi",
                "Dip",
                "Tasks",
                "TeamcityDi",
                "TravisDi",
            ]
        ),
        .target(
            name: "TestRunning",
            dependencies: [
                "Bash",
                "Bundler",
                "CiFoundation",
                "Destinations",
                "Emcee",
                "RemoteFiles",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
                .product(name: "EmceeInterfaces", package: "EmceeTestRunner"),
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
            name: "ReleaseToCocoapodsTask",
            dependencies: [
                "Bash",
                "Bundler",
                "CiFoundation",
                "Destinations",
                "Emcee",
                "Git",
                "Releases",
                "SingletonHell",
                "Tasks",
                "Xcodebuild",
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
                "Tasks",
                "TestRunning",
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
            name: "TeamcityDi",
            dependencies: [
                "Bundler",
                "CiDi",
                "CiFoundation",
                "Cocoapods",
                "Destinations",
                "Dip",
                "Emcee",
                "RemoteFiles",
                "SingletonHell",
                "Tasks",
                "TestRunning",
                .product(name: "EmceeInterfaces", package: "EmceeTestRunner"),
            ]
        ),
        .target(
            name: "TravisDi",
            dependencies: [
                "Bundler",
                "CiDi",
                "CiFoundation",
                "Dip",
                "Tasks",
            ]
        ),
        .target(
            name: "ManagePodOwnersTask",
            dependencies: [
                "Cocoapods",
                "Releases",
                "Tasks",
            ]
        ),
        .target(
            name: "Emcee",
            dependencies: [
                "Bash",
                "Brew",
                "CiFoundation",
                "Destinations",
                "RemoteFiles",
                "SingletonHell",
                .product(name: "EmceeInterfaces", package: "EmceeTestRunner"),
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
                "CiFoundation",
                .product(name: "EmceeInterfaces", package: "EmceeTestRunner"),
            ]
        ),
        .target(
            name: "Bundler",
            dependencies: [
                "Bash",
                "CiFoundation",
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
                "Bash",
                "CiFoundation",
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
                "Tasks",
                "TestRunning",
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
