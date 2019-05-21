public protocol SimctlBoot {
    func boot(device: String) throws
}

// Delegation

public protocol SimctlBootHolder {
    var simctlBoot: SimctlBoot { get }
}

public extension SimctlBoot where Self: SimctlBootHolder {
    func boot(device: String) throws {
        try simctlBoot.boot(device: device)
    }
}
