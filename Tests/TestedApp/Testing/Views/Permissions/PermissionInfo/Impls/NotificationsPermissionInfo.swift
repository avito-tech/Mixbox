import Photos
import UserNotifications
import UIKit

final class NotificationsPermissionInfo: PermissionInfo {
    func identifier() -> String {
        return "notifications"
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func authorizationStatus() -> String {
        if #available(iOS 10.0, *) {
            let status = notificationSettings().authorizationStatus
            
            #if compiler(>=5.3)
            // Xcode 12+
            switch status {
            case .authorized:
                return "authorized"
            case .denied:
                return "denied"
            case .notDetermined:
                return "notDetermined"
            case .provisional:
                return "provisional"
            case .ephemeral:
                return "ephemeral"
            @unknown default:
                return "UNKNOWN: \(status)"
            }
            #else
            switch status {
            case .authorized:
                return "authorized"
            case .denied:
                return "denied"
            case .notDetermined:
                return "notDetermined"
            case .provisional:
                return "provisional"
            @unknown default:
                return "UNKNOWN: \(status)"
            }
            #endif
        } else {
            // We aren't sure if authorization status is `denied` or `notDetermined`,
            // but we can set only `denied` state and in tests we check only `denied` state.
            // I think it is okay for testing iOS 9.
            let deniedOrNotDetermined = "denied"
            
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                return "authorized"
            } else if let settings = UIApplication.shared.currentUserNotificationSettings {
                if settings.types.isEmpty {
                    return deniedOrNotDetermined
                } else {
                    return "authorized"
                }
            } else {
                return deniedOrNotDetermined
            }
        }
    }
    
    @available(iOS 10.0, *)
    func notificationSettings() -> UNNotificationSettings {
        var notificationSettings: UNNotificationSettings?
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings: UNNotificationSettings) in
            notificationSettings = settings
        }
        
        while true {
            if let notificationSettings = notificationSettings {
                return notificationSettings
            }
        }
    }
}
