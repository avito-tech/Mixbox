import SQLite
import MixboxFoundation

public final class TccDb_iOS_from_14: TccDb {
    private final class TccAccessTableKeys {
        // Schema:
        //
        // CREATE TABLE access (
        //     service        TEXT        NOT NULL,
        //     client         TEXT        NOT NULL,
        //     client_type    INTEGER     NOT NULL,
        //     auth_value     INTEGER     NOT NULL,
        //     auth_reason    INTEGER     NOT NULL,
        //     auth_version   INTEGER     NOT NULL,
        //     csreq          BLOB,
        //     policy_id      INTEGER,
        //     indirect_object_identifier_type    INTEGER,
        //     indirect_object_identifier         TEXT NOT NULL DEFAULT 'UNUSED',
        //     indirect_object_code_identity      BLOB,
        //     flags          INTEGER,
        //     last_modified  INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER)),
        //     PRIMARY KEY (service, client, client_type, indirect_object_identifier),
        //     FOREIGN KEY (policy_id) REFERENCES policies(id) ON DELETE CASCADE ON UPDATE CASCADE
        // );
        //
        // Example of contents (allowed):
        //
        // kTCCServicePhotos|ru.avito.app|0|2|4|2||||UNUSED||0|1606915117
        //
        // Example of contents (denied):
        //
        // kTCCServicePhotos|ru.avito.app|0|0|4|2||||UNUSED||0|1606915157
        //
        let service = Expression<String>("service")
        let client = Expression<String>("client")
        let clientType = Expression<Int>("client_type")
        let auth_value = Expression<Int>("auth_value")
        let auth_reason = Expression<Int>("auth_reason")
        let auth_version = Expression<Int>("auth_version")
        let csreq = Expression<SQLite.Blob?>("csreq")
        let policy_id = Expression<Int?>("policy_id")
        let indirect_object_identifier_type = Expression<Int?>("indirect_object_identifier_type")
        let indirect_object_identifier = Expression<String>("indirect_object_identifier")
        let indirect_object_code_identity = Expression<SQLite.Blob?>("indirect_object_code_identity")
        let flags = Expression<Int?>("flags")
        let last_modified = Expression<Int?>("last_modified")
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
            let columnValue = column[keys.auth_value]
            
            switch columnValue {
            case 0:
                return .denied
            case 2:
                return .allowed
            case 3:
                return .selectedPhotos
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
            // Examples (allowed/denied):
            //
            // kTCCServicePhotos|ru.avito.app|0|2|4|2||||UNUSED||0|1606915117
            // kTCCServicePhotos|ru.avito.app|0|0|4|2||||UNUSED||0|1606915157
            accessTable.insert(
                or: .replace,
                keys.service <- serviceId.rawValue,
                keys.client <- bundleId,
                keys.clientType <- 0, // i don't know what this means
                keys.auth_value <- isAllowed ? 2 : 0,
                keys.auth_reason <- 4, // i don't know what this means
                keys.auth_version <- 2, // i don't know what this means
                keys.csreq <- nil,
                keys.policy_id <- nil,
                keys.indirect_object_identifier_type <- nil,
                // Will be default: keys.indirect_object_identifier
                keys.indirect_object_code_identity <- nil,
                keys.flags <- 0 // i don't know what this means
                // Will be default: keys.last_modified
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
