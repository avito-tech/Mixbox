#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import MixboxIpcCommon

public final class FromEnvironmentIpcStarterTypeProvider: IpcStarterTypeProvider {
    private let environmentProvider: EnvironmentProvider
    
    public init(environmentProvider: EnvironmentProvider) {
        self.environmentProvider = environmentProvider
    }
    
    public func ipcStarterType() throws -> IpcStarterType {
        let environmentVariableName = "MIXBOX_IPC_STARTER_TYPE"
        
        if let typeString = environmentProvider.environment[environmentVariableName], !typeString.isEmpty {
            guard let type = IpcStarterType(rawValue: typeString) else {
                throw ErrorString(
                    """
                    Unknown IpcStarterType: \(typeString) in \(environmentVariableName) environment variable
                    """
                )
            }
            
            return type
        } else {
            throw ErrorString(
                """
                \(type(of: self)) can't provide `ipcStarterType`: \
                \(environmentVariableName) environment variable was not set")
                """
            )
        }
    }
}

#endif
