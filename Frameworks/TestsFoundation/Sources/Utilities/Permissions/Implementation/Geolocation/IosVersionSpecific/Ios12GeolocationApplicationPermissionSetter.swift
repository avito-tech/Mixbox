import MixboxFoundation

public final class Ios12GeolocationApplicationPermissionSetter: ApplicationPermissionSetter {
    private let bundleId: String
    private let currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider
    private let testFailureRecorder: TestFailureRecorder
    private let clientsPlistPathRelativePath = "data/Library/Caches/locationd/clients.plist"
    private let clLocationManagerAuthorizationStatusWaiter: ClLocationManagerAuthorizationStatusWaiter
    private let allowedDeniedNotDeterminedStateToClAuthorizationStatusConverter = AllowedDeniedNotDeterminedStateToClAuthorizationStatusConverter()
    
    public init(
        bundleId: String,
        currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider,
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter)
    {
        self.bundleId = bundleId
        self.currentSimulatorFileSystemRootProvider = currentSimulatorFileSystemRootProvider
        self.testFailureRecorder = testFailureRecorder
        self.clLocationManagerAuthorizationStatusWaiter = ClLocationManagerAuthorizationStatusWaiter(waiter: waiter)
    }
    
    public func set(_ state: AllowedDeniedNotDeterminedState) {
        do {
            try setStateOrThrowError(state: state)
        } catch {
            testFailureRecorder.recordFailure(
                description: "Failed to set geolocation permission state \(state): \(error)",
                shouldContinueTest: false
            )
        }
    }
    
    private func setStateOrThrowError(state: AllowedDeniedNotDeterminedState) throws {
        let plistPath = try currentSimulatorFileSystemRootProvider
            .currentSimulatorFileSystemRoot()
            .osxPath(clientsPlistPathRelativePath)
        
        let oldPlist = try getPlist(path: plistPath)
        
        let newPlist = try patchedClientsPlist(
            clientsPlist: oldPlist,
            state: state
        )
        
        try savePlist(
            plist: newPlist,
            path: plistPath
        )
        
        CLLocationManager.shutdownDaemon()
        
        let authorizationStatus = allowedDeniedNotDeterminedStateToClAuthorizationStatusConverter
            .clAuthorizationStatus(state: state)
        
        clLocationManagerAuthorizationStatusWaiter.wait(
            authorizationStatus: authorizationStatus,
            bundleId: bundleId
        )
    }
    
    private func patchedClientsPlist(
        clientsPlist: NSDictionary,
        state: AllowedDeniedNotDeterminedState)
        throws
        -> NSDictionary
    {
        let clientsPlist = NSMutableDictionary(dictionary: clientsPlist)
        
        let patchedSettings = patchedPlistAppSettings(
            state: state,
            existingSettings: clientsPlist.object(forKey: bundleId) as? [String: Any]
        )
        
        clientsPlist.setValue(patchedSettings, forKey: bundleId)
        
        return clientsPlist
    }
    
    private func savePlist(plist: NSDictionary, path: String) throws {
        if !plist.write(toFile: path, atomically: true) {
            throw ErrorString("Failed to write plist to \(path)")
        }
    }
    
    private func getPlist(path: String) throws -> NSDictionary {
        guard let clientsPlist = NSDictionary(contentsOfFile: path) else {
            throw ErrorString("Couldn't load plist from \(path)")
        }
        
        return clientsPlist
    }
    
    private func patchedPlistAppSettings(
        state: AllowedDeniedNotDeterminedState,
        existingSettings: [String: Any]?)
         -> [String: Any]
    {
        switch state {
        case .allowed:
            return determinedClientsPlistAppSettings(authorization: 2, existingSettings: existingSettings)
        case .denied:
            return determinedClientsPlistAppSettings(authorization: 1, existingSettings: existingSettings)
        case .notDetermined:
            return notDeterminedClientsPlistAppSettings()
        }
    }
    
    private func determinedClientsPlistAppSettings(
        authorization: Int,
        existingSettings: [String: Any]?)
        -> [String: Any]
    {
        var settings = existingSettings ?? [:]
        
        settings["Authorization"] = authorization
        settings["BundleId"] = bundleId
        settings["Executable"] = ""
        settings["Registered"] = ""
        settings["SupportedAuthorizationMask"] = 3
        settings["Whitelisted"] = false
        
        settings["InUseLevel"] = nil
        
        return settings
    }
    
    private func notDeterminedClientsPlistAppSettings() -> [String: Any] {
        return [
            "InUseLevel": 4, // I do not know what it means, but it was on FS in .notDetermined state.
            "SupportedAuthorizationMask": 3 // I do not know what it means, but it was on FS in .notDetermined state.
        ]
    }
}
