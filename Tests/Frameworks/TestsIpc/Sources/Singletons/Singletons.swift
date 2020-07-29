import MixboxFoundation

// Singletons are necessary, because we have 2 entry points:
// - PrincipalClass (entry and exit of test bundle)
// - TestCase's (entry and exit of test methods)
//
// Do not add here anything that can be initialized in a single entry point.
//
// NOTE: This class was split into extensions, see extensions
//
public final class Singletons {
    public static let environmentProvider: EnvironmentProvider = makeEnvironmentProvider()
    
    private static func makeEnvironmentProvider() -> EnvironmentProvider {
        let environmentProvider = ProcessInfoEnvironmentProvider(
            processInfo: ProcessInfo.processInfo
        )
        
        let isRunningFromXcode: Bool = ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] != nil
        
        if isRunningFromXcode {
            return DebugEnvironmentProvider(
                originalEnvironmentProvider: environmentProvider
            )
        } else {
            return environmentProvider
        }
    }
}
