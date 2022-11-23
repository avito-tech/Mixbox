#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxFoundation
import MixboxIpcCommon

class FromEnvironmentIpcStarterProvider: IpcStarterProvider {
    private let synchronousIpcClientFactory: SynchronousIpcClientFactory
    private let environmentProvider: EnvironmentProvider
    private let ipcStarterTypeProvider: IpcStarterTypeProvider
    
    init(
        synchronousIpcClientFactory: SynchronousIpcClientFactory,
        environmentProvider: EnvironmentProvider,
        ipcStarterTypeProvider: IpcStarterTypeProvider)
    {
        self.synchronousIpcClientFactory = synchronousIpcClientFactory
        self.environmentProvider = environmentProvider
        self.ipcStarterTypeProvider = ipcStarterTypeProvider
    }
    
    func ipcStarter() throws -> IpcStarter {
        let environment = environmentProvider.environment
        
        switch try ipcStarterTypeProvider.ipcStarterType() {
        case .blackbox:
            let testRunnerHostVariableName = "MIXBOX_HOST"
            let testRunnerPortVariableName = "MIXBOX_PORT"
            
            if let testRunnerHost = environment[testRunnerHostVariableName],
                let testRunnerPort = environment[testRunnerPortVariableName].flatMap({ UInt($0) })
            {
                return BuiltinIpcStarter(
                    testRunnerHost: testRunnerHost,
                    testRunnerPort: testRunnerPort,
                    synchronousIpcClientFactory: synchronousIpcClientFactory
                )
            } else {
                throw ErrorString(
                    """
                    \(type(of: self)) requires both \(testRunnerHostVariableName) and \
                    \(testRunnerPortVariableName) environment variables to be set for \(IpcStarterType.blackbox)
                    """
                )
            }
        case .sbtui:
            return SbtuiIpcStarter(
                reregisterMethodHandlersAutomatically: environment["MIXBOX_REREGISTER_SBTUI_IPC_METHOD_HANDLERS_AUTOMATICALLY"] == "true",
                synchronousIpcClientFactory: synchronousIpcClientFactory
            )
        case .graybox:
            return GrayBoxIpcStarter(
                synchronousIpcClientFactory: synchronousIpcClientFactory
            )
        }
    }
}

#endif
