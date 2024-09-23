// swift-tools-version:5.5

// swiftlint:disable all

import PackageDescription
import Foundation


func linkedLibraries() -> [LinkerSetting] {
    return [
        .linkedFramework("XCTest")
    ]
}

func cSettings() -> [CSetting] {
    return [
        .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(configuration: .debug)),
        .define("SWIFT_PACKAGE"),
        .define("MIXBOX_ENABLE_FRAMEWORK_FOUNDATION", to: "1")
        //.define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: "150000", .when(platforms: nil, configuration: .debug))
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

let mixboxFoundationTargets : [Target] = [
    .target(
        // MARK: FoundationObjcSwift
        name: "MixboxFoundationObjc",
        path: "Frameworks/Foundation/Objc",
        publicHeadersPath: ".",
        cSettings: [
            .headerSearchPath("./**"),
            .define("MIXBOX_ENABLE_FRAMEWORK_FOUNDATION", to: "1"),
        ] + cSettings(),
        cxxSettings: [
            .headerSearchPath("./**"),
            .define("MIXBOX_ENABLE_FRAMEWORK_FOUNDATION", to: "1"),
        ] + cxxSettings(),
        swiftSettings: swiftSettings()
    ),
    .target(
        // MARK: MixboxFoundation
        name: "MixboxFoundation",
        dependencies: [
            "MixboxFoundationObjc"
        ],
        path: "Frameworks/Foundation/Sources",
        swiftSettings: [
            .define("MIXBOX_ENABLE_ALL_FRAMEWORKS")
        ] + swiftSettings()
    )
]

let commoTargets: [Target] = [
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
            type: .dynamic,
            targets: [
                "MixboxFoundation",
                "MixboxFoundationObjc"
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
    targets: mixboxFoundationTargets + commoTargets
)

// swiftlint:enable all
