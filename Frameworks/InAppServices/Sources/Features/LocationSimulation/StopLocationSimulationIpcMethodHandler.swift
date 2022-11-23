#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxIpcCommon
import CoreLocation

final class SimulateLocationIpcMethodHandler: IpcMethodHandler {
    let method = SimulateLocationIpcMethod()
    
    func handle(arguments: SimulateLocationIpcMethod.Arguments, completion: @escaping (IpcVoid) -> ()) {
        DispatchQueue.main.async {
            let location = CLLocation(
                latitude: arguments.latitude,
                longitude: arguments.longitude
            )
            
            LocationSimulationManager.shared.stopLocationSimulation()
            LocationSimulationManager.shared.clearSimulatedLocations()
            LocationSimulationManager.shared.appendSimulatedLocation(location)
            LocationSimulationManager.shared.flush()
            LocationSimulationManager.shared.startLocationSimulation()
            
            completion(IpcVoid())
        }
    }
}

final class StopLocationSimulationIpcMethodHandler: IpcMethodHandler {
    let method = StopLocationSimulationIpcMethod()
    
    func handle(arguments: IpcVoid, completion: @escaping (IpcVoid) -> ()) {
        DispatchQueue.main.async {
            LocationSimulationManager.shared.stopLocationSimulation()
            LocationSimulationManager.shared.clearSimulatedLocations()
            LocationSimulationManager.shared.flush()
            
            completion(IpcVoid())
        }
    }
}

#endif
