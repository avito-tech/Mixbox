// swift-tools-version:5.5

// swiftlint:disable all

import PackageDescription
import Foundation


struct MixboxFramework {
    internal init(name: String, hasObjc: Bool, dependencies: [String] = []) {
        self.name = name
        self.hasObjc = hasObjc
        self.dependencies = dependencies
    }
    
    let name: String
    let hasObjc: Bool
    let dependencies: [String]
    
    var mixboxName: String { "Mixbox" + name }
    var mixboxNameObjc: String { mixboxName + "Objc" }
    
    var targets: [Target] {
        let dependenciesNames = dependencies + (hasObjc ? [mixboxNameObjc] : [])
        let exclude: [String] = hasObjc ? ["ObjectiveC"] : []

        let mainTarget = Target.target(
            name: mixboxName,
            dependencies: dependenciesNames.map(Target.Dependency.init(stringLiteral:)),
            path: "Frameworks/\(name)/Sources",
            exclude: exclude,
            swiftSettings: swiftSettings(),
            linkerSettings: linkedLibraries()
        )
        let objTarget = Target.target(
            name: mixboxNameObjc,
            dependencies: [],
            path: "Frameworks/\(name)/Sources/ObjectiveC",
//            sources: ["/dummy.m"],
            publicHeadersPath: ".",
            cSettings: cSettings() + [
                .headerSearchPath("./**"),
//                .define("MIXBOX_ENABLE_FRAMEWORK_FOUNDATION", to: "1"),
            ],
            cxxSettings: cxxSettings() + [
                .headerSearchPath("./**"),
//                .define("MIXBOX_ENABLE_FRAMEWORK_FOUNDATION", to: "1"),
            ],
            swiftSettings: swiftSettings() + [
            ],
            linkerSettings: linkedLibraries()
        )
        return hasObjc ? [mainTarget, objTarget] : [mainTarget]
    }
    
    var targetNames: [String] {
        targets.map(\.name)
    }
    
    var product: Product {
        Product.library(
            name: mixboxName,
            type: .dynamic,
            targets: targetNames
        )
    }
        
    func linkedLibraries() -> [LinkerSetting] {
        return [
            .linkedFramework("Foundation")
        ]
    }
    
    func linkedTestLibraries() -> [LinkerSetting] {
        return [
            .linkedFramework("XCTest")
        ]
    }


    func cSettings() -> [CSetting] {
        return [
            .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug)),
            .define("SWIFT_PACKAGE")
            
            //.define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: "150000", .when(platforms: nil, configuration: .debug))
        ]
    }

    func cxxSettings() -> [CXXSetting] {
        return [
            .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug)),
            .define("SWIFT_PACKAGE")
            
    //        .define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: "150000", .when(platforms: nil, configuration: .debug))
        ]
    }

    func swiftSettings() -> [SwiftSetting] {
        return [
            .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug)),
            .define("MIXBOX_ENABLE_ALL_FRAMEWORKS"),
            .define("SWIFT_PACKAGE")
    //            .define("XCODE_145")
        ]
    }
}

let mixboxFoundation = MixboxFramework(name: "Foundation", hasObjc: true)

let targets = [
    mixboxFoundation
].flatMap(\.targets)

let products = [
    mixboxFoundation
].map(\.product)

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
    products: products,
        // products
//    [
    
    
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
    
    
//        .library(
//            name: "MixboxFoundation",
//            type: .dynamic,
//            targets: [
//                "MixboxFoundation",
//                "MixboxFoundationObjc"
//            ]
//        ),
    
    
        //        .executable(
        //            name: "MixboxMocksGenerator",
        //            targets: [
        //                "MixboxMocksGenerator"
        //            ]
        //        )
    
    
    
// products
//    ],
    
    dependencies: [
//        .package(url: "https://github.com/jpsim/SourceKitten.git", .exact("0.30.1")),
//        .package(url: "https://github.com/kylef/PathKit.git", .branch("master")),
//        .package(url: "https://github.com/avito-tech/Sourcery.git", .revision("0564feccdc8fade6c68376bdf7f8dab9b79863fe")),
    ],
    targets: targets //+ commoTargets
)

// swiftlint:enable all
