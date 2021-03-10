import MixboxFoundation

public final class ErrorsWrappingTccDb: TccDb {
    private let tccDb: TccDb
    
    public init(tccDb: TccDb) {
        self.tccDb = tccDb
    }
    
    public func getAccess(
        serviceId: TccDbServiceId,
        bundleId: String)
        throws
        -> TccServicePrivacyState
    {
        do {
            return try tccDb.getAccess(
                serviceId: serviceId,
                bundleId: bundleId
            )
        } catch {
            throw ErrorString(
                """
                Failed to call `\(type(of: self)).getAccess(\
                serviceId: \(serviceId), \
                bundleId: \(bundleId))`\
                : \(error)
                """
            )
        }
    }
    
    public func setAccess(
        serviceId: TccDbServiceId,
        bundleId: String,
        isAllowed: Bool)
        throws
    {
        do {
            return try tccDb.setAccess(
                serviceId: serviceId,
                bundleId: bundleId,
                isAllowed: isAllowed
            )
        } catch {
            throw ErrorString(
                """
                Failed to call `\(type(of: self)).setAccess(\
                serviceId: \(serviceId), \
                bundleId: \(bundleId), `\
                isAllowed: \(isAllowed))`\
                : \(error)
                """
            )
        }
    }
    
    public func resetAccess(
        serviceId: TccDbServiceId,
        bundleId: String)
        throws
    {
        do {
            return try tccDb.resetAccess(
                serviceId: serviceId,
                bundleId: bundleId
            )
        } catch {
            throw ErrorString(
                """
                Failed to call `\(type(of: self)).resetAccess(\
                serviceId: \(serviceId), \
                bundleId: \(bundleId))`\
                : \(error)
                """
            )
        }
    }

}
