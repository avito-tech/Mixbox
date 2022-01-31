import Simctl
import Destinations
import CiFoundation
import Bash

public final class IosProjectBuilderImpl: IosProjectBuilder {
    private let xcodebuild: Xcodebuild
    private let simctlList: SimctlList
    private let simctlBoot: SimctlBoot
    private let simctlShutdown: SimctlShutdown
    private let simctlCreate: SimctlCreate
    
    public init(
        xcodebuild: Xcodebuild,
        simctlList: SimctlList,
        simctlBoot: SimctlBoot,
        simctlShutdown: SimctlShutdown,
        simctlCreate: SimctlCreate)
    {
        self.xcodebuild = xcodebuild
        self.simctlList = simctlList
        self.simctlBoot = simctlBoot
        self.simctlShutdown = simctlShutdown
        self.simctlCreate = simctlCreate
    }
    
    public func build(
        projectDirectoryFromRepoRoot: String,
        action: XcodebuildAction,
        scheme: String,
        workspaceName: String,
        destination: MixboxTestDestination)
        throws
        -> XcodebuildResult
    {
        try buildWithRetries {
            try xcodebuild.build(
               projectDirectoryFromRepoRoot: projectDirectoryFromRepoRoot,
               action: action,
               workspaceName: workspaceName,
               scheme: scheme,
               sdk: "iphonesimulator",
               destination: try xcodeDestination(destination: destination)
           )
        }
    }
    
    public func prepare(
        rebootSimulator: Bool,
        destination: MixboxTestDestination
    ) throws {
        let existingDestinationDeviceUdid = try destinationDeviceUdid(destination: destination)
        var shouldBootSimulator = false
        
        if let existingDestinationDeviceUdid = existingDestinationDeviceUdid {
            if rebootSimulator {
                // Improves stability of launching tests
                shutdownSimulator(deviceUdid: existingDestinationDeviceUdid)
                shouldBootSimulator = true
            }
        } else {
            try setUpSimulator(destination: destination)
        }

        if shouldBootSimulator {
            // This is done in background and prepares simulator
            try bootDevice(destination: destination)
        }
    }
    
    public func cleanUp(destination: MixboxTestDestination) throws {
        if let deviceUdid = try? destinationDeviceUdid(destination: destination) {
            shutdownSimulator(deviceUdid: deviceUdid)
        }
    }
    
    private func buildWithRetries<T>(attemptToBuild: () throws -> T) throws -> T {
        let numberOfAttempts = 5
        
        for _ in 0..<(numberOfAttempts - 1) {
            do {
                return try attemptToBuild()
            } catch let error as NonZeroExitCodeBashError {
                // Example:
                // ```
                // The requested device could not be found because no available devices matched the request.
                // ```
                let simulatorUnavailableError = XcodebuildExitCode.internalSoftwareError.rawValue
                
                if error.bashResult.code == simulatorUnavailableError {
                    continue
                } else {
                    throw error
                }
            }
        }
        
        return try attemptToBuild()
    }
    
    private func xcodeDestination(destination: MixboxTestDestination) throws -> String {
        guard let udid = try destinationDeviceUdid(destination: destination) else {
            throw ErrorString("destinationDeviceUdid returned nil")
        }
        
        return "id=\(udid)"
    }
    
    private func shutdownSimulator(deviceUdid: String) {
        // Ignore errors such as "Unable to shutdown device in current state: Shutdown"
        try? simctlShutdown.shutdown(device: deviceUdid)
    }

    private func setUpSimulator(destination: MixboxTestDestination) throws {
        try simctlCreate.create(
            name: simulatorName(destination: destination),
            deviceTypeIdentifier: destination.deviceTypeId,
            runtimeId: destination.runtimeId
        )
    }
    
    // TODO: Test with different simctl versions. There was a bug.
    private func destinationDeviceUdid(destination: MixboxTestDestination) throws -> String? {
        let name = simulatorName(destination: destination)

        let devices = try self.devices(matching: destination)

        return devices
            .first {
                $0.name == name
            }
            .map { $0.udid }
    }
    
    private func simulatorName(destination: MixboxTestDestination) -> String {
        return "Mixbox CI \(destination.deviceType) \(destination.iOSVersion)"
    }
    
    private func devices(matching destination: MixboxTestDestination) throws -> [Device] {
        let list = try simctlList.list()

        if let devices = list.devices[destination.runtimeId] {
            // Xcode 10.2.1
            // simctl: @(#)PROGRAM:simctl  PROJECT:CoreSimulator-587.35

            return devices
        } else if let devices = list.devices["iOS \(destination.iOSVersionShort)"] {
            // Xcode 10.1
            // simctl: @(#)PROGRAM:simctl  PROJECT:CoreSimulator-581.2

            return devices
        } else {
            return []
        }
    }
    
    private func bootDevice(destination: MixboxTestDestination) throws {
        guard let udid = try destinationDeviceUdid(destination: destination) else {
            throw ErrorString("destinationDeviceUdid returned nothing, seems that simulator was not created automatically")
        }

        try simctlBoot.boot(device: udid)
    }
}
