#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Dispatch
import MixboxIpcCommon
import MixboxIpc

public final class StopLocationSimulationIpcMethodHandler: IpcMethodHandler {
    public let method = StopLocationSimulationIpcMethod()
    
    private let locationSimulationManager: LocationSimulationManager
    
    public init(locationSimulationManager: LocationSimulationManager) {
        self.locationSimulationManager = locationSimulationManager
    }
    
    public func handle(arguments: IpcVoid, completion: @escaping (IpcVoid) -> ()) {
        DispatchQueue.main.async { [locationSimulationManager] in
            locationSimulationManager.stopLocationSimulation()
            locationSimulationManager.clearSimulatedLocations()
            locationSimulationManager.flush()
            
            completion(IpcVoid())
        }
    }
}

#endif
