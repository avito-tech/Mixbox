// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Mixbox",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(name: "MixboxAnyCodable", targets: [ "MixboxAnyCodable" ]),
        .library(name: "MixboxBlack", targets: ["MixboxBlack"]),
        .library(name: "MixboxBuiltinIpc", targets: ["MixboxBuiltinIpc"]),
        .library(name: "MixboxDi", targets: ["MixboxDi"]),
        .library(name: "MixboxFakeSettingsAppMain", targets: ["MixboxFakeSettingsAppMain"]),
        .library(name: "MixboxFoundation", targets: ["MixboxFoundation"]),
        .library(name: "MixboxGenerator", targets: ["MixboxGenerator"]),
        .library(name: "MixboxGray", targets: ["MixboxGray"]),
        .library(name: "MixboxInAppServices", targets: ["MixboxInAppServices"]),
        .library(name: "MixboxIoKit", targets: ["MixboxIoKit"]),
        .library(name: "MixboxIpc", targets: ["MixboxIpc"]),
        .library(name: "MixboxIpcCommon", targets: ["MixboxIpcCommon"]),
        .library(name: "MixboxIpcSbtuiClient", targets: ["MixboxIpcSbtuiClient"]),
        .library(name: "MixboxIpcSbtuiHost", targets: ["MixboxIpcSbtuiHost"]), 
        .library(name: "MixboxTestability", targets: ["MixboxTestability"]),
        .library(name: "MixboxTestsFoundation", targets: ["MixboxTestsFoundation"]),
        .library(name: "MixboxUiKit", targets: ["MixboxUiKit"]),
        .library(name: "MixboxUiTestsFoundation", targets: ["MixboxUiTestsFoundation"]),
    ],
    dependencies: [
            .package(url: "https://github.com/AliSoftware/Dip", from: Version(7, 1, 1)),
            .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.0"),
            .package(name: "CocoaImageHashing", url: "https://github.com/ameingast/cocoaimagehashing.git", from: "1.8.0"),
            .package(url: "https://github.com/antigp/SBTUITestTunnel.git", .branch("spm_3.0.6")),
            .package(name: "GCDWebServer", url: "https://github.com/SlaunchaMan/GCDWebServer.git",.branch("swift-package-manager")),
    ],
    targets: [  
        .target(
            name: "MixboxAnyCodable",
            dependencies: [],
            path: "Frameworks/AnyCodable",
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES")
            ]
        ),
        .target(name: "MixboxBlack_objc",
                dependencies: [
                    .target(name: "MixboxUiTestsFoundation"),
                    .target(name: "MixboxIpcSbtuiClient"),
                    .target(name: "MixboxDi")
            ],  path: "Frameworks/Black",
                sources: ["Utils/ActionDependencies/EventGenerator/XcuiEventGeneratorObjC"],
                publicHeadersPath: ".",
                cSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                cxxSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                swiftSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))]),
        .target(name: "MixboxBlack",
                dependencies: [
            .target(name: "MixboxUiTestsFoundation"),
            .target(name: "MixboxIpcSbtuiClient"),
            .target(name: "MixboxDi"),
            .target(name: "MixboxBlack_objc")
            ],  path: "Frameworks/Black",
                exclude: ["Utils/ActionDependencies/EventGenerator/XcuiEventGeneratorObjC"],
                cSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                cxxSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                swiftSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))]),
        .target(name: "MixboxBuiltinIpc_objc", dependencies: [
            .target(name: "MixboxIpc"),
                "GCDWebServer"
            ],
                path: "Frameworks/BuiltinIpc",
                sources: ["Sources/Server/GCDWebServerErrorResponse+Swift.m"]
        ),
        .target(name: "MixboxBuiltinIpc", dependencies: [
            .target(name: "MixboxIpc"),
            "GCDWebServer",
            .target(name: "MixboxBuiltinIpc_objc")
            ],
                path: "Frameworks/BuiltinIpc",
                exclude: ["Sources/Server/GCDWebServerErrorResponse+Swift.m"],
                swiftSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES"),
                    .define("SWIFT_PACKAGE")
        ]),
        .target(name: "MixboxDi",
                dependencies: [
                    "Dip",
                    .target(name: "MixboxFoundation")
            ],  path: "Frameworks/Di"),
        .target(name: "MixboxFakeSettingsAppMain",
                dependencies: [
                    "Dip",
                    .target(name: "MixboxFoundation"),
        ],  path: "Frameworks/FakeSettingsAppMain"),
        .target(name: "MixboxFoundation_objc",
                dependencies: [
            ],
                path: "Frameworks/Foundation/ObjCSource",
                cSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                cxxSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                swiftSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))]
        ),
        
        .target(name: "MixboxFoundation",
                dependencies: [
                    .target(name: "MixboxFoundation_objc")
                ],
                path: "Frameworks/Foundation",
                exclude: ["ObjCSource"],
                cSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
                ],
                cxxSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
                ],
                swiftSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))],
                linkerSettings: [.linkedFramework("Foundation")] ), 
        .target(name: "MixboxGenerator",
                dependencies: [
                    .target(name: "MixboxDi")
            ],  path: "Frameworks/Generator"),
        .target(name: "MixboxGray",
                dependencies: [
                    .target(name: "MixboxUiTestsFoundation"),
                    .target(name: "MixboxUiKit"),
                    .target(name: "MixboxInAppServices"),
                    .target(name: "MixboxDi"),
                    .target(name: "MixboxGray_objc")
            ],  path: "Frameworks/Gray",
                exclude: ["Utils/PrivateHeaders"],
                cSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "TRUE", .when(platforms: nil, configuration: .debug)),
                    .define("ENABLE_TESTING_SEARCH_PATHS", to: "TRUE")
            ], swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))]),
        .target(name: "MixboxGray_objc",
                dependencies: [
                    .target(name: "MixboxUiTestsFoundation"),
                    .target(name: "MixboxUiKit"),
                    .target(name: "MixboxInAppServices"),
                    .target(name: "MixboxDi"),
            ],  path: "Frameworks/Gray",
                sources: ["Utils/PrivateHeaders"],
                publicHeadersPath: ".",
                cSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "TRUE", .when(platforms: nil, configuration: .debug)),
                    .define("ENABLE_TESTING_SEARCH_PATHS", to: "TRUE")
            ], swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))]),
        
        .target(name: "MixboxInAppServices_objc",
                dependencies: [
                    .target(name: "MixboxIpcCommon"),
                    .target(name: "MixboxTestability"),
                    .target(name: "MixboxIpcSbtuiHost"),
                    .target(name: "MixboxBuiltinIpc"),
                    .target(name: "MixboxIoKit"),
                    .target(name: "MixboxIoKit_objc")
        ],  path: "Frameworks/InAppServices",
            sources: ["Support/IPC/IpcStarter/Graybox/PrivateApi/AccessibilityOnSimulatorInitializer.m",
                      "Features/AccessibilityEnchancement/Support/VisibilityChecker/CGGeometry+Extensions.m",
                      "Features/AccessibilityEnchancement/Support/VisibilityChecker/ScreenshotUtil.m",
                      "Features/AccessibilityEnchancement/Support/VisibilityChecker/UIView+Extensions.m",
                      "Features/AccessibilityEnchancement/Support/VisibilityChecker/VisibilityChecker.m",
                      "Features/AccessibilityEnchancement/Support/VisibilityChecker/WindowProvider.m"
        ], publicHeadersPath: "."),
        
        .target(name: "MixboxInAppServices",
                dependencies: [
                    .target(name: "MixboxIpcCommon"),
                    .target(name: "MixboxTestability"),
                    .target(name: "MixboxIpcSbtuiHost"),
                    .target(name: "MixboxBuiltinIpc"),
                    .target(name: "MixboxIoKit"),
                    .target(name: "MixboxInAppServices_objc"),
                    .target(name: "MixboxUiKit"),
                    .target(name: "MixboxIoKit_objc")
            ],  path: "Frameworks/InAppServices",
                exclude: ["Support/IPC/IpcStarter/Graybox/PrivateApi/AccessibilityOnSimulatorInitializer.m",
                          "Features/AccessibilityEnchancement/Support/VisibilityChecker/CGGeometry+Extensions.m",
                          "Features/AccessibilityEnchancement/Support/VisibilityChecker/ScreenshotUtil.m",
                          "Features/AccessibilityEnchancement/Support/VisibilityChecker/UIView+Extensions.m",
                          "Features/AccessibilityEnchancement/Support/VisibilityChecker/VisibilityChecker.m",
                          "Features/AccessibilityEnchancement/Support/VisibilityChecker/WindowProvider.m"
            ],
                cSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
              cxxSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                swiftSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))],
                linkerSettings: [.linkedFramework("MixboxInAppServices_objc"), .linkedFramework("MixboxIoKit_objc")]),
                
        .target(name: "MixboxIoKit_objc",
                dependencies: [
                    .target(name: "MixboxFoundation"),
                    .target(name: "MixboxFoundation_objc") 
        ],  path: "Frameworks/IoKit/Sources",
            sources: ["IOKitExtensions/EnumRawValues.m",
                      "MBIohidEventSender/MBIohidEventSender.mm"],
            publicHeadersPath: "."
        ),
        .target(name: "MixboxIoKit",
                dependencies: [
                    .target(name: "MixboxFoundation"),
                    .target(name: "MixboxIoKit_objc")
        ],  path: "Frameworks/IoKit/Sources",
            exclude: ["IOKitExtensions/EnumRawValues.m",
                      "MBIohidEventSender/MBIohidEventSender.mm",
                      "PrivateApi"],
            cSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
            cxxSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))],
                linkerSettings: [.linkedFramework("IOKit")]),
        
        
        .target(name: "MixboxIpc",
                dependencies: [
                    .target(name: "MixboxFoundation")
        ],  path: "Frameworks/Ipc",
            cSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
            cxxSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))]
        ),
        .target(name: "MixboxIpcCommon",
                dependencies: [
                    .target(name: "MixboxIpc"),
                    .target(name: "MixboxAnyCodable")
        ],  path: "Frameworks/IpcCommon",
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))]),
        
        .target(name: "MixboxIpcSbtuiClient",
                dependencies: [
                    .target(name: "MixboxIpc"),
                    .product(name: "SBTUITestTunnelClient", package: "SBTUITestTunnel"),
                    .target(name: "MixboxTestsFoundation"),
                    .target(name: "MixboxUiTestsFoundation"),
            ],  path: "Frameworks/IpcSbtuiClient",
                cSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "TRUE", .when(platforms: nil, configuration: .debug)),
                    .define("ENABLE_TESTING_SEARCH_PATHS", to: "TRUE")
            ], swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES")
        ]),
        
        .target(name: "MixboxIpcSbtuiHost",
                dependencies: [
                    .target(name: "MixboxIpc"),
                    .product(name: "SBTUITestTunnelServer", package: "SBTUITestTunnel"),
            ],  path: "Frameworks/IpcSbtuiHost",
                swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES")
        ]),
        
        
        .target(name: "MixboxTestability_objc",
                dependencies: [
        ],  path: "Frameworks/Testability",
            sources: [
                "Sources/CommonValues/NSObject+Testability.m"
        ], publicHeadersPath: "."),
        .target(name: "MixboxTestability",
                dependencies: [
            .target(name: "MixboxTestability_objc")
        ],  path: "Frameworks/Testability",
            exclude: [
                "Sources/CommonValues/NSObject+Testability.m"
            ],
            cSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
            cxxSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES")
        ]),
          
        
        .target(name: "MixboxTestsFoundation_objc",
                dependencies: [
        ], path: "Frameworks/TestsFoundation",
           sources: ["ObjcSources"],
           publicHeadersPath: "PrivateHeaders",
           cSettings: [
            .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
           cxxSettings: [
            .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ]),
        .target(name: "MixboxTestsFoundation",
                dependencies: [
                    .target(name: "MixboxFoundation"),
                    .target(name: "MixboxUiKit"),
                    .target(name: "MixboxTestsFoundation_objc"),
                    .product(name: "SQLite", package: "SQLite.swift")
        ],  path: "Frameworks/TestsFoundation",
            exclude: ["ObjcSources", "PrivateHeaders"],
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))
        ]),
        
         
        
        .target(name: "MixboxUiKit",
                dependencies: [
                    .target(name: "MixboxFoundation"),
                    .product(name: "SBTUITestTunnelServer", package: "SBTUITestTunnel"),
            ],  path: "Frameworks/UiKit",
                cSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                cxxSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
                swiftSettings: [
                    .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))]),
        .target(name: "MixboxUiTestsFoundation",
                dependencies: [
                    .target(name: "MixboxTestsFoundation"),
                    .target(name: "MixboxUiKit"),
                    .target(name: "MixboxAnyCodable"),
                    "CocoaImageHashing",
                    .target(name: "MixboxIpcCommon"), 
                    .target(name: "MixboxDi")
        ],  path: "Frameworks/UiTestsFoundation",
            cSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
            cxxSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", to: "1", .when(platforms: nil, configuration: .debug))
            ],
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES", .when(platforms: nil, configuration: .debug))])
    ]
)
