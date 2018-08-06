import Foundation

public final class TccPrivacySettingsManager {
    private let tccDbFinder = TccDbFinder()
    private let bundleId: String
    
    public init(bundleId: String) {
        self.bundleId = bundleId
    }
    
    private func tccDb() -> TccDb? {
        guard let tccDbPath = tccDbFinder.tccDbPath() else {
            return nil
        }
        
        return try? TccDb(path: tccDbPath)
    }
    
    public func fetchPrivacySettingsState(service: ServiceWithPrivacySettings) -> ServiceWithPrivacySettingsState? {
        guard let db = tccDb() else {
            return nil
        }
        
        let service = tccService(service: service)
        
        do {
            return try db.getAccess(service: service, bundleId: bundleId)
        } catch {
            return nil
        }
    }
    
    public func updatePrivacySettings(
        service: ServiceWithPrivacySettings,
        state: ServiceWithPrivacySettingsState)
        -> Bool
    {
        guard let db = tccDb() else {
            return false
        }
        
        let service = tccService(service: service)
        
        do {
            switch state {
            case .allowed:
                try db.setAccess(service: service, bundleId: bundleId, isAllowed: true)
            case .denied:
                try db.setAccess(service: service, bundleId: bundleId, isAllowed: false)
            case .notDetermined:
                try db.resetAccess(service: service, bundleId: bundleId)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func tccService(service: ServiceWithPrivacySettings) -> TccService {
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
