import Foundation

public protocol TccPrivacySettingsManager {
    func fetchPrivacySettingsState(
        service: TccService)
        throws
        -> TccServicePrivacyState
    
    func updatePrivacySettings(
        service: TccService,
        state: TccServicePrivacyState)
        throws
}
