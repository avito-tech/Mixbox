public protocol SimctlList {
    func list() throws -> SimctlListResult
}

// Delegation

public protocol SimctlListHolder {
    var simctlList: SimctlList { get }
}

public extension SimctlList where Self: SimctlListHolder {
    func list() throws -> SimctlListResult {
        return try simctlList.list()
    }
}
