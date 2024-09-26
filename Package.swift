// swift-tools-version:5.5

// swiftlint:disable all

import PackageDescription
import Foundation

// MARK: - Build settings -

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

// MARK: - Specs -

protocol Spec {
    var products: [Product] { get }
    var targets: [ Target] { get }
    var dependency: Target.Dependency { get }
    
}

struct MixboxFramework: Spec {
    enum Language {
        case swift, objc, mixed
    }
    
    init(name: String,
         language: Language = .swift,
         dependencies frameworks: [any Spec] = [],
         customDependencies: [Target.Dependency] = [],
         exclude: [String] = []
    ) {
        self.name = name
        self.language = language
        self.dependencies = customDependencies + frameworks.map(\.dependency)
        self.excludePaths = exclude
    }
    
    let name: String
    let language: Language
    let dependencies: [Target.Dependency]
    let excludePaths: [String]
    
    var mixboxName: String { "Mixbox" + name }
    var mixboxNameObjc: String {
        switch language {
        case .swift, .objc:
            mixboxName
        case .mixed:
            mixboxName + "Objc"
        }
    }
    
    var dependency: Target.Dependency {
        let name = switch language {
        case .swift, .mixed:
            mixboxName
        case .objc:
            mixboxNameObjc
        }
        return Target.Dependency.target(name: name)
    }
    
    var frameworkEnableDefine: String {
        // SBTUITestTunnelCommon -> S_B_T_U_I_TEST_TUNNEL_COMMON
        let convertedName = String(
            name.replacing(#/(?=[A-Z])/#, with: "_").trimmingPrefix("_")
        ).uppercased()
        
        return "MIXBOX_ENABLE_FRAMEWORK_\(convertedName)"
    }
    
    var targets: [Target] {
        let swiftDependencies: [Target.Dependency] = if language == .mixed {
            dependencies + [
                Target.Dependency(stringLiteral: mixboxNameObjc)
            ]
        } else {
            dependencies
        }
        let objcDependencies: [Target.Dependency] = dependencies
        
        let objcPath = language == .mixed
            ? "Frameworks/\(name)/Sources/ObjectiveC"
            : "Frameworks/\(name)"
        let objcSources: [String]? = language == .mixed
            ? nil
            : [ "Sources" ]
        let objcPublicHeadersPath = language == .mixed
            ? "."
            : "Sources"
                           
        let mixedExclude: [String] = language == .mixed ? ["ObjectiveC"] : []
        let swiftExclude = excludePaths + mixedExclude
        let objcExclude = excludePaths

        let swiftTarget = Target.target(
            name: mixboxName,
            dependencies: swiftDependencies,
            path: "Frameworks/\(name)/Sources",
            exclude: swiftExclude,
            swiftSettings: swiftSettings(),
            linkerSettings: linkedLibraries()
        )
        let objcTarget = Target.target(
            name: mixboxNameObjc,
            dependencies: objcDependencies,
            path: objcPath,
            exclude: objcExclude,
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
    
    var products: [Product] {
        [
            Product.library(
                name: mixboxName,
                type: .static,
                targets: targetNames
            )
        ]
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

// MARK: - ThirdParty -

struct ThirdParty {
    let package: Package.Dependency
    let target: Target.Dependency
    
    static let GCDWebServer = ThirdParty(
        package: .package(
            name: "GCDWebServer",
            url: "https://github.com/SlaunchaMan/GCDWebServer.git",
            .revision("5cc010813d797c3f40557c740a4f620bf84da4dd")
        ),
        target: "GCDWebServer"
    )
    
    static let sqlite =  ThirdParty(
        package: .package(
            url: "https://github.com/stephencelis/SQLite.swift.git",
            from: "0.15.0"
        ),
        target: .product(name: "SQLite", package: "SQLite.swift")
    )
}

//        .package(url: "https://github.com/jpsim/SourceKitten.git", .exact("0.30.1")),
//        .package(url: "https://github.com/kylef/PathKit.git", .branch("master")),
//        .package(url: "https://github.com/avito-tech/Sourcery.git", .revision("0564feccdc8fade6c68376bdf7f8dab9b79863fe")),


// MARK: - Frameworks -

let mixboxFoundation = MixboxFramework(name: "Foundation", language: .mixed)
let mixboxDi = MixboxFramework(name: "Di")
let mixboxBuiltinDi = MixboxFramework(name: "BuiltinDi", dependencies: [mixboxDi, mixboxFoundation])
let mixboxCocoaImageHashing = MixboxFramework(
    name: "CocoaImageHashing",
    language: .objc,
    exclude: ["Sources/include/module.modulemap"]
)
let mixboxAnyCodable = MixboxFramework(name: "AnyCodable")
let mixboxGenerators = MixboxFramework(name: "Generators", dependencies: [mixboxDi])

let mixboxSBTUITestTunnelCommon = MixboxFramework(name: "SBTUITestTunnelCommon", language: .objc)
let mixboxSBTUITestTunnelServer = MixboxFramework(
    name: "SBTUITestTunnelServer",
    language: .objc, 
    dependencies: [mixboxSBTUITestTunnelCommon],
    customDependencies: [ThirdParty.GCDWebServer.target]
)
let mixboxSBTUITestTunnelClient = MixboxFramework(
    name: "SBTUITestTunnelClient",
    language: .objc,
    dependencies: [mixboxSBTUITestTunnelCommon]
)
let mixboxUiKit = MixboxFramework(name: "UiKit", dependencies: [mixboxFoundation, mixboxSBTUITestTunnelServer])

let mixboxIpc = MixboxFramework(name: "Ipc", dependencies: [mixboxFoundation])
let mixboxIpcCommon = MixboxFramework(name: "IpcCommon", dependencies: [mixboxIpc, mixboxAnyCodable])
let mixboxBuiltinIpc = MixboxFramework(name: "BuiltinIpc", language: .mixed, dependencies: [mixboxFoundation, mixboxIpc], customDependencies: [ThirdParty.GCDWebServer.target])
let mixboxIpcSbtuiHost = MixboxFramework(name: "IpcSbtuiHost", language: .swift, dependencies: [mixboxIpc, mixboxSBTUITestTunnelServer])
let mixboxReflection = MixboxFramework(name: "Reflection")
let mixboxFakeSettingsAppMain = MixboxFramework(
    name: "FakeSettingsAppMain",
    language: .objc,
    exclude: [
        "Sources/Docs/Images",
        "Sources/Example/Entitlements.entitlements"
    ]
)

struct MixboxTestsFoundation: Spec {
    static let spec = MixboxTestsFoundation()
    
    init() {
        let name = "TestsFoundation"
        let mixboxName: String = "Mixbox" + name
        let mixboxNameObjc: String = mixboxName + "Objc"
        let path = "Frameworks/\(name)"
        let objcSources = "Sources/ObjectiveC"
        
        objcTarget = Target.target(
            name: mixboxNameObjc,
            dependencies: [],
            path: path,
            exclude: [
                "\(objcSources)/PrivateHeaders"
            ],
            sources: [ objcSources ],
            publicHeadersPath: "PublicHeaders",
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings()
        )
        
        swiftTarget = Target.target(
            name: mixboxName,
            dependencies: [
                mixboxIpcCommon.dependency,
                mixboxUiKit.dependency,
                mixboxBuiltinDi.dependency,
                ThirdParty.sqlite.target,
                .target(name: mixboxNameObjc)
            ],
            path: path,
            exclude: [ objcSources ],
            sources: [ "Sources" ],
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings()
        )
        
        product = Product.library(
            name: mixboxName,
            type: .static,
            targets: [mixboxName, mixboxNameObjc]
        )
        
        dependency = Target.Dependency.target(name: mixboxName)
    }
    
    let objcTarget: Target
    let swiftTarget: Target
    let product: Product
    let dependency: Target.Dependency
    
    var targets: [Target] { [objcTarget, swiftTarget] }
    var products: [Product] { [product] }
}

let mixboxUiTestsFoundation = MixboxFramework(
    name: "UiTestsFoundation",
    dependencies: [
        MixboxTestsFoundation.spec,
        mixboxUiKit,
        mixboxAnyCodable,
        mixboxCocoaImageHashing,
        mixboxIpcCommon
    ]
)
let mixboxIpcSbtuiClient = MixboxFramework(
    name: "IpcSbtuiClient",
    language: .swift,
    dependencies: [mixboxIpc, mixboxSBTUITestTunnelClient, MixboxTestsFoundation.spec, mixboxUiTestsFoundation]
)

struct MixboxIoKit: Spec {
    static let spec = MixboxIoKit()
    
    init() {
        let name = "IoKit"
        let mixboxName: String = "Mixbox" + name
        let mixboxNameObjc: String = mixboxName + "Objc"
        let path = "Frameworks/\(name)"
        let objcSources = [
            "Sources/IOKitExtensions/EnumRawValues.m",
            "Sources/MBIohidEventSender/MBIohidEventSender.mm",
            "Sources/SoftLinking",
            "Sources/PrivateApi"
        ]
        let excludeHeaders = [
            "Sources/MBIohidEventSender/MBIohidEventSender.h",
            "Sources/IOKitExtensions/EnumRawValues.h",
        ]
        
        let objcTarget = Target.target(
            name: mixboxNameObjc,
            dependencies: [],
            path: path,
            sources: objcSources,
            publicHeadersPath: ".",
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings()
        )
        let swiftTarget = Target.target(
            name: mixboxName,
            dependencies: [
                .target(name: mixboxNameObjc),
                mixboxFoundation.dependency
            ],
            path: path,
            exclude: objcSources + excludeHeaders,
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings(),
            linkerSettings: [.linkedFramework("IOKit")]
        )
        targets = [objcTarget, swiftTarget]
        dependency = Target.Dependency.target(name: mixboxName)
        products = [ Product.library(name: mixboxName, type: .static, targets: [mixboxName, mixboxNameObjc]) ]
    }
    
    let products: [Product]
    let targets: [Target]
    let dependency: Target.Dependency
}

// MARK: - Lists -

let targetSpecs: [any Spec] = [
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
    mixboxReflection,
    mixboxBuiltinIpc,
    mixboxIpcSbtuiHost,
    mixboxUiTestsFoundation,
    MixboxTestsFoundation.spec,
    MixboxIoKit.spec,
    mixboxIpcSbtuiClient,
    mixboxFakeSettingsAppMain
]

let targets: [Target] = targetSpecs.flatMap(\.targets)

let productSpecs: [any Spec] = [
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
    mixboxReflection,
    mixboxBuiltinIpc,
    mixboxIpcSbtuiHost,
    mixboxUiTestsFoundation,
    MixboxTestsFoundation.spec,
    MixboxIoKit.spec,
    mixboxIpcSbtuiClient,
    mixboxFakeSettingsAppMain
]

let products: [Product] = productSpecs.flatMap(\.products)


// TODO: - Remove this
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
        ThirdParty.GCDWebServer.package,
        ThirdParty.sqlite.package
    ],
    targets: targets
)

// swiftlint:enable all
