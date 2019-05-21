import Simctl
import Bash
import CiFoundation

public final class SimulatorUtils {
    private static let simctl = DelegatingSimctl(
        simctlList: SimctlListImpl(bashExecutor: bashExecutor),
        simctlBoot: SimctlBootImpl(bashExecutor: bashExecutor),
        simctlShutdown: SimctlShutdownImpl(bashExecutor: bashExecutor),
        simctlCreate: SimctlCreateImpl(bashExecutor: bashExecutor)
    )
    
    public static func shutdownDevices() throws {
        try simctl.shutdown(device: "all")
    }
    
    // TODO: Test with different simctl versions. There was a bug.
    public static func destinationDeviceUdid() throws -> String? {
        let testDestination = try DestinationUtils.destination().testDestination
        
        let name = testDestination.deviceType
        
        let devices = try self.devices(matching: testDestination)
        
        return devices
            .first { $0.name == name }
            .map { $0.udid }
    }
    
    private static func devices(matching testDestination: TestDestination) throws -> [Device] {
        let list = try simctl.list()
        
        if let devices = list.devices[testDestination.runtimeId] {
            // Xcode 10.2.1
            // simctl: @(#)PROGRAM:simctl  PROJECT:CoreSimulator-587.35
            
            return devices
        } else if let devices = list.devices["iOS \(testDestination.iOSVersionShort)"] {
            // Xcode 10.1
            // simctl: @(#)PROGRAM:simctl  PROJECT:CoreSimulator-581.2
            
            return devices
        } else {
            return []
        }
    }
    
    public static func bootDevice() throws {
        guard let udid = try SimulatorUtils.destinationDeviceUdid() else {
            throw ErrorString("destinationDeviceUdid returned nothing, seems that simulator was not created automatically")
        }
        
        try simctl.boot(device: udid)
    }
    
    public static func setUpSimulatorIfNeeded() throws {
        let simulatorExists = try SimulatorUtils.destinationDeviceUdid() != nil
        
        if !simulatorExists {
            try setUpSimulator()
        }
    }
    
    public static func setUpSimulator() throws {
        let testDestination = try DestinationUtils.destination().testDestination
        
        try simctl.create(
            name: testDestination.deviceType,
            deviceTypeIdentifier: testDestination.deviceTypeId,
            runtimeId: testDestination.runtimeId
        )
    }
}
