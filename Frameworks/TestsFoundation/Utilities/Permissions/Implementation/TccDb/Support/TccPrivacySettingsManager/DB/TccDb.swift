import SQLite
import MixboxFoundation

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
        
        if let column = columnNullable {
            let columnValue = column[keys.allowed]
            
            switch columnValue {
            case 0:
                return .denied
            case 1:
                return .allowed
            default:
                throw ErrorString("Invalid value for key 'allowed': \(columnValue). Expected: 0 or 1")
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
