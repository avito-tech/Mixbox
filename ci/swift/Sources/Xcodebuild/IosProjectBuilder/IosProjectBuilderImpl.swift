import Simctl
import Destinations
import CiFoundation

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
        testDestination: MixboxTestDestination,
        xcodebuildPipeFilter: String)
        throws
        -> XcodebuildResult
    {
        return try xcodebuild.build(
            xcodebuildPipeFilter: xcodebuildPipeFilter,
            projectDirectoryFromRepoRoot: projectDirectoryFromRepoRoot,
            action: action,
            workspaceName: workspaceName,
            scheme: scheme,
            sdk: "iphonesimulator",
            destination: try xcodeDestination(testDestination: testDestination)
        )
    }
    
    public func prepareForIosTesting(rebootSimulator: Bool, testDestination: MixboxTestDestination) throws {
        if rebootSimulator {
            // Improves stability of launching tests
            try shutdownSimulators()
        }

        try setUpSimulatorIfNeeded(testDestination: testDestination)

        if rebootSimulator {
            // This is done in background and prepares simulator
            try bootDevice(testDestination: testDestination)
        }
    }
    
    public func cleanUpAfterIosTesting() throws {
        try shutdownSimulators()
    }
    
    private func xcodeDestination(testDestination: MixboxTestDestination) throws -> String {
        guard let udid = try destinationDeviceUdid(testDestination: testDestination) else {
            throw ErrorString("destinationDeviceUdid returned nil")
        }
        
        return "id=\(udid)"
    }
    
    private func shutdownSimulators() throws {
        try simctlShutdown.shutdown(device: "all")
    }
    
    private func setUpSimulatorIfNeeded(testDestination: MixboxTestDestination) throws {
        let simulatorExists = try destinationDeviceUdid(testDestination: testDestination) != nil

        if !simulatorExists {
            try setUpSimulator(testDestination: testDestination)
        }
    }

    private func setUpSimulator(testDestination: MixboxTestDestination) throws {
        try simctlCreate.create(
            name: testDestination.deviceType,
            deviceTypeIdentifier: testDestination.deviceTypeId,
            runtimeId: testDestination.runtimeId
        )
    }
    
    // TODO: Test with different simctl versions. There was a bug.
    private func destinationDeviceUdid(testDestination: MixboxTestDestination) throws -> String? {
        let name = testDestination.deviceType

        let devices = try self.devices(matching: testDestination)

        return devices
            .first { $0.name == name }
            .map { $0.udid }
    }
    
    private func devices(matching testDestination: MixboxTestDestination) throws -> [Device] {
        let list = try simctlList.list()

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
    
    private func bootDevice(testDestination: MixboxTestDestination) throws {
        guard let udid = try destinationDeviceUdid(testDestination: testDestination) else {
            throw ErrorString("destinationDeviceUdid returned nothing, seems that simulator was not created automatically")
        }

        try simctlBoot.boot(device: udid)
    }
}
