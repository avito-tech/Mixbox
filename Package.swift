// swift-tools-version:5.7

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

class BaseSpec: Spec {
    init(
        name: String,
        dependencies frameworks: [any Spec] = [],
        customDependencies: [Target.Dependency] = []
    ) {
        self.name = name
        self.dependencies = customDependencies + frameworks.map(\.dependency)
    }
    
    let name: String
    let dependencies: [Target.Dependency]
    
    var products: [Product] { [] }
    var targets: [ Target] { [] }
    var dependency: Target.Dependency { Target.Dependency.target(name: mixboxName) }
    
    var frameworkPath: String { "Frameworks/\(name)" }
    var objcSourcesFolder: String { "Sources/ObjectiveC" }
    var mixboxName: String { "Mixbox" + name }
    var mixboxNameObjc: String { mixboxName + "Objc" }
    
    var frameworkEnableDefine: String {
        // SBTUITestTunnelCommon -> S_B_T_U_I_TEST_TUNNEL_COMMON
        let convertedName = String(
            name.replacing(#/(?=[A-Z])/#, with: "_").trimmingPrefix("_")
        ).uppercased()
        
        return "MIXBOX_ENABLE_FRAMEWORK_\(convertedName)"
    }
    
    func cSettings() -> [CSetting] {
        return defaultCSettings() + [
            .define(frameworkEnableDefine, .when(configuration: .debug))
        ]
    }

    func cxxSettings() -> [CXXSetting] {
        return defaultCXXSettings() + [
            .define(frameworkEnableDefine, .when(configuration: .debug))
        ]
    }

    func swiftSettings() -> [SwiftSetting] {
        return defaultSwiftSettings() + [
            .define(frameworkEnableDefine, .when(configuration: .debug))
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
}

final class MixboxFramework: BaseSpec {
    enum Language {
        case swift, objc, mixed
    }
    
    init(name: String,
         language: Language = .swift,
         dependencies frameworks: [any Spec] = [],
         customDependencies: [Target.Dependency] = [],
         exclude: [String] = []
    ) {
        
        self.language = language
        self.excludePaths = exclude
        super.init(name: name, dependencies: frameworks, customDependencies: customDependencies)
    }
    
    let language: Language
    let excludePaths: [String]
    
    override var mixboxNameObjc: String {
        switch language {
        case .swift, .objc:
            mixboxName
        case .mixed:
            mixboxName + "Objc"
        }
    }
    
    override var dependency: Target.Dependency {
        let name = switch language {
        case .swift, .mixed:
            mixboxName
        case .objc:
            mixboxNameObjc
        }
        return Target.Dependency.target(name: name)
    }
    
    override var targets: [Target] {
        let swiftDependencies: [Target.Dependency] = if language == .mixed {
            dependencies + [
                Target.Dependency(stringLiteral: mixboxNameObjc)
            ]
        } else {
            dependencies
        }
        let objcDependencies: [Target.Dependency] = dependencies
        
        let objcPath = language == .mixed
            ? "\(frameworkPath)/\(objcSourcesFolder)"
            : frameworkPath
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
            path: "\(frameworkPath)/Sources",
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
    
    override var products: [Product] {
        [
            Product.library(
                name: mixboxName,
                type: .static,
                targets: targetNames
            )
        ]
    }
}

final class Executable: BaseSpec {
    var mainTarget: PackageDescription.Target {
        Target.executableTarget(
            name: mixboxName,
            dependencies: dependencies,
            path: "Frameworks/\(name)/Sources",
            swiftSettings: swiftSettings(),
            linkerSettings: linkedLibraries()
        )
    }
    
    var product: PackageDescription.Product {
        Product.executable(name: mixboxName, targets: [mixboxName])
    }
        
    override var products: [PackageDescription.Product] { [product] }
    override var targets: [PackageDescription.Target] { [mainTarget] }
}

// MARK: - ThirdParty -

struct ThirdParty {
    let package: Package.Dependency
    let target: Target.Dependency
    
    static let GCDWebServer = ThirdParty(
        package: .package(
            url: "https://github.com/SlaunchaMan/GCDWebServer.git",
            revision: "5cc010813d797c3f40557c740a4f620bf84da4dd"
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

struct SourceryPackage {
    let package: Package.Dependency = .package(
        url: "ssh://git@stash.msk.avito.ru:7999/iedm/sourcery.git",
        revision: "0564feccdc8fade6c68376bdf7f8dab9b79863fe"
    )
    let framework: Target.Dependency = .product(name: "SourceryFramework", package: "Sourcery")
    let runtime: Target.Dependency = .product(name: "SourceryRuntime", package: "Sourcery")

    static let sourcery = SourceryPackage()
    
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

let mixboxMocksGeneration = MixboxFramework(
    name: "MocksGeneration",
    language: .swift,
    dependencies: [],
    customDependencies: [
        SourceryPackage.sourcery.runtime,
        SourceryPackage.sourcery.framework
    ]
)

final class MixboxTestsFoundation: BaseSpec {
    static let spec = MixboxTestsFoundation()
    
    init() {
        super.init(name: "TestsFoundation")
    }
    
    var objcTarget: Target {
        Target.target(
            name: mixboxNameObjc,
            dependencies: [],
            path: frameworkPath,
            exclude: [
                "\(objcSourcesFolder)/PrivateHeaders"
            ],
            sources: [ objcSourcesFolder ],
            publicHeadersPath: "PublicHeaders",
            cSettings: cSettings(),
            cxxSettings: cxxSettings(),
            swiftSettings: swiftSettings()
        )
    }
    
    var swiftTarget: Target {
        Target.target(
            name: mixboxName,
            dependencies: [
                mixboxIpcCommon.dependency,
                mixboxUiKit.dependency,
                mixboxBuiltinDi.dependency,
                ThirdParty.sqlite.target,
                .target(name: mixboxNameObjc)
            ],
            path: frameworkPath,
            exclude: [ objcSourcesFolder ],
            sources: [ "Sources" ],
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings()
        )
    }
    
    var product: Product {
        Product.library(
            name: mixboxName,
            type: .static,
            targets: [mixboxName, mixboxNameObjc]
        )
    }
    
    override var targets: [Target] { [objcTarget, swiftTarget] }
    override var products: [Product] { [product] }
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

final class MixboxIoKit: BaseSpec {
    static let spec = MixboxIoKit()
    
    init() {
        super.init(name: "IoKit")
    }
    
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
    
    var objcTarget: Target {
        Target.target(
            name: mixboxNameObjc,
            dependencies: [],
            path: frameworkPath,
            sources: objcSources,
            publicHeadersPath: ".",
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings()
        )
    }
    
    var swiftTarget: Target {
        Target.target(
            name: mixboxName,
            dependencies: [
                .target(name: mixboxNameObjc),
                mixboxFoundation.dependency
            ],
            path: frameworkPath,
            exclude: objcSources + excludeHeaders,
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings(),
            linkerSettings: [.linkedFramework("IOKit")]
        )
    }
    
    override var products: [Product] {
        [
            Product.library(
                name: mixboxName,
                type: .static,
                targets: [mixboxName, mixboxNameObjc])
        ]
    }
    override var targets: [Target] { [objcTarget, swiftTarget] }
    
}


final class MixboxInAppServices: BaseSpec {
    static let spec = MixboxInAppServices()
    
    init() {
        super.init(name: "InAppServices")
    }

//        ./Sources/Support/AccessibilityForTestAutomation/AccessibilityForTestAutomationInitializer/Implementation/ObjectiveC/AccessibilityUtilitiesAccessibilityInitializer/AccessibilityUtilitiesAccessibilityInitializer.m
//        ./Sources/Support/AccessibilityForTestAutomation/AccessibilityForTestAutomationInitializer/Implementation/ObjectiveC/UIAccessibilityAccessibilityInitializer/UIAccessibilityAccessibilityInitializer.m
//        ./Sources/Support/AccessibilityForTestAutomation/AccessibilityForTestAutomationInitializer/Implementation/ObjectiveC/LibAccessibilityAccessibilityInitializer/LibAccessibilityAccessibilityInitializer.m
    
    let objcSources: [String] = [
//            "Sources/Features/Keyboard/Testability/UIKeyboardLayout+Testability.m",
//            "Sources/Features/Keyboard/Testability/UIKeyboardLayout+Testability.h",
//            "Sources/Features/Keyboard/Testability/UIKBTree+Testability.m",
//            "Sources/Features/Keyboard/Testability/UIKBTree+Testability.h",
        "Sources/Support/SimulatorStateInitializer/TIPreferencesControllerObjCWrapper/TIPreferencesControllerObjCWrapper.m",
        "Sources/Support/SimulatorStateInitializer/TIPreferencesControllerObjCWrapper/TIPreferencesControllerObjCWrapper.h",
        "Sources/Support/AccessibilityForTestAutomation/AccessibilityForTestAutomationInitializer/Implementation/ObjectiveC",
        "Sources/Support/SimulatorStateInitializer/TIPreferencesControllerObjCWrapper"
    ]
    let excludeFiles: [String] = [
        "Sources/Features/AccessibilityEnchancement/Support/VisibilityChecker/VisibilityChecker.md"
    ]
    let animationDelegateSources: [String] = [
        "Sources/Features/WaitingForQuiescence/CoreAnimation/SurrogateCAAnimationDelegate/SurrogateCAAnimationDelegateObjC.m",
        "Sources/Features/WaitingForQuiescence/CoreAnimation/SurrogateCAAnimationDelegate/SurrogateCAAnimationDelegateObjC.h"
    ]
       
    var mixboxNameAnimationDelegate: String { mixboxName + "AnimationDelegate" }
        
    var objcTarget: Target {
        Target.target(
            name: mixboxNameObjc,
            dependencies: [mixboxTestability.dependency],
            path: frameworkPath,
            sources: objcSources,
            publicHeadersPath: ".",
            cSettings: defaultCSettings() + [.headerSearchPath("./**")],
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings()
        )
    }
    
    var swiftTarget: Target {
        Target.target(
            name: mixboxName,
            dependencies: [
                .target(name: mixboxNameObjc),
                mixboxIpc.dependency,
                mixboxIpcCommon.dependency,
                mixboxFoundation.dependency,
                mixboxTestability.dependency,
                mixboxUiKit.dependency,
                MixboxIoKit.spec.dependency,
                mixboxBuiltinDi.dependency,
                mixboxDi.dependency,
                mixboxBuiltinIpc.dependency,
                mixboxIpcSbtuiHost.dependency
            ],
            path: frameworkPath,
            exclude: objcSources + excludeFiles + animationDelegateSources,
            sources: [ "Sources" ],
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings(),
            linkerSettings: [.linkedFramework("IOKit")]
        )
    }
    
    var animationDelegateTarget: Target {
        Target.target(
            name: mixboxNameAnimationDelegate,
            dependencies: [
                .target(name: mixboxName),
            ],
            path: frameworkPath,
            sources: animationDelegateSources,
            publicHeadersPath: ".",
            cSettings: defaultCSettings(),
            cxxSettings: defaultCXXSettings(),
            swiftSettings: defaultSwiftSettings()
        )
    }
    
    override var products: [Product] {
        [
            Product.library(
                name: mixboxName,
                type: .static,
                targets: [mixboxName, mixboxNameObjc, mixboxNameAnimationDelegate]
            )
        ]
    }
    override var targets: [Target] { [objcTarget, swiftTarget, animationDelegateTarget] }
}

let mixboxTestability = MixboxFramework(
    name: "Testability",
    language: .mixed,
    dependencies: [mixboxFoundation, mixboxUiKit]
)

let mixboxStubbing = MixboxFramework(
    name: "Stubbing",
    language: .swift,
    dependencies: [
        MixboxTestsFoundation.spec,
        mixboxGenerators
    ]
)

let mixboxMocksRuntime = MixboxFramework(
    name: "MocksRuntime",
    language: .swift,
    dependencies: [MixboxTestsFoundation.spec, mixboxGenerators]
)

let mixboxMocksGenerator = Executable(name: "MocksGenerator", dependencies: [mixboxMocksGeneration])


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
    mixboxTestability,
    mixboxFakeSettingsAppMain,
    MixboxInAppServices.spec,
    mixboxMocksGeneration,
    mixboxStubbing,
    mixboxMocksRuntime,
    mixboxMocksGenerator
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
    mixboxTestability,
    MixboxInAppServices.spec,
    mixboxFakeSettingsAppMain,
    mixboxMocksGeneration,
    mixboxStubbing,
    mixboxMocksRuntime,
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
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: products,
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", exact: "0.30.1"),
        ThirdParty.GCDWebServer.package,
        ThirdParty.sqlite.package,
        SourceryPackage.sourcery.package,
    ],
    targets: targets
)

// swiftlint:enable all
