import Foundation

public protocol TccPrivacySettingsManager: class {
    func fetchPrivacySettingsState(
        service: TccService)
        throws
        -> TccServicePrivacyState
    
    func updatePrivacySettings(
        service: TccService,
        state: TccServicePrivacyState)
        throws
}
