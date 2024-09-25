// swift-tools-version:5.5

// swiftlint:disable all

import PackageDescription
import Foundation

let iphoneOSMaxAllowed = "170000"

func defaultCSettings() -> [CSetting] {
    return [
        .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: [Platform.iOS], configuration: .debug)),
        .define("MIXBOX_ENABLE_ALL_FRAMEWORKS", .when(platforms: [Platform.iOS], configuration: .debug)),
        .define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: iphoneOSMaxAllowed, .when(platforms: [Platform.iOS], configuration: .debug)),
        .define("SWIFT_PACKAGE")
    ]
}

func defaultCXXSettings() -> [CXXSetting] {
    return [
        .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: [Platform.iOS], configuration: .debug)),
        .define("MIXBOX_ENABLE_ALL_FRAMEWORKS", .when(platforms: [Platform.iOS], configuration: .debug)),
        .define("__IPHONE_OS_VERSION_MAX_ALLOWED", to: iphoneOSMaxAllowed, .when(platforms: [Platform.iOS], configuration: .debug)),
        .define("SWIFT_PACKAGE")
    ]
}

func defaultSwiftSettings() -> [SwiftSetting] {
    return [
        .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: [Platform.iOS], configuration: .debug)),
        .define("MIXBOX_ENABLE_ALL_FRAMEWORKS", .when(platforms: [Platform.iOS], configuration: .debug)),
        .define("SWIFT_PACKAGE")
//            .define("XCODE_153")
    ]
}

struct MixboxFramework {
    enum Language {
        case swift, objc, mixed
    }
    
    /// convenience init
    init(name: String, language: Language = .swift, dependencies: [MixboxFramework], customDependencies: [String] = []) {
        self.init(
            name: name,
            language: language,
            dependencies: dependencies.map(\.dependency) + customDependencies
        )
    }
    
    init(name: String, language: Language = .swift, dependencies: [String] = []) {
        self.name = name
        self.language = language
        self.dependencies = dependencies
    }
    
    let name: String
    let language: Language
    let dependencies: [String]
    
    var mixboxName: String { "Mixbox" + name }
    var mixboxNameObjc: String {
        switch language {
        case .swift, .objc:
            mixboxName
        case .mixed:
            mixboxName + "Objc"
        }
    }
    
    var dependency: String {
        switch language {
        case .swift, .mixed:
            mixboxName
        case .objc:
            mixboxNameObjc
        }
    }
    
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
        let commonDependencies: [Target.Dependency] = dependencies.map(Target.Dependency.init(stringLiteral:))
        
        let swiftDependencies: [Target.Dependency] = if language == .mixed {
            commonDependencies + [
                Target.Dependency(stringLiteral: mixboxNameObjc)
            ]
        } else {
            commonDependencies
        }
        let objcDependencies: [Target.Dependency] = commonDependencies
        
        let objcPath = language == .mixed
            ? "Frameworks/\(name)/Sources/ObjectiveC"
            : "Frameworks/\(name)"
        let objcSources: [String]? = language == .mixed
            ? nil
            : [ "Sources" ]
        let objcPublicHeadersPath = language == .mixed
            ? "."
            : "Sources"
                           
        let exclude: [String] = language == .mixed ? ["ObjectiveC"] : []

        let swiftTarget = Target.target(
            name: mixboxName,
            dependencies: swiftDependencies,
            path: "Frameworks/\(name)/Sources",
            exclude: exclude,
            swiftSettings: swiftSettings(),
            linkerSettings: linkedLibraries()
        )
        let objcTarget = Target.target(
            name: mixboxNameObjc,
            dependencies: objcDependencies,
            path: objcPath,
            sources: objcSources,
            publicHeadersPath: objcPublicHeadersPath,
            cSettings: cSettings() + [
                .headerSearchPath("./**"),
            ],
            cxxSettings: cxxSettings() + [
                .headerSearchPath("./**"),
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
        return defaultCSettings() + [
            .define(frameworkEnableDefine, .when(platforms: nil, configuration: .debug))
        ]
    }

    func cxxSettings() -> [CXXSetting] {
        return defaultCXXSettings() + [
            .define(frameworkEnableDefine, .when(platforms: nil, configuration: .debug))
        ]
    }

    func swiftSettings() -> [SwiftSetting] {
        return defaultSwiftSettings() + [
            .define(frameworkEnableDefine, .when(platforms: nil, configuration: .debug))
        ]
    }
}

// MARK: - Dependencies -

let dependencyGCDWebServer: Package.Dependency = .package(
    name: "GCDWebServer",
    url: "https://github.com/SlaunchaMan/GCDWebServer.git",
    .revision("5cc010813d797c3f40557c740a4f620bf84da4dd")
)

//        .package(url: "https://github.com/jpsim/SourceKitten.git", .exact("0.30.1")),
//        .package(url: "https://github.com/kylef/PathKit.git", .branch("master")),
//        .package(url: "https://github.com/avito-tech/Sourcery.git", .revision("0564feccdc8fade6c68376bdf7f8dab9b79863fe")),


// MARK: - Frameworks -


let mixboxFoundation = MixboxFramework(name: "Foundation", language: .mixed)
let mixboxDi = MixboxFramework(name: "Di")
let mixboxBuiltinDi = MixboxFramework(name: "BuiltinDi", dependencies: [mixboxDi, mixboxFoundation])
let mixboxCocoaImageHashing = MixboxFramework(name: "CocoaImageHashing")
let mixboxAnyCodable = MixboxFramework(name: "AnyCodable")
let mixboxGenerators = MixboxFramework(name: "Generators", dependencies: [mixboxDi])

let mixboxSBTUITestTunnelCommon = MixboxFramework(name: "SBTUITestTunnelCommon", language: .objc)
let mixboxSBTUITestTunnelServer = MixboxFramework(
    name: "SBTUITestTunnelServer",
    language: .objc, 
    dependencies: [mixboxSBTUITestTunnelCommon],
    customDependencies: [dependencyGCDWebServer.name!]    
)
let mixboxSBTUITestTunnelClient = MixboxFramework(
    name: "SBTUITestTunnelClient",
    language: .objc,
    dependencies: [mixboxSBTUITestTunnelCommon]
)
let mixboxUiKit = MixboxFramework(name: "UiKit", dependencies: [mixboxFoundation, mixboxSBTUITestTunnelServer])
let mixboxIpc = MixboxFramework(name: "Ipc", dependencies: [mixboxFoundation])
let mixboxIpcCommon = MixboxFramework(name: "IpcCommon", dependencies: [mixboxIpc, mixboxAnyCodable])
let mixboxReflection = MixboxFramework(name: "Reflection")

let targets = [
    mixboxFoundation,
    mixboxDi,
    mixboxBuiltinDi,
    mixboxCocoaImageHashing,
    mixboxAnyCodable,
    mixboxGenerators,
    mixboxSBTUITestTunnelCommon,
    mixboxSBTUITestTunnelServer,
    mixboxSBTUITestTunnelClient,
    mixboxUiKit,
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
    mixboxSBTUITestTunnelCommon, 
    mixboxSBTUITestTunnelServer,
    mixboxSBTUITestTunnelClient,
    mixboxUiKit,
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

// MARK: - Package -

let package = Package(
    name: "Mixbox",
    platforms: [.iOS(.v15)],
    products: products,
    dependencies: [
        dependencyGCDWebServer,
    ],
    targets: targets
)

// swiftlint:enable all
