// swift-tools-version:5.5

// swiftlint:disable all

import PackageDescription
import Foundation


struct MixboxFramework {
    enum Language {
        case swift, objc, mixed
        
        var hasObjc: Bool {
            switch self {
            case .objc, .mixed:
                true
            default:
                false
            }
        }
    }
    
    internal init(name: String, language: Language = .swift, dependencies: [String] = []) {
        self.name = name
        self.language = language
        self.dependencies = dependencies
    }
    
    let name: String
    let language: Language
    let dependencies: [String]
    
    var mixboxName: String { "Mixbox" + name }
    var mixboxNameObjc: String { mixboxName + "Objc" }
    
    var frameworkEnableDefine: String {
        // SBTUITestTunnelCommon -> S_B_T_U_I_TEST_TUNNEL_COMMON
        let convertedName = String(
            name
                .split(separator: #/(?=[A-Z])/#)
                .map { "\($0)_" }
                .joined()
                .dropLast()
        ).uppercased()
        
        return "MIXBOX_ENABLE_FRAMEWORK_\(convertedName)"
    }
    
    var targets: [Target] {
        let dependenciesNames = dependencies + (language == .mixed ? [mixboxNameObjc] : [])
        let exclude: [String] = language == .mixed ? ["ObjectiveC"] : []

        let swiftTarget = Target.target(
            name: mixboxName,
            dependencies: dependenciesNames.map(Target.Dependency.init(stringLiteral:)),
            path: "Frameworks/\(name)/Sources",
            exclude: exclude,
            swiftSettings: swiftSettings(),
            linkerSettings: linkedLibraries()
        )
        let objcPath = language == .mixed
            ? "Frameworks/\(name)/Sources/ObjectiveC"
            : "Frameworks/\(name)/Sources"
        let objcTarget = Target.target(
            name: mixboxNameObjc,
            dependencies: [],
            path: objcPath,
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
        return switch language {
        case .swift:
            [swiftTarget]
        case .objc:
            [objcTarget]
        case .mixed:
            [swiftTarget, objcTarget]
        }
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
            .define("MIXBOX_ENABLE_ALL_FRAMEWORKS", .when(platforms: nil, configuration: .debug)),
            .define(frameworkEnableDefine, .when(platforms: nil, configuration: .debug)),
            .define("SWIFT_PACKAGE")
            
            //.define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: "150000", .when(platforms: nil, configuration: .debug))
        ]
    }

    func cxxSettings() -> [CXXSetting] {
        return [
            .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug)),
            .define("MIXBOX_ENABLE_ALL_FRAMEWORKS", .when(platforms: nil, configuration: .debug)),
            .define(frameworkEnableDefine, .when(platforms: nil, configuration: .debug)),
            .define("SWIFT_PACKAGE")
            
    //        .define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: "150000", .when(platforms: nil, configuration: .debug))
        ]
    }

    func swiftSettings() -> [SwiftSetting] {
        return [
            .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug)),
            .define("MIXBOX_ENABLE_ALL_FRAMEWORKS", .when(platforms: nil, configuration: .debug)),
            .define(frameworkEnableDefine, .when(platforms: nil, configuration: .debug)),
            .define("SWIFT_PACKAGE")
    //            .define("XCODE_145")
        ]
    }
}

let mixboxFoundation = MixboxFramework(name: "Foundation", language: .mixed)
let mixboxDi = MixboxFramework(name: "Di")
let mixboxBuiltinDi = MixboxFramework(name: "BuiltinDi", dependencies: [mixboxDi.mixboxName, mixboxFoundation.mixboxName])
let mixboxCocoaImageHashing = MixboxFramework(name: "CocoaImageHashing")
let mixboxAnyCodable = MixboxFramework(name: "AnyCodable")
let mixboxGenerators = MixboxFramework(name: "Generators", dependencies: [mixboxDi.mixboxName])
let mixboxSBTUITestTunnelCommon = MixboxFramework(name: "SBTUITestTunnelCommon", language: .objc)
let mixboxIpc = MixboxFramework(name: "Ipc", language: .swift, dependencies: ["MixboxFoundation"])
let mixboxIpcCommon = MixboxFramework(name: "IpcCommon", language: .swift, dependencies: ["MixboxIpc", "MixboxAnyCodable"])
let mixboxReflection = MixboxFramework(name: "Reflection", language: .swift)

let targets = [
    mixboxFoundation,
    mixboxDi,
    mixboxBuiltinDi,
    mixboxCocoaImageHashing,
    mixboxAnyCodable,
    mixboxGenerators,
    mixboxSBTUITestTunnelCommon,
    mixboxIpc,
    mixboxIpcCommon,
    mixboxReflection
].flatMap(\.targets)

let products = [
    mixboxFoundation,
    mixboxDi,
    mixboxBuiltinDi,
    mixboxCocoaImageHashing,
    mixboxAnyCodable,
    mixboxGenerators,
    mixboxIpc,
    mixboxIpcCommon,
    mixboxReflection
].map(\.product)

let commoTargets: [Target] = [
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
    targets: targets
)

// swiftlint:enable all
