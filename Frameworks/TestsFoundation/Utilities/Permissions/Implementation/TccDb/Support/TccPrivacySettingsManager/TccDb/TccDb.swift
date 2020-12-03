import SQLite
import MixboxFoundation

public protocol TccDb {
    func getAccess(
        serviceId: TccDbServiceId,
        bundleId: String)
        throws
        -> TccServicePrivacyState
    
    func setAccess(
        serviceId: TccDbServiceId,
        bundleId: String,
        isAllowed: Bool)
        throws
    
    func resetAccess(
        serviceId: TccDbServiceId,
        bundleId: String)
        throws
}
