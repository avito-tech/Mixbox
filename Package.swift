// swift-tools-version:5.5

// swiftlint:disable all

import PackageDescription
import Foundation

func cSettings() -> [CSetting] {
    return [
        .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(configuration: .debug)),
        .define("SWIFT_PACKAGE")
        //.define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: "150000", .when(platforms: nil, configuration: .debug))
    ]
}

func linkedLibraries() -> [LinkerSetting] {
    return [
        .linkedFramework("XCTest")
    ]
}

func cxxSettings() -> [CXXSetting] {
    return [
        .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when( configuration: .debug)),
        .define("SWIFT_PACKAGE")
        
//        .define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: "150000", .when(platforms: nil, configuration: .debug))
    ]
}

func swiftSettings() -> [SwiftSetting] {
    return [
        .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(configuration: .debug)),
            .define("SWIFT_PACKAGE")
//            .define("XCODE_145")
    ]
}


let package = Package(
    name: "Mixbox",
    platforms: [.macOS(.v10_15)],
    products: [
        //        .library(
        //            name: "MixboxMocksGeneration",
        //            targets: [
        //                "MixboxMocksGeneration"
        //            ]
        //        ),
        //        .library(
        //            name: "MixboxDi",
        //            targets: [
        //                "MixboxDi"
        //            ]
        //        ),
        //        .library(
        //            name: "MixboxBuiltinDi",
        //            targets: [
        //                "MixboxBuiltinDi"
        //            ]
        //        ),
        //        .library(
        //            name: "MixboxBuiltinDi",
        //            targets: [
        //                "MixboxBuiltinDi"
        //            ]
        //        ),
        .library(
            name: "MixboxFoundation",
            targets: [
                "MixboxFoundation",
                "FoundationObjcSwift"
            ]
        ),
        //        .executable(
        //            name: "MixboxMocksGenerator",
        //            targets: [
        //                "MixboxMocksGenerator"
        //            ]
        //        )
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
                .define("MIXBOX_ENABLE_ALL_FRAMEWORKS")
            ]
        ),
        .target(
            // MARK: MixboxDi
            name: "MixboxDi",
            dependencies: [
                
            ],
            path: "Frameworks/Di/Sources",
            swiftSettings: [
                .define("MIXBOX_ENABLE_ALL_FRAMEWORKS")
            ]
        ),
        .target(
            // MARK: FoundationObjcSwift
            name: "FoundationObjcSwift",
            dependencies: [
                
            ],
            path: "Frameworks/Foundation/ObjcSwift",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("MIXBOX_ENABLE_FRAMEWORK_FOUNDATION"),
            ]
        ),
        .target(
            // MARK: MixboxFoundation
            name: "MixboxFoundation",
            dependencies: [
                "FoundationObjcSwift"
            ],
            path: "Frameworks/Foundation/Sources",
            swiftSettings: [
                .define("MIXBOX_ENABLE_ALL_FRAMEWORKS")
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

// swiftlint:enable all
