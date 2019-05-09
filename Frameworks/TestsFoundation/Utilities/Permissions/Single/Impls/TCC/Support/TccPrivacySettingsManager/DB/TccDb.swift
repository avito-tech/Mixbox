import SQLite

final class TccDb {
    private let db: Connection
    private let accessTable = Table("access")
    
    init(path: String) throws {
        db = try Connection(path)
    }
    
    func getAccess(serviceId: TccDbServiceId, bundleId: String) throws -> TccServicePrivacyState {
        let keys = TccAccessTableKeys()
        
        let columnNullable = try db.pluck(
            accessTable
                .filter(keys.client == bundleId)
                .filter(keys.service == serviceId.rawValue)
        )
        
        class InvalidValueError: Error {}
        
        if let column = columnNullable {
            switch column[keys.allowed] {
            case 0:
                return .denied
            case 1:
                return .allowed
            default:
                throw InvalidValueError()
            }
        } else {
            return .notDetermined
        }
    }
    
    func setAccess(serviceId: TccDbServiceId, bundleId: String, isAllowed: Bool) throws {
        let keys = TccAccessTableKeys()
        
        try db.run(
            accessTable.insert(
                or: .replace,
                keys.service <- serviceId.rawValue,
                keys.client <- bundleId,
                keys.clientType <- 0, // i don't know what this means
                keys.allowed <- isAllowed ? 1 : 0,
                keys.promptCount <- 1,
                keys.csreq <- nil,
                keys.policyId <- nil
            )
        )
    }
    
    func resetAccess(serviceId: TccDbServiceId, bundleId: String) throws {
        let keys = TccAccessTableKeys()
        let row = accessTable.filter(keys.service == serviceId.rawValue && keys.client == bundleId)
        
        try db.run(row.delete())
    }
}
