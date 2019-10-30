// This info (`FrameworkInfo`) is used to check that no testing code leaks to production,
// if it is accidentally linked in release build. It acts as an additional protective measure.
//
// Example: `InAppServices` is linked to app directly. Every source inside this framework should contain
// `#if MIXBOX_ENABLE_IN_APP_SERVICES` + `#endif` to disable compilation if it is accidentally linked in release.
//
// So `requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds` is `true`.
//
// `Foundation` is a dependency of `InAppServices`. So the bool should be also `true`
//
// Note that ideally there should be runtime generation of graph of dependencies and only leaves should be marked
// as frameworks that are linked to app - `InAppServices` & `Testability`. But a hardcoded bool works kind of okay.
//
public final class FrameworkInfosProviderImpl: FrameworkInfosProvider {
    public init() {
    }
    
    // swiftlint:disable:next function_body_length
    public func frameworkInfos() -> [FrameworkInfo] {
        return [
            FrameworkInfo(
                name: "AnyCodable",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "Black",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: false
            ),
            FrameworkInfo(
                name: "BuiltinIpc",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "Di",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: false
            ),
            FrameworkInfo(
                name: "FakeSettingsAppMain",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: false
            ),
            FrameworkInfo(
                name: "Foundation",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "Gray",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: false
            ),
            FrameworkInfo(
                name: "InAppServices",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "Ipc",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "IpcCommon",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "IpcSbtuiClient",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: false
            ),
            FrameworkInfo(
                name: "IpcSbtuiHost",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "Testability",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "TestsFoundation",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: false
            ),
            FrameworkInfo(
                name: "UiKit",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
            ),
            FrameworkInfo(
                name: "UiTestsFoundation",
                requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: false
            )
        ]
    }
}
