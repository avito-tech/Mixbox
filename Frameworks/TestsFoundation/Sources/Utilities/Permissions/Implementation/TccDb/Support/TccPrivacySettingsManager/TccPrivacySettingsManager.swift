import Foundation

public protocol TccPrivacySettingsManager: AnyObject {
    func fetchPrivacySettingsState(
        service: TccService)
        throws
        -> TccServicePrivacyState
    
    func updatePrivacySettings(
        service: TccService,
        state: TccServicePrivacyState)
        throws
}
