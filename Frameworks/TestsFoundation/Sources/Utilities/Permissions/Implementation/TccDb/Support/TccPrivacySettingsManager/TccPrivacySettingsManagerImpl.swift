import MixboxFoundation

public final class TccPrivacySettingsManagerImpl: TccPrivacySettingsManager {
    private let bundleId: String
    private let tccDbFactory: TccDbFactory
    
    public init(
        bundleId: String,
        tccDbFactory: TccDbFactory)
    {
        self.bundleId = bundleId
        self.tccDbFactory = tccDbFactory
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
            case .selectedPhotos:
                throw ErrorString("Setting state \(state) is not supported")
            }
        } catch {
            throw ErrorString(
                """
                Failed to call `\(type(of: self)).updatePrivacySettings(\
                service: \(service), \
                state: \(state))`\
                : \(error)
                """
            )
        }
    }
    
    // MARK: - Private
    
    private func tccDb() throws -> TccDb {
        return try tccDbFactory.tccDb()
    }
    
    // swiftlint:disable:next cyclomatic_complexity
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
