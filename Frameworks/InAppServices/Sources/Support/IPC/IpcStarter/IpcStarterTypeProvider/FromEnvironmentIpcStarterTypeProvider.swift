#if MIXBOX_ENABLE_IN_APP_SERVICES

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
