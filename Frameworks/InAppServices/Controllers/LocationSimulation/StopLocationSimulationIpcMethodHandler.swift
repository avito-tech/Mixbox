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
