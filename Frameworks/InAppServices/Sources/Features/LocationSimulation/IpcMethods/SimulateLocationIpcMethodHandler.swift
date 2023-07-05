#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxIpcCommon
import CoreLocation

public final class SimulateLocationIpcMethodHandler: IpcMethodHandler {
    public let method = SimulateLocationIpcMethod()
    
    private let locationSimulationManager: LocationSimulationManager
    
    public init(locationSimulationManager: LocationSimulationManager) {
        self.locationSimulationManager = locationSimulationManager
    }
    
    public func handle(arguments: SimulateLocationIpcMethod.Arguments, completion: @escaping (IpcVoid) -> ()) {
        DispatchQueue.main.async { [locationSimulationManager] in
            let location = CLLocation(
                latitude: arguments.latitude,
                longitude: arguments.longitude
            )
            
            locationSimulationManager.stopLocationSimulation()
            locationSimulationManager.clearSimulatedLocations()
            locationSimulationManager.appendSimulatedLocation(location)
            locationSimulationManager.flush()
            locationSimulationManager.startLocationSimulation()
            
            completion(IpcVoid())
        }
    }
}

#endif
