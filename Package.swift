// swift-tools-version:5.0

import PackageDescription

let frameworksByHavingMixedSources = [
    "AnyCodable": false,
    "Black": true,
    "BuiltinDi": false,
    "BuiltinIpc": true,
    "Di": false,
    "FakeSettingsAppMain": false,
    "Foundation": false,
    "Generators": false,
    "Gray": false,
    "InAppServices": true,
    "IoKit": true,
    "Ipc": false,
    "IpcCommon": false,
    "IpcSbtuiClient": false,
    "IpcSbtuiHost": false,
    "MocksRuntime": false,
    "Reflection": false,
    "Stubbing": false,
    "Testability": true,
    "TestsFoundation": true,
    "UiKit": false,
    "UiTestsFoundation": false
]

let frameworks = frameworksByHavingMixedSources
    .filter { framework, hasMixedSourced in !hasMixedSourced }
    .map { framework, _ in framework }

let package = Package(
    name: "Mixbox",
    products: frameworks.map {
        .library(name: "Mixbox\($0)", targets: [ "Mixbox\($0)" ])
    },
    targets: frameworks.map {
        .target(
            name: "Mixbox\($0)",
            dependencies: [],
            path: "Frameworks/\($0)",
            swiftSettings: [
                .define("MIXBOX_ENABLE_IN_APP_SERVICES")
            ]
        )
    }
)
