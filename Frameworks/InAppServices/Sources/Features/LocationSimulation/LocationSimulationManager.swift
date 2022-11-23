#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import CoreLocation

final class LocationSimulationManager {
    
    static let shared: LocationSimulationManager = LocationSimulationManager()
    
    private let manager: CLSimulationManager = CLSimulationManager()
    
    private init() {}
    
    func startLocationSimulation() {
        manager.startLocationSimulation()
    }
    
    func stopLocationSimulation() {
        manager.stopLocationSimulation()
    }
    
    func appendSimulatedLocation(_ location: CLLocation) {
        manager.appendSimulatedLocation(location)
    }
    
    func clearSimulatedLocations() {
        manager.clearSimulatedLocations()
    }
    
    func flush() {
        manager.flush()
    }
}

#endif
