import Foundation

public final class EnvironmentSingletons {
    public static let isDebug: Bool = ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] != nil
    
    public static let environmentProvider: EnvironmentProvider = {
        let environmentProvider = ProcessInfoEnvironmentProvider(
            processInfo: ProcessInfo.processInfo
        )
        
        if isDebug {
            return DebugEnvironmentProvider(
                originalEnvironmentProvider: environmentProvider
            )
        } else {
            return environmentProvider
        }
    }()
}
