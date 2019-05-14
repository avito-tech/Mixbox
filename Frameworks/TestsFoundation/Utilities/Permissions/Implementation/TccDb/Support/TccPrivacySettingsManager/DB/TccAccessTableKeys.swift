import SQLite

final class TccAccessTableKeys {
    let service = Expression<String>("service")
    let client = Expression<String>("client")
    let clientType = Expression<Int>("client_type")
    let allowed = Expression<Int>("allowed")
    let promptCount = Expression<Int>("prompt_count")
    let csreq = Expression<SQLite.Blob?>("csreq")
    let policyId = Expression<Int?>("policy_id")
}
