public final class FrameworkInfosProviderImpl: FrameworkInfosProvider {
    public init() {
    }
    
    // swiftlint:disable:next function_body_length
    public func frameworkInfos() -> [FrameworkInfo] {
        return [
            FrameworkInfo(
                name: "AnyCodable",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "Black",
                needsIfs: false
            ),
            FrameworkInfo(
                name: "BuiltinIpc",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "Di",
                needsIfs: false
            ),
            FrameworkInfo(
                name: "FakeSettingsAppMain",
                needsIfs: false
            ),
            FrameworkInfo(
                name: "Foundation",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "Gray",
                needsIfs: false
            ),
            FrameworkInfo(
                name: "InAppServices",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "Ipc",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "IpcCommon",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "IpcSbtuiClient",
                needsIfs: false
            ),
            FrameworkInfo(
                name: "IpcSbtuiHost",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "Testability",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "TestsFoundation",
                needsIfs: false
            ),
            FrameworkInfo(
                name: "UiKit",
                needsIfs: true
            ),
            FrameworkInfo(
                name: "UiTestsFoundation",
                needsIfs: false
            )
        ]
    }
}
