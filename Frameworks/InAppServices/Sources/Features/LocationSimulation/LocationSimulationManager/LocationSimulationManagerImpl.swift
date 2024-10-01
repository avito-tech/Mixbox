#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import CoreLocation
#if SWIFT_PACKAGE
import MixboxInAppServicesObjc
#endif

public final class LocationSimulationManagerImpl: LocationSimulationManager {
    private let manager: CLSimulationManager = CLSimulationManager()
    
    public init() {}
    
    public func startLocationSimulation() {
        manager.startLocationSimulation()
    }
    
    public func stopLocationSimulation() {
        manager.stopLocationSimulation()
    }
    
    public func appendSimulatedLocation(_ location: CLLocation) {
        manager.appendSimulatedLocation(location)
    }
    
    public func clearSimulatedLocations() {
        manager.clearSimulatedLocations()
    }
    
    public func flush() {
        manager.flush()
    }
}

#endif
