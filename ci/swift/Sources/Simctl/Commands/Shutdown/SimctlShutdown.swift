public protocol SimctlShutdown {
    func shutdown(device: String) throws
}

// Delegation

public protocol SimctlShutdownHolder {
    var simctlShutdown: SimctlShutdown { get }
}

public extension SimctlShutdown where Self: SimctlShutdownHolder {
    func shutdown(device: String) throws {
        try simctlShutdown.shutdown(device: device)
    }
}
