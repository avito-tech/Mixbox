#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation
import CoreLocation
import MixboxInAppServices_objc

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
