import CoreLocation
import Foundation
import MixboxIpc
import MixboxIpcCommon

public protocol LocationSimulator: class {
    @discardableResult
    func simulate(location: CLLocation) -> Bool
    
    func clearSimulations()
}

public final class LocationSimulatorImpl: LocationSimulator {
    private let ipcClient: SynchronousIpcClient
    
    public init(ipcClient: SynchronousIpcClient) {
        self.ipcClient = ipcClient
    }
    
    @discardableResult
    public func simulate(location: CLLocation) -> Bool {
        let result = ipcClient.call(
            method: SimulateLocationIpcMethod(),
            arguments: SimulateLocationIpcMethod.Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        )
        return result.isData
    }
    
    public func clearSimulations() {
        _ = ipcClient.call(
            method: StopLocationSimulationIpcMethod()
        )
    }
}
