import SQLite
import MixboxFoundation

public final class TccDb_iOS_from_10_to_13: TccDb {
    private final class TccAccessTableKeys {
        let service = Expression<String>("service")
        let client = Expression<String>("client")
        let clientType = Expression<Int>("client_type")
        let allowed = Expression<Int>("allowed")
        let promptCount = Expression<Int>("prompt_count")
        let csreq = Expression<SQLite.Blob?>("csreq")
        let policyId = Expression<Int?>("policy_id")
    }

    private let db: Connection
    private let accessTable = Table("access")
    
    public init(path: String) throws {
        do {
            db = try Connection(path)
        } catch {
            throw ErrorString("Failed to establish connection to sqlite database for path \(path)")
        }
    }
    
    public func getAccess(
        serviceId: TccDbServiceId,
        bundleId: String)
        throws
        -> TccServicePrivacyState
    {
        let keys = TccAccessTableKeys()
        
        let columnNullable = try ErrorString.map(
            body:{
                try db.pluck(
                    accessTable
                        .filter(keys.client == bundleId)
                        .filter(keys.service == serviceId.rawValue)
                )
            },
            transform: { error in
                "Failed to call `\(type(of: db)).pluck`: \(error)"
            }
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
    
    public func setAccess(
        serviceId: TccDbServiceId,
        bundleId: String,
        isAllowed: Bool)
        throws
    {
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
    
    public func resetAccess(
        serviceId: TccDbServiceId,
        bundleId: String)
        throws
    {
        let keys = TccAccessTableKeys()
        let row = accessTable.filter(keys.service == serviceId.rawValue && keys.client == bundleId)
        
        try db.run(row.delete())
    }
}
