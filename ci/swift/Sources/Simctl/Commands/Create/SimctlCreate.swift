public protocol SimctlCreate {
    func create(
        name: String,
        deviceTypeIdentifier: String,
        runtimeId: String)
        throws
}

// Delegation

public protocol SimctlCreateHolder {
    var simctlCreate: SimctlCreate { get }
}

extension SimctlCreate where Self: SimctlCreateHolder {
    public func create(
        name: String,
        deviceTypeIdentifier: String,
        runtimeId: String)
        throws
    {
        try simctlCreate.create(
            name: name,
            deviceTypeIdentifier: deviceTypeIdentifier,
            runtimeId: runtimeId
        )
    }
}
