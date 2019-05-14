import MixboxFoundation

public final class TccPrivacySettingsManagerImpl: TccPrivacySettingsManager {
    private let bundleId: String
    private let tccDbFinder: TccDbFinder
    
    public init(bundleId: String, tccDbFinder: TccDbFinder) {
        self.bundleId = bundleId
        self.tccDbFinder = tccDbFinder
    }
    
    // MARK: - TccPrivacySettingsManager
    
    public func fetchPrivacySettingsState(
        service: TccService)
        throws
        -> TccServicePrivacyState
    {
        let db = try tccDb()
        
        let serviceId = tccServiceId(service: service)
        
        return try db.getAccess(serviceId: serviceId, bundleId: bundleId)
    }
    
    public func updatePrivacySettings(
        service: TccService,
        state: TccServicePrivacyState)
        throws
    {
        do {
            let db = try tccDb()
            
            let serviceId = tccServiceId(service: service)
            
            switch state {
            case .allowed:
                try db.setAccess(serviceId: serviceId, bundleId: bundleId, isAllowed: true)
            case .denied:
                try db.setAccess(serviceId: serviceId, bundleId: bundleId, isAllowed: false)
            case .notDetermined:
                try db.resetAccess(serviceId: serviceId, bundleId: bundleId)
            }
        } catch {
            throw ErrorString("Can not updatePrivacySettings: \(error)")
        }
    }
    
    // MARK: - Private
    
    private func tccDb() throws -> TccDb {
        let tccDbPath = try tccDbFinder.tccDbPath()
        
        return try TccDb(path: tccDbPath)
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    private func tccServiceId(service: TccService) -> TccDbServiceId {
        switch service {
        case .calendar:
            return .calendar
        case .camera:
            return .camera
        case .mso:
            return .mso
        case .mediaLibrary:
            return .mediaLibrary
        case .microphone:
            return .microphone
        case .motion:
            return .motion
        case .photos:
            return .photos
        case .reminders:
            return .reminders
        case .siri:
            return .siri
        case .willow:
            return .willow
        case .addressBook:
            return .addressBook
        case .bluetoothPeripheral:
            return .bluetoothPeripheral
        case .calls:
            return .calls
        case .facebook:
            return .facebook
        case .keyboardNetwork:
            return .keyboardNetwork
        case .liverpool:
            return .liverpool
        case .shareKit:
            return .shareKit
        case .sinaWeibo:
            return .sinaWeibo
        case .speechRecognition:
            return .speechRecognition
        case .tencentWeibo:
            return .tencentWeibo
        case .twitter:
            return .twitter
        case .ubiquity:
            return .ubiquity
        }
    }
}
